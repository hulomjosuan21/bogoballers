import 'package:bogoballers/core/services/secure_storage_service.dart';
import 'package:flutter/material.dart';

class BackgroundSyncService {
  BackgroundSyncService._privateConstructor();

  static final BackgroundSyncService instance = BackgroundSyncService._privateConstructor();

  Future<void> start() async {
    try {
      await _syncLeagueData();
    } catch (e, st) {
      debugPrint("Background sync failed: $e\n$st");
    }
  }

  Future<void> _syncLeagueData() async {
  const key = 'user_id';
  final readValue = await SecureStorageService.instance.read(key);
  debugPrint('📦 Retrieved $key: $readValue');
  }
}