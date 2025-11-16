import 'package:bogoballers/core/models/leagueMatch.dart';
import 'package:bogoballers/core/models/league_model.dart';
import 'package:bogoballers/core/models/team_model.dart';

class LeagueParticipation {
  final League league;
  final List<LeagueTeam> teams;
  final List<LeagueMatchModel> matches;

  LeagueParticipation({
    required this.league,
    required this.teams,
    required this.matches,
  });

  factory LeagueParticipation.fromMap(Map<String, dynamic> json) {
    final teamsJson = json['teams'] as List<dynamic>? ?? [];
    final matchesJson = json['matches'] as List<dynamic>? ?? [];

    return LeagueParticipation(
      league: League.fromMap(json['league'] as Map<String, dynamic>),
      teams: teamsJson
          .map((e) => LeagueTeam.fromMap(e as Map<String, dynamic>))
          .toList(),
      matches: matchesJson
          .map((e) => LeagueMatchModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
