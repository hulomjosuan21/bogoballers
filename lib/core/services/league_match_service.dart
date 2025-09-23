import 'package:bogoballers/core/models/leagueMatch.dart';
import 'package:bogoballers/core/network/dio_client.dart';
import 'package:bogoballers/core/services/entity_service.dart';
import 'package:dio/dio.dart';

class LeagueMatchService {
  static Future<List<LeagueMatchModel>> getAllByUserId() async {
    final api = DioClient().client;

    final entity = await getEntityCredentialsFromStorage();

    final Response response = await api.post(
      '/league-match/matches/all/${entity.userId}',
      data: {'condition': 'Upcoming'},
    );

    final data = response.data as List<dynamic>;

    return data
        .map((json) => LeagueMatchModel.fromMap(json as Map<String, dynamic>))
        .toList();
  }
}
