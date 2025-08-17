import 'package:bogoballers/core/helpers/api_reponse.dart';
import 'package:bogoballers/core/models/team_model.dart';
import 'package:bogoballers/core/network/dio_client.dart';
import 'package:dio/dio.dart';

class TeamService {
  static Future<List<TeamModel>> fetchTeams() async {
    final api = DioClient().client;
    final Response<List> response = await api.get('/team-manager/teams');

    return (response.data ?? [])
        .map((e) => TeamModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  static Future<ApiResponse> createTeam(FormData data) async {
    final api = DioClient().client;
    Response response = await api.post('/team-manager/create/team', data: data);

    final apiResponse = ApiResponse.fromJsonNoPayload(response.data);

    return apiResponse;
  }
}
