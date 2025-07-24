import 'package:bogoballers/core/theme/input_theme.dart';
import 'package:bogoballers/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart' hide AppThemeColors;

TextTheme _interTextTheme(TextTheme base) {
  return base.copyWith(
    displayLarge: base.displayLarge?.copyWith(fontFamily: 'Inter'),
    displayMedium: base.displayMedium?.copyWith(fontFamily: 'Inter'),
    displaySmall: base.displaySmall?.copyWith(fontFamily: 'Inter'),
    headlineLarge: base.headlineLarge?.copyWith(fontFamily: 'Inter'),
    headlineMedium: base.headlineMedium?.copyWith(fontFamily: 'Inter'),
    headlineSmall: base.headlineSmall?.copyWith(fontFamily: 'Inter'),
    titleLarge: base.titleLarge?.copyWith(fontFamily: 'Inter'),
    titleMedium: base.titleMedium?.copyWith(fontFamily: 'Inter'),
    titleSmall: base.titleSmall?.copyWith(fontFamily: 'Inter'),
    bodyLarge: base.bodyLarge?.copyWith(fontFamily: 'Inter'),
    bodyMedium: base.bodyMedium?.copyWith(fontFamily: 'Inter'),
    bodySmall: base.bodySmall?.copyWith(fontFamily: 'Inter'),
    labelLarge: base.labelLarge?.copyWith(fontFamily: 'Inter'),
    labelMedium: base.labelMedium?.copyWith(fontFamily: 'Inter'),
    labelSmall: base.labelSmall?.copyWith(fontFamily: 'Inter'),
  );
}

ThemeData get lightTheme {
  return ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.color9,
    fontFamily: 'Inter',
    colorScheme: ColorScheme.light(
      primary: AppColors.color9,
      onPrimary: AppColors.contrast,
      secondary: AppColors.color7,
      onSecondary: AppColors.contrast,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      error: AppColors.color11,
      onError: AppColors.contrast,
    ),
    textTheme: _interTextTheme(ThemeData.light().textTheme),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.textPrimary,
      iconTheme: IconThemeData(color: AppColors.color9),
      titleTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        fontFamily: 'Inter',
      ),
      elevation: 0,
    ),
    inputDecorationTheme: appInputDecorationThemeFrom(
      AppThemeColors.fromAppColors(const AppLightColors()),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.color9,
        foregroundColor: AppColors.contrast,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.indicator,
    ),
    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.all(AppColors.track.withAlpha(30)),
      thumbColor: WidgetStateProperty.all(AppColors.color9),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.gray2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    extensions: <ThemeExtension<dynamic>>[
      AppThemeColors.fromAppColors(const AppLightColors()),
    ],
  );
}

ThemeData get darkTheme {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppDarkColors.background,
    primaryColor: AppDarkColors.color9,
    fontFamily: 'Inter',
    colorScheme: ColorScheme.dark(
      primary: AppDarkColors.color9,
      onPrimary: AppDarkColors.contrast,
      secondary: AppDarkColors.color7,
      onSecondary: AppDarkColors.contrast,
      surface: AppDarkColors.surface,
      onSurface: AppDarkColors.textPrimary,
      error: AppDarkColors.color10,
      onError: AppDarkColors.contrast,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppDarkColors.gray2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    textTheme: _interTextTheme(ThemeData.dark().textTheme),
    appBarTheme: AppBarTheme(
      backgroundColor: AppDarkColors.background,
      foregroundColor: AppDarkColors.textPrimary,
      iconTheme: IconThemeData(color: AppColors.color9),
      titleTextStyle: TextStyle(
        color: AppDarkColors.textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        fontFamily: 'Inter',
      ),
      elevation: 0,
    ),
    inputDecorationTheme: appInputDecorationThemeFrom(
      AppThemeColors.fromAppColors(const AppDarkThemeColors()),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppDarkColors.color9,
        foregroundColor: AppDarkColors.contrast,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppDarkColors.indicator,
    ),
    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.all(AppDarkColors.track.withAlpha(30)),
      thumbColor: WidgetStateProperty.all(AppDarkColors.color9),
    ),
    extensions: <ThemeExtension<dynamic>>[
      AppThemeColors.fromAppColors(const AppDarkThemeColors()),
    ],
  );
}
