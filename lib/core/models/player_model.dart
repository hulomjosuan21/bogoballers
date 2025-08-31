// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:bogoballers/core/models/user_model.dart';
import 'package:dio/dio.dart';

abstract class Player {
  final String player_id;
  final String user_id;
  final String full_name;
  final String gender;
  final String birth_date;
  final String player_address;
  final String jersey_name;
  final double jersey_number;
  final List<String> position;
  final double height_in;
  final double weight_kg;
  final int total_games_played;
  final int total_points_scored;
  final int total_assists;
  final int total_rebounds;
  final int total_join_league;
  final String profile_image_url;

  Player({
    required this.player_id,
    required this.user_id,
    required this.full_name,
    required this.gender,
    required this.birth_date,
    required this.player_address,
    required this.jersey_name,
    required this.jersey_number,
    required this.position,
    required this.height_in,
    required this.weight_kg,
    required this.total_games_played,
    required this.total_points_scored,
    required this.total_assists,
    required this.total_rebounds,
    required this.profile_image_url,
    required this.total_join_league,
  });
}

class PlayerModel extends Player {
  final UserModel user;
  final String created_at;
  final String updated_at;
  PlayerModel({
    required super.player_id,
    required super.user_id,
    required super.full_name,
    required super.gender,
    required super.birth_date,
    required super.player_address,
    required super.jersey_name,
    required super.jersey_number,
    required super.position,
    required super.height_in,
    required super.weight_kg,
    required super.total_games_played,
    required super.total_points_scored,
    required super.total_assists,
    required super.total_rebounds,
    required super.profile_image_url,
    required this.created_at,
    required this.updated_at,
    required this.user,
    required super.total_join_league,
  });

  factory PlayerModel.fromMap(Map<String, dynamic> map) {
    return PlayerModel(
      player_id: map['player_id'],
      user_id: map['user_id'],
      full_name: map['full_name'],
      gender: map['gender'],
      birth_date: map['birth_date'],
      player_address: map['player_address'],
      jersey_name: map['jersey_name'],
      jersey_number: map['jersey_number'],
      position: List<String>.from(map['position']),
      height_in: map['height_in'],
      weight_kg: map['weight_kg'],
      total_games_played: map['total_games_played'],
      total_points_scored: map['total_points_scored'],
      total_assists: map['total_assists'],
      total_rebounds: map['total_rebounds'],
      total_join_league: map['total_join_league'],
      profile_image_url: map['profile_image_url'],
      created_at: map['created_at'],
      updated_at: map['updated_at'],
      user: UserModel.fromMap(map['user']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'player_id': player_id,
      'user_id': user_id,
      'full_name': full_name,
      'gender': gender,
      'birth_date': birth_date,
      'player_address': player_address,
      'jersey_name': jersey_name,
      'jersey_number': jersey_number,
      'position': position,
      'height_in': height_in,
      'weight_kg': weight_kg,
      'total_games_played': total_games_played,
      'total_points_scored': total_points_scored,
      'total_assists': total_assists,
      'total_rebounds': total_rebounds,
      'profile_image_url': profile_image_url,
      'created_at': created_at,
      'updated_at': updated_at,
      'user': user.toMap(),
    };
  }
}

class CreatePlayer {
  final String email;
  final String password_str;
  final String contact_number;
  final String full_name;
  final String gender;
  final String birth_date;
  final String player_address;
  final String? fcm_token;
  final String jersey_name;
  final double jersey_number;
  final List<String> position;
  final MultipartFile profile_image;

  CreatePlayer({
    required this.email,
    required this.password_str,
    required this.contact_number,
    required this.full_name,
    required this.gender,
    required this.birth_date,
    required this.player_address,
    required this.jersey_name,
    required this.jersey_number,
    required this.position,
    required this.profile_image,
    required this.fcm_token,
  });

  FormData toFormDataForCreation() {
    final map = {
      "email": email,
      "password_str": password_str,
      "contact_number": contact_number,
      "full_name": full_name,
      "gender": gender,
      "birth_date": birth_date,
      "player_address": player_address,
      "jersey_name": jersey_name,
      "jersey_number": jersey_number,
      "position": jsonEncode(position),
      "profile_image": profile_image,
    };

    if (fcm_token != null && fcm_token!.isNotEmpty) {
      map["fcm_token"] = fcm_token!;
    }

    return FormData.fromMap(map);
  }
}

class PlayerTeamModel extends Player {
  final String player_team_id;
  final String team_id;
  final bool is_ban;
  final String is_accepted;
  final UserModelForTeam user;

  PlayerTeamModel({
    required this.player_team_id,
    required this.team_id,
    required this.is_ban,
    required this.is_accepted,
    required super.player_id,
    required super.user_id,
    required super.full_name,
    required super.gender,
    required super.birth_date,
    required super.player_address,
    required super.jersey_name,
    required super.jersey_number,
    required super.position,
    required super.height_in,
    required super.weight_kg,
    required super.total_games_played,
    required super.total_points_scored,
    required super.total_assists,
    required super.total_rebounds,
    required super.profile_image_url,
    required this.user,
    required super.total_join_league,
  });

  factory PlayerTeamModel.fromMap(Map<String, dynamic> map) {
    return PlayerTeamModel(
      player_team_id: map['player_team_id'],
      team_id: map['team_id'],
      is_ban: map['is_ban'],
      is_accepted: map['is_accepted'],
      player_id: map['player_id'],
      user_id: map['user_id'],
      full_name: map['full_name'],
      gender: map['gender'],
      birth_date: map['birth_date'],
      player_address: map['player_address'],
      jersey_name: map['jersey_name'],
      jersey_number: (map['jersey_number'] as num).toDouble(),
      position: List<String>.from(map['position']),
      height_in: (map['height_in'] as num).toDouble(),
      weight_kg: (map['weight_kg'] as num).toDouble(),
      total_games_played: map['total_games_played'],
      total_points_scored: map['total_points_scored'],
      total_assists: map['total_assists'],
      total_rebounds: map['total_rebounds'],
      total_join_league: map['total_join_league'],
      profile_image_url: map['profile_image_url'],
      user: UserModelForTeam.fromMap(map['user']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'player_team_id': player_team_id,
      'team_id': team_id,
      'is_ban': is_ban,
      'is_accepted': is_accepted,
      'player_id': player_id,
      'user_id': user_id,
      'full_name': full_name,
      'gender': gender,
      'birth_date': birth_date,
      'player_address': player_address,
      'jersey_name': jersey_name,
      'jersey_number': jersey_number,
      'position': position,
      'height_in': height_in,
      'weight_kg': weight_kg,
      'total_games_played': total_games_played,
      'total_points_scored': total_points_scored,
      'total_assists': total_assists,
      'total_rebounds': total_rebounds,
      'profile_image_url': profile_image_url,
      'user': user.toMap(),
    };
  }
}
