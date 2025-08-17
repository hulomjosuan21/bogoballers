import 'package:bogoballers/core/helpers/api_reponse.dart';
import 'package:bogoballers/core/models/team_manager.dart';
import 'package:bogoballers/core/network/dio_client.dart';
import 'package:dio/dio.dart';

class TeamManagerServices {
  static Future<ApiResponse> createNewTeamManager(
    CreateTeamManager user,
  ) async {
    final api = DioClient().client;

    Response response = await api.post(
      '/team-manager/create',
      data: user.toFormData(),
    );
    final apiResponse = ApiResponse.fromJsonNoPayload(response.data);
    return apiResponse;
  }

  static Future<TeamManagerModel> fetchTeamManager() async {
    final api = DioClient().client;

    Response response = await api.get('/team-manager/auth');

    return TeamManagerModel.fromMap(response.data as Map<String, dynamic>);
  }
}
