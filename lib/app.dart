import 'package:bogoballers/core/theme/theme.dart';
import 'package:bogoballers/screens/player/player_home_screen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BogoBallers',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const PlayerHomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}