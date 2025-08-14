import 'package:bogoballers/app.dart';
import 'package:bogoballers/core/notification_service.dart';
import 'package:bogoballers/core/services/auth_service.dart';
import 'package:bogoballers/core/services/background_sync_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
// import 'package:provider/provider.dart' as provider;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  try {
    await dotenv.load(fileName: ".env");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // await SecureStorageService.instance.deleteAll();

    await NotificationService.instance.initialize();
    Future.microtask(() => BackgroundSyncService.instance.start());

    runApp(riverpod.ProviderScope(child: App()));
  } finally {
    FlutterNativeSplash.remove();
  }
}
