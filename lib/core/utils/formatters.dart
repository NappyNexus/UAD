import 'package:intl/intl.dart';

/// Utility formatters for currency, dates, and numbers.
class Formatters {
  Formatters._();

  /// Dominican Peso formatted currency (e.g., "RD$45,000.00").
  static String currency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'es_DO',
      symbol: 'RD\$',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  /// Currency without decimals (e.g., "RD$45,000").
  static String currencyShort(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'es_DO',
      symbol: 'RD\$',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  /// Compact currency for large numbers (e.g., "RD$45.2M").
  static String currencyCompact(double amount) {
    if (amount >= 1000000) {
      return 'RD\$${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return 'RD\$${(amount / 1000).toStringAsFixed(0)}K';
    }
    return currencyShort(amount);
  }

  /// Format a date string (ISO or similar) to "15 Oct 2024".
  static String dateShort(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('d MMM yyyy', 'es_DO').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  /// Format to "15/10/2024".
  static String dateNumeric(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  /// Format to "Octubre 15, 2024".
  static String dateLong(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMMM d, yyyy', 'es_DO').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  /// Time ago relative text (e.g., "Hace 5 min", "Hace 2 horas").
  static String timeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'Ahora';
    if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
    if (diff.inHours < 24) {
      final hours = diff.inHours;
      return 'Hace $hours hora${hours > 1 ? "s" : ""}';
    }
    final days = diff.inDays;
    if (days < 7) return 'Hace $days día${days > 1 ? "s" : ""}';
    if (days < 30)
      return 'Hace ${(days / 7).floor()} semana${(days / 7).floor() > 1 ? "s" : ""}';
    return DateFormat('d MMM yyyy', 'es_DO').format(dateTime);
  }

  /// Format GPA to 2 decimal places.
  static String gpa(double value) => value.toStringAsFixed(2);

  /// Format a number with thousands separators.
  static String number(num value) {
    return NumberFormat('#,##0', 'es_DO').format(value);
  }

  /// Format a percentage (e.g., "87.3%").
  static String percentage(double value) => '${value.toStringAsFixed(1)}%';
}
