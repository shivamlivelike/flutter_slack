import 'package:date_format/date_format.dart';

import '../main.dart';

extension RoutesExtensions on Routes {
  String get path {
    return "/${this.toString().split(".")[1]}";
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return this.year == other.year &&
        this.month == other.month &&
        this.day == other.day;
  }

  bool isYesterdayDateOf(DateTime other) {
    return this.year == other.year &&
        this.month == other.month &&
        this.day == other.day - 1;
  }

  String showDateOnly() {
    if (this.isSameDate(DateTime.now())) {
      return "Today";
    }
    if (this.isYesterdayDateOf(DateTime.now())) {
      return "Yesterday";
    }
    return formatDate(this, [DD, ',', MM, ' ', dd]);
  }
}
