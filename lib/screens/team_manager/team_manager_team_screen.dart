import 'package:bogoballers/core/constants/size.dart';
import 'package:bogoballers/core/models/player_model.dart';
import 'package:bogoballers/core/models/team_model.dart';
import 'package:bogoballers/screens/team_manager/team_manager_player_team_screen.dart';
import 'package:flutter/material.dart';
import 'package:bogoballers/core/theme/theme_extensions.dart';

class TeamManagerTeamScreen extends StatefulWidget {
  const TeamManagerTeamScreen({super.key, required this.team});

  final Team team;

  @override
  State<TeamManagerTeamScreen> createState() => _TeamManagerTeamScreenState();
}

class _TeamManagerTeamScreenState extends State<TeamManagerTeamScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.team.teamName),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'player_request':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlayerPendingRequestScreen(
                          players: widget.team.pendingPlayers,
                        ),
                      ),
                    );
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'player_request',
                  child: Text('Player Request'),
                ),
              ],
            ),
          ],
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: Sizes.spaceMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  width: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.network(
                        widget.team.teamLogoUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: Sizes.spaceSm),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StatCell(
                    value: widget.team.totalDraws.toString(),
                    label: 'Losses',
                  ),
                  SizedBox(
                    height: 32,
                    child: VerticalDivider(
                      thickness: 1,
                      width: 24,
                      color: colors.gray6,
                    ),
                  ),
                  StatCell(
                    value: widget.team.totalDraws.toString(),
                    label: 'Draws',
                  ),
                  SizedBox(
                    height: 32,
                    child: VerticalDivider(
                      thickness: 1,
                      width: 24,
                      color: colors.gray6,
                    ),
                  ),
                  StatCell(
                    value: widget.team.totalPoints.toString(),
                    label: 'Points',
                  ),
                ],
              ),
              const SizedBox(height: Sizes.spaceLg),

              const Text(
                "Players",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),
              TabBar(
                labelColor: colors.color9,
                unselectedLabelColor: Colors.grey,
                indicatorColor: colors.color9,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: "Players"),
                  Tab(text: "Invited"),
                ],
              ),
              Container(
                color: colors.gray2,
                height: 400,
                child: TabBarView(
                  children: [
                    ListView.builder(
                      itemCount: widget.team.acceptedPlayers.length,
                      itemBuilder: (context, index) {
                        final player = widget.team.acceptedPlayers[index];
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(Sizes.radiusSm),
                            child: Image.network(
                              widget.team.teamLogoUrl,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            player.fullName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            "${player.jerseyName} | #${player.jerseyNumber.toStringAsFixed(0)}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: colors.gray8, fontSize: 11),
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlayerTeamScreen(
                                onTeamScreen: false,
                                player: player,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    ListView.builder(
                      itemCount: widget.team.invitedPlayers.length,
                      itemBuilder: (context, index) {
                        final player = widget.team.invitedPlayers[index];
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(Sizes.radiusSm),
                            child: Image.network(
                              player.profileImageUrl,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            player.fullName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            "${player.jerseyName} | #${player.jerseyNumber.toStringAsFixed(0)}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: colors.gray8, fontSize: 11),
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlayerTeamScreen(
                                onTeamScreen: false,
                                player: player,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatCell extends StatelessWidget {
  final String value;
  final String label;
  const StatCell({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

class PlayerPendingRequestScreen extends StatelessWidget {
  final List<PlayerTeam> players;
  const PlayerPendingRequestScreen({super.key, required this.players});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Player Request")),
      body: ListView.builder(
        itemCount: players.length,
        itemBuilder: (context, index) {
          final player = players[index];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(Sizes.radiusSm),
              child: Image.network(
                player.profileImageUrl,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              player.fullName,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            subtitle: Text(
              "${player.jerseyName} | #${player.jerseyNumber.toStringAsFixed(0)}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: colors.gray8, fontSize: 11),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PlayerTeamScreen(onTeamScreen: false, player: player),
              ),
            ),
          );
        },
      ),
    );
  }
}
