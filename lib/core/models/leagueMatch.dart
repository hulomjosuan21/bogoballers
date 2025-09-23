// ignore: file_names
import 'package:bogoballers/core/models/league_model.dart';
import 'package:bogoballers/core/models/team_model.dart';

class LeagueMatchModel {
  final String leagueMatchId;
  final String publicLeagueMatchId;
  final String leagueId;
  final String leagueCategoryId;
  final String roundId;

  final String? homeTeamId;
  final LeagueTeam? homeTeam;
  final String? awayTeamId;
  final LeagueTeam? awayTeam;

  final int? homeTeamScore;
  final int? awayTeamScore;
  final String? winnerTeamId;
  final String? loserTeamId;

  final String? scheduledDate;
  final int quarters;
  final int minutesPerQuarter;
  final int minutesPerOvertime;
  final String? court;
  final List<String> referees;

  final List<String> previousMatchIds;
  final String? nextMatchId;
  final String? nextMatchSlot;

  final String? loserNextMatchId;
  final String? loserNextMatchSlot;

  final int? roundNumber;
  final String? bracketSide;
  final String? bracketPosition;
  final String pairingMethod;
  final String? generatedBy;
  final String? displayName;

  final bool isFinal;
  final bool isThirdPlace;
  final String status;

  final League league;

  final int? stageNumber;
  final List<String> dependsOnMatchIds;
  final bool isPlaceholder;
  final String? bracketStageLabel;

  final String leagueMatchCreatedAt;
  final String leagueMatchUpdatedAt;

  LeagueMatchModel({
    required this.leagueMatchId,
    required this.publicLeagueMatchId,
    required this.leagueId,
    required this.leagueCategoryId,
    required this.roundId,
    this.homeTeamId,
    this.homeTeam,
    this.awayTeamId,
    this.awayTeam,
    this.homeTeamScore,
    this.awayTeamScore,
    this.winnerTeamId,
    this.loserTeamId,
    this.scheduledDate,
    required this.quarters,
    required this.minutesPerQuarter,
    required this.minutesPerOvertime,
    this.court,
    required this.referees,
    required this.previousMatchIds,
    this.nextMatchId,
    this.nextMatchSlot,
    this.loserNextMatchId,
    this.loserNextMatchSlot,
    this.roundNumber,
    this.bracketSide,
    this.bracketPosition,
    required this.pairingMethod,
    this.generatedBy,
    this.displayName,
    required this.isFinal,
    required this.isThirdPlace,
    required this.status,
    required this.league,
    this.stageNumber,
    required this.dependsOnMatchIds,
    required this.isPlaceholder,
    this.bracketStageLabel,
    required this.leagueMatchCreatedAt,
    required this.leagueMatchUpdatedAt,
  });

  factory LeagueMatchModel.fromMap(Map<String, dynamic> json) {
    return LeagueMatchModel(
      leagueMatchId: json['league_match_id'],
      publicLeagueMatchId: json['public_league_match_id'],
      leagueId: json['league_id'],
      leagueCategoryId: json['league_category_id'],
      roundId: json['round_id'],
      homeTeamId: json['home_team_id'],
      homeTeam: json['home_team'] != null
          ? LeagueTeam.fromMap(json['home_team'])
          : null,
      awayTeamId: json['away_team_id'],
      awayTeam: json['away_team'] != null
          ? LeagueTeam.fromMap(json['away_team'])
          : null,

      homeTeamScore: (json['home_team_score'] as num?)?.toInt(),
      awayTeamScore: (json['away_team_score'] as num?)?.toInt(),

      quarters: (json['quarters'] as num?)?.toInt() ?? 0,
      minutesPerQuarter: (json['minutes_per_quarter'] as num?)?.toInt() ?? 0,
      minutesPerOvertime: (json['minutes_per_overtime'] as num?)?.toInt() ?? 0,
      roundNumber: (json['round_number'] as num?)?.toInt(),
      stageNumber: (json['stage_number'] as num?)?.toInt(),

      winnerTeamId: json['winner_team_id'],
      loserTeamId: json['loser_team_id'],
      scheduledDate: json['scheduled_date'],

      court: json['court'],
      nextMatchId: json['next_match_id'],
      nextMatchSlot: json['next_match_slot'],
      loserNextMatchId: json['loser_next_match_id'],
      loserNextMatchSlot: json['loser_next_match_slot'],
      bracketSide: json['bracket_side'],
      bracketPosition: json['bracket_position'],
      pairingMethod: json['pairing_method'],
      generatedBy: json['generated_by'],
      displayName: json['display_name'],
      isFinal: json['is_final'],
      isThirdPlace: json['is_third_place'],
      status: json['status'],
      league: League.fromMap(json['league']),
      referees: (json['referees'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),

      previousMatchIds: (json['previous_match_ids'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),

      dependsOnMatchIds: (json['depends_on_match_ids'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),

      isPlaceholder: json['is_placeholder'],
      bracketStageLabel: json['bracket_stage_label'],
      leagueMatchCreatedAt: json['league_match_created_at'],
      leagueMatchUpdatedAt: json['league_match_updated_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'league_match_id': leagueMatchId,
      'public_league_match_id': publicLeagueMatchId,
      'league_id': leagueId,
      'league_category_id': leagueCategoryId,
      'round_id': roundId,
      'home_team_id': homeTeamId,
      'home_team': homeTeam?.toMap(),
      'away_team_id': awayTeamId,
      'away_team': awayTeam?.toMap(),
      'home_team_score': homeTeamScore,
      'away_team_score': awayTeamScore,
      'winner_team_id': winnerTeamId,
      'loser_team_id': loserTeamId,
      'scheduled_date': scheduledDate,
      'quarters': quarters,
      'minutes_per_quarter': minutesPerQuarter,
      'minutes_per_overtime': minutesPerOvertime,
      'court': court,
      'referees': referees,
      'previous_match_ids': previousMatchIds,
      'next_match_id': nextMatchId,
      'next_match_slot': nextMatchSlot,
      'loser_next_match_id': loserNextMatchId,
      'loser_next_match_slot': loserNextMatchSlot,
      'round_number': roundNumber,
      'bracket_side': bracketSide,
      'bracket_position': bracketPosition,
      'pairing_method': pairingMethod,
      'generated_by': generatedBy,
      'display_name': displayName,
      'is_final': isFinal,
      'is_third_place': isThirdPlace,
      'status': status,
      'league': league,
      'stage_number': stageNumber,
      'depends_on_match_ids': dependsOnMatchIds,
      'is_placeholder': isPlaceholder,
      'bracket_stage_label': bracketStageLabel,
      'league_match_created_at': leagueMatchCreatedAt,
      'league_match_updated_at': leagueMatchUpdatedAt,
    };
  }
}
