import 'package:intl/intl.dart';

class Formatters {
  static final NumberFormat currencyFormatter = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
  );

  static final NumberFormat compactCurrencyFormatter =
      NumberFormat.compactCurrency(symbol: '\$', decimalDigits: 1);

  static final DateFormat dateFormatter = DateFormat('MMM dd, yyyy');
  static final DateFormat shortDateFormatter = DateFormat('MMM dd');
  static final DateFormat monthYearFormatter = DateFormat('MMMM yyyy');
  static final DateFormat timeFormatter = DateFormat('HH:mm');

  // Format currency
  static String formatCurrency(double amount) {
    return currencyFormatter.format(amount);
  }

  // Format compact currency (e.g., $1.2K, $1.5M)
  static String formatCompactCurrency(double amount) {
    return compactCurrencyFormatter.format(amount);
  }

  // Format date
  static String formatDate(DateTime date) {
    return dateFormatter.format(date);
  }

  // Format short date
  static String formatShortDate(DateTime date) {
    return shortDateFormatter.format(date);
  }

  // Format month and year
  static String formatMonthYear(DateTime date) {
    return monthYearFormatter.format(date);
  }

  // Format time
  static String formatTime(DateTime date) {
    return timeFormatter.format(date);
  }

  // Format percentage
  static String formatPercentage(double value) {
    return '${value.toStringAsFixed(1)}%';
  }

  // Format number with commas
  static String formatNumber(double number) {
    return NumberFormat('#,##0').format(number);
  }

  // Format decimal number
  static String formatDecimal(double number, {int decimalPlaces = 2}) {
    return NumberFormat('#,##0.${'0' * decimalPlaces}').format(number);
  }

  // Get relative time (e.g., "2 hours ago", "3 days ago")
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  // Format file size
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  // Format phone number
  static String formatPhoneNumber(String phone) {
    if (phone.length == 10) {
      return '(${phone.substring(0, 3)}) ${phone.substring(3, 6)}-${phone.substring(6)}';
    }
    return phone;
  }

  // Capitalize first letter
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  // Truncate text with ellipsis
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  // Format duration
  static String formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return '${duration.inSeconds}s';
    }
  }
}
