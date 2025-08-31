import 'package:bogoballers/core/constants/size.dart';
import 'package:bogoballers/core/enums/permission.dart';
import 'package:bogoballers/core/models/league.dart';
import 'package:bogoballers/core/models/league_admin_model.dart';
import 'package:bogoballers/core/models/player_model.dart';
import 'package:bogoballers/core/models/team_model.dart';
import 'package:bogoballers/screens/league_admin_screen.dart';
import 'package:bogoballers/screens/league_screen.dart';
import 'package:bogoballers/screens/player_screen.dart';
import 'package:bogoballers/screens/team_screen.dart';
import 'package:flutter/material.dart';

abstract class BaseSearchResultScreen<T> {
  List<Permission> get permissions;

  T get result;
}

class PlayerSearchResultListTile extends StatelessWidget
    implements BaseSearchResultScreen<PlayerModel> {
  @override
  final List<Permission> permissions;

  @override
  final PlayerModel result;

  const PlayerSearchResultListTile({
    super.key,
    required this.result,
    required this.permissions,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(Sizes.radiusSm),
        child: Image.network(
          result.profile_image_url,
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
              result.full_name,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
          const SizedBox(width: 8),
          _buildBadge('Player', Colors.blue),
        ],
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PlayerScreen(permissions: permissions, result: result),
        ),
      ),
    );
  }
}

class TeamSearchResultListTile extends StatelessWidget
    implements BaseSearchResultScreen<TeamModelForSearchResult> {
  @override
  final TeamModelForSearchResult result;
  @override
  final List<Permission> permissions;

  const TeamSearchResultListTile({
    super.key,
    required this.result,
    required this.permissions,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(Sizes.radiusSm),
        child: Image.network(
          result.team_logo_url,
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
              result.team_name,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
          const SizedBox(width: 8),
          _buildBadge('Team', Colors.green),
        ],
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              TeamScreen(permissions: permissions, result: result),
        ),
      ),
    );
  }
}

class LeagueAdministratorSearchResultListTile extends StatelessWidget
    implements BaseSearchResultScreen<LeagueAdminModel> {
  @override
  final LeagueAdminModel result;
  @override
  final List<Permission> permissions;

  const LeagueAdministratorSearchResultListTile({
    super.key,
    required this.result,
    required this.permissions,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(Sizes.radiusSm),
        child: Image.network(
          result.organization_logo_url,
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
              result.organization_name,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
          const SizedBox(width: 8),
          _buildBadge('League Admin', Colors.orange),
        ],
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LeagueAdministratorScreen(
            permissions: permissions,
            result: result,
          ),
        ),
      ),
    );
  }
}

class LeagueSearchResultListTile extends StatelessWidget
    implements BaseSearchResultScreen<LeagueModel> {
  @override
  final LeagueModel result;
  @override
  final List<Permission> permissions;

  const LeagueSearchResultListTile({
    super.key,
    required this.result,
    required this.permissions,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(Sizes.radiusSm),
        child: Image.network(
          result.banner_url,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              result.league_title,
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
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              LeagueScreen(permissions: permissions, result: result),
        ),
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
