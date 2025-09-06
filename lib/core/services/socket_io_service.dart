import 'package:bogoballers/core/services/entity_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as sio;
import 'package:flutter/foundation.dart';

class SocketService {
  SocketService._privateConstructor();
  static final SocketService instance = SocketService._privateConstructor();

  sio.Socket? socket;
  bool _isConnected = false;
  String? _currentUserId;

  static const String _socketUrl = 'https://api.bogoballers.site';

  Future<void> connect() async {
    try {
      final entity = await getEntityCredentialsFromStorageOrNull();
      if (entity == null) {
        debugPrint('SocketService: No entity credentials found');
        return;
      }

      _currentUserId = entity.userId;

      if (_isConnected && socket != null && socket!.connected) {
        debugPrint('SocketService: Already connected');
        return;
      }

      if (socket != null) {
        socket!.clearListeners();
        socket!.disconnect();
      }

      socket = sio.io(
        _socketUrl,
        sio.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .enableReconnection()
            .setReconnectionAttempts(10)
            .setReconnectionDelay(1000)
            .setQuery({'user_id': _currentUserId})
            .build(),
      );

      socket!.onConnect((_) {
        debugPrint('SocketService: connected');
        _isConnected = true;
        if (_currentUserId != null) {
          socket!.emit('join', {'user_id': _currentUserId});
        }
      });

      socket!.onDisconnect((reason) {
        debugPrint('SocketService: disconnected: $reason');
        _isConnected = false;
      });

      socket!.onReconnect((attempt) {
        debugPrint('SocketService: reconnected attempt: $attempt');
        _isConnected = true;
        if (_currentUserId != null) {
          socket!.emit('join', {'user_id': _currentUserId});
        }
      });

      socket!.onConnectError((err) {
        debugPrint('SocketService: connect_error: $err');
        _isConnected = false;
      });

      socket!.onError((err) {
        debugPrint('SocketService: error: $err');
      });

      socket!.connect();
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      debugPrint('SocketService.connect error: $e');
    }
  }

  void register(String userId) {
    if (_isConnected && socket != null && socket!.connected) {
      socket!.emit('register', {'user_id': userId});
    }
  }

  void getConversations(String userId) {
    if (_isConnected && socket != null && socket!.connected) {
      socket!.emit('get_conversations', {'user_id': userId});
    }
  }

  void sendMessage(Map<String, dynamic> message) {
    if (_isConnected && socket != null && socket!.connected) {
      socket!.emit('send_message', message);
    }
  }

  Map<String, dynamic>? _extractMessage(dynamic raw) {
    try {
      if (raw == null) return null;
      if (raw is Map) {
        if (raw.containsKey('message') && raw['message'] is Map) {
          return Map<String, dynamic>.from(raw['message']);
        }
        if (raw.containsKey('data') && raw['data'] is Map) {
          return Map<String, dynamic>.from(raw['data']);
        }
        if (raw.containsKey('message_id') || raw.containsKey('sender_id')) {
          return Map<String, dynamic>.from(raw);
        }
        if (raw.containsKey('type') &&
            raw.containsKey('message') &&
            raw['message'] is Map) {
          return Map<String, dynamic>.from(raw['message']);
        }
      }
    } catch (e) {
      debugPrint('SocketService._extractMessage error: $e');
    }
    return null;
  }

  void onNewMessage(void Function(Map<String, dynamic>) callback) {
    socket?.off('new_message');
    socket?.on('new_message', (data) {
      final msg = _extractMessage(data);
      if (msg != null) callback(msg);
    });
  }

  void onConversations(void Function(dynamic) callback) {
    socket?.off('conversations');
    socket?.on('conversations', callback);
  }

  void onMessageSent(void Function(Map<String, dynamic>) callback) {
    socket?.off('message_sent');
    socket?.on('message_sent', (data) {
      final msg = _extractMessage(data);
      if (msg != null) {
        callback(msg);
      } else {
        try {
          if (data is Map && data['data'] is Map) {
            callback(Map<String, dynamic>.from(data['data']));
            return;
          }
        } catch (_) {}
      }
    });
  }

  void off(String event) {
    socket?.off(event);
  }

  void clearListeners() {
    socket?.clearListeners();
  }

  bool get isConnected => _isConnected && socket != null && socket!.connected;

  void disconnect() {
    _isConnected = false;
    try {
      socket?.disconnect();
      socket?.clearListeners();
    } catch (_) {}
  }

  void dispose() {
    try {
      socket?.dispose();
    } catch (_) {}
  }
}
