import 'package:bogoballers/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

InputDecorationTheme appInputDecorationThemeFrom(AppThemeColors colors) {
  return InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: colors.gray8, width: 0.5),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: colors.gray8, width: 0.5),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: colors.gray5, width: 0.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: colors.color9, width: 0.5),
    ),
    labelStyle: TextStyle(color: colors.gray11, fontSize: 12),
    prefixIconColor: colors.gray6,
    focusColor: colors.color9,
    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    hintStyle: TextStyle(color: colors.gray6, fontSize: 12),
    errorStyle: TextStyle(fontSize: 8),
    helperStyle: TextStyle(fontSize: 8),
    isDense: true,
  );
}
