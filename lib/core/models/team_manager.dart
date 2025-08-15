// ignore_for_file: non_constant_identifier_names

import 'package:bogoballers/core/models/user_model.dart';

class TeamManager extends User {
  final String display_name;

  TeamManager({
    required super.user_id,
    required super.email,
    required super.contact_number,
    required super.account_type,
    required super.is_verified,
    required super.created_at,
    required super.updated_at,
    required this.display_name,
  });

  factory TeamManager.fromMap(Map<String, dynamic> map) {
    return TeamManager(
      user_id: map['user_id'],
      email: map['email'],
      contact_number: map['contact_number'],
      account_type: map['account_type'],
      is_verified: map['is_verified'],
      created_at: map['created_at'],
      updated_at: map['updated_at'],
      display_name: map['display_name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'email': email,
      'contact_number': contact_number,
      'account_type': account_type,
      'is_verified': is_verified,
      'created_at': created_at,
      'updated_at': updated_at,
      'display_name': display_name,
    };
  }
}

class CreateTeamManager {
  final String email;
  final String password_str;
  final String contact_number;
  final String display_name;

  CreateTeamManager({
    required this.display_name,
    required this.email,
    required this.password_str,
    required this.contact_number,
  });

  Map<String, String> toFormData() {
    return {
      'email': email,
      'password_str': password_str,
      'contact_number': contact_number,
      'display_name': display_name,
    };
  }
}
