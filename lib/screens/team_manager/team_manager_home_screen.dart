import 'package:bogoballers/core/constants/size.dart';
import 'package:bogoballers/core/helpers/logout.dart';
import 'package:bogoballers/core/providers/team_manager_provider.dart';
import 'package:bogoballers/core/services/test_service.dart';
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
              PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(onTap: testWriteID, child: const Text('Test')),
                  PopupMenuItem(
                    onTap: () => logout(context),
                    child: const Text('Logout'),
                  ),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SearchScreen()),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(Sizes.spaceMd),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: colors.gray2,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      width: Sizes.borderWidthSm,
                      color: colors.gray6,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: colors.gray11),
                      SizedBox(width: 8),
                      Text("Search...", style: TextStyle(color: colors.gray11)),
                    ],
                  ),
                ),
              ),
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
