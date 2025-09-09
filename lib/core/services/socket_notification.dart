import 'package:bogoballers/core/services/socket_io_service.dart';
import 'package:flutter/foundation.dart';

extension NotificationSocketExtension on SocketService {
  /// Join the notification room for a given user
  void joinNotificationRoom(String userId) {
    if (isConnected) {
      debugPrint('🔔 Joining notification room: $userId');
      socket!.emit('join_notification_room', {'user_id': userId});
    }
  }

  /// Fetch notifications for a given user
  void getNotifications(String userId) {
    if (isConnected) {
      debugPrint('📥 Requesting notifications for: $userId');
      socket!.emit('get_notifications', {'user_id': userId});
    }
  }

  /// Listen for the confirmation that you joined a notification room
  void onJoinedNotificationRoom(void Function(Map<String, dynamic>) callback) {
    on('joined_notification_room', (data) {
      debugPrint('✅ Joined notification room: $data');
      if (data is Map) {
        callback(Map<String, dynamic>.from(data));
      }
    });
  }

  /// Listen for the list of notifications
  void onNotifications(void Function(List<Map<String, dynamic>>) callback) {
    on('notifications', (data) {
      debugPrint('📋 Notifications received: $data');
      if (data is Map && data.containsKey('notifications')) {
        final list = (data['notifications'] as List)
            .map((n) => Map<String, dynamic>.from(n))
            .toList();
        callback(list);
      }
    });
  }

  /// Send a notification to another user
  void sendNotification({
    required String toId,
    required String message,
    Map<String, dynamic>? extra,
  }) {
    if (isConnected) {
      final payload = {
        'to_id': toId,
        'message': message,
        if (extra != null) ...extra,
      };
      debugPrint('📤 Sending notification: $payload');
      socket!.emit('send_notification', payload);
    }
  }

  /// Listen for new incoming notifications
  void onNewNotification(void Function(Map<String, dynamic>) callback) {
    on('new_notification', (data) {
      debugPrint('🔔 New notification: $data');
      if (data is Map) {
        callback(Map<String, dynamic>.from(data));
      }
    });
  }
}
