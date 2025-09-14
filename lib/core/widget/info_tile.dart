import 'package:bogoballers/core/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:bogoballers/core/theme/theme_extensions.dart';

class InfoTile extends StatelessWidget {
  final AppThemeColors colors;
  final IconData icon;
  final String label;
  final String? value;

  const InfoTile({
    super.key,
    required this.colors,
    required this.icon,
    required this.label,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.spaceMd,
        vertical: Sizes.spaceSm + Sizes.spaceXs,
      ),
      child: Row(
        children: [
          Icon(icon, size: Sizes.fontSizeXl, color: colors.textSecondary),
          const SizedBox(width: Sizes.spaceMd),
          Text(
            label,
            style: TextStyle(
              fontSize: Sizes.fontSizeSm,
              color: colors.textSecondary,
            ),
          ),
          const Spacer(),
          Text(
            value ?? 'N/A',
            style: TextStyle(
              fontSize: Sizes.fontSizeSm,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
