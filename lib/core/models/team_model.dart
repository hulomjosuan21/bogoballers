// ignore_for_file: non_constant_identifier_names

import 'package:bogoballers/core/models/player_model.dart';
import 'package:dio/dio.dart';

abstract class Team {
  final String team_id;
  final String user_id;
  final String team_name;
  final String team_address;
  final String contact_number;
  final String team_motto;
  final String team_logo_url;
  final int championships_won;
  final String coach_name;
  final String? assistant_coach_name;
  final int total_wins;
  final int total_losses;
  final int total_draws;
  final int total_points;
  final bool is_recruiting;
  final String team_category;

  Team({
    required this.team_id,
    required this.user_id,
    required this.team_name,
    required this.team_address,
    required this.contact_number,
    required this.team_motto,
    required this.team_logo_url,
    required this.championships_won,
    required this.coach_name,
    required this.assistant_coach_name,
    required this.total_wins,
    required this.total_losses,
    required this.total_draws,
    required this.total_points,
    required this.is_recruiting,
    required this.team_category,
  });
}

class TeamModel extends Team {
  final PlayerTeamModel? team_captain;

  TeamModel({
    required this.team_captain,
    required super.team_id,
    required super.user_id,
    required super.team_name,
    required super.team_address,
    required super.contact_number,
    required super.team_motto,
    required super.team_logo_url,
    required super.championships_won,
    required super.coach_name,
    required super.assistant_coach_name,
    required super.total_wins,
    required super.total_losses,
    required super.total_draws,
    required super.total_points,
    required super.is_recruiting,
    required super.team_category,
  });

  factory TeamModel.fromMap(Map<String, dynamic> json) {
    return TeamModel(
      team_captain: json['team_captain'] != null
          ? PlayerTeamModel.fromMap(json['team_captain'])
          : null,
      team_id: json['team_id'],
      user_id: json['user_id'],
      team_name: json['team_name'],
      team_address: json['team_address'],
      contact_number: json['contact_number'],
      team_motto: json['team_motto'],
      team_logo_url: json['team_logo_url'],
      championships_won: json['championships_won'],
      coach_name: json['coach_name'],
      assistant_coach_name: json['assistant_coach_name'],
      total_wins: json['total_wins'],
      total_losses: json['total_losses'],
      total_draws: json['total_draws'],
      total_points: json['total_points'],
      is_recruiting: json['is_recruiting'],
      team_category: json['team_category'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'team_captain': team_captain?.toMap(),
      'team_id': team_id,
      'user_id': user_id,
      'team_name': team_name,
      'team_address': team_address,
      'contact_number': contact_number,
      'team_motto': team_motto,
      'team_logo_url': team_logo_url,
      'championships_won': championships_won,
      'coach_name': coach_name,
      'assistant_coach_name': assistant_coach_name,
      'total_wins': total_wins,
      'total_losses': total_losses,
      'total_draws': total_draws,
      'total_points': total_points,
      'is_recruiting': is_recruiting,
      'team_category': team_category,
    };
  }
}

class CreateTeam {
  final String team_name;
  final String team_address;
  final String contact_number;
  final String team_motto;
  final MultipartFile team_logo;
  final String coach_name;
  final String assistant_coach_name;
  final String team_category;

  CreateTeam({
    required this.team_name,
    required this.team_address,
    required this.contact_number,
    required this.team_motto,
    required this.team_logo,
    required this.coach_name,
    required this.assistant_coach_name,
    required this.team_category,
  });

  FormData toFormData() {
    return FormData.fromMap({
      'team_name': team_name,
      'team_address': team_address,
      'contact_number': contact_number,
      'team_motto': team_motto,
      'team_logo': team_logo,
      'coach_name': coach_name,
      'assistant_coach_name': assistant_coach_name,
      'team_category': team_category,
    });
  }
}
