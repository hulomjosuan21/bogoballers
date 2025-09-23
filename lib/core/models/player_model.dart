import 'package:bogoballers/core/models/user_model.dart';

class Player {
  final String playerId;
  final String publicPlayerId;
  final String userId;
  final String fullName;
  final String profileImageUrl;
  final String gender;
  final String birthDate;
  final String playerAddress;
  final String jerseyName;
  final double jerseyNumber;
  final List<String> position;
  final double heightIn;
  final double weightKg;
  final int totalGamesPlayed;
  final int totalPointsScored;
  final int totalAssists;
  final int totalRebounds;
  final int totalJoinLeague;
  final bool isBan;
  final bool isAllowed;
  final List<String>? validDocuments;
  final User user;
  final String playerCreatedAt;
  final String playerUpdatedAt;

  Player({
    required this.playerId,
    required this.publicPlayerId,
    required this.userId,
    required this.fullName,
    required this.profileImageUrl,
    required this.gender,
    required this.birthDate,
    required this.playerAddress,
    required this.jerseyName,
    required this.jerseyNumber,
    required this.position,
    required this.heightIn,
    required this.weightKg,
    required this.totalGamesPlayed,
    required this.totalPointsScored,
    required this.totalAssists,
    required this.totalRebounds,
    required this.totalJoinLeague,
    required this.isBan,
    required this.isAllowed,
    this.validDocuments,
    required this.user,
    required this.playerCreatedAt,
    required this.playerUpdatedAt,
  });

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      playerId: map['player_id'] as String,
      publicPlayerId: map['public_player_id'] as String,
      userId: map['user_id'] as String,
      fullName: map['full_name'] as String,
      profileImageUrl: map['profile_image_url'] as String,
      gender: map['gender'] as String,
      birthDate: map['birth_date'] as String,
      playerAddress: map['player_address'] as String,
      position: List<String>.from(map['position'] as List),
      jerseyName: map['jersey_name'] as String,
      jerseyNumber: (map['jersey_number'] as num).toDouble(),
      heightIn: (map['height_in'] as num).toDouble(),
      weightKg: (map['weight_kg'] as num).toDouble(),

      totalGamesPlayed: (map['total_games_played'] as num?)?.toInt() ?? 0,

      totalPointsScored: (map['total_points_scored'] as num).toInt(),
      totalAssists: (map['total_assists'] as num).toInt(),
      totalRebounds: (map['total_rebounds'] as num).toInt(),
      totalJoinLeague: (map['total_join_league'] as num).toInt(),

      isBan: map['is_ban'] as bool,
      isAllowed: map['is_allowed'] as bool,
      validDocuments: map['valid_documents'] != null
          ? List<String>.from(map['valid_documents'] as List)
          : null,
      user: User.fromMap(map['user'] as Map<String, dynamic>),
      playerCreatedAt: map['player_created_at'] as String,
      playerUpdatedAt: map['player_updated_at'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'player_id': playerId,
      'public_player_id': publicPlayerId,
      'user_id': userId,
      'full_name': fullName,
      'profile_image_url': profileImageUrl,
      'gender': gender,
      'birth_date': birthDate,
      'player_address': playerAddress,
      'jersey_name': jerseyName,
      'jersey_number': jerseyNumber,
      'position': position,
      'height_in': heightIn,
      'weight_kg': weightKg,
      'total_games_played': totalGamesPlayed,
      'total_points_scored': totalPointsScored,
      'total_assists': totalAssists,
      'total_rebounds': totalRebounds,
      'total_join_league': totalJoinLeague,
      'is_ban': isBan,
      'is_allowed': isAllowed,
      'valid_documents': validDocuments,
      'user': user.toMap(),
      'player_created_at': playerCreatedAt,
      'player_updated_at': playerUpdatedAt,
    };
  }
}

class PlayerTeam extends Player {
  final String playerTeamId;
  final String teamId;
  final bool isTeamCaptain;
  final String isAccepted;
  final String playerTeamCreatedAt;
  final String playerTeamUpdatedAt;

