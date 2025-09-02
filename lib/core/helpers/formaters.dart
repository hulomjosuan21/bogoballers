import 'package:intl/intl.dart';

class Formater {
  static String formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat("MMM d, y").format(date);
    } catch (_) {
      return dateStr;
    }
  }

  static String formatDateTime(String dateTimeStr) {
    try {
      final date = DateTime.parse(dateTimeStr);
      return DateFormat("MMM d, y • h:mm a").format(date);
    } catch (_) {
      return dateTimeStr;
    }
  }
}
