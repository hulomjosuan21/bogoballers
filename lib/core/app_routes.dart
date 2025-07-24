import 'package:bogoballers/screens/auth/login_screen.dart';
import 'package:bogoballers/screens/payment_cancelled_screen.dart';
import 'package:bogoballers/screens/payment_success_screen.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/auth/login/screen': (context) => LoginScreen(),
  '/payment-success': (context) => const PaymentSuccessScreen(),
  '/payment-cancelled': (context) => const PaymentCancelledScreen()
};
