import 'package:bogoballers/core/helpers/api_reponse.dart';
import 'package:bogoballers/core/models/team_manager.dart';
import 'package:bogoballers/core/network/dio_client.dart';
import 'package:dio/dio.dart';

class TeamManagerServices {
  Future<ApiResponse> createNewTeamManager(CreateTeamManager user) async {
    final api = DioClient().client;

    Response response = await api.post(
      '/team-manager/create',
      data: user.toFormData(),
    );
    final apiResponse = ApiResponse.fromJsonNoPayload(response.data);
    return apiResponse;
  }

  // Future<ApiResponse<TeamModel>> createNewTeam(TeamModel team) async {
  //   final api = DioClient().client;
  //   Response response = await api.post(
  //     '/team/new',
  //     data: team.toFormDataForCreation(),
  //   );
  //   final apiResponse = ApiResponse<TeamModel>.fromJson(
  //     response.data,
  //     (data) => TeamModel.fromJson(data),
  //   );
  //   return apiResponse;
  // }

  // Future<List<PlayerTeamWrapper>?> fetchPlayers(
  //   String teamId, {
  //   String? status,
  // }) async {
  //   final api = DioClient().client;

  //   final response = await api.get(
  //     '/team/players/$teamId',
  //     queryParameters: {if (status != null) 'status': status},
  //   );

  //   final apiResponse = ApiResponse<List<PlayerTeamWrapper>?>.fromJson(
  //     response.data,
  //     (data) => (data as List)
  //         .map((item) => PlayerTeamWrapper.fromJson(item))
  //         .toList(),
  //   );

  //   return apiResponse.payload;
  // }
}