  PlayerTeam({
    required this.playerTeamId,
    required this.teamId,
    required this.isTeamCaptain,
    required this.isAccepted,
    required this.playerTeamCreatedAt,
    required this.playerTeamUpdatedAt,
    required super.playerId,
    required super.publicPlayerId,
    required super.userId,
    required super.fullName,
    required super.profileImageUrl,
    required super.gender,
    required super.birthDate,
    required super.playerAddress,
    required super.jerseyName,
    required super.jerseyNumber,
    required super.position,
    required super.heightIn,
    required super.weightKg,
    required super.totalGamesPlayed,
    required super.totalPointsScored,
    required super.totalAssists,
    required super.totalRebounds,
    required super.totalJoinLeague,
    required super.isBan,
    required super.isAllowed,
    super.validDocuments,
    required super.user,
    required super.playerCreatedAt,
    required super.playerUpdatedAt,
  });

  factory PlayerTeam.fromMap(Map<String, dynamic> map) {
    return PlayerTeam(
      playerTeamId: map['player_team_id'] as String,
      teamId: map['team_id'] as String,
      isTeamCaptain: map['is_team_captain'] as bool,
      isAccepted: map['is_accepted'] as String,
      playerTeamCreatedAt: map['player_team_created_at'] as String,
      playerTeamUpdatedAt: map['player_team_updated_at'] as String,
      playerId: map['player_id'] as String,
      publicPlayerId: map['public_player_id'] as String,
      userId: map['user_id'] as String,
      fullName: map['full_name'] as String,
      profileImageUrl: map['profile_image_url'] as String,
      gender: map['gender'] as String,
      birthDate: map['birth_date'] as String,
      playerAddress: map['player_address'] as String,
      jerseyName: map['jersey_name'] as String,
      jerseyNumber: map['jersey_number'] as double,
      position: List<String>.from(map['position'] as List),
      heightIn: map['height_in'] as double,
      weightKg: map['weight_kg'] as double,
      totalGamesPlayed: map['total_games_played'] as int,
      totalPointsScored: map['total_points_scored'] as int,
      totalAssists: map['total_assists'] as int,
      totalRebounds: map['total_rebounds'] as int,
      totalJoinLeague: map['total_join_league'] as int,
      isBan: map['is_ban'] as bool,
      isAllowed: map['is_allowed'] as bool,
      validDocuments: map['valid_documents'] != null
          ? List<String>.from(map['valid_documents'] as List)
          : null,
      user: User.fromMap(map['user'] as Map<String, dynamic>),
      playerCreatedAt: map['player_created_at'] as String,
      playerUpdatedAt: map['player_updated_at'] as String,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'player_team_id': playerTeamId,
      'team_id': teamId,
      'is_team_captain': isTeamCaptain,
      'is_accepted': isAccepted,
      'player_team_created_at': playerTeamCreatedAt,
      'player_team_updated_at': playerTeamUpdatedAt,
    };
  }
}

class LeaguePlayer extends PlayerTeam {
  final String leaguePlayerId;
  final String leagueId;
  final String leagueCategoryId;
  final String leagueTeamId;
  final int totalPoints;
  final bool isBanInLeague;
  final bool isAllowedInLeague;
  final String leaguePlayerCreatedAt;
  final String leaguePlayerUpdatedAt;

  LeaguePlayer({
    required this.leaguePlayerId,
    required this.leagueId,
    required this.leagueCategoryId,
    required this.leagueTeamId,
    required this.totalPoints,
    required this.isBanInLeague,
    required this.isAllowedInLeague,
    required this.leaguePlayerCreatedAt,
    required this.leaguePlayerUpdatedAt,
    required super.playerTeamId,
    required super.teamId,
    required super.isTeamCaptain,
    required super.isAccepted,
    required super.playerTeamCreatedAt,
    required super.playerTeamUpdatedAt,
    required super.playerId,
    required super.publicPlayerId,
    required super.userId,
    required super.fullName,
    required super.profileImageUrl,
    required super.gender,
    required super.birthDate,
    required super.playerAddress,
    required super.jerseyName,
    required super.jerseyNumber,
    required super.position,
    required super.heightIn,
    required super.weightKg,
    required super.totalGamesPlayed,
    required super.totalPointsScored,
    required super.totalAssists,
    required super.totalRebounds,
    required super.totalJoinLeague,
    required super.isBan,
    required super.isAllowed,
    super.validDocuments,
    required super.user,
    required super.playerCreatedAt,
    required super.playerUpdatedAt,
  });

