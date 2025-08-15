import 'package:bogoballers/core/helpers/api_reponse.dart';
import 'package:bogoballers/core/network/dio_client.dart';
import 'package:bogoballers/core/services/secure_storage_service.dart';
import 'package:dio/dio.dart';

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

  static Future<ApiResponse<void>> login({required FormData u}) async {
    final api = DioClient().client;

    final response = await api.post('/entity/login', data: u);

    final cookie = response.headers['set-cookie']?.first;

    setQuartAuthCookie(cookie);

    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJsonNoPayload(
      response.data,
    );

    return apiResponse;
  }
}
