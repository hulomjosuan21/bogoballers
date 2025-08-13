import 'package:bogoballers/core/helpers/api_reponse.dart';
import 'package:bogoballers/core/models/user_model.dart';
import 'package:bogoballers/core/network/dio_client.dart';
import 'package:bogoballers/core/services/secure_storage_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AuthService {
  static Future<ApiResponse<void>> login({required FormData u}) async {
    final api = DioClient().client;

    final response = await api.post('/entity/login', data: u);

    final setCookie = response.headers['set-cookie']?.first;
    if (setCookie != null) {
      final match = RegExp(r'QUART_AUTH=([^;]+)').firstMatch(setCookie);
      if (match != null) {
        final quartAuth = match.group(1)!;
        debugPrint('🍪 QUART_AUTH: $quartAuth');

        await SecureStorageService.instance.write(
          key: 'QUART_AUTH',
          value: quartAuth,
        );
      }
    }

    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data,
      (json) => json as Map<String, dynamic>,
    );

    return apiResponse;
  }

  static Future<ApiResponse<UserModel>?> getCurrentUser() async {
    try {
      final api = DioClient().client;

      final response = await api.get('/entity/auth');

      if (response.statusCode == 200 && response.data != null) {
        final apiResponse = ApiResponse<UserModel>.fromJson(
          Map<String, dynamic>.from(response.data),
          (json) => UserModel.fromJson(Map<String, dynamic>.from(json)),
        );

        if (apiResponse.payload != null) {
          debugPrint("👤 Current user JSON:\n${apiResponse.payload!.toJson()}");
        }

        return apiResponse;
      } else {
        debugPrint('No user data returned: ${response.data}');
      }
    } on DioException catch (e) {
      debugPrint(
        'Error fetching current user: ${e.response?.statusCode} ${e.message}',
      );
    } catch (e) {
      debugPrint('Unexpected error: $e');
    }

    return null;
  }

  static Future<void> playerRegister() async {}

  static Future<void> teamManagerRegister() async {}
}
