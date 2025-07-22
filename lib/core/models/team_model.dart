// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'package:dio/dio.dart';

enum TeamInviteStatus {
  pending('Pending'),
  accepted('Accepted'),
  rejected('Rejected'),
  invited('Invited');

  final String value;

  const TeamInviteStatus(this.value);

  static TeamInviteStatus? fromValue(String? value) {
    return TeamInviteStatus.values.firstWhere(
      (e) => e.value.toLowerCase() == value?.toLowerCase(),
      orElse: () => TeamInviteStatus.pending,
    );
  }
}

class PlayerTeamModel {
  late String player_team_id;
  String player_id;
  String team_id;
  late bool is_ban;

  late DateTime birth_date;
  late String full_name;
  late String gender;
  late String contact_number;
  late String jersey_name;
  late double jersey_number;
  late String player_address;
  late String position;
  late String profile_image_url;
  late String user_id;
  late bool is_team_captain;

  factory PlayerTeamModel.fromJson(Map<String, dynamic> json) {
    return PlayerTeamModel(
      player_team_id: json['player_team_id'] ?? '',
      player_id: json['player_id'] ?? '',
      team_id: json['team_id'] ?? '',
      is_ban: json['is_ban'] ?? false,
      birth_date: _parseHttpDate(json['birth_date']),
      full_name: json['full_name'] ?? '',
      gender: json['gender'] ?? '',
      contact_number: json['contact_number'],
      jersey_name: json['jersey_name'] ?? '',
      jersey_number: json['jersey_number'],
      player_address: json['player_address'] ?? '',
      position: json['position'] ?? '',
      profile_image_url: json['profile_image_url'] ?? '',
      user_id: json['user_id'] ?? '',
      is_team_captain: json['is_team_captain'],
    );
  }

  static DateTime _parseHttpDate(String? raw) {
    try {
      if (raw == null) return DateTime(2000);
      return HttpDate.parse(raw);
    } catch (e) {
      return DateTime(2000);
    }
  }

  PlayerTeamModel({
    required this.player_team_id,
    required this.player_id,
    required this.team_id,
    required this.is_ban,
    required this.birth_date,
    required this.full_name,
    required this.gender,
    required this.contact_number,
    required this.jersey_name,
    required this.jersey_number,
    required this.player_address,
    required this.position,
    required this.profile_image_url,
    required this.user_id,
    required this.is_team_captain,
  });

  Map<String, dynamic> toMap() {
    return {
      'player_team_id': player_team_id,
      'player_id': player_id,
      'team_id': team_id,
      'is_ban': is_ban,
      'birth_date': birth_date,
      'full_name': full_name,
      'gender': gender,
      'jersey_name': jersey_name,
      'jersey_number': jersey_number,
      'player_address': player_address,
      'position': position,
      'profile_image_url': profile_image_url,
      'user_id': user_id,
    };
  }

  PlayerTeamModel.create({required this.player_id, required this.team_id});
}

class TeamModel {
  late String team_id;
  String user_id;
  String team_name;
  String team_address;
  String contact_number;
  String team_motto;
  late String team_logo_url;
  late int championships_won;
  String coach_name;
  String? assistant_coach_name;
  late int total_wins;
  late int total_losses;
  late bool is_recruiting;
  String? team_captain_id;
  String? team_category;

