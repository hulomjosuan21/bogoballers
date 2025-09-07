import 'package:bogoballers/core/constants/size.dart';
import 'package:bogoballers/core/helpers/message_helpers.dart';
import 'package:bogoballers/core/models/message.dart';
import 'package:bogoballers/core/services/socket_io_service.dart';
import 'package:flutter/material.dart';
import 'package:bogoballers/core/widget/snackbars.dart';
import 'package:bogoballers/core/theme/theme_extensions.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final ConversationWith partner;
  final List<Message> initialMessages;

  const ChatScreen({
    super.key,
    required this.currentUserId,
    required this.partner,
    required this.initialMessages,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late List<Message> messages;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSocketConnected = false;

  @override
  void initState() {
    super.initState();
    messages = List<Message>.from(widget.initialMessages);
    _setupSocket();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    try {
      SocketService.instance.off('new_message');
      SocketService.instance.off('message_sent');
    } catch (_) {}
    super.dispose();
  }

  void _setupSocket() {
    final socketService = SocketService.instance;

    if (!socketService.isConnected) {
      socketService.connect().then((_) {
        if (mounted) {
          setState(() => _isSocketConnected = socketService.isConnected);
        }
      });
    } else {
      setState(() => _isSocketConnected = true);
    }

    try {
      socketService.off('new_message');
      socketService.off('message_sent');
    } catch (_) {}

    socketService.onNewMessage(_handleNewMessage);
    socketService.onMessageSent(_handleMessageSent);
  }

  void _handleNewMessage(dynamic messageDataRaw) {
    try {
      final messageData = messageDataRaw as Map<String, dynamic>;
      final newMessage = Message.fromMap(messageData);

      if (newMessage.senderId == widget.partner.userId &&
          newMessage.receiverId == widget.currentUserId) {
        setState(() {
          if (!isDuplicateMessage(newMessage, messages)) {
            messages.add(newMessage);
            _scrollToBottom();
          }
        });
      }
    } catch (e) {
      if (mounted) {
        showAppSnackbar(
          context,
          message: "Failed to receive message: ${e.toString()}",
          title: "Error",
          variant: SnackbarVariant.error,
        );
      }
    }
  }

  void _handleMessageSent(dynamic messageDataRaw) {
    try {
      final messageData = messageDataRaw as Map<String, dynamic>;
      final newMessage = Message.fromMap(messageData);

      if (newMessage.senderId == widget.currentUserId &&
          newMessage.receiverId == widget.partner.userId) {
        setState(() {
          final tempMessageIndex = messages.indexWhere(
            (m) =>
                m.messageId == null &&
                m.content == newMessage.content &&
                m.senderId == widget.currentUserId,
          );

          if (tempMessageIndex != -1) {
            messages[tempMessageIndex] = newMessage;
          } else if (!isDuplicateMessage(newMessage, messages)) {
            messages.add(newMessage);
          }
          _scrollToBottom();
        });
      }
    } catch (e) {
      if (mounted) {
        showAppSnackbar(
          context,
          message: "Failed to process sent message: ${e.toString()}",
          title: "Error",
          variant: SnackbarVariant.error,
        );
      }
    }
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isEmpty || !_isSocketConnected) return;

    final socketService = SocketService.instance;
    final tempMessage = Message(
      messageId: null,
      senderId: widget.currentUserId,
      receiverId: widget.partner.userId,
      content: content,
      sentAt: DateTime.now().toIso8601String(),
    );

    setState(() {
      messages.add(tempMessage);
      _messageController.clear();
      _scrollToBottom();
    });

    socketService.sendMessage({
      'sender_id': widget.currentUserId,
      'receiver_id': widget.partner.userId,
      'content': content,
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 50,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.partner.name,
          style: TextStyle(color: colors.textPrimary),
        ),
        flexibleSpace: Container(color: colors.gray1),
        backgroundColor: colors.surface,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isSocketConnected ? Colors.green : colors.gray6,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (!_isSocketConnected)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Sizes.spaceMd),
              color: colors.color8,
              child: Text(
                'Connection lost. Messages may not send.',
                style: TextStyle(color: colors.contrast),
                textAlign: TextAlign.center,
              ),
            ),
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: colors.gray8,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Start your conversation",
                          style: TextStyle(fontSize: 18, color: colors.gray9),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 10,
                    ),
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isMe = msg.senderId == widget.currentUserId;
                      final isPending = msg.messageId == null;

                      return Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(12),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                          ),
                          decoration: BoxDecoration(
                            color: isMe
                                ? (isPending ? colors.gray6 : colors.color9)
                                : colors.gray3,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: Radius.circular(isMe ? 16 : 0),
                              bottomRight: Radius.circular(isMe ? 0 : 16),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  msg.content,
                                  style: TextStyle(
                                    color: isMe
                                        ? colors.contrast
                                        : colors.textPrimary,
                                  ),
                                ),
                              ),
                              if (isMe && isPending) ...[
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      colors.contrast.withAlpha(70),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            color: colors.surface,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      enabled: _isSocketConnected,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        hintText: _isSocketConnected
                            ? 'Type a message...'
                            : 'Connecting...',
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _isSocketConnected ? _sendMessage : null,
                    color: _isSocketConnected
                        ? colors.color9
                        : colors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
