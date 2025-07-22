import 'package:bogoballers/core/dio_client.dart';
import 'package:bogoballers/core/helpers/api_reponse.dart';
import 'package:bogoballers/core/models/player_model.dart';
import 'package:dio/dio.dart';

class PlayerServices {
  Future<ApiResponse> createNewPlayer(PlayerModel player) async {
    final api = DioClient().client;
    Response response = await api.post(
      '/entity/create-new/player',
      data: player.toFormDataForCreation(),
    );
    final apiResponse = ApiResponse.fromJsonNoPayload(response.data);
    return apiResponse;
  }

  static Future<ApiResponse> updatePlayer({
    required String player_id,
    required Map<String, dynamic> json,
  }) async {
    final api = DioClient().client;
    Response response = await api.put(
      '/player/update/profile/${player_id}',
      data: json,
    );
    final apiResponse = ApiResponse.fromJsonNoPayload(response.data);
    return apiResponse;
  }
}
