import 'package:bogoballers/core/constants/size.dart';
import 'package:bogoballers/core/helpers/logout.dart';
import 'package:bogoballers/core/providers/team_manager_provider.dart';
import 'package:bogoballers/core/services/test_service.dart';
import 'package:bogoballers/screens/notification_screen.dart';
import 'package:bogoballers/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bogoballers/core/theme/theme_extensions.dart';

class TeamManagerHomeScreen extends ConsumerStatefulWidget {
  const TeamManagerHomeScreen({super.key});

  @override
  ConsumerState<TeamManagerHomeScreen> createState() =>
      _TeamManagerHomeScreenState();
}

class _TeamManagerHomeScreenState extends ConsumerState<TeamManagerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final teamManagerAsync = ref.watch(teamManagerProvider);

    return teamManagerAsync.when(
      data: (teamManager) {
        return Scaffold(
          appBar: AppBar(
            title: Text(teamManager.display_name),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          drawer: Drawer(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Text(
                    teamManager.display_name,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.bug_report),
                  title: const Text("Test"),
                  onTap: () {
                    Navigator.pop(context);
                    testWriteID();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Logout"),
                  onTap: () {
                    Navigator.pop(context);
                    logout(context);
                  },
                ),
              ],
            ),
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
              // 👇 Add more home content here
            ],
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text("Error: $err"))),
    );
  }
}
