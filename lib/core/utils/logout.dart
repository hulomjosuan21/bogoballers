import 'package:flutter/material.dart';

Future<void> handleLogout(BuildContext context) async {
  Navigator.pushReplacementNamed(context, '/auth/login/screen');
}