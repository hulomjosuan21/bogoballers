import 'package:bogoballers/core/helpers/api_reponse.dart';
import 'package:bogoballers/core/models/player_model.dart';
import 'package:bogoballers/core/network/dio_client.dart';
import 'package:dio/dio.dart';

class PlayerService {
  static Future<List<Player>> fetchAllPlayers(String? search) async {
    final api = DioClient().client;

    Response response = await api.get(
      '/player/all',
      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );

    final apiResponse = ApiResponse.fromJson(
      response.data,
      (data) => (data as List<dynamic>)
          .map((e) => Player.fromMap(e as Map<String, dynamic>))
          .toList(),
    );

    return apiResponse.payload ?? [];
  }

  static Future<ApiResponse> createNewPlayer(FormData player) async {
    final api = DioClient().client;
    Response response = await api.post('/player/create', data: player);
    final apiResponse = ApiResponse.fromJsonNoPayload(response.data);
    return apiResponse;
  }

  static Future<Player> fetchPlayer() async {
    final api = DioClient().client;
    Response response = await api.get('/player/auth');

    if (response.data == null) {
      throw Exception('No response from server');
    }

    return Player.fromMap(response.data);
  }
}
