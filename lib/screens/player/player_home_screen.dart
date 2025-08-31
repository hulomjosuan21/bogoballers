import 'package:bogoballers/core/constants/size.dart';
import 'package:bogoballers/core/helpers/logout.dart';
import 'package:bogoballers/core/theme/theme_extensions.dart';
import 'package:bogoballers/screens/search_screen.dart';
import 'package:flutter/material.dart';

class PlayerHomeScreen extends StatelessWidget {
  const PlayerHomeScreen({super.key});

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
              PopupMenuItem(onTap: () {}, child: Text('Test')),
              PopupMenuItem(
                onTap: () => logout(context),
                child: Text('Logout'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(Sizes.spaceMd),
            child: TextField(
              readOnly: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                );
              },
              decoration: InputDecoration(
                hintText: "Search...",
                helperText:
                    "Find players, teams, leagues or league administrators",
                suffixIcon: Icon(Icons.search, color: colors.gray11),
                filled: true,
                fillColor: colors.gray2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
