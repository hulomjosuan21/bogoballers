// ignore_for_file: non_constant_identifier_names

import 'package:bogoballers/core/helpers/api_reponse.dart';
import 'package:bogoballers/core/network/dio_client.dart';
import 'package:bogoballers/core/services/entity_service.dart';
import 'package:dio/dio.dart';

class PlayerTeamService {
  static Future<ApiResponse> addPlayer({
    required String teamId,
    required String playerId,
    required String status,
  }) async {
    final api = DioClient().client;

    final entity = await getEntityCredentialsFromStorage();
    final userId = entity.userId;

    final data = {"team_id": teamId, "player_id": playerId, "status": status};

    Response response = await api.post(
      "/player-team/add-player",
      queryParameters: {"user_id": userId},
      data: data,
    );

    return ApiResponse.fromJsonNoPayload(response.data);
  }

  static Future<ApiResponse> updateOne({
    required String playerTeamId,
    required Map<String, dynamic> data,
  }) async {
    final api = DioClient().client;

    Response response = await api.put(
      '/player-team/update/$playerTeamId',
      data: data,
    );

    return ApiResponse.fromJsonNoPayload(response.data);
  }

  static Future<ApiResponse> toggleTeamCaptain(String playerTeamId) async {
    final api = DioClient().client;

    Response response = await api.put(
      '/player-team/toggle-captain/$playerTeamId',
    );

    return ApiResponse.fromJsonNoPayload(response.data);
  }

  static Future<ApiResponse> removePlayerFromTeam(String playerTeamId) async {
    final api = DioClient().client;

    Response response = await api.put(
      '/player-team/toggle-captain/$playerTeamId',
    );

    return ApiResponse.fromJsonNoPayload(response.data);
  }
}
