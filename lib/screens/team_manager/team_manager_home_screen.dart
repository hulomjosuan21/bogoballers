import 'package:bogoballers/core/services/test_service.dart';
import 'package:bogoballers/core/utils/logout.dart';
import 'package:flutter/material.dart';

import '../../core/theme/theme_extensions.dart';

class TeamManagerHomeScreen extends StatelessWidget {
  const TeamManagerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back)),
        title: Text("Home"),
        centerTitle: true,
        actions: [
            PopupMenuButton(
          icon: Icon(Icons.more_vert),
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(onTap: testWriteID,child: Text('Test'),),
            PopupMenuItem(
              child: Text('Logout'),
              onTap: () => handleLogout(context)
            ),
          ],
        ),
        ],
      ),
      body: Center(child: Text("Home",style: TextStyle(color: colors.textPrimary),)),
    );
  }
}