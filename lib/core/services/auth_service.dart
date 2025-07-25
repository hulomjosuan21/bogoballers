import 'package:bogoballers/core/dio_client.dart';
import 'package:bogoballers/core/helpers/api_reponse.dart';
import 'package:bogoballers/core/services/secure_storage_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AuthService {
  static Future<ApiResponse<void>> login({
    required FormData u,
    required s,
  }) async {
    final api = DioClient().client;

    final response = await api.post(
      '/entity/login',
      data: u,
      queryParameters: {'stay_login': s},
    );

    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data,
      (json) => json as Map<String, dynamic>,
    );

    final token = apiResponse.payload?['access_token'];
    await SecureStorageService.instance.saveAccessToken(token);

    return apiResponse;
  }

  static Future<void> playerRegister() async {}

  static Future<void> teamManagerRegister() async {}
}
