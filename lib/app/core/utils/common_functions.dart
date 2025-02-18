// import intl
import 'package:intl/intl.dart';

class CommonFunctions {
  static String formatDateTime(DateTime dateTime) {
    // if date time has time part, return it with time
    // date format is: December 15, 2025 08:00 AM
    if (dateTime.hour != 0 || dateTime.minute != 0) {
      return DateFormat.yMMMMd().add_jm().format(dateTime);
    }

    // if date time has no time part, return it without time
    // date format is: December 15, 2025
    return DateFormat.yMMMMd().format(dateTime);
  }

  static String formatUSD(double amount) {
    return NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
    ).format(amount);
  }
}
