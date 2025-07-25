import 'package:bogoballers/core/services/secure_storage_service.dart';
import 'package:flutter/material.dart';

class BackgroundSyncService {
  BackgroundSyncService._privateConstructor();

  static final BackgroundSyncService instance =
      BackgroundSyncService._privateConstructor();

  Future<void> start() async {
    try {
      await _syncLeagueData();
      await _syncFcmToken();
    } catch (e, st) {
      debugPrint("Background sync failed: $e\n$st");
    }
  }

  Future<void> _syncLeagueData() async {
    const key = 'user_id';
    final readValue = await SecureStorageService.instance.read(key);
    debugPrint('📦 Retrieved $key: $readValue');
  }

  Future<void> _syncFcmToken() async {
    final user = await SecureStorageService.instance.getUserDataFromToken();
    if (user == null) {
      debugPrint("⚠️ Cannot sync FCM token: no valid token or user");
      return;
    }

    try {
      await SecureStorageService.instance.generateAndSaveFCMToken(userId: user.user_id);
      debugPrint('✅ Synced FCM token for user: ${user.user_id}');
    } catch (e) {
      debugPrint('❌ Failed to sync FCM token: $e');
    }
  }
}
