import 'package:bogoballers/core/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:bogoballers/core/theme/theme_extensions.dart';

class InfoListTile extends StatelessWidget {
  final AppThemeColors colors;
  final IconData icon;
  final String label;
  final List<String>? values;

  const InfoListTile({
    super.key,
    required this.colors,
    required this.icon,
    required this.label,
    this.values,
  });

  @override
  Widget build(BuildContext context) {
    // Check if the list of values is null or empty
    final bool hasValues = values != null && values!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.spaceMd,
        vertical: Sizes.spaceSm + Sizes.spaceXs,
      ),
      child: Row(
        // Use CrossAxisAlignment.start to align the icon/label with the top
        // of the list of values on the right.
        crossAxisAlignment: CrossAxisAlignment.start,
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
          // The Column widget is used to stack the values vertically.
          Column(
            // Use CrossAxisAlignment.end to right-align the text.
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (hasValues)
                // If we have values, map each string to a Text widget.
                ...values!.map((value) {
                  return Padding(
                    // Add a little space between each item in the list
                    padding: const EdgeInsets.only(bottom: Sizes.spaceXs),
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: Sizes.fontSizeSm,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                  );
                }).toList()
              else
                // If the list is null or empty, display 'N/A'
                Text(
                  'N/A',
                  style: TextStyle(
                    fontSize: Sizes.fontSizeSm,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class InfoListTileCompact extends StatelessWidget {
  final AppThemeColors colors;
  final IconData icon;
  final String label;
  final List<String>? values;

  const InfoListTileCompact({
    super.key,
    required this.colors,
    required this.icon,
    required this.label,
    this.values,
  });

  @override
  Widget build(BuildContext context) {
    final hasValues = values != null && values!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.spaceMd,
        vertical: Sizes.spaceXs,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: Sizes.fontSizeXl, color: colors.textSecondary),
          const SizedBox(width: Sizes.spaceMd),

          // 🔥 LABEL + VALUES stacked
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label
                Text(
                  label,
                  style: TextStyle(
                    fontSize: Sizes.fontSizeSm,
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: Sizes.spaceXs),

                // Values
                if (hasValues)
                  ...values!.map(
                    (value) => Padding(
                      padding: const EdgeInsets.only(bottom: Sizes.spaceXs),
                      child: Text(
                        value,
                        style: TextStyle(
                          fontSize: Sizes.fontSizeSm,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                  )
                else
                  Text(
                    'N/A',
                    style: TextStyle(
                      fontSize: Sizes.fontSizeSm,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
