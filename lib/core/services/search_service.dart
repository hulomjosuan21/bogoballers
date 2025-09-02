import 'package:bogoballers/core/network/dio_client.dart';

class SearchService {
  Future<Map<String, dynamic>> searchEntity(String query) async {
    final api = DioClient().client;
    final response = await api.post('/entity/search', data: {'query': query});

    return response.data;
  }
}