  late MultipartFile team_logo_image;
  late DateTime created_at;
  late DateTime updated_at;


  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      team_id: json['team_id'],
      user_id: json['user_id'],
      team_name: json['team_name'],
      team_address: json['team_address'],
      contact_number: json['contact_number'],
      team_motto: json['team_motto'],
      team_logo_url: json['team_logo_url'],
      championships_won: json['championships_won'],
      coach_name: json['coach_name'],
      assistant_coach_name: json['assistant_coach_name'] ?? null,
      total_wins: json['total_wins'],
      total_losses: json['total_losses'] ?? 0,
      is_recruiting: json['is_recruiting'] ?? 0,
      created_at: DateTime.parse(json['created_at']),
      updated_at: DateTime.parse(json['updated_at']),
      team_category: json['team_category']
    );
  }

  TeamModel({
    required this.team_id,
    required this.user_id,
    required this.team_name,
    required this.team_address,
    required this.contact_number,
    required this.team_motto,
    required this.coach_name,
    this.assistant_coach_name,
    required this.team_logo_url,
    required this.championships_won,
    this.team_captain_id,
    required this.created_at,
    required this.updated_at,
    required this.is_recruiting,
    required this.total_wins,
    required this.total_losses,
    required this.team_category
  });

  TeamModel copyWith({
    String? team_name,
    String? team_address,
    String? contact_number,
    String? team_motto,
    String? team_category,
    String? coach_name,
    String? assistant_coach_name,
    bool? is_recruiting,
    String? team_captain_id,
  }) {
    return TeamModel(
      team_id: team_id,
      user_id: user_id,
      team_name: team_name ?? this.team_name,
      team_address: team_address ?? this.team_address,
      contact_number: contact_number ?? this.contact_number,
      team_motto: team_motto ?? this.team_motto,
      team_logo_url: team_logo_url,
      championships_won: championships_won,
      coach_name: coach_name ?? this.coach_name,
      assistant_coach_name: assistant_coach_name ?? this.assistant_coach_name,
      total_wins: total_wins,
      total_losses: total_losses,
      is_recruiting: is_recruiting ?? this.is_recruiting,
      team_captain_id: team_captain_id ?? this.team_captain_id,
      created_at: created_at,
      updated_at: updated_at,
      team_category: team_category
    );
  }

  Map<String, dynamic> toJsonForUpdate(TeamModel original) {
    final Map<String, dynamic> updatedFields = {};

    if (team_name != original.team_name) updatedFields['team_name'] = team_name;
    if (team_address != original.team_address)
      updatedFields['team_address'] = team_address;
    if (contact_number != original.contact_number)
      updatedFields['contact_number'] = contact_number;
    if (team_motto != original.team_motto)
      updatedFields['team_motto'] = team_motto;
    if (coach_name != original.coach_name)
      updatedFields['coach_name'] = coach_name;
    if (assistant_coach_name != original.assistant_coach_name)
      updatedFields['assistant_coach_name'] = assistant_coach_name;
    if (is_recruiting != original.is_recruiting)
      updatedFields['is_recruiting'] = is_recruiting;
    if (team_captain_id != original.team_captain_id)
      updatedFields['team_captain_id'] = team_captain_id;

    return updatedFields;
  }

  Map<String, dynamic> toMap() {
    return {
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
      'is_recruiting': is_recruiting,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  Map<String, dynamic> toChangedJson(TeamModel other) {
    final Map<String, dynamic> changes = {};

    if (team_name != other.team_name) changes['team_name'] = team_name;
    if (team_address != other.team_address)
      changes['team_address'] = team_address;
    if (contact_number != other.contact_number)
      changes['contact_number'] = contact_number;
    if (team_motto != other.team_motto) changes['team_motto'] = team_motto;
    if (team_logo_url != other.team_logo_url)
      changes['team_logo_url'] = team_logo_url;
    if (championships_won != other.championships_won)
      changes['championships_won'] = championships_won;
    if (coach_name != other.coach_name) changes['coach_name'] = coach_name;
    if (assistant_coach_name != other.assistant_coach_name)
      changes['assistant_coach_name'] = assistant_coach_name;
    if (total_wins != other.total_wins) changes['total_wins'] = total_wins;
    if (total_losses != other.total_losses)
      changes['total_losses'] = total_losses;
    if (is_recruiting != other.is_recruiting)
      changes['is_recruiting'] = is_recruiting;
    if (team_captain_id != other.team_captain_id)
      changes['team_captain_id'] = team_captain_id;

    return changes;
  }

  TeamModel.create({
    required this.user_id,
    required this.team_name,
    required this.team_address,
    required this.contact_number,
    required this.team_motto,
    required this.coach_name,
    this.assistant_coach_name,
    required this.team_logo_image,
  });

  get imageUrl => null;

  FormData toFormDataForCreation() {
    final formMap = {
      'user_id': user_id,
      'team_name': team_name,
      'team_address': team_address,
      'contact_number': contact_number,
      'team_motto': team_motto,
      'coach_name': coach_name,
      'assistant_coach_name': assistant_coach_name,
      'team_logo_image': team_logo_image,
    };

    return FormData.fromMap(formMap);
  }
}
