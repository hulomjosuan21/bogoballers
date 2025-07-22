import 'package:bogoballers/core/theme/theme_extensions.dart';
import 'package:bogoballers/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';

class PlayerHomeScreen extends StatelessWidget {
  const PlayerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    return LoginScreen();
  }
}