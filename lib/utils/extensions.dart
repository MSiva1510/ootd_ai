import 'package:intl/intl.dart';

/// String extensions
extension StringExtension on String {
  /// Check if string is email
  bool isEmail() {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// Check if string is empty or null
  bool get isEmpty => trim().isEmpty;

  /// Capitalize first letter
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  /// Check if string is numeric
  bool isNumeric() => double.tryParse(this) != null;

  /// Remove all spaces
  String removeSpaces() => replaceAll(' ', '');

  /// Truncate string
  String truncate(int length, {String suffix = '...'}) {
    if (this.length <= length) return this;
    return substring(0, length) + suffix;
  }
}

/// DateTime extensions
extension DateTimeExtension on DateTime {
  /// Get formatted date string
  String format(String pattern) {
    return DateFormat(pattern).format(this);
  }

  /// Get formatted date with locale
  String formatWithLocale(String pattern, String locale) {
    return DateFormat(pattern, locale).format(this);
  }

  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Check if date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Get human-readable date string
  String toHumanReadable() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (isToday) {
      return 'Today at ${format('h:mm a')}';
    } else if (isYesterday) {
      return 'Yesterday at ${format('h:mm a')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else {
      return format('MMM d, y');
    }
  }

  /// Get time until (for future dates)
  String getTimeUntil() {
    final now = DateTime.now();
    final difference = this.difference(now);

    if (difference.inSeconds < 0) return 'Overdue';
    if (difference.inSeconds < 60) return 'In ${difference.inSeconds}s';
    if (difference.inMinutes < 60) return 'In ${difference.inMinutes}m';
    if (difference.inHours < 24) return 'In ${difference.inHours}h';
    if (difference.inDays < 7) return 'In ${difference.inDays}d';
    if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'In $weeks week${weeks > 1 ? 's' : ''}';
    }
    return format('MMM d, y');
  }
}

/// List extensions
extension ListExtension<T> on List<T> {
  /// Check if list is empty or null
  bool get isNullOrEmpty => isEmpty;

  /// Get first element or null
  T? getFirstOrNull() => isEmpty ? null : first;

  /// Get last element or null
  T? getLastOrNull() => isEmpty ? null : last;

  /// Remove duplicates
  List<T> removeDuplicates() => toSet().toList();

  /// Chunk list into smaller lists
  List<List<T>> chunked(int size) {
    final chunks = <List<T>>[];
    for (int i = 0; i < length; i += size) {
      chunks.add(sublist(i, (i + size > length) ? length : i + size));
    }
    return chunks;
  }

  /// Map with index
  List<R> mapIndexed<R>(R Function(int index, T item) callback) {
    return asMap().entries.map((e) => callback(e.key, e.value)).toList();
  }
}

/// int extensions
extension IntExtension on int {
  /// Check if number is even
  bool get isEven => this % 2 == 0;

  /// Check if number is odd
  bool get isOdd => this % 2 != 0;

  /// Check if number is positive
  bool get isPositive => this > 0;

  /// Check if number is negative
  bool get isNegative => this < 0;

  /// Convert to duration
  Duration toDays() => Duration(days: this);

  Duration toHours() => Duration(hours: this);

  Duration toMinutes() => Duration(minutes: this);

  Duration toSeconds() => Duration(seconds: this);

  /// Format as currency
  String asCurrency({String symbol = '\$'}) => '$symbol${toStringAsFixed(2)}';
}

/// double extensions
extension DoubleExtension on double {
  /// Check if number is even
  bool get isEven => toInt().isEven;

  /// Check if number is positive
  bool get isPositive => this > 0;

  /// Check if number is negative
  bool get isNegative => this < 0;

  /// Round to n decimal places
  double roundToPrecision(int decimalPlaces) {
    final mod = 10.0 * decimalPlaces;
    return (this * mod).round() / mod;
  }

  /// Format as currency
  String asCurrency({String symbol = '\$'}) => '$symbol${toStringAsFixed(2)}';
}

/// Map extensions
extension MapExtension<K, V> on Map<K, V> {
  /// Check if map is empty or null
  bool get isNullOrEmpty => isEmpty;

  /// Add multiple entries
  void addAll(Map<K, V> other) => addAll(other);

  /// Get value or return default
  V? getOrDefault(K key, V defaultValue) => this[key] ?? defaultValue;

  /// Remove multiple keys
  void removeAll(List<K> keys) {
    for (var key in keys) {
      remove(key);
    }
  }
}

/// Duration extensions
extension DurationExtension on Duration {
  /// Get formatted time string
  String toFormattedString() {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);

    final parts = <String>[];
    if (hours > 0) parts.add('${hours}h');
    if (minutes > 0) parts.add('${minutes}m');
    if (seconds > 0) parts.add('${seconds}s');

    return parts.isEmpty ? '0s' : parts.join(' ');
  }

  /// Get hours
  int get hours => inHours;

  /// Get minutes
  int get minutes => inMinutes;

  /// Get seconds
  int get seconds => inSeconds;
}

/// Num extensions
extension NumExtension on num {
  /// Clamp value between min and max
  num clamp(num min, num max) {
    if (this < min) return min;
    if (this > max) return max;
    return this;
  }

  /// Percentage
  num percentage(num total) => (this / total) * 100;

  /// Is between
  bool isBetween(num min, num max) => this >= min && this <= max;
}
