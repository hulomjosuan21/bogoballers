import 'package:bogoballers/core/helpers/api_reponse.dart';
import 'package:bogoballers/core/network/dio_client.dart';
import 'package:bogoballers/core/services/player/player_team_service.dart';
import 'package:dio/dio.dart';

class NotificationAction {
  static Future<ApiResponse> acceptTeamInvitation(String playerTeamId) async {
    return await PlayerTeamService.updateOne(
      playerTeamId: playerTeamId,
      data: {"is_accepted": "Accepted"},
    );
  }

  static Future<ApiResponse> deleteNotification(String notificationId) async {
    final api = DioClient().client;

    Response response = await api.delete('/notif/delete/$notificationId');

    return ApiResponse.fromJsonNoPayload(response.data);
  }

  static Future<ApiResponse> rejectTeamInvitation(String playerTeamId) async {
    return await PlayerTeamService.updateOne(
      playerTeamId: playerTeamId,
      data: {"is_accepted": "Rejected"},
    );
  }
}
