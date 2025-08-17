import 'package:bogoballers/core/constants/size.dart';
import 'package:bogoballers/core/providers/team_provider.dart';
import 'package:bogoballers/core/theme/theme_extensions.dart';
import 'package:bogoballers/screens/team_manager/team_manager_create_team_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeamsScreen extends ConsumerStatefulWidget {
  const TeamsScreen({super.key});

  @override
  ConsumerState<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends ConsumerState<TeamsScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.invalidate(teamsProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final teamsAsync = ref.watch(teamsProvider);
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Teams"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "Add Team",
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreateTeamSreen()),
            ),
          ),
        ],
      ),
      body: teamsAsync.when(
        data: (teams) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(teamsProvider);
              await ref.read(teamsProvider.future);
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: teams.length,
              itemBuilder: (context, index) {
                final team = teams[index];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(Sizes.radiusSm),
                    child: Image.network(
                      team.team_logo_url,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    team.team_name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    team.team_motto,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: colors.gray8, fontSize: 11),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
      ),
    );
  }
}
