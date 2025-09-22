import 'dart:async';
import 'package:bogoballers/core/models/message.dart';
import 'package:bogoballers/core/services/entity_service.dart';
import 'package:bogoballers/core/services/socket_io_service.dart';
import 'package:bogoballers/core/services/socket_service_messages.dart';
import 'package:bogoballers/core/widget/snackbars.dart';
import 'package:bogoballers/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class ChatLoaderScreen extends StatefulWidget {
  final ConversationWith partner;

  const ChatLoaderScreen({super.key, required this.partner});

  @override
  State<ChatLoaderScreen> createState() => _ChatLoaderScreenState();
}

class _ChatLoaderScreenState extends State<ChatLoaderScreen> {
  Timer? _timeoutTimer;

  @override
  void initState() {
    super.initState();
    _initializeAndFetch();
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    SocketService.instance.off('conversations');
    super.dispose();
  }

  Future<void> _initializeAndFetch() async {
    try {
      final entity = await getEntityCredentialsFromStorage();
      if (!mounted) return;

      final socketService = SocketService.instance;

      _timeoutTimer = Timer(const Duration(seconds: 15), () {
        if (mounted) {
          _handleError('Server did not respond in time.');
        }
      });

      socketService.onConversations((data) {
        _timeoutTimer?.cancel();
        if (!mounted) return;

        try {
          List<dynamic>? conversationList;
          if (data is List) {
            conversationList = data;
          } else if (data is Map<String, dynamic>) {
            if (data.containsKey('conversations') &&
                data['conversations'] is List) {
              conversationList = data['conversations'];
            } else if (data.containsKey('data') && data['data'] is List) {
              conversationList = data['data'];
            }
          }

          if (conversationList == null) {
            throw Exception(
              "Could not find a list of conversations in the server response.",
            );
          }
          // END OF FIX

          List<Message> initialMessages = [];

          final targetConversationData = conversationList.firstWhere(
            (conv) =>
                conv['conversation_with']['user_id'] == widget.partner.userId,
            orElse: () => null,
          );

          if (targetConversationData != null) {
            final conversation = Conversation.fromMap(targetConversationData);
            initialMessages = conversation.messages;
          }

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => ChatScreen(
                currentUserId: entity.userId,
                partner: widget.partner,
                initialMessages: initialMessages,
              ),
            ),
          );
        } catch (e) {
          _handleError('Failed to process conversation data: ${e.toString()}');
        }
      });

      socketService.getConversations(entity.userId);
    } catch (e) {
      _handleError('Could not start chat: ${e.toString()}');
    }
  }

  void _handleError(String message) {
    if (mounted) {
      _timeoutTimer?.cancel();
      showAppSnackbar(
        context,
        message: message,
        title: "Error",
        variant: SnackbarVariant.error,
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.partner.name)),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
