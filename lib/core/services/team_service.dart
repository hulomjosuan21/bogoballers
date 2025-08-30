// ignore_for_file: non_constant_identifier_names

import 'package:bogoballers/core/helpers/api_reponse.dart';
import 'package:bogoballers/core/models/team_model.dart';
import 'package:bogoballers/core/network/dio_client.dart';
import 'package:bogoballers/core/services/entity_service.dart';
import 'package:dio/dio.dart';

class TeamService {
  static Future<List<TeamModel>> fetchTeams() async {
    final entity = await getEntityCredentialsFromStorage();
    final user_id = entity.userId;
    final api = DioClient().client;
    final Response<List> response = await api.get('/team/all?user_id=$user_id');

    return (response.data ?? [])
        .map((e) => TeamModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  static Future<ApiResponse> createTeam(FormData data) async {
    final api = DioClient().client;
    Response response = await api.post('/team/create', data: data);

    final apiResponse = ApiResponse.fromJsonNoPayload(response.data);

    return apiResponse;
  }
}
