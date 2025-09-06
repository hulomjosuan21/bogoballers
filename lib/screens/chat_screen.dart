import 'package:bogoballers/core/services/socket_io_service.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final Map<String, dynamic> partner;
  final List<dynamic> initialMessages;

  const ChatScreen({
    super.key,
    required this.currentUserId,
    required this.partner,
    this.initialMessages = const [],
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late List<Map<String, dynamic>> _messages;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Load messages passed from ConversationListScreen
    _messages = widget.initialMessages
        .map((m) => Map<String, dynamic>.from(m))
        .toList();

    // Listen for new messages from socket
    SocketService.instance.onNewMessage((msg) {
      if (msg['sender_id'] == widget.partner['user_id'] ||
          msg['receiver_id'] == widget.partner['user_id']) {
        setState(() {
          _messages.add(msg);
        });
      }
    });
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    final newMsg = {
      "sender_id": widget.currentUserId,
      "receiver_id": widget.partner['user_id'],
      "content": _controller.text.trim(),
      "sent_at": DateTime.now().toIso8601String(),
    };

    // Send via socket
    SocketService.instance.sendMessage(newMsg);

    // Optimistic update
    setState(() {
      _messages.add(newMsg);
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.partner["name"] ?? "Chat")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg['sender_id'] == widget.currentUserId;

                return Align(
                  alignment: isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue[300] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(msg['content']),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
