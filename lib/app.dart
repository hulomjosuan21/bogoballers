import 'package:bogoballers/core/app_routes.dart';
import 'package:bogoballers/core/theme/theme.dart';
import 'package:bogoballers/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';

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
      if (uri != null && mounted) {
        _handleDeepLink(uri);
      }
    });

    _appLinks.uriLinkStream.listen((uri) {
      if (mounted) {
        _handleDeepLink(uri);
      }
    });
  }

  void _handleDeepLink(Uri uri) {
    final route = uri.path.isNotEmpty ? uri.path : '/default';

    if (appRoutes.containsKey(route)) {
      Navigator.pushNamed(context, route);
    } else {
      debugPrint('Unknown deep link route: $route');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BogoBallers',
      theme: lightTheme,
      darkTheme: darkTheme,
      routes: appRoutes,
      themeMode: ThemeMode.system,
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
