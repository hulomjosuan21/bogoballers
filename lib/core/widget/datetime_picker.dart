import 'package:bogoballers/core/theme/theme_extensions.dart' show AppThemeColors;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

ThemeData datePickerPopupTheme(BuildContext context) {
final colors = Theme.of(context).extension<AppThemeColors>()!;

  return ThemeData(
  dialogTheme: DialogThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
  datePickerTheme: DatePickerThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    headerBackgroundColor: colors.color9,
    headerForegroundColor: colors.gray1,
    todayBackgroundColor: WidgetStateProperty.all(colors.color9),
    todayForegroundColor: WidgetStateProperty.all(colors.gray1),
    surfaceTintColor: Colors.transparent,
  ),
  colorScheme: ColorScheme.light(
    primary: colors.color9,
    onPrimary: colors.gray1,
    onSurface: colors.gray11,
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: colors.color9),
  ),
);
}
class DateTimePickerField extends StatelessWidget {
  final DateTime? selectedDate;
  final String labelText;
  final String? helperText;
  final bool includeTime;
  final bool enabled;
  final void Function(DateTime)? onChanged;

  const DateTimePickerField({
    super.key,
    required this.selectedDate,
    this.labelText = 'Select date',
    this.helperText,
    this.includeTime = false,
    this.enabled = true,
    this.onChanged,
  });

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final format = includeTime ? 'yyyy-MM-dd HH:mm' : 'yyyy-MM-dd';
    return DateFormat(format).format(date);
  }

  @override
  Widget build(BuildContext context) {
    final displayText = _formatDate(selectedDate);
    final textColor = enabled
        ? Theme.of(context).textTheme.bodyLarge?.color
        : Theme.of(context).disabledColor;

    return InkWell(
      onTap: () async {
        if (!enabled) return;

        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(3000),
          builder: (BuildContext context, Widget? child) {
            return Theme(data: datePickerPopupTheme(context), child: child!);
          },
        );

        if (pickedDate != null && context.mounted) {
          if (includeTime) {
            final pickedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(
                selectedDate ?? DateTime.now(),
              ),
              builder: (BuildContext context, Widget? child) {
                return Theme(
                  data: datePickerPopupTheme(context),
                  child: child!,
                );
              },
            );

            if (pickedTime != null) {
              pickedDate = DateTime(
                pickedDate.year,
                pickedDate.month,
                pickedDate.day,
                pickedTime.hour,
                pickedTime.minute,
              );
            }
          }

          onChanged?.call(pickedDate);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          suffixIcon: const Icon(Icons.calendar_today),
          helperText: helperText,
          enabled: enabled,
        ),
        child: Text(
          displayText.isNotEmpty ? displayText : 'Select a date',
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }

  ThemeData datePickerPopupTheme(BuildContext context) {
    // You can customize this if needed
    return Theme.of(context);
  }
}
