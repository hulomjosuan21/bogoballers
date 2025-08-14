// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';

abstract class User {
  final String user_id;
  final String email;
  final String contact_number;
  final String account_type;
  final bool is_verified;
  final String created_at;
  final String updated_at;

  User({
    required this.user_id,
    required this.email,
    required this.contact_number,
    required this.account_type,
    required this.is_verified,
    required this.created_at,
    required this.updated_at,
  });
}

class UserModel extends User {
  UserModel({
    required super.user_id,
    required super.email,
    required super.contact_number,
    required super.account_type,
    required super.is_verified,
    required super.created_at,
    required super.updated_at,
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

class CreateUser {
  final String email;
  final String password_str;
  final String contact_number;

  CreateUser({
    required this.email,
    required this.password_str,
    required this.contact_number,
  });

  FormData toFormData() {
    return FormData.fromMap({
      'email': email,
      'password_str': password_str,
      'contact_number': contact_number,
    });
  }
}
