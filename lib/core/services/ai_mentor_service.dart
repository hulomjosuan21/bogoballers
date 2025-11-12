import 'package:bogoballers/core/network/dio_client.dart';

class AIMentorService {
  Future<Map<String, dynamic>?> sendMessage({
    required String userId,
    required String message,
  }) async {
    try {
      final api = DioClient().client;
      final response = await api.post(
        '/ai/chat',
        data: {'user_id': userId, 'message': message},
      );
      return response.data;
    } catch (e) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getHistory(String userId) async {
    try {
      final api = DioClient().client;
      final response = await api.get('/ai/history/$userId');
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      return [];
    }
  }

  Future<void> clearHistory(String userId) async {
    try {
      final api = DioClient().client;
      await api.delete('/ai/history/$userId');
    } catch (e) {
      print('Clear Error: $e');
    }
  }
}
