import 'package:bogoballers/core/helpers/logout.dart';
import 'package:bogoballers/core/services/test_service.dart';
import 'package:flutter/material.dart';

import 'package:bogoballers/core/theme/theme_extensions.dart';

class TeamManagerHomeScreen extends StatefulWidget {
  const TeamManagerHomeScreen({super.key});

  @override
  State<TeamManagerHomeScreen> createState() => _TeamManagerHomeScreenState();
}

class _TeamManagerHomeScreenState extends State<TeamManagerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(onTap: testWriteID, child: Text('Test')),
              PopupMenuItem(
                onTap: () => logout(context),
                child: Text('Logout'),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Text("Home", style: TextStyle(color: colors.textPrimary)),
      ),
    );
  }
}
