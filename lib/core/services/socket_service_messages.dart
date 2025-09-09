import 'package:bogoballers/core/services/socket_io_service.dart';
import 'package:flutter/foundation.dart';

extension MessageSocketExtension on SocketService {
  void sendMessage(Map<String, dynamic> message) {
    if (isConnected) {
      debugPrint('📤 Sending message: $message');
      socket!.emit('send_message', message);
    }
  }

  void getConversations(String userId) {
    if (isConnected) {
      debugPrint('🔄 Requesting conversations for user: $userId');
      socket!.emit('get_conversations', {'user_id': userId});
    }
  }

  void onNewMessage(void Function(Map<String, dynamic>) callback) {
    on('new_message', (data) {
      debugPrint('📨 new_message: $data');
      if (data is Map<String, dynamic>) {
        callback(data);
      }
    });
  }

  void onConversations(void Function(dynamic) callback) {
    on('conversations', (data) {
      debugPrint('📋 conversations: $data');
      callback(data);
    });
  }

  void onMessageSent(void Function(Map<String, dynamic>) callback) {
    on('message_sent', (data) {
      debugPrint('✅ message_sent: $data');
      if (data is Map<String, dynamic>) {
        callback(data);
      }
    });
  }

  void onConversationUpdate(void Function(Map<String, dynamic>) callback) {
    on('conversation_update', (data) {
      debugPrint('🔄 conversation_update: $data');
      if (data is Map<String, dynamic>) {
        callback(data);
      }
    });
  }
}
