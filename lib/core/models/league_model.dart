// ignore_for_file: non_constant_identifier_names

class LeagueCategoryModel {
  late String category_id;
  late String league_id;

  String category_name;

  String category_format;
  String stage;
  int max_team;
  double entrance_fee_amount;
  late bool accept_teams;

  late DateTime created_at;
  late DateTime updated_at;

  LeagueCategoryModel({
    required this.category_id,
    required this.league_id,
    required this.category_name,
    required this.category_format,
    required this.stage,
    required this.max_team,
    required this.created_at,
    required this.updated_at,
    required this.entrance_fee_amount,
    required this.accept_teams,
  });

  LeagueCategoryModel.create({
    required this.category_name,
    required this.category_format,
    this.stage = "Group Stage",
    required this.max_team,
    this.entrance_fee_amount = 0.0,
  });

  Map<String, dynamic> toJsonForCreation() {
    return {
      'category_name': category_name,
      'category_format': category_format,
      'stage': stage,
      'max_team': max_team,
      'entrance_fee_amount': entrance_fee_amount,
    };
  }

  factory LeagueCategoryModel.fromJson(Map<String, dynamic> json) {
    return LeagueCategoryModel(
      category_id: json['category_id'],
      league_id: json['league_id'],
      category_name: json['category_name'],
      category_format: json['category_format'],
      entrance_fee_amount: (json['entrance_fee_amount'] as num).toDouble(),
      stage: json['stage'],
      max_team: json['max_team'],
      created_at: DateTime.parse(json['created_at']),
      updated_at: DateTime.parse(json['updated_at']),
      accept_teams: json['accept_teams'],
    );
  }

  LeagueCategoryModel copyWith({
    String? category_id,
    String? league_id,
    String? category_name,
    String? category_format,
    String? stage,
    int? max_team,
    List<LeagueTeamModel>? category_teams,
    DateTime? created_at,
    DateTime? updated_at,
  }) {
    return LeagueCategoryModel(
      category_id: category_id ?? this.category_id,
      league_id: league_id ?? this.league_id,
      category_name: category_name ?? this.category_name,
      category_format: category_format ?? this.category_format,
      stage: stage ?? this.stage,
      max_team: max_team ?? this.max_team,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      entrance_fee_amount: entrance_fee_amount,
      accept_teams: accept_teams,
    );
  }
}

class LeagueTeamModel {
  late String league_team_id;
  late String team_id;
  late String league_id;
  late String category_id;

  int wins;
  int losses;
  int draws;
  int points;

  DateTime? created_at;
  DateTime? updated_at;

  LeagueTeamModel({
    required this.league_team_id,
    required this.team_id,
    required this.league_id,
    required this.category_id,
    required this.wins,
    required this.losses,
    required this.draws,
    required this.points,
    this.created_at,
    this.updated_at,
  });

  LeagueTeamModel.create({
    required this.team_id,
    required this.league_id,
    required this.category_id,
    required this.wins,
    required this.losses,
    required this.draws,
    required this.points,
  });

  factory LeagueTeamModel.fromJson(Map<String, dynamic> json) {
    return LeagueTeamModel(
      league_team_id: json['league_team_id'],
      team_id: json['team_id'],
      league_id: json['league_id'],
      category_id: json['category_id'],
      wins: json['wins'],
      losses: json['losses'],
      draws: json['draws'],
      points: json['points'],
      created_at: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updated_at: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'league_team_id': league_team_id,
      'team_id': team_id,
      'league_id': league_id,
      'category_id': category_id,
      'wins': wins,
      'losses': losses,
      'draws': draws,
      'points': points,
      'created_at': created_at?.toIso8601String(),
      'updated_at': updated_at?.toIso8601String(),
    };
  }

  LeagueTeamModel copyWith({
    String? league_team_id,
    String? team_id,
    String? league_id,
    String? category_id,
    int? wins,
    int? losses,
    int? draws,
    int? points,
    DateTime? created_at,
    DateTime? updated_at,
  }) {
    return LeagueTeamModel(
      league_team_id: league_team_id ?? this.league_team_id,
      team_id: team_id ?? this.team_id,
      league_id: league_id ?? this.league_id,
      category_id: category_id ?? this.category_id,
      wins: wins ?? this.wins,
      losses: losses ?? this.losses,
      draws: draws ?? this.draws,
      points: points ?? this.points,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }
}
