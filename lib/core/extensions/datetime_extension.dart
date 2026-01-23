import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  // Format methods
  String format([String pattern = 'dd/MM/yyyy']) {
    return DateFormat(pattern).format(this);
  }

  String get fullDate => DateFormat('EEEE, dd MMMM yyyy').format(this);
  String get shortDate => DateFormat('dd MMM yyyy').format(this);
  String get mediumDate => DateFormat('dd MMMM yyyy').format(this);
  String get timeOnly => DateFormat('HH:mm').format(this);
  String get dateTime => DateFormat('dd MMM yyyy, HH:mm').format(this);
  String get monthYear => DateFormat('MMMM yyyy').format(this);
  String get dayMonth => DateFormat('dd MMM').format(this);

  // Comparisons
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }

  bool isSameYear(DateTime other) {
    return year == other.year;
  }

  bool get isToday {
    final now = DateTime.now();
    return isSameDay(now);
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(yesterday);
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return isSameDay(tomorrow);
  }

  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return isAfter(startOfWeek) && isBefore(endOfWeek);
  }

  bool get isThisMonth {
    final now = DateTime.now();
    return isSameMonth(now);
  }

  bool get isThisYear {
    final now = DateTime.now();
    return isSameYear(now);
  }

  bool get isPast => isBefore(DateTime.now());
  bool get isFuture => isAfter(DateTime.now());

  // Date manipulations
  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  DateTime get startOfWeek {
    return subtract(Duration(days: weekday - 1));
  }

  DateTime get endOfWeek {
    return startOfWeek.add(
      const Duration(days: 6, hours: 23, minutes: 59, seconds: 59),
    );
  }

  DateTime get startOfMonth => DateTime(year, month, 1);

  DateTime get endOfMonth {
    final nextMonth = month == 12
        ? DateTime(year + 1, 1, 1)
        : DateTime(year, month + 1, 1);
    return nextMonth.subtract(
      const Duration(
        days: 1,
        hours: 0,
        minutes: 0,
        seconds: 0,
        milliseconds: 1,
      ),
    );
  }

  DateTime get startOfYear => DateTime(year, 1, 1);
  DateTime get endOfYear => DateTime(year, 12, 31, 23, 59, 59);

  DateTime addDays(int days) => add(Duration(days: days));
  DateTime subtractDays(int days) => subtract(Duration(days: days));

  DateTime addMonths(int months) {
    int newYear = year;
    int newMonth = month + months;

    while (newMonth > 12) {
      newMonth -= 12;
      newYear++;
    }

    while (newMonth < 1) {
      newMonth += 12;
      newYear--;
    }

    return DateTime(
      newYear,
      newMonth,
      day,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    );
  }

  DateTime subtractMonths(int months) => addMonths(-months);

  DateTime addYears(int years) => DateTime(
    year + years,
    month,
    day,
    hour,
    minute,
    second,
    millisecond,
    microsecond,
  );
  DateTime subtractYears(int years) => addYears(-years);

  // Relative time
  String get relativeTime {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
      }
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years year${years == 1 ? '' : 's'} ago';
    }
  }

  String get relativeTimeFuture {
    final now = DateTime.now();
    final difference = this.difference(now);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Now';
        }
        return 'In ${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'}';
      }
      return 'In ${difference.inHours} hour${difference.inHours == 1 ? '' : 's'}';
    } else if (difference.inDays == 1) {
      return 'Tomorrow';
    } else if (difference.inDays < 7) {
      return 'In ${difference.inDays} day${difference.inDays == 1 ? '' : 's'}';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'In $weeks week${weeks == 1 ? '' : 's'}';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'In $months month${months == 1 ? '' : 's'}';
    } else {
      final years = (difference.inDays / 365).floor();
      return 'In $years year${years == 1 ? '' : 's'}';
    }
  }

  // Age calculation
  int get age {
    final now = DateTime.now();
    int age = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }
    return age;
  }

  // Days in month
  int get daysInMonth {
    final nextMonth = month == 12
        ? DateTime(year + 1, 1, 1)
        : DateTime(year, month + 1, 1);
    return nextMonth.subtract(const Duration(days: 1)).day;
  }

  // Week of year
  int get weekOfYear {
    final startOfYear = DateTime(year, 1, 1);
    final difference = this.difference(startOfYear);
    return (difference.inDays / 7).ceil();
  }

  // Quarter
  int get quarter => ((month - 1) / 3).floor() + 1;

  // Copy with
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }

  // To local/UTC
  DateTime get toLocalDate => toLocal();
  DateTime get toUtcDate => toUtc();
}
