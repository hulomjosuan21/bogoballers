import 'package:bogoballers/core/constants/size.dart';
import 'package:bogoballers/core/helpers/message_helpers.dart';
import 'package:bogoballers/core/models/message.dart';
import 'package:bogoballers/core/services/socket_io_service.dart';
import 'package:bogoballers/core/widget/snackbars.dart';
import 'package:bogoballers/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:bogoballers/core/services/entity_service.dart';
import 'package:bogoballers/core/theme/theme_extensions.dart';

class ConversationListScreen extends StatefulWidget {
  const ConversationListScreen({super.key});

  @override
  State<ConversationListScreen> createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen>
    with WidgetsBindingObserver {
  String? currentUserId;
  List<Conversation> conversations = [];
  bool _isLoading = true;
  bool _isSocketConnected = false;
  bool _hasInitialized = false;
  bool _hasLoadedConversations = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _init();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    try {
      SocketService.instance.off('conversations');
      SocketService.instance.off('new_message');
      SocketService.instance.off('message_sent');
      SocketService.instance.off('conversation_update');
    } catch (_) {}
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && _hasInitialized) {
      _refreshConversations();
    }
  }

  Future<void> _init() async {
    if (_hasInitialized) return;
    try {
      final entity = await getEntityCredentialsFromStorage();
      setState(() => currentUserId = entity.userId);

      final socketService = SocketService.instance;
      if (!socketService.isConnected) await socketService.connect();

      setState(() {
        _isSocketConnected = socketService.isConnected;
        _isLoading = false;
        _hasInitialized = true;
      });

      if (!_isSocketConnected) {
        setState(() => _hasLoadedConversations = true);
        _showConnectionError();
        return;
      }

      _setupSocketListeners();
      await Future.delayed(const Duration(milliseconds: 200));
      socketService.getConversations(entity.userId);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasInitialized = true;
        _hasLoadedConversations = true;
      });
      if (!mounted) return;
      showAppSnackbar(
        context,
        message: 'Failed to initialize: ${e.toString()}',
        title: "Error",
        variant: SnackbarVariant.error,
      );
    }
  }

  void _setupSocketListeners() {
    final socketService = SocketService.instance;
    try {
      socketService.off('conversations');
      socketService.off('new_message');
      socketService.off('message_sent');
      socketService.off('conversation_update');
    } catch (_) {}

    socketService.onConversations((data) {
      try {
        List<dynamic>? conversationData;
        if (data is List) {
          conversationData = data;
        } else if (data is Map) {
          if (data.containsKey('conversations') &&
              data['conversations'] is List) {
            conversationData = data['conversations'];
          } else if (data.containsKey('data') && data['data'] is List) {
            conversationData = data['data'];
          }
        }

        if (conversationData != null) {
          final convList = conversationData
              .map((c) => Conversation.fromMap(c as Map<String, dynamic>))
              .toList();
          convList.sort((a, b) {
            final aLast = a.messages.isNotEmpty ? a.messages.last.sentAt : null;
            final bLast = b.messages.isNotEmpty ? b.messages.last.sentAt : null;
            if (aLast == null && bLast == null) return 0;
            if (aLast == null) return 1;
            if (bLast == null) return -1;
            try {
              final aDate = DateTime.parse(aLast);
              final bDate = DateTime.parse(bLast);
              return bDate.compareTo(aDate);
            } catch (_) {
              return 0;
            }
          });

          setState(() {
            conversations = convList;
            _hasLoadedConversations = true;
          });
        } else {
          setState(() {
            conversations = [];
            _hasLoadedConversations = true;
          });
        }
      } catch (_) {
        setState(() {
          conversations = [];
          _hasLoadedConversations = true;
        });
      }
    });

    socketService.onNewMessage(
      (data) => _handleIncomingMessage(data, isSentByMe: false),
    );
    socketService.onMessageSent(
      (data) => _handleIncomingMessage(data, isSentByMe: true),
    );

    socketService.on('conversation_update', (data) {
      if (currentUserId == null) return;
      _handleIncomingMessage(data, isSentByMe: false);
    });
  }

  void _handleIncomingMessage(
    dynamic messageDataRaw, {
    required bool isSentByMe,
  }) {
    if (currentUserId == null) return;
    try {
      final messageData = messageDataRaw as Map<String, dynamic>;

      final otherId = isSentByMe
          ? messageData['receiver_id']
          : messageData['sender_id'];
      final otherName = isSentByMe
          ? messageData['receiver_name']
          : messageData['sender_name'];

      final newMessage = Message.fromMap(messageData);

      setState(() {
        final idx = conversations.indexWhere(
          (c) => c.conversationWith.userId == otherId,
        );

        Conversation? updatedConv;
        if (idx != -1) {
          updatedConv = conversations[idx];
          final messages = List<Message>.from(updatedConv.messages);

          if (isDuplicateMessage(newMessage, messages)) return;

          if (isSentByMe && messages.isNotEmpty) {
            final lastMessage = messages.last;
            if (lastMessage.messageId == null &&
                lastMessage.content == newMessage.content &&
                lastMessage.senderId == currentUserId) {
              messages[messages.length - 1] = newMessage;
            } else {
              messages.add(newMessage);
            }
          } else {
            messages.add(newMessage);
          }

          updatedConv = Conversation(
            conversationWith: updatedConv.conversationWith,
            messages: messages,
          );
          conversations.removeAt(idx);
        } else {
          updatedConv = Conversation(
            conversationWith: ConversationWith(
              userId: otherId ?? '',
              entityId: isSentByMe
                  ? messageData['receiver_entity_id']
                  : messageData['sender_entity_id'],
              name: otherName ?? 'Unknown User',
            ),
            messages: [newMessage],
          );
        }

        conversations.insert(0, updatedConv);
        _hasLoadedConversations = true;
      });
    } catch (e) {
      if (mounted) {
        showAppSnackbar(
          context,
          message: "Failed to process message: ${e.toString()}",
          title: "Error",
          variant: SnackbarVariant.error,
        );
      }
    }
  }

  void _showConnectionError() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Failed to connect. Please check your internet connection.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _refreshConversations() async {
    if (currentUserId == null) return;
    final socketService = SocketService.instance;

    if (!socketService.isConnected) {
      setState(() => _isLoading = true);
      await socketService.connect();
      int attempts = 0;
      while (!socketService.isConnected && attempts < 10) {
        await Future.delayed(const Duration(milliseconds: 500));
        attempts++;
      }
      setState(() {
        _isSocketConnected = socketService.isConnected;
        _isLoading = false;
      });
      if (socketService.isConnected) _setupSocketListeners();
    }

    if (socketService.isConnected) {
      socketService.getConversations(currentUserId!);
    } else {
      _showConnectionError();
      setState(() => _hasLoadedConversations = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Chats"),
          flexibleSpace: Container(color: colors.gray1),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (currentUserId == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Chats"),
          flexibleSpace: Container(color: colors.gray1),
        ),
        body: const Center(child: Text('Please log in to view messages')),
      );
    }

    final realConversations = conversations
        .where((c) => c.messages.isNotEmpty)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        flexibleSpace: Container(color: colors.gray1),
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
              padding: const EdgeInsets.all(8.0),
              color: colors.color5,
              child: const Text(
                'Connection lost. Trying to reconnect...',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshConversations,
              child: (!_hasLoadedConversations)
                  ? const Center(child: CircularProgressIndicator())
                  : realConversations.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.chat_bubble_outline,
                                  size: 64,
                                  color: colors.gray1,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "No chats yet",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: colors.gray1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: realConversations.length,
                      itemBuilder: (context, index) {
                        final convo = realConversations[index];
                        final partner = convo.conversationWith;
                        final lastMessage = convo.messages.last;

                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Sizes.radiusMd),
                            border: Border.all(
                              color: colors.gray6,
                              width: Sizes.borderWidthSm,
                            ),
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 6.0,
                            vertical: 2.0,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: colors.color9,
                              child: ClipOval(
                                child:
                                    partner.imageUrl != null &&
                                        partner.imageUrl!.isNotEmpty
                                    ? Image.network(
                                        partner.imageUrl!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Center(
                                                child: Text(
                                                  partner.name[0].toUpperCase(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              );
                                            },
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Center(
                                                child: Text(
                                                  partner.name[0].toUpperCase(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              );
                                            },
                                      )
                                    : Center(
                                        child: Text(
                                          partner.name[0].toUpperCase(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                              ),
                            ),

                            title: Text(
                              partner.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: colors.gray12,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    lastMessage.content,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: colors.gray11),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  formatConversationTimestamp(
                                    lastMessage.sentAt,
                                  ),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colors.gray10,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChatScreen(
                                    currentUserId: currentUserId!,
                                    partner: partner,
                                    initialMessages: convo.messages,
                                  ),
                                ),
                              ).then((_) {
                                _refreshConversations();
                              });
                            },
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
