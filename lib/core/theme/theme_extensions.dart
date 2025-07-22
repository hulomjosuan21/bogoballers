// theme_extensions.dart
import 'package:bogoballers/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

@immutable
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  // Red Shades
  final Color color1;
  final Color color2;
  final Color color3;
  final Color color4;
  final Color color5;
  final Color color6;
  final Color color7;
  final Color color8;
  final Color color9;
  final Color color10;
  final Color color11;
  final Color color12;

  // Gray Shades
  final Color gray1;
  final Color gray2;
  final Color gray3;
  final Color gray4;
  final Color gray5;
  final Color gray6;
  final Color gray7;
  final Color gray8;
  final Color gray9;
  final Color gray10;
  final Color gray11;
  final Color gray12;

  // Common Roles
  final Color contrast;
  final Color surface;
  final Color indicator;
  final Color track;

  // Text Roles
  final Color textPrimary;
  final Color textSecondary;
  final Color background;

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
    required this.indicator,
    required this.track,
    required this.textPrimary,
    required this.textSecondary,
    required this.background,
  });

  @override
  AppThemeColors copyWith({
    Color? color1,
    Color? color2,
    Color? color3,
    Color? color4,
    Color? color5,
    Color? color6,
    Color? color7,
    Color? color8,
    Color? color9,
    Color? color10,
    Color? color11,
    Color? color12,
    Color? gray1,
    Color? gray2,
    Color? gray3,
    Color? gray4,
    Color? gray5,
    Color? gray6,
    Color? gray7,
    Color? gray8,
    Color? gray9,
    Color? gray10,
    Color? gray11,
    Color? gray12,
    Color? contrast,
    Color? surface,
    Color? indicator,
    Color? track,
    Color? textPrimary,
    Color? textSecondary,
    Color? background,
  }) {
    return AppThemeColors(
      color1: color1 ?? this.color1,
      color2: color2 ?? this.color2,
      color3: color3 ?? this.color3,
      color4: color4 ?? this.color4,
      color5: color5 ?? this.color5,
      color6: color6 ?? this.color6,
      color7: color7 ?? this.color7,
      color8: color8 ?? this.color8,
      color9: color9 ?? this.color9,
      color10: color10 ?? this.color10,
      color11: color11 ?? this.color11,
      color12: color12 ?? this.color12,
      gray1: gray1 ?? this.gray1,
      gray2: gray2 ?? this.gray2,
      gray3: gray3 ?? this.gray3,
      gray4: gray4 ?? this.gray4,
      gray5: gray5 ?? this.gray5,
      gray6: gray6 ?? this.gray6,
      gray7: gray7 ?? this.gray7,
      gray8: gray8 ?? this.gray8,
      gray9: gray9 ?? this.gray9,
      gray10: gray10 ?? this.gray10,
      gray11: gray11 ?? this.gray11,
      gray12: gray12 ?? this.gray12,
      contrast: contrast ?? this.contrast,
      surface: surface ?? this.surface,
      indicator: indicator ?? this.indicator,
      track: track ?? this.track,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      background: background ?? this.background,
    );
  }

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
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) return this;
    return AppThemeColors(
      color1: Color.lerp(color1, other.color1, t)!,
      color2: Color.lerp(color2, other.color2, t)!,
      color3: Color.lerp(color3, other.color3, t)!,
      color4: Color.lerp(color4, other.color4, t)!,
      color5: Color.lerp(color5, other.color5, t)!,
      color6: Color.lerp(color6, other.color6, t)!,
      color7: Color.lerp(color7, other.color7, t)!,
      color8: Color.lerp(color8, other.color8, t)!,
      color9: Color.lerp(color9, other.color9, t)!,
      color10: Color.lerp(color10, other.color10, t)!,
      color11: Color.lerp(color11, other.color11, t)!,
      color12: Color.lerp(color12, other.color12, t)!,
      gray1: Color.lerp(gray1, other.gray1, t)!,
      gray2: Color.lerp(gray2, other.gray2, t)!,
      gray3: Color.lerp(gray3, other.gray3, t)!,
      gray4: Color.lerp(gray4, other.gray4, t)!,
      gray5: Color.lerp(gray5, other.gray5, t)!,
      gray6: Color.lerp(gray6, other.gray6, t)!,
      gray7: Color.lerp(gray7, other.gray7, t)!,
      gray8: Color.lerp(gray8, other.gray8, t)!,
      gray9: Color.lerp(gray9, other.gray9, t)!,
      gray10: Color.lerp(gray10, other.gray10, t)!,
      gray11: Color.lerp(gray11, other.gray11, t)!,
      gray12: Color.lerp(gray12, other.gray12, t)!,
      contrast: Color.lerp(contrast, other.contrast, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      indicator: Color.lerp(indicator, other.indicator, t)!,
      track: Color.lerp(track, other.track, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      background: Color.lerp(background, other.background, t)!,
    );
  }
}