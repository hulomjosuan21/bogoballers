import 'package:bogoballers/core/constants/file_strings.dart';
import 'package:bogoballers/core/helpers/api_reponse.dart';
import 'package:bogoballers/core/network/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

String formatJerseyNumber(double? input) {
  if (input == null) return "No data";
  return input % 1 == 0 ? input.toInt().toString() : input.toString();
}

Future<List<String>> leagueCategories() async {
  try {
    final api = DioClient().client;

    Response response = await api.get('/league/category-list');

    final apiResponse = ApiResponse<List<String>>.fromJson(
      response.data,
      (data) => List<String>.from(data),
    );

    if (apiResponse.payload == null) {
      throw Exception("Empty payload from server.");
    }

    return apiResponse.payload!;
  } catch (e, stack) {
    debugPrint("Error fetching categories: $e\n$stack");
    return [];
  }
}

Future<List<String>> barangayList() async {
  try {
    final api = DioClient().client;

    Response response = await api.get('/barangay-list');

    final apiResponse = ApiResponse<List<String>>.fromJson(
      response.data,
      (data) => List<String>.from(data),
    );

    if (apiResponse.payload == null) {
      throw Exception("Empty payload from server.");
    }

    return apiResponse.payload!;
  } catch (e, stack) {
    debugPrint("Error fetching categories: $e\n$stack");
    return [];
  }
}

Future<List<String>> organizationTypeList() async {
  try {
    final api = DioClient().client;

    Response response = await api.get('/organization-types');

    final apiResponse = ApiResponse<List<String>>.fromJson(
      response.data,
      (data) => List<String>.from(data),
    );

    if (apiResponse.payload == null) {
      throw Exception("Empty payload from server.");
    }

    return apiResponse.payload!;
  } catch (e, stack) {
    debugPrint("Error fetching categories: $e\n$stack");
    return [];
  }
}

Future<String> termsAndConditionsContent({required String key}) async {
  try {
    final String jsonString = await rootBundle.loadString(
      FilesStrings.termConditionJsonPath,
    );
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    if (!jsonMap.containsKey(key)) {
      throw Exception("Key '$key' not found in terms JSON.");
    }

    return jsonMap[key] as String;
  } catch (e, stack) {
    debugPrint("Error loading terms and conditions: $e\n$stack");
    return 'Failed to load content.';
  }
}

Future<List<ImageFile>> pickImagesUsingImagePicker(int maxCount) async {
  final picker = ImagePicker();
  final picked = await picker.pickMultiImage();
  final limited = picked.take(maxCount).toList();

  return Future.wait(
    limited.map((file) async {
      final bytes = await file.readAsBytes();

      return ImageFile(
        UniqueKey().toString(),
        name: file.name,
        extension: file.name.split('.').last,
        bytes: bytes,
        path: file.path,
      );
    }),
  );
}
