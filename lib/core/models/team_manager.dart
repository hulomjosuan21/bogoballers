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
