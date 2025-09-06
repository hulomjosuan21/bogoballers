// lib/core/services/background_sync_service.dart
import 'package:bogoballers/core/services/socket_io_service.dart';
import 'package:flutter/material.dart';

class BackgroundSyncService {
  BackgroundSyncService._privateConstructor();

  static final BackgroundSyncService instance =
      BackgroundSyncService._privateConstructor();

  Future<void> start() async {
    try {
      await SocketService.instance.connect();

      debugPrint("Background sync started...");
    } catch (e, st) {
      debugPrint("⚠️ Background sync failed: $e\n$st");
    }
  }
}
