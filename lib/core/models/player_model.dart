// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:ffi';

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
  final int games_played;
  final int points_scored;
  final int assists;
  final int rebounds;
  final String profile_image_url;
  final String created_at;
  final String updated_at;
  final UserModel user;

  Player({
    required this.user,
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
    required this.games_played,
    required this.points_scored,
    required this.assists,
    required this.rebounds,
    required this.profile_image_url,
    required this.created_at,
    required this.updated_at,
  });
}

class PlayerModel extends Player {
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
    required super.games_played,
    required super.points_scored,
    required super.assists,
    required super.rebounds,
    required super.profile_image_url,
    required super.created_at,
    required super.updated_at,
    required super.user,
  });
}

class CreatePlayer {
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
  final MultipartFile profile_image;

  CreatePlayer({
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
    required this.profile_image,
  });

  FormData toFormDataForCreation() {
    return FormData.fromMap({
      "user_id": user_id,
      "full_name": full_name,
      "gender": gender,
      "birth_date": birth_date,
      "player_address": player_address,
      "jersey_name": jersey_name,
      "jersey_number": jersey_number,
      "position": jsonEncode(position),
      "height_in": height_in,
      "weight_kg": weight_kg,
      "profile_image": profile_image,
    });
  }
}

class PlayerTeamModel extends Player {
  final String player_team_id;
  final String team_id;
  Bool is_ban;
  Bool is_accepted;

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
    required super.games_played,
    required super.points_scored,
    required super.assists,
    required super.rebounds,
    required super.profile_image_url,
    required super.created_at,
    required super.updated_at,
    required super.user,
  });
}
