import 'package:bogoballers/core/services/secure_storage_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio _dio;

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['API_BASE_URL'] ?? 'http://localhost:5000',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(minutes: 10),
        sendTimeout: const Duration(minutes: 5),
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(responseBody: true, requestBody: true),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SecureStorageService.instance.read('QUART_AUTH');
          if (token != null) {
            options.headers['Cookie'] = 'QUART_AUTH=$token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  Dio get client => _dio;

  String get baseUrl => _dio.options.baseUrl;

  Future<void> clearAccessToken() async {
    await SecureStorageService.instance.delete('QUART_AUTH');
  }

  Future<void> printStoredQuartAuth() async {
    final token = await SecureStorageService.instance.read('QUART_AUTH');
    debugPrint('🍪 Stored QUART_AUTH: $token');
  }
}
