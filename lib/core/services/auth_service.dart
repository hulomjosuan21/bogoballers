// ignore_for_file: unused_catch_clause

import 'package:bogoballers/core/helpers/api_reponse.dart';
import 'package:bogoballers/core/network/dio_client.dart';
import 'package:bogoballers/core/services/secure_storage_service.dart';
import 'package:bogoballers/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AuthService {
  // static Future<void> getCurrentUserAndNavigate() async {
  //   try {
  //     final api = DioClient().client;
  //     final response = await api.get('/entity/auth');

  //     if (response.statusCode == 200 && response.data != null) {
  //       final data = Map<String, dynamic>.from(response.data);
  //       if (data.containsKey('player_id')) {
  //         final player = PlayerModel.fromJson(data);
  //         debugPrint("👤 Player JSON: ${player.toJson()}");
  //         navigatorKey.currentState?.pushReplacementNamed(
  //           '/player/main/screen',
  //         );
  //       } else {
  //         final user = UserModel.fromJson(data);
  //         debugPrint("👤 User JSON: ${user.toJson()}");
  //         if (user.account_type.value == 'Team_Manager') {
  //           navigatorKey.currentState?.pushReplacementNamed(
  //             '/team-manager/main/screen',
  //           );
  //         } else {
  //           navigatorKey.currentState?.pushReplacementNamed('/auth/login');
  //         }
  //       }
  //     } else {
  //       navigatorKey.currentState?.pushReplacementNamed('/auth/login');
  //     }
  //   } on DioException catch (e) {
  //     navigatorKey.currentState?.pushReplacementNamed('/auth/login');
  //   } catch (e) {
  //     navigatorKey.currentState?.pushReplacementNamed('/auth/login');
  //   }
  // }

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

    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data,
      (json) => json as Map<String, dynamic>,
    );

    return apiResponse;
  }

  static Future<void> playerRegister() async {}

  static Future<void> teamManagerRegister() async {}
}
