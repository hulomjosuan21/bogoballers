import 'package:intl/intl.dart';

String scheduleDataFormat(String? scheduledDate) {
  if (scheduledDate != null && DateTime.tryParse(scheduledDate) != null) {
    return DateFormat(
      'MMM dd, yyyy hh:mm a',
    ).format(DateTime.parse(scheduledDate).toLocal());
  }

  return "Not yet Scheduled";
}
