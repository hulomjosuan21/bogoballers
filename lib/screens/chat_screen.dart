import 'package:bogoballers/core/constants/size.dart';
import 'package:bogoballers/core/services/socket_io_service.dart';
import 'package:flutter/material.dart';
import 'package:bogoballers/core/theme/theme_extensions.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final Map<String, dynamic> partner;
  final List<Map<String, dynamic>> initialMessages;

  const ChatScreen({
    super.key,
    required this.currentUserId,
    required this.partner,
    this.initialMessages = const [],
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  late List<Map<String, dynamic>> _messages;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isConnected = false;
  final Set<String> _pendingMessages = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _messages = List<Map<String, dynamic>>.from(widget.initialMessages);
    _sortMessages();

    _isConnected = SocketService.instance.isConnected;
    _setupSocketListeners();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      setState(() {
        _isConnected = SocketService.instance.isConnected;
      });
    }
  }

  void _sortMessages() {
    _messages.sort((a, b) {
      final aTime = a['sent_at'];
      final bTime = b['sent_at'];

      if (aTime == null && bTime == null) return 0;
      if (aTime == null) return -1;
      if (bTime == null) return 1;

      try {
        final aDate = DateTime.parse(aTime);
        final bDate = DateTime.parse(bTime);
        return aDate.compareTo(bDate);
      } catch (e) {
        return 0;
      }
    });
  }

  void _setupSocketListeners() {
    final socketService = SocketService.instance;

    socketService.onNewMessage((msg) {
      final senderId = msg['sender_id']?.toString();
      final receiverId = msg['receiver_id']?.toString();
      final partnerId = widget.partner['user_id']?.toString();

      final isRelevant =
          (senderId == partnerId && receiverId == widget.currentUserId) ||
          (senderId == widget.currentUserId && receiverId == partnerId);

      if (isRelevant) {
        _addMessage(msg, fromSocket: true);
      }
    });

    socketService.onMessageSent((serverMsg) {
      final senderId = serverMsg['sender_id']?.toString();
      final receiverId = serverMsg['receiver_id']?.toString();
      final partnerId = widget.partner['user_id']?.toString();

      final isRelevant =
          (senderId == widget.currentUserId && receiverId == partnerId);

      if (isRelevant) {
        _handleMessageConfirmation(serverMsg);
      }
    });
  }

  void _addMessage(
    Map<String, dynamic> message, {
    bool fromSocket = false,
    bool optimistic = false,
  }) {
    setState(() {
      final messageId = message['message_id'];

      if (messageId != null) {
        final exists = _messages.any((m) => m['message_id'] == messageId);
        if (exists) {
          debugPrint('⚠️ Duplicate message detected by ID: $messageId');
          return;
        }
      }

      if (messageId == null || optimistic) {
        final content = message['content'];
        final sentAt = message['sent_at'];
        final senderId = message['sender_id'];

        final exists = _messages.any(
          (m) =>
              m['content'] == content &&
              m['sent_at'] == sentAt &&
              m['sender_id'] == senderId,
        );

        if (exists) {
          return;
        }
      }

      if (optimistic && messageId == null) {
        final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
        message['message_id'] = tempId;
        message['_is_optimistic'] = true;
        _pendingMessages.add(tempId);
      }

      _messages.add(message);
      _sortMessages();

      debugPrint(
        '✅ Added message: ${message['content']} (optimistic: $optimistic, fromSocket: $fromSocket)',
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _handleMessageConfirmation(Map<String, dynamic> serverMsg) {
    setState(() {
      final content = serverMsg['content'];

      final tempIndex = _messages.indexWhere(
        (m) =>
            m['_is_optimistic'] == true &&
            m['content'] == content &&
            m['sender_id'] == widget.currentUserId,
      );

      if (tempIndex != -1) {
        final tempId = _messages[tempIndex]['message_id'];
        _pendingMessages.remove(tempId);
        _messages[tempIndex] = {...serverMsg, '_is_confirmed': true};
      } else {
        _addMessage(serverMsg, fromSocket: true);
      }
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || !_isConnected) return;

    final tempMessage = {
      "sender_id": widget.currentUserId,
      "receiver_id": widget.partner['user_id'],
      "content": text,
    };

    _controller.clear();

    _addMessage(tempMessage, optimistic: true);

    try {
      final serverMessage = Map<String, dynamic>.from(tempMessage);
      serverMessage.remove('_is_optimistic');

      SocketService.instance.sendMessage(serverMessage);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send message: $e'),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Retry',
            onPressed: () {
              final retryMessage = Map<String, dynamic>.from(tempMessage);
              retryMessage.remove('_is_optimistic');
              SocketService.instance.sendMessage(retryMessage);
            },
          ),
        ),
      );
    }
  }

  String _formatMessageTime(String? timestamp) {
    if (timestamp == null) return '';
    try {
      final dateTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final diff = now.difference(dateTime);

      if (diff.inDays > 0) {
        return '${dateTime.day}/${dateTime.month}';
      } else if (diff.inHours > 0) {
        final hour = dateTime.hour;
        final minute = dateTime.minute.toString().padLeft(2, '0');
        final period = hour >= 12 ? 'PM' : 'AM';
        final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
        return '$displayHour:$minute $period';
      } else if (diff.inMinutes > 0) {
        return '${diff.inMinutes}m ago';
      } else {
        return 'now';
      }
    } catch (e) {
      return '';
    }
  }

  Widget _buildMessage(Map<String, dynamic> message, int index) {
    final isMe = message['sender_id'] == widget.currentUserId;
    final content = message['content'] ?? '';
    final timestamp = message['sent_at'];
    final isOptimistic = message['_is_optimistic'] == true;

    Widget? dateSeparator;
    if (index == 0 || _shouldShowDateSeparator(index)) {
      dateSeparator = _buildDateSeparator(timestamp);
    }

    return Column(
      children: [
        if (dateSeparator != null) dateSeparator,
        Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.only(
              left: isMe ? 50 : 8,
              right: isMe ? 8 : 50,
              bottom: 4,
            ),
            child: Column(
              crossAxisAlignment: isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isMe
                        ? (isOptimistic ? Colors.blue[200] : Colors.blue[300])
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(Sizes.radiusMd),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        content,
                        style: TextStyle(
                          fontSize: 16,
                          color: isMe ? Colors.white : Colors.black87,
                        ),
                      ),
                      if (isOptimistic)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 12,
                                height: 12,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    isMe ? Colors.white70 : Colors.grey[600]!,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Sending...',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isMe
                                      ? Colors.white70
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    _formatMessageTime(timestamp),
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool _shouldShowDateSeparator(int index) {
    if (index == 0) return true;

    final currentMsg = _messages[index];
    final previousMsg = _messages[index - 1];

    final currentTime = currentMsg['sent_at'];
    final previousTime = previousMsg['sent_at'];

    if (currentTime == null || previousTime == null) return false;

    try {
      final currentDate = DateTime.parse(currentTime);
      final previousDate = DateTime.parse(previousTime);

      return currentDate.day != previousDate.day ||
          currentDate.month != previousDate.month ||
          currentDate.year != previousDate.year;
    } catch (e) {
      return false;
    }
  }

  Widget _buildDateSeparator(String? timestamp) {
    if (timestamp == null) return const SizedBox.shrink();

    try {
      final date = DateTime.parse(timestamp);
      final now = DateTime.now();
      final diff = now.difference(date);

      String dateStr;
      if (diff.inDays == 0) {
        dateStr = 'Today';
      } else if (diff.inDays == 1) {
        dateStr = 'Yesterday';
      } else if (diff.inDays < 7) {
        const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        dateStr = weekdays[date.weekday - 1];
      } else {
        dateStr = '${date.day}/${date.month}/${date.year}';
      }

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              dateStr,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                (widget.partner["name"] ?? "U")[0].toUpperCase(),
                style: TextStyle(
                  color: colors.gray1,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.partner["name"] ?? "Unknown User",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _isConnected ? 'Online' : 'Connecting...',
                    style: TextStyle(
                      fontSize: 12,
                      color: _isConnected ? Colors.green : Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isConnected ? Colors.green : Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (!_isConnected)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              color: Colors.orange,
              child: Text(
                'Connection lost. Messages may not be delivered.',
                style: TextStyle(color: colors.gray1, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: colors.color4,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No messages yet',
                          style: TextStyle(fontSize: 18, color: colors.gray6),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start the conversation!',
                          style: TextStyle(fontSize: 14, color: colors.gray5),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return _buildMessage(_messages[index], index);
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(top: BorderSide(color: colors.gray6)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "Type a message...",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.send, color: colors.gray11),
                    onPressed: _isConnected ? _sendMessage : null,
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
