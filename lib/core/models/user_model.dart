// ignore_for_file: non_constant_identifier_names
import 'package:bogoballers/core/enums/user_enum.dart';
import 'package:dio/dio.dart';

class UserFromToken {
  final String user_id;
  final String account_type;

  UserFromToken({required this.user_id, required this.account_type});
}

class UserModel {
  late String user_id;
  String email;
  late String contact_number;
  String? password_str;
  late AccountTypeEnum account_type;
  bool? is_verified;
  late DateTime created_at;
  late DateTime updated_at;

  UserModel({
    required this.user_id,
    required this.email,
    required this.contact_number,
    required this.account_type,
    required this.is_verified,
    required this.created_at,
    required this.updated_at,
  });

  UserModel.create({
    required this.email,
    required this.contact_number,
    required this.password_str,
  });

  UserModel.login({required this.email, required this.password_str});

  FormData toFormDataForLogin() {
    final formMap = {'email': email, 'password_str': password_str};
    return FormData.fromMap(formMap);
  }

  Map<String, dynamic> toJsonForCreation() {
    return {
      'email': email,
      'password_str': password_str,
      'contact_number': contact_number,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      user_id: json['user_id'],
      email: json['email'],
      contact_number: json['contact_number'],
      account_type: AccountTypeEnum.fromValue(json['account_type'])!,
      is_verified: json['is_verified'],
      created_at: DateTime.parse(json['created_at']),
      updated_at: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
      'email': email,
      'contact_number': contact_number,
      'account_type': account_type.value,
      'created_at': created_at.toIso8601String(),
      'updated_at': updated_at.toIso8601String(),
    };
  }
}
