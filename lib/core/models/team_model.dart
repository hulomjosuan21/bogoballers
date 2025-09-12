import 'package:bogoballers/core/models/player_model.dart';
import 'package:bogoballers/core/models/user_model.dart';

class Team {
  final String teamId;
  final String publicTeamId;
  final String userId;
  final String teamName;
  final String teamAddress;
  final String? teamCategory;
  final String contactNumber;
  final String? teamMotto;
  final String teamLogoUrl;
  final int championshipsWon;
  final String coachName;
  final String? assistantCoachName;
  final int totalWins;
  final int totalLosses;
  final int totalDraws;
  final int totalPoints;
  final bool isRecruiting;
  final User creator;
  final String teamCreatedAt;
  final String teamUpdatedAt;
  final List<PlayerTeam> acceptedPlayers;
  final List<PlayerTeam> pendingPlayers;
  final List<PlayerTeam> rejectedPlayers;
  final List<PlayerTeam> invitedPlayers;
  final List<PlayerTeam> standbyPlayers;
  final List<PlayerTeam> guestPlayers;

  Team({
    required this.teamId,
    required this.publicTeamId,
    required this.userId,
    required this.teamName,
    required this.teamAddress,
    this.teamCategory,
    required this.contactNumber,
    this.teamMotto,
    required this.teamLogoUrl,
    required this.championshipsWon,
    required this.coachName,
    this.assistantCoachName,
    required this.totalWins,
    required this.totalLosses,
    required this.totalDraws,
    required this.totalPoints,
    required this.isRecruiting,
    required this.creator,
    required this.teamCreatedAt,
    required this.teamUpdatedAt,
    required this.acceptedPlayers,
    required this.pendingPlayers,
    required this.rejectedPlayers,
    required this.invitedPlayers,
    required this.standbyPlayers,
    required this.guestPlayers,
  });

  factory Team.fromMap(Map<String, dynamic> map) {
    return Team(
      teamId: map['team_id'] as String,
      publicTeamId: map['public_team_id'] as String,
      userId: map['user_id'] as String,
      teamName: map['team_name'] as String,
      teamAddress: map['team_address'] as String,
      teamCategory: map['team_category'] as String?,
      contactNumber: map['contact_number'] as String,
      teamMotto: map['team_motto'] as String?,
      teamLogoUrl: map['team_logo_url'] as String,
      championshipsWon: map['championships_won'] as int,
      coachName: map['coach_name'] as String,
      assistantCoachName: map['assistant_coach_name'] as String?,
      totalWins: map['total_wins'] as int,
      totalLosses: map['total_losses'] as int,
      totalDraws: map['total_draws'] as int,
      totalPoints: map['total_points'] as int,
      isRecruiting: map['is_recruiting'] as bool,
      creator: User.fromMap(map['creator'] as Map<String, dynamic>),
      teamCreatedAt: map['team_created_at'] as String,
      teamUpdatedAt: map['team_updated_at'] as String,
      acceptedPlayers: (map['accepted_players'] as List)
          .map((e) => PlayerTeam.fromMap(e as Map<String, dynamic>))
          .toList(),
      pendingPlayers: (map['pending_players'] as List)
          .map((e) => PlayerTeam.fromMap(e as Map<String, dynamic>))
          .toList(),
      rejectedPlayers: (map['rejected_players'] as List)
          .map((e) => PlayerTeam.fromMap(e as Map<String, dynamic>))
          .toList(),
      invitedPlayers: (map['invited_players'] as List)
          .map((e) => PlayerTeam.fromMap(e as Map<String, dynamic>))
          .toList(),
      standbyPlayers: (map['stanby_players'] as List)
          .map((e) => PlayerTeam.fromMap(e as Map<String, dynamic>))
          .toList(),
      guestPlayers: (map['guest_players'] as List)
          .map((e) => PlayerTeam.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'team_id': teamId,
      'public_team_id': publicTeamId,
      'user_id': userId,
      'team_name': teamName,
      'team_address': teamAddress,
      'team_category': teamCategory,
      'contact_number': contactNumber,
      'team_motto': teamMotto,
      'team_logo_url': teamLogoUrl,
      'championships_won': championshipsWon,
      'coach_name': coachName,
      'assistant_coach_name': assistantCoachName,
      'total_wins': totalWins,
      'total_losses': totalLosses,
      'total_draws': totalDraws,
      'total_points': totalPoints,
      'is_recruiting': isRecruiting,
      'creator': creator.toMap(),
      'team_created_at': teamCreatedAt,
      'team_updated_at': teamUpdatedAt,
      'accepted_players': acceptedPlayers.map((e) => e.toMap()).toList(),
      'pending_players': pendingPlayers.map((e) => e.toMap()).toList(),
      'rejected_players': rejectedPlayers.map((e) => e.toMap()).toList(),
      'invited_players': invitedPlayers.map((e) => e.toMap()).toList(),
      'stanby_players': standbyPlayers.map((e) => e.toMap()).toList(),
      'guest_players': guestPlayers.map((e) => e.toMap()).toList(),
    };
  }
}

class LeagueTeam extends Team {
  final String leagueTeamId;
  final String leagueId;
  final String leagueCategoryId;
  final String status;
  final bool isEliminated;
  final int amountPaid;
  final String paymentStatus;
  final int wins;
  final int losses;
  final int draws;
  final int points;
  final String leagueTeamCreatedAt;
  final String leagueTeamUpdatedAt;
  final List<LeaguePlayer> leaguePlayers;

