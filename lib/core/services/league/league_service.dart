import 'package:bogoballers/core/models/league_model.dart';
import 'package:bogoballers/core/network/dio_client.dart';
import 'package:dio/dio.dart';

class LeagueService {
  static Future<Response> registerTeam(Map<String, dynamic> data) async {
    final api = DioClient().client;

    final response = await api.post('/league-team/register', data: data);
    return response;
  }

  static Future<Response> registerTeamFree(Map<String, dynamic> data) async {
    final api = DioClient().client;

    try {
      final response = await api.post(
        '/league-team/register-team/free',
        data: data,
      );
      return response;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? e.message ?? "Something went wrong",
      );
    }
  }

  static Future<List<League>> leagueCarouselItems() async {
    final api = DioClient().client;

    try {
      final response = await api.get('/league/carousel');
      final list = (response.data as List)
          .map((e) => League.fromMap(e))
          .toList();
      return list;
    } catch (e) {
      return [];
    }
  }
}
