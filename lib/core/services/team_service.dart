import 'package:bogoballers/core/helpers/api_reponse.dart';
import 'package:bogoballers/core/models/team_model.dart';
import 'package:bogoballers/core/network/dio_client.dart';
import 'package:bogoballers/core/services/entity_service.dart';
import 'package:dio/dio.dart';

class TeamService {
  static Future<List<Team>> fetchTeams() async {
    final entity = await getEntityCredentialsFromStorage();
    final userId = entity.userId;
    final api = DioClient().client;
    final Response<List> response = await api.get('/team/all/$userId');

    return (response.data ?? [])
        .map((e) => Team.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  static Future<ApiResponse> createTeam(FormData data) async {
    final api = DioClient().client;
    Response response = await api.post('/team/create', data: data);

    final apiResponse = ApiResponse.fromJsonNoPayload(response.data);

    return apiResponse;
  }
}
