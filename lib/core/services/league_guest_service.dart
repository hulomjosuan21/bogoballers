import 'package:bogoballers/core/network/dio_client.dart';

class LeagueGuestService {
  static Future<Map<String, dynamic>> submitGuestRequest({
    required String leagueCategoryId,
    required String paymentMethod,
    String? teamId,
    String? playerId,
  }) async {
    final api = DioClient().client;

    if ((teamId == null && playerId == null) ||
        (teamId != null && playerId != null)) {
      throw ArgumentError(
        'You must provide either a teamId or a playerId, but not both.',
      );
    }

    final payload = {
      'league_category_id': leagueCategoryId,
      'team_id': teamId,
      'player_id': playerId,
      'payment_method': paymentMethod,
    };

    payload.removeWhere((key, value) => value == null);

    final response = await api.post<Map<String, dynamic>>(
      '/league-guest/register',
      data: payload,
    );
    return response.data ?? {'message': 'Request submitted successfully.'};
  }
}
