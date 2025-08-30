import 'package:bogoballers/core/app_routes.dart';
import 'package:bogoballers/core/services/entity_service.dart';
import 'package:bogoballers/core/theme/theme.dart';
import 'package:bogoballers/main.dart';
import 'package:bogoballers/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';

import 'screens/player/player_main_screen.dart';
import 'screens/team_manager/team_manager_main_screen.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AppLinks _appLinks;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();

    _appLinks.getInitialLink().then((uri) {
      if (uri != null && mounted) _navigateDeepLink(uri);
    });

    _appLinks.uriLinkStream.listen((uri) {
      if (mounted) _navigateDeepLink(uri);
    });
  }

  void _navigateDeepLink(Uri uri) {
    final route = uri.path.isNotEmpty ? uri.path : '/splash';
    if (appRoutes.containsKey(route)) {
      Navigator.pushNamed(context, route);
    } else {
      debugPrint('Unknown deep link route: $route');
    }
  }

  Future<String?> _fetchHomeType() => EntityService.fetchEntityRedirect();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BogoBallers',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      routes: appRoutes,
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      onGenerateRoute: generateRoute,
      home: FutureBuilder<String?>(
        future: _fetchHomeType(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SplashScreen();
          }

          if (snapshot.hasError || snapshot.data == null) {
            return const LoginScreen();
          }
          switch (snapshot.data) {
            case 'player':
              return PlayerMainScreen();
            case 'team_manager':
              return TeamManagerMainScreen();
            default:
              return const LoginScreen();
          }
        },
      ),
    );
  }
}
