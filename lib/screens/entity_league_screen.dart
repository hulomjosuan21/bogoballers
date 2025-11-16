import 'package:bogoballers/core/constants/size.dart';
import 'package:bogoballers/core/models/team_model.dart';
import 'package:bogoballers/core/providers/leauge_provider.dart';
import 'package:bogoballers/core/providers/player_provider.dart';
import 'package:bogoballers/core/services/entity_service.dart';
import 'package:bogoballers/core/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:bogoballers/core/theme/theme_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ParamAccountType {
  player("Player"),
  manager("Team_Manager");

  final String value;

  const ParamAccountType(this.value);
}

class EntityLeagueScreen extends ConsumerStatefulWidget {
  final ParamAccountType accountType;
  const EntityLeagueScreen({super.key, required this.accountType});

  @override
  ConsumerState<EntityLeagueScreen> createState() => _EntityLeagueScreenState();
}

class _EntityLeagueScreenState extends ConsumerState<EntityLeagueScreen> {
  String? userId;
  String? playerId;

  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    try {
      if (widget.accountType == ParamAccountType.player) {
        final player = await ref.read(playerProvider.future);

        playerId = player.playerId.toString();
      } else {
        final creds = await getEntityCredentialsFromStorage();
        userId = creds.userId;
      }
      setState(() => isLoading = false);
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (error != null) {
      return Scaffold(body: Center(child: Text("Error: $error")));
    }

    final params = (userId: userId, playerId: playerId);

    final leagueAsync = ref.watch(leagueParticipationProvider(params));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("My Leagues"),
        flexibleSpace: Container(color: colors.color1),
      ),
      body: leagueAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'Error loading league data: ${err.toString()}',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),
        data: (leagueParticipations) {
          if (leagueParticipations.isEmpty) {
            return const Center(
              child: Text(
                "No league participation",
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: leagueParticipations.length,
            itemBuilder: (context, index) {
              final participation = leagueParticipations[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: BoxBorder.all(
                      width: Sizes.borderWidthSm,
                      color: colors.gray6,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                        child: Image.network(
                          participation.league.bannerUrl,
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Container(color: Colors.black26),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                        child: Text(
                          participation.league.leagueTitle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: Sizes.spaceMd),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          participation.teams.length > 1 ? "Teams" : "Team",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      SizedBox(height: 6),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: participation.teams.length,
                          itemBuilder: (context, index) {
                            final team = participation.teams[index];

                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: colors.gray4,
                                  width: 1,
                                ),
                              ),
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: team.teamLogoUrl.isNotEmpty
                                      ? Image.network(
                                          team.teamLogoUrl,
                                          width: 20,
                                          height: 20,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          width: 20,
                                          height: 20,
                                          color: Colors.grey.shade300,
                                          child: const Icon(
                                            Icons.image_not_supported,
                                            size: 12,
                                          ),
                                        ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                title: Text(
                                  team.teamName,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                onTap: () {},
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: Sizes.spaceMd),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          participation.matches.length > 1
                              ? "Matches"
                              : "Match",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      SizedBox(height: 6),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: participation.matches.length,
                          itemBuilder: (context, index) {
                            final m = participation.matches[index];

                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: colors.gray4,
                                  width: 1,
                                ),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 12,
                                ),
                                title: matchTitle(
                                  homeTeam: m.homeTeam,
                                  awayTeam: m.awayTeam,
                                ),
                                subtitle: Text(
                                  m.scheduledDate != null
                                      ? "Schedule: ${scheduleDataFormat(m.scheduledDate)}"
                                      : "Tap to view details",
                                  style: TextStyle(fontSize: 10),
                                ),
                                onTap: () {},
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: Sizes.spaceMd),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget matchTitle({
    required LeagueTeam? homeTeam,
    required LeagueTeam? awayTeam,
  }) {
    final homeName = homeTeam?.teamName;
    final homeImage = homeTeam?.teamLogoUrl;
    final awayName = awayTeam?.teamName;
    final awayImage = awayTeam?.teamLogoUrl;
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: homeImage != null
              ? Image.network(
                  homeImage,
                  width: 20,
                  height: 20,
                  fit: BoxFit.cover,
                )
              : Container(
                  width: 20,
                  height: 20,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.image_not_supported, size: 12),
                ),
        ),

        const SizedBox(width: 6),

        Expanded(
          child: Text(
            homeName ?? 'N/A',
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),

        const SizedBox(width: 6),

        const Text(
          "vs",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),

        const SizedBox(width: 6),

        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: awayImage != null
              ? Image.network(
                  awayImage,
                  width: 20,
                  height: 20,
                  fit: BoxFit.cover,
                )
              : Container(
                  width: 20,
                  height: 20,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.image_not_supported, size: 12),
                ),
        ),

        const SizedBox(width: 6),
        Expanded(
          child: Text(
            awayName ?? 'N/A',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
