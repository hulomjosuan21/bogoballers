import 'package:bogoballers/core/services/secure_storage_service.dart';
import 'package:flutter/material.dart';

Future<void> logout(BuildContext context) async {
  await SecureStorageService.instance.deleteAll();
  Navigator.pushReplacementNamed(context, '/auth/login');
}
