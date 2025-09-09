import 'package:bogoballers/core/helpers/api_reponse.dart';
import 'package:bogoballers/core/services/player/player_team_service.dart';

class NotificationAction {
  static Future<ApiResponse> acceptTeamInvitation(String playerTeamId) async {
    return await PlayerTeamService.updateOne(
      playerTeamId: playerTeamId,
      data: {"is_accepted": "Accepted"},
    );
  }

  static Future<ApiResponse> rejectTeamInvitation(String playerTeamId) async {
    return await PlayerTeamService.updateOne(
      playerTeamId: playerTeamId,
      data: {"is_accepted": "Rejected"},
    );
  }
}
