import 'package:bogoballers/core/helpers/api_reponse.dart';
import 'package:bogoballers/core/models/user_model.dart';
import 'package:bogoballers/core/network/dio_client.dart';
import 'package:dio/dio.dart';

class TeamManagerServices {
  static Future<ApiResponse> createNewTeamManager(
    Map<String, String> data,
  ) async {
    final api = DioClient().client;

    Response response = await api.post('/team-manager/create', data: data);
    final apiResponse = ApiResponse.fromJsonNoPayload(response.data);
    return apiResponse;
  }

  static Future<User> fetchTeamManager() async {
    final api = DioClient().client;

    Response response = await api.get('/team-manager/auth');

    return User.fromMap(response.data as Map<String, dynamic>);
  }
}
