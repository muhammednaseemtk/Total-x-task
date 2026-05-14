extension StringExtensions on String {
  String get capitalize {
    if (trim().isEmpty) return this;

    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String get capitalizeWords {
    if (trim().isEmpty) return this;

    return split(' ')
        .where((word) => word.trim().isNotEmpty)
        .map((word) => word.capitalize)
        .join(' ');
  }

  bool get isValidPhone {
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{10,}$');

    return phoneRegex.hasMatch(trim());
  }

  String get orEmpty => trim();
}

extension DateTimeExtensions on DateTime {
  String get formattedDate {
    final formattedDay = day.toString().padLeft(2, '0');
    final formattedMonth = month.toString().padLeft(2, '0');

    return '$formattedDay/$formattedMonth/$year';
  }

  String get formattedTime {
    final formattedHour = hour.toString().padLeft(2, '0');
    final formattedMinute = minute.toString().padLeft(2, '0');

    return '$formattedHour:$formattedMinute';
  }

  String get formattedDateTime {
    return '$formattedDate $formattedTime';
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays >= 365) {
      return '${(difference.inDays / 365).floor()} year(s) ago';
    }

    if (difference.inDays >= 30) {
      return '${(difference.inDays / 30).floor()} month(s) ago';
    }

    if (difference.inDays > 0) {
      return '${difference.inDays} day(s) ago';
    }

    if (difference.inHours > 0) {
      return '${difference.inHours} hour(s) ago';
    }

    if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute(s) ago';
    }

    if (difference.inSeconds > 0) {
      return '${difference.inSeconds} second(s) ago';
    }

    return 'Just now';
  }
}

extension IntExtensions on int {
  bool get isEvenNumber => this % 2 == 0;

  bool get isOddNumber => this % 2 != 0;

  bool get isAbove25 => this > 25;

  bool get isBelowOrEqual25 => this <= 25;
}
