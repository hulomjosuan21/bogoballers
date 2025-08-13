import 'package:bogoballers/core/app_routes.dart';
import 'package:bogoballers/core/enums/user_enum.dart';
import 'package:bogoballers/core/models/user_model.dart';
import 'package:bogoballers/core/theme/theme.dart';
import 'package:bogoballers/screens/auth/login_screen.dart';
import 'package:bogoballers/screens/player/player_main_screen.dart';
import 'package:bogoballers/screens/team_manager/team_manager_main_screen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    Widget homeScreen;

    // if (userFromToken == null) {
    //   homeScreen = const LoginScreen();
    // } else {
    //   try {
    //     final accountTypeEnum = AccountTypeEnum.fromValue(
    //       userFromToken?.account_type,
    //     );

    //     switch (accountTypeEnum) {
    //       case AccountTypeEnum.PLAYER:
    //         homeScreen = const PlayerMainScreen();
    //         debugPrint("Logged: Player");
    //         break;
    //       case AccountTypeEnum.TEAM_MANAGER:
    //         homeScreen = const TeamManagerMainScreen();
    //         debugPrint("Logged: Team Manager");
    //         break;
    //       default:
    //         homeScreen = const LoginScreen();
    //         debugPrint("Logged: Unknown or unsupported account type");
    //     }
    //   } catch (e) {
    //     homeScreen = const LoginScreen();
    //   }
    // }

    return MaterialApp(
      title: 'BogoBallers',
      theme: lightTheme,
      darkTheme: darkTheme,
      routes: appRoutes,
      themeMode: ThemeMode.system,
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
