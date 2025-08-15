import 'package:bogoballers/core/helpers/api_reponse.dart';
import 'package:bogoballers/core/network/dio_client.dart';
import 'package:dio/dio.dart';

class PlayerService {
  static Future<ApiResponse> createNewPlayer(FormData player) async {
    final api = DioClient().client;
    Response response = await api.post('/player/create', data: player);
    final apiResponse = ApiResponse.fromJsonNoPayload(response.data);
    return apiResponse;
  }
}
