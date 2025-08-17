import 'package:flutter/material.dart';

class BackgroundSyncService {
  BackgroundSyncService._privateConstructor();

  static final BackgroundSyncService instance =
      BackgroundSyncService._privateConstructor();

  Future<void> start() async {
    try {
      debugPrint("Background sync started...");
    } catch (e, st) {
      debugPrint("⚠️ Background sync failed: $e\n$st");
    }
  }
}
