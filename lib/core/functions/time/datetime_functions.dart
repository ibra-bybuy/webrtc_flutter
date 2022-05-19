import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DateFunctions {
  final DateTime passedDate;

  DateFunctions({required this.passedDate}) {
    initializeDateFormatting();
  }

  bool isThisYear() =>
      passedDate.toLocal().year == DateTime.now().toLocal().year;

  bool isThisMonth() =>
      passedDate.toLocal().month == DateTime.now().toLocal().month;

  bool isThisDay() => passedDate.toLocal().day == DateTime.now().toLocal().day;

  bool isDaysAgo(int days) =>
      passedDate.toLocal().day == DateTime.now().toLocal().day - days;

  bool isYesterday() => isThisYear() && isThisMonth() && isDaysAgo(1);

  bool isToday() => isThisYear() && isThisMonth() && isThisDay();

  String dayMonthYear() {
    DateFormat formatter = isThisYear()
        ? new DateFormat.MMMMd("ru_RU")
        : new DateFormat.yMMMMd("ru_RU");

    return formatter.format(passedDate);
  }

  String dayMonthYearHuman() {
    if (isToday()) return "Сегодня";
    if (isYesterday()) return "Вчера";

    return dayMonthYear();
  }

  String hourMinute() => DateFormat("HH:mm").format(passedDate.toLocal());

  String displayDate() {
    if (isToday())
      return hourMinute();
    else
      return dayMonthYear() + " " + hourMinute();
  }

  String displayTimeForTodayOrDate() {
    if (isToday())
      return hourMinute();
    else
      return dayMonthYear();
  }
}
