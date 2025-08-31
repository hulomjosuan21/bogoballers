import 'package:bogoballers/core/theme/app_colors.dart';
import 'package:bogoballers/screens/auth/login_screen.dart';
import 'package:bogoballers/screens/payment_cancelled_screen.dart';
import 'package:bogoballers/screens/payment_success_screen.dart';
import 'package:bogoballers/screens/player/player_main_screen.dart';
import 'package:bogoballers/screens/team_manager/team_manager_main_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: AppLightColors().color9),
      ),
    );
  }
}

final Map<String, WidgetBuilder> appRoutes = {
  '/splash': (context) => SplashScreen(),
  '/auth/login': (context) => LoginScreen(),
  '/player/main/screen': (context) => PlayerMainScreen(),
  '/team-manager/main/screen': (context) => TeamManagerMainScreen(),
  '/payment-success': (context) => const PaymentSuccessScreen(),
  '/payment-cancelled': (context) => const PaymentCancelledScreen(),
};

Route<dynamic>? generateRoute(RouteSettings settings) {
  final uri = Uri.parse(settings.name ?? "");

  switch (uri.path) {
    default:
      return null;
  }
}
