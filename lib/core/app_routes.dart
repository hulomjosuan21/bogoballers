import 'package:bogoballers/screens/auth/login_screen.dart';
import 'package:bogoballers/screens/payment_cancelled_screen.dart';
import 'package:bogoballers/screens/payment_success_screen.dart';
import 'package:bogoballers/screens/player/player_main_screen.dart';
import 'package:bogoballers/screens/team_manager/team_manager_main_screen.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/auth/login': (context) => LoginScreen(),
  '/player/main/screen': (context) => PlayerMainScreen(),
  '/team-manager/main/screen': (context) => TeamManagerMainScreen(),
  '/payment-success': (context) => const PaymentSuccessScreen(),
  '/payment-cancelled': (context) => const PaymentCancelledScreen()
};
