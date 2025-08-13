import 'package:bogoballers/core/models/user_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SecureStorageService {
  SecureStorageService._internal();

  static final SecureStorageService instance = SecureStorageService._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _accessTokenKey = 'access_token';

  Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await _storage.read(key: key);
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
    if (token.isEmpty || JwtDecoder.isExpired(token)) {
      throw Exception('Invalid or expired access token');
    }

    final decoded = JwtDecoder.decode(token);
    if (!decoded.containsKey('sub') || !decoded.containsKey('account_type')) {
      throw Exception('Access token missing required claims: sub/account_type');
    }

    await write(key: _accessTokenKey, value: token);
  }

  Future<UserFromToken?> getUserDataFromToken() async {
    final token = await read(_accessTokenKey);

    if (token == null || JwtDecoder.isExpired(token)) {
      return null;
    }

    final decodedToken = JwtDecoder.decode(token);

    final userId = decodedToken['sub']?.toString();
    final accountType = decodedToken['account_type']?.toString();

    if (userId == null && accountType == null) {
      return null;
    }

    return UserFromToken(user_id: userId!, account_type: accountType!);
  }

  Future<bool> hasValidAccessToken() async {
    final token = await read(_accessTokenKey);
    return token != null && !JwtDecoder.isExpired(token);
  }
}

extension FCMTokenHandler on SecureStorageService {
  static const String _fcmTokenKey = 'fcm_token';

  Future<void> generateAndSaveFCMToken({required String userId}) async {
    final existingToken = await _storage.read(key: '$_fcmTokenKey:$userId');
    if (existingToken != null) return;

    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken == null) throw Exception('Failed to retrieve FCM token');

    await _storage.write(key: '$_fcmTokenKey:$userId', value: fcmToken);

    await _sendTokenToBackend(userId: userId, token: fcmToken);
  }

  Future<void> _sendTokenToBackend({
    required String userId,
    required String token,
  }) async {
    // final dio = Dio(BaseOptions(
    //   baseUrl: 'https://your-backend-api.com', // Replace with actual backend
    //   connectTimeout: const Duration(seconds: 5),
    // ));

    // await dio.post('/fcm/save', data: {
    //   'user_id': userId,
    //   'fcm_token': token,
    // });
  }
}
