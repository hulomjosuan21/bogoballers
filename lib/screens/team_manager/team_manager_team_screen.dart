import 'package:bogoballers/core/constants/size.dart';
import 'package:bogoballers/core/models/team_model.dart';
import 'package:bogoballers/screens/team_manager/team_manager_player_team_screen.dart';
import 'package:flutter/material.dart';
import 'package:bogoballers/core/theme/theme_extensions.dart';

class TeamManagerTeamScreen extends StatefulWidget {
  const TeamManagerTeamScreen({super.key, required this.team});

  final TeamModel team;

  @override
  State<TeamManagerTeamScreen> createState() => _TeamManagerTeamScreenState();
}

class _TeamManagerTeamScreenState extends State<TeamManagerTeamScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(centerTitle: true, title: Text(widget.team.team_name)),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: Sizes.spaceMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              Center(
                child: SizedBox(
                  width: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.network(
                        widget.team.team_logo_url,
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
                    value: widget.team.total_losses.toString(),
                    label: 'Losses',
                  ),
                  SizedBox(
                    height: 32, // or match your text+label height
                    child: VerticalDivider(
                      thickness: 1,
                      width: 24,
                      color: colors.gray6,
                    ),
                  ),
                  StatCell(
                    value: widget.team.total_draws.toString(),
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
                    value: widget.team.total_points.toString(),
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
                  Tab(text: "Pending"),
                ],
              ),
              Container(
                color: colors.gray2,
                height: 400,
                child: TabBarView(
                  children: [
                    const Center(child: Text("👥 Invited content")),
                    ListView.builder(
                      itemCount: widget.team.invited_players.length,
                      itemBuilder: (context, index) {
                        final player = widget.team.invited_players[index];
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(Sizes.radiusSm),
                            child: Image.network(
                              widget.team.team_logo_url,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            player.full_name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            "${player.jersey_name} | #${player.jersey_number.toStringAsFixed(0)}",
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

                    const Center(child: Text("📅 Pending content")),
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
