import 'package:flutter/material.dart';

enum NotificationType { exchange, referral, withdrawal, system, other }

class NotificationTypeHelper {
  /// Get notification type from notification title or content
  static NotificationType getTypeFromContent(String? title, String? content) {
    final titleLower = title?.toLowerCase() ?? '';
    final contentLower = content?.toLowerCase() ?? '';

    if (titleLower.contains('exchange') || contentLower.contains('exchange')) {
      return NotificationType.exchange;
    } else if (titleLower.contains('referral') ||
        contentLower.contains('referral')) {
      return NotificationType.referral;
    } else if (titleLower.contains('withdraw') ||
        contentLower.contains('withdraw')) {
      return NotificationType.withdrawal;
    } else if (titleLower.contains('system') ||
        contentLower.contains('system')) {
      return NotificationType.system;
    } else {
      return NotificationType.other;
    }
  }

  /// Get icon for notification type
  static IconData getIconForType(NotificationType type) {
    switch (type) {
      case NotificationType.exchange:
        return Icons.swap_horiz;
      case NotificationType.referral:
        return Icons.people;
      case NotificationType.withdrawal:
        return Icons.account_balance_wallet;
      case NotificationType.system:
        return Icons.info;
      case NotificationType.other:
        return Icons.notifications;
    }
  }

  /// Get color for notification type
  static Color getColorForType(NotificationType type) {
    switch (type) {
      case NotificationType.exchange:
        return Colors.blue;
      case NotificationType.referral:
        return Colors.green;
      case NotificationType.withdrawal:
        return Colors.orange;
      case NotificationType.system:
        return Colors.purple;
      case NotificationType.other:
        return Colors.grey;
    }
  }
}
