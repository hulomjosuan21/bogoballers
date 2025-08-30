// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';

abstract class User {
  final String user_id;
  final String email;
  final String contact_number;
  final String account_type;
  final bool is_verified;

  User({
    required this.user_id,
    required this.email,
    required this.contact_number,
    required this.account_type,
    required this.is_verified,
  });
}

class UserLogin {
  final String email;
  final String password;

  UserLogin({required this.email, required this.password});

  FormData toFormData() {
    return FormData.fromMap({'email': email, 'password': password});
  }
}

class UserModel extends User {
  final String created_at;
  final String updated_at;

  UserModel({
    required super.user_id,
    required super.email,
    required super.contact_number,
    required super.account_type,
    required super.is_verified,
    required this.created_at,
    required this.updated_at,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      user_id: map['user_id'] as String,
      email: map['email'] as String,
      contact_number: map['contact_number'] as String,
      account_type: map['account_type'] as String,
      is_verified: map['is_verified'] as bool,
      created_at: map['created_at'] as String,
      updated_at: map['updated_at'] as String,
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
    };
  }
}

class UserModelForTeam extends User {
  UserModelForTeam({
    required super.user_id,
    required super.email,
    required super.contact_number,
    required super.account_type,
    required super.is_verified,
  });

  factory UserModelForTeam.fromMap(Map<String, dynamic> map) {
    return UserModelForTeam(
      user_id: map['user_id'] as String,
      email: map['email'] as String,
      contact_number: map['contact_number'] as String,
      account_type: map['account_type'] as String,
      is_verified: map['is_verified'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'email': email,
      'contact_number': contact_number,
      'account_type': account_type,
      'is_verified': is_verified,
    };
  }
}
