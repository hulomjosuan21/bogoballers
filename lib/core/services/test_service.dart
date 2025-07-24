import 'package:bogoballers/core/services/secure_storage_service.dart';
import 'package:flutter/material.dart';

Future<void> testWriteID() async {
  const key = 'user_id';
  const value = '12345';

  await SecureStorageService.instance.write(key: key, value: value);
  debugPrint('✅ Saved $key: $value');

  final readValue = await SecureStorageService.instance.read(key);
  debugPrint('📦 Retrieved $key: $readValue'); 
}