  factory LeaguePlayer.fromMap(Map<String, dynamic> map) {
    return LeaguePlayer(
      leaguePlayerId: map['league_player_id'] as String,
      leagueId: map['league_id'] as String,
      leagueCategoryId: map['league_category_id'] as String,
      leagueTeamId: map['league_team_id'] as String,
      totalPoints: (map['total_points'] as num?)?.toInt() ?? 0,
      isBanInLeague: map['is_ban_in_league'] as bool? ?? false,
      isAllowedInLeague: map['is_allowed_in_league'] as bool? ?? true,

      leaguePlayerCreatedAt: map['league_player_created_at'] as String,
      leaguePlayerUpdatedAt: map['league_player_updated_at'] as String,
      playerTeamId: map['player_team_id'] as String,
      teamId: map['team_id'] as String,

      jerseyNumber:
          (map['jersey_number'] as num?)?.toDouble() ?? 0.0, // Add null safety
      heightIn:
          (map['height_in'] as num?)?.toDouble() ?? 0.0, // Add null safety
      weightKg:
          (map['weight_kg'] as num?)?.toDouble() ?? 0.0, // Add null safety

      totalGamesPlayed: (map['total_games_played'] as num?)?.toInt() ?? 0,
      totalPointsScored:
          (map['total_points_scored'] as num?)?.toInt() ?? 0, // Add null safety
      totalAssists:
          (map['total_assists'] as num?)?.toInt() ?? 0, // Add null safety
      totalRebounds:
          (map['total_rebounds'] as num?)?.toInt() ?? 0, // Add null safety
      totalJoinLeague:
          (map['total_join_league'] as num?)?.toInt() ?? 0, // Add null safety

      isTeamCaptain:
          map['is_team_captain'] as bool? ?? false, // Add null safety
      isAccepted: map['is_accepted'] as String? ?? 'pending', // Add null safety
      playerTeamCreatedAt: map['player_team_created_at'] as String,
      playerTeamUpdatedAt: map['player_team_updated_at'] as String,
      playerId: map['player_id'] as String,
      publicPlayerId: map['public_player_id'] as String,
      userId: map['user_id'] as String,
      fullName:
          map['full_name'] as String? ?? 'Unknown Player', // Add null safety
      profileImageUrl:
          map['profile_image_url'] as String? ?? '', // Add null safety
      gender: map['gender'] as String? ?? 'Unknown', // Add null safety
      birthDate: map['birth_date'] as String? ?? '', // Add null safety
      playerAddress: map['player_address'] as String? ?? '', // Add null safety
      jerseyName: map['jersey_name'] as String? ?? 'Unknown', // Add null safety
      position: map['position'] != null
          ? List<String>.from(map['position'] as List)
          : ['Unknown'], // Add null safety
      isBan: map['is_ban'] as bool? ?? false, // Add null safety
      isAllowed: map['is_allowed'] as bool? ?? true, // Add null safety
      validDocuments: map['valid_documents'] != null
          ? List<String>.from(map['valid_documents'] as List)
          : null,
      user: User.fromMap(map['user'] as Map<String, dynamic>),
      playerCreatedAt: map['player_created_at'] as String,
      playerUpdatedAt: map['player_updated_at'] as String,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'league_player_id': leaguePlayerId,
      'league_id': leagueId,
      'league_category_id': leagueCategoryId,
      'league_team_id': leagueTeamId,
      'total_points': totalPoints,
      'is_ban_in_league': isBanInLeague,
      'is_allowed_in_league': isAllowedInLeague,
      'league_player_created_at': leaguePlayerCreatedAt,
      'league_player_updated_at': leaguePlayerUpdatedAt,
    };
  }
}
