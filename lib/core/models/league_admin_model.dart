// ignore_for_file: non_constant_identifier_names

import 'package:bogoballers/core/models/user_model.dart';

abstract class LeagueAdmin {
  final String user_id;
  final String league_administrator_id;
  final String organization_name;
  final String organization_type;
  final String organization_address;
  final String organization_logo_url;

  LeagueAdmin({
    required this.user_id,
    required this.league_administrator_id,
    required this.organization_name,
    required this.organization_type,
    required this.organization_address,
    required this.organization_logo_url,
  });
}

class LeagueAdminModel extends LeagueAdmin {
  final String created_at;
  final String updated_at;
  final UserModel user;

  LeagueAdminModel({
    required super.user_id,
    required super.league_administrator_id,
    required super.organization_name,
    required super.organization_type,
    required super.organization_address,
    required super.organization_logo_url,
    required this.created_at,
    required this.updated_at,
    required this.user,
  });

  factory LeagueAdminModel.fromMap(Map<String, dynamic> map) {
    return LeagueAdminModel(
      user_id: map['user_id'] as String,
      league_administrator_id: map['league_administrator_id'] as String,
      organization_name: map['organization_name'] as String,
      organization_type: map['organization_type'] as String,
      organization_address: map['organization_address'] as String,
      organization_logo_url: map['organization_logo_url'] as String,
      created_at: map['created_at'] as String,
      updated_at: map['updated_at'] as String,
      user: UserModel.fromMap(map['user'] as Map<String, dynamic>),
    );
  }
}
