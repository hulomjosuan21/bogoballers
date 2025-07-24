import 'package:flutter/material.dart';

/// Base color definitions for light theme
class AppColors {
  static const color1 = Color(0xFFFEFCFB);
  static const color2 = Color(0xFFFFF5F0);
  static const color3 = Color(0xFFFFE9DE);
  static const color4 = Color(0xFFFFD7C4);
  static const color5 = Color(0xFFFFC9B1);
  static const color6 = Color(0xFFFFB99C);
  static const color7 = Color(0xFFFFA585);
  static const color8 = Color(0xFFF58C67);
  static const color9 = Color(0xFFF85C15);
  static const color10 = Color(0xFFEA4F00);
  static const color11 = Color(0xFFD74400);
  static const color12 = Color(0xFF592C1C);

  static const gray1 = Color(0xFFFCFCFD);
  static const gray2 = Color(0xFFF9F9FB);
  static const gray3 = Color(0xFFEFF0F3);
  static const gray4 = Color(0xFFE7E8EC);
  static const gray5 = Color(0xFFE0E1E6);
  static const gray6 = Color(0xFFD8D9E0);
  static const gray7 = Color(0xFFCDCED7);
  static const gray8 = Color(0xFFB9BBC6);
  static const gray9 = Color(0xFF8B8D98);
  static const gray10 = Color(0xFF80828D);
  static const gray11 = Color(0xFF62636C);
  static const gray12 = Color(0xFF1E1F24);

  static const contrast = Color(0xFFFFFFFF);
  static const surface = Color(0xFFF9F9FB);
  static const indicator = color9;
  static const track = color9;
  static const textPrimary = gray12;
  static const textSecondary = gray10;
  static const background = gray1;
}

/// Base color definitions for dark theme
class AppDarkColors {
  static const color1 = Color(0xFF160F0D);
  static const color2 = Color(0xFF1F1511);
  static const color3 = Color(0xFF371A10);
  static const color4 = Color(0xFF4D1905);
  static const color5 = Color(0xFF5C210A);
  static const color6 = Color(0xFF6C2E17);
  static const color7 = Color(0xFF843E25);
  static const color8 = Color(0xFFAB502F);
  static const color9 = Color(0xFFF85C15);
  static const color10 = Color(0xFFEA4F00);
  static const color11 = Color(0xFFFF9870);
  static const color12 = Color(0xFFFFD9CA);

  static const gray1 = Color(0xFF111113);
  static const gray2 = Color(0xFF19191B);
  static const gray3 = Color(0xFF222325);
  static const gray4 = Color(0xFF292A2E);
  static const gray5 = Color(0xFF303136);
  static const gray6 = Color(0xFF393A40);
  static const gray7 = Color(0xFF46484F);
  static const gray8 = Color(0xFF5F606A);
  static const gray9 = Color(0xFF6C6E79);
  static const gray10 = Color(0xFF797B86);
  static const gray11 = Color(0xFFB2B3BD);
  static const gray12 = Color(0xFFEEEFF0);

  static const contrast = Color(0xFFFFFFFF);
  static const surface = Color(0xFF19191B);
  static const indicator = color9;
  static const track = color9;
  static const textPrimary = gray12;
  static const textSecondary = gray9;
  static const background = gray1;
}

/// Abstract base for themed colors
abstract class AppColorsBase {
  Color get color1;
  Color get color2;
  Color get color3;
  Color get color4;
  Color get color5;
  Color get color6;
  Color get color7;
  Color get color8;
  Color get color9;
  Color get color10;
  Color get color11;
  Color get color12;

  Color get gray1;
  Color get gray2;
  Color get gray3;
  Color get gray4;
  Color get gray5;
  Color get gray6;
  Color get gray7;
  Color get gray8;
  Color get gray9;
  Color get gray10;
  Color get gray11;
  Color get gray12;

  Color get contrast;
  Color get surface;
  Color get track;
  Color get indicator;
  Color get textPrimary;
  Color get textSecondary;
  Color get background;
}

/// Concrete implementation for light theme
class AppLightColors implements AppColorsBase {
  const AppLightColors();

  @override Color get color1 => AppColors.color1;
  @override Color get color2 => AppColors.color2;
  @override Color get color3 => AppColors.color3;
  @override Color get color4 => AppColors.color4;
  @override Color get color5 => AppColors.color5;
  @override Color get color6 => AppColors.color6;
  @override Color get color7 => AppColors.color7;
  @override Color get color8 => AppColors.color8;
  @override Color get color9 => AppColors.color9;
  @override Color get color10 => AppColors.color10;
  @override Color get color11 => AppColors.color11;
  @override Color get color12 => AppColors.color12;

  @override Color get gray1 => AppColors.gray1;
  @override Color get gray2 => AppColors.gray2;
  @override Color get gray3 => AppColors.gray3;
  @override Color get gray4 => AppColors.gray4;
  @override Color get gray5 => AppColors.gray5;
  @override Color get gray6 => AppColors.gray6;
  @override Color get gray7 => AppColors.gray7;
  @override Color get gray8 => AppColors.gray8;
  @override Color get gray9 => AppColors.gray9;
  @override Color get gray10 => AppColors.gray10;
  @override Color get gray11 => AppColors.gray11;
  @override Color get gray12 => AppColors.gray12;

