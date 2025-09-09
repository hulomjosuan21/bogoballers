import 'package:bogoballers/core/services/entity_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as sio;
import 'package:flutter/foundation.dart';

class SocketService {
  SocketService._privateConstructor();
  static final SocketService instance = SocketService._privateConstructor();

  sio.Socket? socket;
  bool _isConnected = false;
  String? _currentUserId;

  final Map<String, void Function(dynamic)> _eventCallbacks = {};

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
          socket!.emit('join_user_room', {'user_id': _currentUserId});
          _reregisterCallbacks();
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
          socket!.emit('join_user_room', {'user_id': _currentUserId});
          _reregisterCallbacks();
        }
      });

      socket!.onConnectError((err) {
        debugPrint('SocketService: connect_error: $err');
        _isConnected = false;
      });

      socket!.onError((err) {
        debugPrint('SocketService: error: $err');
      });

      socket!.on('joined_room', (data) {
        debugPrint('SocketService: Successfully joined room: $data');
      });

      socket!.connect();
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      debugPrint('SocketService.connect error: $e');
    }
  }

  void _reregisterCallbacks() {
    _eventCallbacks.forEach((event, callback) {
      socket?.off(event);
      socket?.on(event, callback);
    });
  }

  void on(String event, void Function(dynamic) callback) {
    void socketCallback(dynamic data) {
      debugPrint('🔗 Event $event received: $data');
      callback(data);
    }

    _eventCallbacks[event] = socketCallback;
    socket?.off(event);
    socket?.on(event, socketCallback);
  }

  void off(String event) {
    socket?.off(event);
    _eventCallbacks.remove(event);
  }

  void clearListeners() {
    socket?.clearListeners();
    _eventCallbacks.clear();
  }

  bool get isConnected => _isConnected && socket != null && socket!.connected;
  String? get currentUserId => _currentUserId;

  void disconnect() {
    _isConnected = false;
    _eventCallbacks.clear();
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
