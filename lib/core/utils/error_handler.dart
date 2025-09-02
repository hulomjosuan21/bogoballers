import 'dart:convert';

import 'package:dio/dio.dart';

class ErrorHandler {
  static String getErrorMessage(Object error, {bool devMode = true}) {
    if (devMode) return error.toString();

    if (error is DioException) {
      final data = error.response?.data;

      if (data != null) {
        try {
          final jsonData = data is String ? json.decode(data) : data;
          if (jsonData is Map && jsonData.containsKey('message')) {
            return jsonData['message'];
          }
        } catch (_) {}
      }

      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return "The request timed out. Please try again.";
        case DioExceptionType.connectionError:
          return "No internet connection. Please check your network.";
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          if (statusCode == 400) return "Bad request. Please check your input.";
          if (statusCode == 401) return "Unauthorized. Please log in again.";
          if (statusCode == 404) return "The requested resource was not found.";
          if (statusCode == 500) return "Server error. Please try again later.";
          return "Unexpected server response.";
        default:
          return "An unexpected network error occurred.";
      }
    }

    if (error is FormatException) {
      return "Invalid response format from server.";
    }

    if (error.toString().contains("SocketException")) {
      return "No internet connection. Please check your network.";
    }

    return "Something went wrong. Please try again.";
  }
}
