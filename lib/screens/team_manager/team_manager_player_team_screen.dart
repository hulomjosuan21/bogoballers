import 'package:bogoballers/core/models/player_model.dart';
import 'package:flutter/material.dart';

class PlayerTeamScreen extends StatelessWidget {
  const PlayerTeamScreen({
    super.key,
    required this.onTeamScreen,
    required this.player,
  });

  final bool onTeamScreen;
  final PlayerTeam player;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(player.fullName)),
    );
  }
}
