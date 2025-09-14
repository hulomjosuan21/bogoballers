import 'package:bogoballers/core/constants/size.dart';
import 'package:bogoballers/core/enums/permission.dart';
import 'package:bogoballers/core/providers/team_provider.dart';
import 'package:bogoballers/core/services/entity_service.dart';
import 'package:bogoballers/core/theme/theme_extensions.dart';
import 'package:bogoballers/screens/team_manager/team_manager_create_team_screen.dart';
import 'package:bogoballers/screens/team_manager/team_manager_team_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeamManagerTeamsScreen extends ConsumerStatefulWidget {
  final bool selectMode;

  const TeamManagerTeamsScreen({super.key, this.selectMode = false});

  @override
  ConsumerState<TeamManagerTeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends ConsumerState<TeamManagerTeamsScreen> {
  String? accountType;

  @override
  void initState() {
    super.initState();
    _getAccountTypeFromStorage();
    Future.microtask(() {
      ref.invalidate(teamsProvider);
    });
  }

  Future<void> _getAccountTypeFromStorage() async {
    final entity = await getEntityCredentialsFromStorageOrNull();
    accountType = entity?.accountType;
  }

  @override
  Widget build(BuildContext context) {
    final teamsAsync = ref.watch(teamsProvider);
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectMode ? "Select Team" : "Teams"),
        actions: [
          if (!widget.selectMode)
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
                      team.teamLogoUrl,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    team.teamName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    team.teamMotto ?? "No Data",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: colors.gray8, fontSize: 11),
                  ),
                  onTap: () {
                    if (widget.selectMode) {
                      Navigator.pop(context, {
                        'teamId': team.teamId,
                        'teamLogoUrl': team.teamLogoUrl,
                      });
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TeamManagerTeamScreen(
                            permissions: userPermission(accountType),
                            team: team,
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) {
          return Center(child: Text("Error: $err"));
        },
      ),
    );
  }
}