  LeagueTeam({
    required this.leagueTeamId,
    required this.leagueId,
    required this.leagueCategoryId,
    required this.status,
    required this.isEliminated,
    required this.amountPaid,
    required this.paymentStatus,
    required this.wins,
    required this.losses,
    required this.draws,
    required this.points,
    required this.leagueTeamCreatedAt,
    required this.leagueTeamUpdatedAt,
    required this.leaguePlayers,
    required super.teamId,
    required super.publicTeamId,
    required super.userId,
    required super.teamName,
    required super.teamAddress,
    super.teamCategory,
    required super.contactNumber,
    super.teamMotto,
    required super.teamLogoUrl,
    required super.championshipsWon,
    required super.coachName,
    super.assistantCoachName,
    required super.totalWins,
    required super.totalLosses,
    required super.totalDraws,
    required super.totalPoints,
    required super.isRecruiting,
    required super.creator,
    required super.teamCreatedAt,
    required super.teamUpdatedAt,
    required super.acceptedPlayers,
    required super.pendingPlayers,
    required super.rejectedPlayers,
    required super.invitedPlayers,
    required super.standbyPlayers,
    required super.guestPlayers,
  });

  factory LeagueTeam.fromMap(Map<String, dynamic> map) {
    return LeagueTeam(
      leagueTeamId: map['league_team_id'] as String,
      leagueId: map['league_id'] as String,
      leagueCategoryId: map['league_category_id'] as String,
      status: map['status'] as String,
      isEliminated: map['is_eliminated'] as bool,
      amountPaid: map['amount_paid'] as int,
      paymentStatus: map['payment_status'] as String,
      wins: map['wins'] as int,
      losses: map['losses'] as int,
      draws: map['draws'] as int,
      points: map['points'] as int,
      leagueTeamCreatedAt: map['league_team_created_at'] as String,
      leagueTeamUpdatedAt: map['league_team_updated_at'] as String,
      leaguePlayers: (map['league_players'] as List)
          .map((e) => LeaguePlayer.fromMap(e as Map<String, dynamic>))
          .toList(),
      teamId: map['team_id'] as String,
      publicTeamId: map['public_team_id'] as String,
      userId: map['user_id'] as String,
      teamName: map['team_name'] as String,
      teamAddress: map['team_address'] as String,
      teamCategory: map['team_category'] as String?,
      contactNumber: map['contact_number'] as String,
      teamMotto: map['team_motto'] as String?,
      teamLogoUrl: map['team_logo_url'] as String,
      championshipsWon: map['championships_won'] as int,
      coachName: map['coach_name'] as String,
      assistantCoachName: map['assistant_coach_name'] as String?,
      totalWins: map['total_wins'] as int,
      totalLosses: map['total_losses'] as int,
      totalDraws: map['total_draws'] as int,
      totalPoints: map['total_points'] as int,
      isRecruiting: map['is_recruiting'] as bool,
      creator: User.fromMap(map['creator'] as Map<String, dynamic>),
      teamCreatedAt: map['team_created_at'] as String,
      teamUpdatedAt: map['team_updated_at'] as String,
      acceptedPlayers: (map['accepted_players'] as List)
          .map((e) => PlayerTeam.fromMap(e as Map<String, dynamic>))
          .toList(),
      pendingPlayers: (map['pending_players'] as List)
          .map((e) => PlayerTeam.fromMap(e as Map<String, dynamic>))
          .toList(),
      rejectedPlayers: (map['rejected_players'] as List)
          .map((e) => PlayerTeam.fromMap(e as Map<String, dynamic>))
          .toList(),
      invitedPlayers: (map['invited_players'] as List)
          .map((e) => PlayerTeam.fromMap(e as Map<String, dynamic>))
          .toList(),
      standbyPlayers: (map['stanby_players'] as List)
          .map((e) => PlayerTeam.fromMap(e as Map<String, dynamic>))
          .toList(),
      guestPlayers: (map['guest_players'] as List)
          .map((e) => PlayerTeam.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'league_team_id': leagueTeamId,
      'league_id': leagueId,
      'league_category_id': leagueCategoryId,
      'status': status,
      'is_eliminated': isEliminated,
      'amount_paid': amountPaid,
      'payment_status': paymentStatus,
      'wins': wins,
      'losses': losses,
      'draws': draws,
      'points': points,
      'league_team_created_at': leagueTeamCreatedAt,
      'league_team_updated_at': leagueTeamUpdatedAt,
      'league_players': leaguePlayers.map((e) => e.toMap()).toList(),
    };
  }
}
