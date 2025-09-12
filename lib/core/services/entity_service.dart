import 'package:bogoballers/core/helpers/api_reponse.dart';
import 'package:bogoballers/core/network/dio_client.dart';
import 'package:bogoballers/core/services/secure_storage_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class EntityService {
  static Future<String?> fetchEntityRedirect() async {
    final token = await SecureStorageService.instance.read('QUART_AUTH');

    if (token == null) return null;

    final api = DioClient().client;
    final response = await api.get('/entity/auth');

    if (response.statusCode == 200 && response.data != null) {
      return response.data.toString();
    }
    return null;
  }

  static Future<void> setQuartAuthCookie(String? cookie) async {
    if (cookie == null) {
      throw Exception('Cookie is null');
    }

    final match = RegExp(r'QUART_AUTH=([^;]+)').firstMatch(cookie);
    if (match == null || match.group(1) == null) {
      throw Exception('QUART_AUTH not found in cookie');
    }

    final quartAuth = match.group(1)!;

    await SecureStorageService.instance.write(
      key: 'QUART_AUTH',
      value: quartAuth,
    );
  }

  static Future<ApiResponse<void>> login({
    required Map<String, String> u,
  }) async {
    final api = DioClient().client;

    final response = await api.post('/entity/login', data: u);

    final cookie = response.headers['set-cookie']?.first;
    if (cookie != null) {
      setQuartAuthCookie(cookie);
    }

    final apiResponse = ApiResponse<String>.fromJson(
      response.data,
      (data) => data as String,
    );

    final token = apiResponse.payload;

    if (token != null && token.isNotEmpty) {
      await SecureStorageService.instance.saveAccessToken(token);
    }

    return apiResponse;
  }
}

Future<({String userId, String entityId, String accountType})>
getEntityCredentialsFromStorage() async {
  final token = await SecureStorageService.instance.read("ACCESS_TOKEN");
  if (token == null || token.isEmpty) {
    throw Exception("No access token found");
  }
  if (JwtDecoder.isExpired(token)) {
    throw Exception("Access token expired");
  }

  final decoded = JwtDecoder.decode(token);

  final userId = decoded["sub"]?.toString();
  final entityId = decoded["entity_id"]?.toString();
  final accountType = decoded["account_type"]?.toString();

  if (userId == null || entityId == null || accountType == null) {
    throw Exception("Invalid token payload");
  }

  return (userId: userId, entityId: entityId, accountType: accountType);
}

Future<({String userId, String entityId, String accountType})?>
getEntityCredentialsFromStorageOrNull() async {
  final token = await SecureStorageService.instance.read("ACCESS_TOKEN");
  if (token == null || token.isEmpty) return null;

  try {
    if (JwtDecoder.isExpired(token)) return null;

    final decoded = JwtDecoder.decode(token);
    final userId = decoded["sub"]?.toString();
    final entityId = decoded["entity_id"]?.toString();
    final accountType = decoded["account_type"]?.toString();

    if (userId == null || entityId == null || accountType == null) return null;

    return (userId: userId, entityId: entityId, accountType: accountType);
  } catch (_) {
    return null;
  }
}
