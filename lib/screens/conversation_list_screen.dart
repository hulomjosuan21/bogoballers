import 'package:bogoballers/core/services/socket_io_service.dart';
import 'package:bogoballers/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:bogoballers/core/services/entity_service.dart';

class ConversationListScreen extends StatefulWidget {
  const ConversationListScreen({super.key});

  @override
  State<ConversationListScreen> createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen> {
  String? currentUserId;
  List<dynamic> conversations = [];
  bool _isLoading = true;
  bool _isSocketConnected = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    // cleanup listeners to avoid duplicates when screen is reopened
    try {
      SocketService.instance.off('conversations');
      SocketService.instance.off('new_message');
      SocketService.instance.off('message_sent');
    } catch (_) {}
    super.dispose();
  }

  Future<void> _init() async {
    try {
      debugPrint('🚀 Initializing ConversationListScreen');

      final entity = await getEntityCredentialsFromStorage();
      setState(() => currentUserId = entity.userId);

      debugPrint('👤 Current user ID: ${entity.userId}');

      final socketService = SocketService.instance;

      if (!socketService.isConnected) {
        debugPrint('🔄 Connecting to socket...');
        await socketService.connect();

        // Wait for connection with timeout (10s)
        int attempts = 0;
        while (!socketService.isConnected && attempts < 20) {
          await Future.delayed(const Duration(milliseconds: 500));
          attempts++;
        }
      }

      setState(() {
        _isSocketConnected = socketService.isConnected;
        _isLoading = false;
      });

      if (!_isSocketConnected) {
        debugPrint('❌ Failed to connect to socket');
        _showConnectionError();
        return;
      }

      debugPrint('✅ Socket connected successfully');
      _setupSocketListeners();

      // Request conversations from server
      socketService.getConversations(entity.userId);
    } catch (e) {
      debugPrint('❌ Error during initialization: $e');
      setState(() {
        _isLoading = false;
      });
      _showError('Failed to initialize. Please try again.');
    }
  }

  void _setupSocketListeners() {
    final socketService = SocketService.instance;

    // Conversations list
    socketService.onConversations((data) {
      debugPrint(
        '📋 Received conversations (truncated): ${data.toString().substring(0, 120)}',
      );
      try {
        final conversationData =
            (data is Map && data.containsKey('conversations'))
            ? data['conversations']
            : data;
        if (conversationData != null && conversationData is List) {
          setState(() {
            conversations = List.from(conversationData);
          });
          debugPrint('✅ Updated conversations list: ${conversations.length}');
        } else {
          debugPrint('⚠️ Invalid conversation data format: $data');
        }
      } catch (e) {
        debugPrint('❌ Error processing conversations: $e');
      }
    });

    // New message
    socketService.onNewMessage((messageData) {
      debugPrint('📨 ConversationList received new_message: $messageData');

      if (currentUserId == null) {
        debugPrint('⚠️ Current user ID is null, ignoring message');
        return;
      }

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

        debugPrint('🔄 Processing message from/to: $otherId ($otherName)');

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
            final messages = (conversations[idx]["messages"] as List?) ?? [];
            final messageId = messageData["message_id"];
            final exists =
                messageId != null &&
                messages.any((m) => m["message_id"] == messageId);

            if (!exists) {
              conversations[idx]["messages"] = [...messages, newMessage];

              // Move conversation to top
              final conv = conversations.removeAt(idx);
              conversations.insert(0, conv);
            }
          } else {
            conversations.insert(0, {
              "conversation_with": {
                "user_id": otherId,
                "name": otherName ?? "Unknown User",
                "entity_id": otherEntityId,
              },
              "messages": [newMessage],
            });
          }
        });
      } catch (e) {
        debugPrint('❌ Error processing new message in conversation list: $e');
      }
    });

    // message_sent (confirmation)
    socketService.onMessageSent((serverMsg) {
      debugPrint('✅ ConversationList received message_sent: $serverMsg');
      // optionally update UI if needed (we handle optimistic updates in ChatScreen)
    });
  }

  void _showConnectionError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Failed to connect. Please check your internet connection.',
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _refreshConversations() async {
    if (currentUserId != null && _isSocketConnected) {
      debugPrint('🔄 Refreshing conversations...');
      SocketService.instance.getConversations(currentUserId!);
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
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isSocketConnected ? _refreshConversations : null,
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
            child: conversations.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "No conversations yet",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Start a conversation to see your messages here",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        if (_isSocketConnected) ...[
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _refreshConversations,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Refresh'),
                          ),
                        ],
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _refreshConversations,
                    child: ListView.builder(
                      itemCount: conversations.length,
                      itemBuilder: (context, index) {
                        final convo = conversations[index];
                        final partner = convo["conversation_with"];
                        final messagesList =
                            (convo["messages"] as List<dynamic>?) ?? [];
                        final lastMessage = messagesList.isNotEmpty
                            ? messagesList.last
                            : null;

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
                                    lastMessage?["content"] ??
                                        "No messages yet",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ),
                                if (lastMessage != null) ...[
                                  const SizedBox(width: 8),
                                  Text(
                                    _formatTimestamp(lastMessage["sent_at"]),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              debugPrint(
                                '🚀 Opening chat with: ${partner["name"]}',
                              );
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
