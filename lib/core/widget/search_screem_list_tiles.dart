import 'package:bogoballers/core/constants/size.dart';
import 'package:bogoballers/core/models/league.dart';
import 'package:bogoballers/core/models/league_admin_model.dart';
import 'package:bogoballers/core/models/player_model.dart';
import 'package:bogoballers/core/models/team_model.dart';
import 'package:flutter/material.dart';

class PlayerSearchResultListTile extends StatelessWidget {
  final PlayerModel player;

  const PlayerSearchResultListTile({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(Sizes.radiusSm),
        child: Image.network(
          player.profile_image_url,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              maxLines: 1,
              overflow: TextOverflow.fade,
              player.full_name,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
          const SizedBox(width: 8),
          _buildBadge('Player', Colors.blue),
        ],
      ),
    );
  }
}

class TeamSearchResultListTile extends StatelessWidget {
  final TeamModelForSearchResult team;

  const TeamSearchResultListTile({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
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
      title: Row(
        children: [
          Text(
            maxLines: 1,
            overflow: TextOverflow.fade,
            team.team_name,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(width: 8),
          _buildBadge('Team', Colors.green),
        ],
      ),
    );
  }
}

class LeagueAdministratorSearchResultListTile extends StatelessWidget {
  final LeagueAdminModel leagueAdmin;

  const LeagueAdministratorSearchResultListTile({
    super.key,
    required this.leagueAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(Sizes.radiusSm),
        child: Image.network(
          leagueAdmin.organization_logo_url,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              maxLines: 1,
              overflow: TextOverflow.fade,
              leagueAdmin.organization_name,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
          const SizedBox(width: 8),
          _buildBadge('League Admin', Colors.orange),
        ],
      ),
    );
  }
}

class LeagueSearchResultListTile extends StatelessWidget {
  final LeagueModel league;

  const LeagueSearchResultListTile({super.key, required this.league});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(Sizes.radiusSm),
        child: Image.network(
          league.banner_url,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              league.league_title,
              maxLines: 2,
              overflow: TextOverflow.fade,
              softWrap: true,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ),
          const SizedBox(width: 8),
          _buildBadge('League', Colors.indigoAccent),
        ],
      ),
    );
  }
}

Widget _buildBadge(String text, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 8,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
