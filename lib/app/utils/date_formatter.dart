import 'package:intl/intl.dart';

class DateFormatter {
  /// Formats a date to a relative time string (e.g., "Just now", "2 hours ago", "3 days ago")
  static String getTimeAgo(DateTime? dateTime) {
    if (dateTime == null) {
      return 'Unknown time';
    }

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year(s) ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month(s) ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day(s) ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour(s) ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute(s) ago';
    } else {
      return 'Just now';
    }
  }

  /// Parses a date string using a specified format
  static DateTime? parseDate(
    String? dateString, {
    String format = "dd/MM/yyyy HH:mm:ss",
  }) {
    if (dateString == null || dateString.isEmpty) {
      return null;
    }

    try {
      return DateFormat(format).parse(dateString);
    } catch (e) {
      print("Error parsing date: $e");
      return null;
    }
  }

  /// Formats a date to a simple time format (e.g., "08:58 PM")
  static String formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('hh:mm a').format(dateTime);
  }

  /// Groups notifications by date category (Today, Yesterday, This Week, This Month, Earlier)
  static String getDateCategory(DateTime? dateTime) {
    if (dateTime == null) return 'Unknown';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (dateOnly.isAtSameMomentAs(today)) {
      return 'Today';
    } else if (dateOnly.isAtSameMomentAs(yesterday)) {
      return 'Yesterday';
    } else if (dateOnly.isAfter(today.subtract(const Duration(days: 7)))) {
      return 'This Week';
    } else if (dateOnly.month == today.month && dateOnly.year == today.year) {
      return 'This Month';
    } else {
      return 'Earlier';
    }
  }
}
