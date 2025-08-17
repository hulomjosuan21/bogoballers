import 'package:bogoballers/core/network/dio_client.dart';
import 'package:bogoballers/core/services/entity_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  SecureStorageService._internal();

  static final SecureStorageService instance = SecureStorageService._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _accessTokenKey = 'ACCESS_TOKEN';

  Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> deleteCredentials() async {
    await delete('QUART_AUTH');
    await delete(_accessTokenKey);
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  Future<bool> containsKey(String key) async {
    return await _storage.containsKey(key: key);
  }

  Future<void> saveAccessToken(String token) async {
    await write(key: _accessTokenKey, value: token);
  }
}

extension FCMTokenHandler on SecureStorageService {
  static const String _fcmTokenKey = 'fcm_token';

  Future<void> syncFcmToken([String? refreshedToken]) async {
    try {
      final messaging = FirebaseMessaging.instance;
      final token = refreshedToken ?? await messaging.getToken();
      if (token == null) return;

      final creds = await getEntityCredentialsFromStorage();
      final userId = creds.userId;
      final entityId = creds.entityId;

      final namespacedKey = '$_fcmTokenKey:$userId';

      final storedToken = await read(namespacedKey);

      if (storedToken == token) {
        return;
      }

      await write(key: namespacedKey, value: token);

      final api = DioClient().client;
      await api.post(
        '/entity/update-fcm',
        data: {'fcm_token': token, 'user_id': userId, 'entity_id': entityId},
      );
    } catch (e) {
      debugPrint("❌ Failed to sync FCM token: $e");
    }
  }
}
