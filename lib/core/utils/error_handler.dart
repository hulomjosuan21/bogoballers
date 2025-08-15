import 'package:bogoballers/core/utils/custom_exceptions.dart';
import 'package:dio/dio.dart';

class ErrorHandler {
  static String getErrorMessage(Object error) {
    if (error is ValidationException) {
      return error.message;
    }
    if (error is DioException) {
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
