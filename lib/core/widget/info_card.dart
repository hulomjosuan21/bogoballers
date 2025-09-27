import 'package:bogoballers/core/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:bogoballers/core/theme/theme_extensions.dart';

Widget buildInfoCard({
  required AppThemeColors colors,
  required String title,
  required IconData icon,
  required List<Widget> children,
}) {
  return Container(
    decoration: BoxDecoration(
      color: colors.surface,
      borderRadius: BorderRadius.circular(Sizes.radiusMd),
      border: Border.all(color: colors.gray5, width: Sizes.borderWidthSm),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            Sizes.spaceMd,
            Sizes.spaceSm,
            Sizes.spaceMd,
            Sizes.spaceSm,
          ),
          child: Row(
            children: [
              Icon(icon, size: Sizes.fontSizeLg, color: colors.textPrimary),
              const SizedBox(width: Sizes.spaceSm),
              Text(
                title,
                style: TextStyle(
                  fontSize: Sizes.fontSizeMd,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: Sizes.borderWidthSm,
          thickness: Sizes.borderWidthSm,
          color: colors.gray5,
        ),
        ...children,
      ],
    ),
  );
}
