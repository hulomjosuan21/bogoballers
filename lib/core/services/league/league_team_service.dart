import 'package:bogoballers/core/network/dio_client.dart';

class LeagueTeamService {
  static Future<Map<String, dynamic>> addTeam({
    required String teamId,
    required String leagueId,
    required String leagueCategoryId,
    required double amountPaid,
    required String paymentMethod,
  }) async {
    final api = DioClient().client;
    final response = await api.post(
      '/league-team/add-team',
      data: {
        "team_id": teamId,
        "league_id": leagueId,
        "league_category_id": leagueCategoryId,
        "amount_paid": amountPaid,
        "payment_method": paymentMethod,
      },
    );

    return response.data;
  }
}
