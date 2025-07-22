import 'package:bogoballers/core/dio_client.dart';
import 'package:bogoballers/core/helpers/api_reponse.dart';
import 'package:bogoballers/core/models/player_model_beta.dart';
import 'package:bogoballers/core/models/team_model.dart';
import 'package:bogoballers/core/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';

class TeamCreatorServices {
  Future<ApiResponse> createNewTeamCreator(UserModel user) async {
    final api = DioClient().client;

    debugPrint(user.toJsonForCreation().toString());
    Response response = await api.post(
      '/entity/create-new/team-creator',
      data: user.toJsonForCreation(),
    );
    final apiResponse = ApiResponse.fromJsonNoPayload(response.data);
    return apiResponse;
  }

  Future<ApiResponse<TeamModel>> createNewTeam(TeamModel team) async {
    final api = DioClient().client;
    Response response = await api.post(
      '/team/new',
      data: team.toFormDataForCreation(),
    );
    final apiResponse = await ApiResponse<TeamModel>.fromJson(
      response.data,
      (data) => TeamModel.fromJson(data),
    );
    return apiResponse;
  }

Future<List<PlayerTeamWrapper>?> fetchPlayers(String teamId, {String? status}) async {
  final api = DioClient().client;

  final response = await api.get(
    '/team/players/$teamId',
    queryParameters: {
      if (status != null) 'status': status
    },
  );

  final apiResponse = ApiResponse<List<PlayerTeamWrapper>?>.fromJson(
    response.data,
    (data) => (data as List)
        .map((item) => PlayerTeamWrapper.fromJson(item))
        .toList(),
  );

  return apiResponse.payload;
}
}
