import 'package:flutter/material.dart';
import 'package:bogoballers/core/services/ai_mentor_service.dart';
import 'package:bogoballers/core/services/secure_storage_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:bogoballers/core/theme/theme_extensions.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final AIMentorService _aiService = AIMentorService();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> messages = [];
  bool _isLoading = false;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _initializeUserAndChat();
  }

  Future<void> _initializeUserAndChat() async {
    try {
      final creds = await getEntityCredentialsFromStorage();
      setState(() => _userId = creds.userId);

      await _loadHistory();
    } catch (e) {
      print('❌ Failed to load user credentials: $e');
    }
  }

  /// 🔐 Helper from your auth utils
  Future<({String userId, String entityId, String accountType})>
  getEntityCredentialsFromStorage() async {
    final token = await SecureStorageService.instance.read("ACCESS_TOKEN");

    if (token == null || token.isEmpty) {
      throw Exception("No access token found");
    }
    if (JwtDecoder.isExpired(token)) {
      throw Exception("Access token expired");
    }

    final decoded = JwtDecoder.decode(token);
    final userId = decoded["sub"]?.toString();
    final entityId = decoded["entity_id"]?.toString();
    final accountType = decoded["account_type"]?.toString();

    if (userId == null || entityId == null || accountType == null) {
      throw Exception("Invalid token payload");
    }

    return (userId: userId, entityId: entityId, accountType: accountType);
  }

  /// 🧠 Load chat history
  Future<void> _loadHistory() async {
    if (_userId == null) return;

    final history = await _aiService.getHistory(_userId!);
    setState(() {
      messages = history
          .map(
            (msg) => {
              'role': msg['role'] ?? '',
              'content': msg['content'] ?? '',
            },
          )
          .toList();
    });
  }

  Future<void> _sendMessage() async {
    if (_userId == null) return;

    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({'role': 'user', 'content': text});
      _isLoading = true;
    });
    _controller.clear();

    final res = await _aiService.sendMessage(userId: _userId!, message: text);

    if (res != null) {
      setState(() {
        messages.add({
          'role': res['coach']['role'],
          'content': res['coach']['content'],
        });
      });
    }

    setState(() => _isLoading = false);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "🏀 Coach Wan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              if (_userId == null) return;
              await _aiService.clearHistory(_userId!);
              setState(() => messages.clear());
            },
          ),
        ],
      ),
      body: _userId == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(12),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isUser = msg['role'] == 'user';
                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isUser ? colors.color9 : colors.gray3,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            msg['content'] ?? '',
                            style: TextStyle(
                              color: isUser ? colors.gray1 : colors.gray12,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(),
                  ),
                _buildInputBar(),
              ],
            ),
    );
  }

  Widget _buildInputBar() {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.send,
              decoration: InputDecoration(
                hintText: "Ask Coach Wan...",
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: colors.color9,
            child: IconButton(
              icon: Icon(Icons.send, color: colors.gray1),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
