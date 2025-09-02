// ignore_for_file: non_constant_identifier_names

import 'package:bogoballers/core/helpers/api_reponse.dart';
import 'package:bogoballers/core/network/dio_client.dart';
import 'package:bogoballers/core/services/entity_service.dart';
import 'package:dio/dio.dart';

class PlayerTeamUpdatePayload {
  final String playerId;
  final String newStatus;

  PlayerTeamUpdatePayload({required this.playerId, required this.newStatus});

  Map<String, String> toMap() {
    return {"player_id": playerId, "new_status": newStatus};
  }
}

class PlayerTeamService {
  static Future<ApiResponse> addPlayer({
    required String teamId,
    required String playerId,
    required String status,
    String? teamLogoUrl, // already nullable
  }) async {
    final api = DioClient().client;

    final entity = await getEntityCredentialsFromStorage();
    final userId = entity.userId;

    final data = {
      "team_id": teamId,
      "player_id": playerId,
      "status": status,
      if (teamLogoUrl != null && teamLogoUrl.isNotEmpty)
        "team_logo_url": teamLogoUrl,
    };

    Response response = await api.post(
      "/player-team/add-player",
      queryParameters: {"user_id": userId},
      data: data,
    );

    return ApiResponse.fromJsonNoPayload(response.data);
  }

  static Future<ApiResponse> updateStatus({
    String? teamId,
    String? playerTeamId,
    required PlayerTeamUpdatePayload data,
  }) async {
    final api = DioClient().client;

    if ((teamId == null || teamId.isEmpty) &&
        (playerTeamId == null || playerTeamId.isEmpty)) {
      throw ArgumentError("Either teamId or playerTeamId must be provided.");
    }

    final queryParams = <String, String>{};
    if (teamId != null && teamId.isNotEmpty) {
      queryParams["team_id"] = teamId;
    }
    if (playerTeamId != null && playerTeamId.isNotEmpty) {
      queryParams["player_team_id"] = playerTeamId;
    }

    final url = "/player-team/update-status";

    Response response = await api.put(
      url,
      queryParameters: queryParams,
      data: data.toMap(),
    );

    return ApiResponse.fromJsonNoPayload(response.data);
  }
}
