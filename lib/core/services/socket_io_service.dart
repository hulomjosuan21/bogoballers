import 'package:bogoballers/core/services/entity_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as sio;
import 'package:flutter/foundation.dart';

class SocketService {
  SocketService._privateConstructor();

  static final SocketService instance = SocketService._privateConstructor();

  late sio.Socket socket;

  Future<void> connect() async {
    final entity = await getEntityCredentialsFromStorageOrNull();
    if (entity == null) return;
    final socketUrl = 'https://api.bogoballers.site';
    socket = sio.io(
      socketUrl,
      sio.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      debugPrint('Connected to server');
      socket.emit('register', {'user_id': entity.userId}); // now safe
    });

    socket.on('registered', (data) {
      debugPrint('Registration success: $data');
    });

    socket.on('connected_devices', (data) {
      debugPrint('Devices connected for this user: $data');
    });

    socket.onDisconnect((_) {
      debugPrint('Disconnected from server');
    });
  }

  void getConnectedDevices(String userId) {
    socket.emit('get_connected_devices', {'user_id': userId});
  }
}
