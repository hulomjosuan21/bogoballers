import 'package:bogoballers/core/services/socket_io_service.dart';
import 'package:bogoballers/core/utils/error_handler.dart';
import 'package:bogoballers/core/widget/snackbars.dart';
import 'package:bogoballers/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:bogoballers/core/services/entity_service.dart';

class ConversationListScreen extends StatefulWidget {
  const ConversationListScreen({super.key});

  @override
  State<ConversationListScreen> createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen>
    with WidgetsBindingObserver {
  String? currentUserId;
  List<dynamic> conversations = [];
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
      if (!socketService.isConnected) {
        await socketService.connect();
        int attempts = 0;
        while (!socketService.isConnected && attempts < 20) {
          await Future.delayed(const Duration(milliseconds: 500));
          attempts++;
        }
      }

      setState(() {
        _isSocketConnected = socketService.isConnected;
        _isLoading = false;
        _hasInitialized = true;
      });

      if (!_isSocketConnected) {
        setState(() {
          _hasLoadedConversations = true;
        });
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
        message: 'Failed to initialize. Please try again.',
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
          conversationData.sort((a, b) {
            final aMessages = (a['messages'] as List?) ?? [];
            final bMessages = (b['messages'] as List?) ?? [];

            if (aMessages.isEmpty && bMessages.isEmpty) return 0;
            if (aMessages.isEmpty) return 1;
            if (bMessages.isEmpty) return -1;

            final aLastTime = aMessages.last['sent_at'];
            final bLastTime = bMessages.last['sent_at'];

            if (aLastTime == null && bLastTime == null) return 0;
            if (aLastTime == null) return 1;
            if (bLastTime == null) return -1;

            try {
              final aDate = DateTime.parse(aLastTime);
              final bDate = DateTime.parse(bLastTime);
              return bDate.compareTo(aDate);
            } catch (_) {
              return 0;
            }
          });

          setState(() {
            conversations = List.from(conversationData ?? []);
            _hasLoadedConversations = true;
          });
        } else {
          setState(() {
            conversations = [];
            _hasLoadedConversations = true;
          });
        }
      } catch (e) {
        setState(() {
          conversations = [];
          _hasLoadedConversations = true;
        });
      }
    });

    socketService.onNewMessage((messageData) {
      if (currentUserId == null) return;
      _updateConversationWithNewMessage(messageData);
      if (!_hasLoadedConversations) {
        setState(() {
          _hasLoadedConversations = true;
        });
      }
    });

    socketService.onMessageSent((serverMsg) {
      _updateConversationWithNewMessage(serverMsg);
      if (!_hasLoadedConversations) {
        setState(() {
          _hasLoadedConversations = true;
        });
      }
    });
  }

  void _updateConversationWithNewMessage(Map<String, dynamic> messageData) {
    try {
      final senderId = messageData['sender_id']?.toString();
      final receiverId = messageData['receiver_id']?.toString();

      final otherId = (senderId == currentUserId) ? receiverId : senderId;
      final otherName = (senderId == currentUserId)
          ? messageData['receiver_name']
          : messageData['sender_name'];
      final otherEntityId = (senderId == currentUserId)
          ? messageData['receiver_entity_id']
          : messageData['sender_entity_id'];

      setState(() {
        final idx = conversations.indexWhere(
          (c) => c?['conversation_with']?['user_id']?.toString() == otherId,
        );

        final newMessage = {
          "message_id": messageData["message_id"],
          "content": messageData["content"],
          "sent_at": messageData["sent_at"],
          "sender_id": senderId,
          "receiver_id": receiverId,
        };

        if (idx != -1) {
          final messages = List<Map<String, dynamic>>.from(
            (conversations[idx]["messages"] as List?) ?? [],
          );

          final messageId = messageData["message_id"];
          final isDuplicate = messageId != null
              ? messages.any((m) => m["message_id"] == messageId)
              : messages.any(
                  (m) =>
                      m["content"] == newMessage["content"] &&
                      m["sent_at"] == newMessage["sent_at"] &&
                      m["sender_id"] == newMessage["sender_id"],
                );

          if (!isDuplicate) {
            messages.add(newMessage);
            conversations[idx]["messages"] = messages;
            final conv = conversations.removeAt(idx);
            conversations.insert(0, conv);
          }
        } else {
          final newConversation = {
            "conversation_with": {
              "user_id": otherId,
              "name": otherName ?? "Unknown User",
              "entity_id": otherEntityId,
            },
            "messages": [newMessage],
          };
          conversations.insert(0, newConversation);
        }

        _hasLoadedConversations = true;
      });
    } catch (e) {
      if (mounted) {
        showAppSnackbar(
          context,
          message: ErrorHandler.getErrorMessage(e),
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
    if (currentUserId != null) {
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

        if (socketService.isConnected) {
          _setupSocketListeners();
        }
      }

      if (socketService.isConnected) {
        // request updated conversations — the listener will flip _hasLoadedConversations
        socketService.getConversations(currentUserId!);
      } else {
        // Show connection error and make sure we don't get stuck on an indefinite "loading" UI
        _showConnectionError();
        setState(() {
          _hasLoadedConversations = true;
        });
      }
    }
  }

  String _formatTimestamp(String? timestamp) {
    if (timestamp == null) return '';
    try {
      final dateTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final diff = now.difference(dateTime);

      if (diff.inDays > 0) return '${diff.inDays}d ago';
      if (diff.inHours > 0) return '${diff.inHours}h ago';
      if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
      return 'Just now';
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Connecting...'),
            ],
          ),
        ),
      );
    }

    if (currentUserId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Messages")),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text('Authentication required'),
              Text('Please log in to view messages'),
            ],
          ),
        ),
      );
    }

    // only show conversations that actually contain messages
    final realConversations = conversations.where((c) {
      final msgs = (c["messages"] as List?) ?? [];
      return msgs.isNotEmpty;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isSocketConnected ? Colors.green : Colors.red,
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
              color: Colors.orange,
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
                  // first-mount: wait for socket response (shows inline spinner)
                  ? const Center(child: CircularProgressIndicator())
                  : realConversations.isEmpty
                  // only show "No conversations yet" after we've loaded/resolved
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.chat_bubble_outline,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  "No conversations yet",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Start a conversation to see your messages here",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
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
                        final partner = convo["conversation_with"];
                        final messagesList = List<Map<String, dynamic>>.from(
                          (convo["messages"] as List<dynamic>?) ?? [],
                        );
                        final lastMessage = messagesList.last;

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Text(
                                (partner["name"] ?? "U")[0].toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              partner["name"] ?? "Unknown User",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    lastMessage["content"] ?? "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _formatTimestamp(lastMessage["sent_at"]),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChatScreen(
                                    currentUserId: currentUserId!,
                                    partner: partner,
                                    initialMessages: messagesList,
                                  ),
                                ),
                              );
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
