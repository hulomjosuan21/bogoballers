// ignore_for_file: non_constant_identifier_names

import 'package:bogoballers/core/models/category.dart';
import 'package:bogoballers/core/models/league_admin_model.dart';

abstract class League {
  final String league_id;
  final String league_administrator_id;
  final String league_title;
  final String league_description;
  final String league_address;
  final double league_budget;
  final String registration_deadline;
  final String opening_date;
  final List<String> league_schedule;
  final String banner_url;
  final String status;
  final int season_year;
  final List<String> sportsmanship_rules;

  League({
    required this.league_id,
    required this.league_administrator_id,
    required this.league_title,
    required this.league_description,
    required this.league_address,
    required this.league_budget,
    required this.registration_deadline,
    required this.opening_date,
    required this.league_schedule,
    required this.banner_url,
    required this.status,
    required this.season_year,
    required this.sportsmanship_rules,
  });
}

class LeagueModel extends League {
  final String created_at;
  final String updated_at;
  final List<LeagueCategory> categories;
  final LeagueAdminModel creator;

  LeagueModel({
    required super.league_id,
    required super.league_administrator_id,
    required super.league_title,
    required super.league_description,
    required super.league_budget,
    required super.league_address,
    required super.registration_deadline,
    required super.opening_date,
    required super.league_schedule,
    required super.banner_url,
    required super.status,
    required super.season_year,
    required super.sportsmanship_rules,
    required this.created_at,
    required this.updated_at,
    required this.categories,
    required this.creator,
  });

  factory LeagueModel.fromMap(Map<String, dynamic> map) {
    return LeagueModel(
      league_id: map['league_id'],
      league_administrator_id: map['league_administrator_id'],
      league_title: map['league_title'],
      league_description: map['league_description'],
      league_address: map['league_address'],
      league_budget: map['league_budget'],
      registration_deadline: map['registration_deadline'],
      opening_date: map['opening_date'],
      league_schedule: List<String>.from(map['league_schedule']),
      banner_url: map['banner_url'],
      status: map['status'],
      season_year: map['season_year'],
      sportsmanship_rules: List<String>.from(map['sportsmanship_rules']),
      created_at: map['created_at'],
      updated_at: map['updated_at'],
      categories: (map['categories'] as List)
          .map((item) => LeagueCategory.fromMap(item as Map<String, dynamic>))
          .toList(),
      creator: LeagueAdminModel.fromMap(map['creator']),
    );
  }
}

class LeagueCategory extends Category {
  final String league_category_id;
  final String league_id;
  final int max_team;
  final bool accept_teams;
  final List<LeagueCategoryRound> rounds;

  LeagueCategory({
    required super.category_id,
    required super.category_name,
    required super.check_player_age,
    required super.player_min_age,
    required super.player_max_age,
    required super.player_gender,
    required super.check_address,
    required super.allowed_address,
    required super.allow_guest_team,
    required super.team_entrance_fee_amount,
    required super.allow_guest_player,
    required super.guest_player_fee_amount,
    required this.league_category_id,
    required this.league_id,
    required this.max_team,
    required this.accept_teams,
    required this.rounds,
    required super.requires_valid_document,
    required super.allowed_documents,
    required super.document_valid_until,
  });

  factory LeagueCategory.fromMap(Map<String, dynamic> map) {
    return LeagueCategory(
      category_id: map['category_id'],
      category_name: map['category_name'],
      check_player_age: map['check_player_age'],
      player_min_age: map['player_min_age'],
      player_max_age: map['player_max_age'],
      player_gender: map['player_gender'],
      check_address: map['check_address'],
      allowed_address: map['allowed_address'],
      allow_guest_team: map['allow_guest_team'],
      team_entrance_fee_amount: map['team_entrance_fee_amount'],
      allow_guest_player: map['allow_guest_player'],
      guest_player_fee_amount: map['guest_player_fee_amount'],
      league_category_id: map['league_category_id'],
      requires_valid_document: map['requires_valid_document'],
      allowed_documents: map['allowed_documents'] != null
          ? List<String>.from(map['allowed_documents'])
          : null,
      document_valid_until: map['document_valid_until'],
      league_id: map['league_id'],
      max_team: map['max_team'],
      accept_teams: map['accept_teams'],
      rounds: (map['rounds'] as List)
          .map(
            (item) => LeagueCategoryRound.fromMap(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

class LeagueCategoryRound {
  final String round_id;
  final String league_category_id;
  final String round_name;
  final int round_order;
  final String round_status;
  final LeagueCategoryRoundFormat? round_format;
  final String? next_round_id;

  LeagueCategoryRound({
    required this.round_id,
    required this.league_category_id,
    required this.round_name,
    required this.round_order,
    required this.round_status,
    required this.round_format,
    required this.next_round_id,
  });

  factory LeagueCategoryRound.fromMap(Map<String, dynamic> map) {
    return LeagueCategoryRound(
      round_id: map['round_id'],
      league_category_id: map['league_category_id'],
      round_name: map['round_name'],
      round_order: map['round_order'],
      round_status: map['round_status'],
      round_format: map['round_format'] != null
          ? LeagueCategoryRoundFormat.fromMap(map['round_format'])
          : null,
      next_round_id: map['next_round_id'],
    );
  }
}

class LeagueCategoryRoundFormat {
  final String round_id;
  final String format_type;
  final String pairing_method;

  LeagueCategoryRoundFormat({
    required this.round_id,
    required this.format_type,
    required this.pairing_method,
  });

  factory LeagueCategoryRoundFormat.fromMap(Map<String, dynamic> map) {
    return LeagueCategoryRoundFormat(
      round_id: map['round_id'],
      format_type: map['format_type'],
      pairing_method: map['pairing_method'],
    );
  }
}
