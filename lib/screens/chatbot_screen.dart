import 'package:bogoballers/core/utils/custom_exceptions.dart';
import 'package:bogoballers/core/widget/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
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
  bool _isTyping = false;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _initializeUserAndChat();
  }

  Future<void> _initializeUserAndChat() async {
    try {
      final creds = await getEntityCredentialsFromStorage();
      _userId = creds.userId;
      await _loadHistory();
      setState(() {});
    } catch (e) {
      if (context.mounted) {
        handleErrorCallBack(e, (message) {
          showAppSnackbar(
            context,
            message: message,
            title: "Error",
            variant: SnackbarVariant.error,
          );
        });
      }
    }
  }

  /// 🔐 Decode JWT and extract IDs
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

  Future<void> _loadHistory() async {
    if (_userId == null) return;
    final history = await _aiService.getHistory(_userId!);
    setState(() {
      messages = history
          .map(
            (msg) => {
              'role': msg['role'] ?? '',
              'content': msg['content'] ?? '',
              'time':
                  msg['created_at'] ?? DateTime.now().toUtc().toIso8601String(),
            },
          )
          .toList();
    });
  }

  Future<void> _sendMessage() async {
    if (_userId == null) return;

    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final now = DateTime.now().toUtc().toIso8601String();

    setState(() {
      messages.add({'role': 'user', 'content': text, 'time': now});
      _controller.clear();
      _isTyping = true;
    });

    _scrollToBottom();

    final res = await _aiService.sendMessage(userId: _userId!, message: text);

    setState(() {
      _isTyping = false;
      if (res != null) {
        messages.add({
          'role': res['coach']['role'],
          'content': res['coach']['content'],
          'time': DateTime.now().toUtc().toIso8601String(),
        });
      }
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 250), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTimestamp(DateTime time) {
    int hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12 == 0 ? 12 : hour % 12;
    return "$hour:$minute $period";
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
        flexibleSpace: Container(color: colors.gray1),
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
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [colors.gray1, colors.gray2, colors.gray3],
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(12),
                      itemCount: messages.length + (_isTyping ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (_isTyping && index == messages.length) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: _buildTypingBubble(colors),
                          );
                        }

                        final msg = messages[index];
                        final isUser = msg['role'] == 'user';
                        return Align(
                          alignment: isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: _buildChatBubble(msg, isUser, colors),
                        );
                      },
                    ),
                  ),
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: CircularProgressIndicator(),
                    ),
                  _buildInputBar(colors),
                ],
              ),
            ),
    );
  }

  Widget _buildChatBubble(
    Map<String, dynamic> msg,
    bool isUser,
    AppThemeColors colors,
  ) {
    final timestamp = msg['time'] != null
        ? _formatTimestamp(DateTime.parse(msg['time']).toLocal())
        : '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      child: Column(
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            decoration: BoxDecoration(
              color: isUser ? colors.color9 : colors.gray3,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: isUser
                    ? const Radius.circular(16)
                    : const Radius.circular(4),
                bottomRight: isUser
                    ? const Radius.circular(4)
                    : const Radius.circular(16),
              ),
            ),
            child: MarkdownBody(
              data: msg['content'] ?? '',
              selectable: true,
              softLineBreak: true,
              styleSheet: MarkdownStyleSheet(
                p: TextStyle(
                  color: isUser ? colors.gray1 : colors.gray12,
                  fontSize: 15,
                  height: 1.4,
                ),
                strong: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isUser ? colors.gray1 : colors.gray12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(timestamp, style: TextStyle(fontSize: 11, color: colors.gray9)),
        ],
      ),
    );
  }

  Widget _buildTypingBubble(AppThemeColors colors) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: colors.gray3,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
          bottomLeft: Radius.circular(4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _dot(colors, 0),
          const SizedBox(width: 4),
          _dot(colors, 200),
          const SizedBox(width: 4),
          _dot(colors, 400),
        ],
      ),
    );
  }

  Widget _dot(AppThemeColors colors, int delay) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.3, end: 1),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      builder: (context, value, child) => Opacity(opacity: value, child: child),
      onEnd: () => setState(() {}),
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(color: colors.gray10, shape: BoxShape.circle),
      ),
    );
  }

  Widget _buildInputBar(AppThemeColors colors) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    return SafeArea(
      top: false,
      child: Container(
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
      ),
    );
  }
}