  @override Color get contrast => AppColors.contrast;
  @override Color get surface => AppColors.surface;
  @override Color get track => AppColors.track;
  @override Color get indicator => AppColors.indicator;
  @override Color get textPrimary => AppColors.textPrimary;
  @override Color get textSecondary => AppColors.textSecondary;
  @override Color get background => AppColors.background;
}

/// Concrete implementation for dark theme
class AppDarkThemeColors implements AppColorsBase {
  const AppDarkThemeColors();

  @override Color get color1 => AppDarkColors.color1;
  @override Color get color2 => AppDarkColors.color2;
  @override Color get color3 => AppDarkColors.color3;
  @override Color get color4 => AppDarkColors.color4;
  @override Color get color5 => AppDarkColors.color5;
  @override Color get color6 => AppDarkColors.color6;
  @override Color get color7 => AppDarkColors.color7;
  @override Color get color8 => AppDarkColors.color8;
  @override Color get color9 => AppDarkColors.color9;
  @override Color get color10 => AppDarkColors.color10;
  @override Color get color11 => AppDarkColors.color11;
  @override Color get color12 => AppDarkColors.color12;

  @override Color get gray1 => AppDarkColors.gray1;
  @override Color get gray2 => AppDarkColors.gray2;
  @override Color get gray3 => AppDarkColors.gray3;
  @override Color get gray4 => AppDarkColors.gray4;
  @override Color get gray5 => AppDarkColors.gray5;
  @override Color get gray6 => AppDarkColors.gray6;
  @override Color get gray7 => AppDarkColors.gray7;
  @override Color get gray8 => AppDarkColors.gray8;
  @override Color get gray9 => AppDarkColors.gray9;
  @override Color get gray10 => AppDarkColors.gray10;
  @override Color get gray11 => AppDarkColors.gray11;
  @override Color get gray12 => AppDarkColors.gray12;

  @override Color get contrast => AppDarkColors.contrast;
  @override Color get surface => AppDarkColors.surface;
  @override Color get track => AppDarkColors.track;
  @override Color get indicator => AppDarkColors.indicator;
  @override Color get textPrimary => AppDarkColors.textPrimary;
  @override Color get textSecondary => AppDarkColors.textSecondary;
  @override Color get background => AppDarkColors.background;
}

/// ThemeExtension class for theme access
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  final Color color1, color2, color3, color4, color5, color6,
      color7, color8, color9, color10, color11, color12;
  final Color gray1, gray2, gray3, gray4, gray5, gray6,
      gray7, gray8, gray9, gray10, gray11, gray12;
  final Color contrast, surface, track, indicator, textPrimary, textSecondary, background;

  const AppThemeColors({
    required this.color1,
    required this.color2,
    required this.color3,
    required this.color4,
    required this.color5,
    required this.color6,
    required this.color7,
    required this.color8,
    required this.color9,
    required this.color10,
    required this.color11,
    required this.color12,
    required this.gray1,
    required this.gray2,
    required this.gray3,
    required this.gray4,
    required this.gray5,
    required this.gray6,
    required this.gray7,
    required this.gray8,
    required this.gray9,
    required this.gray10,
    required this.gray11,
    required this.gray12,
    required this.contrast,
    required this.surface,
    required this.track,
    required this.indicator,
    required this.textPrimary,
    required this.textSecondary,
    required this.background,
  });

  factory AppThemeColors.fromAppColors(AppColorsBase c) {
    return AppThemeColors(
      color1: c.color1,
      color2: c.color2,
      color3: c.color3,
      color4: c.color4,
      color5: c.color5,
      color6: c.color6,
      color7: c.color7,
      color8: c.color8,
      color9: c.color9,
      color10: c.color10,
      color11: c.color11,
      color12: c.color12,
      gray1: c.gray1,
      gray2: c.gray2,
      gray3: c.gray3,
      gray4: c.gray4,
      gray5: c.gray5,
      gray6: c.gray6,
      gray7: c.gray7,
      gray8: c.gray8,
      gray9: c.gray9,
      gray10: c.gray10,
      gray11: c.gray11,
      gray12: c.gray12,
      contrast: c.contrast,
      surface: c.surface,
      track: c.track,
      indicator: c.indicator,
      textPrimary: c.textPrimary,
      textSecondary: c.textSecondary,
      background: c.background,
    );
  }

  @override
  AppThemeColors copyWith({Color? color1, Color? color2, /* ... all props ... */ Color? background}) {
    return this; // You can expand this if you need editable extension
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) return this;
    return this;
  }
}

/// BuildContext extension for convenient access
extension AppThemeColorsContextExtension on BuildContext {
  AppThemeColors get colors {
    final ext = Theme.of(this).extension<AppThemeColors>();
    assert(ext != null, 'Missing AppThemeColors in ThemeData');
    return ext!;
  }
}
