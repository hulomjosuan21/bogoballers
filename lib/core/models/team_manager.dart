// ignore_for_file: non_constant_identifier_names

import 'package:bogoballers/core/models/user_model.dart';

class TeamManagerModel extends User {
  final String display_name;

  TeamManagerModel({
    required super.user_id,
    required super.email,
    required super.contact_number,
    required super.account_type,
    required super.is_verified,
    required super.created_at,
    required super.updated_at,
    required this.display_name,
  });

  factory TeamManagerModel.fromMap(Map<String, dynamic> map) {
    return TeamManagerModel(
      user_id: map['user_id'] as String,
      email: map['email'] as String,
      contact_number: map['contact_number'] as String,
      account_type: map['account_type'] as String,
      is_verified: map['is_verified'] as bool,
      created_at: map['created_at'] as String,
      updated_at: map['updated_at'] as String,
      display_name: map['display_name'] as String,
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
