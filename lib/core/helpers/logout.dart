import 'package:bogoballers/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bogoballers/core/services/secure_storage_service.dart';

Future<void> logout(BuildContext context) async {
  await SecureStorageService.instance.deleteCredentials();

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (_) =>
          ProviderScope(key: UniqueKey(), child: const LoginScreen()),
    ),
    (route) => false,
  );
}
