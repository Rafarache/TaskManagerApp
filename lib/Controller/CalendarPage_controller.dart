import 'package:intl/intl.dart';

import '../Model/taskHelper.dart';

bool isSameWeek(DateTime a, DateTime b) {
  /// Handle Daylight Savings by setting hour to 12:00 Noon
  /// rather than the default of Midnight
  a = DateTime.utc(a.year, a.month, a.day);
  b = DateTime.utc(b.year, b.month, b.day);

  var diff = a.toUtc().difference(b.toUtc()).inDays;
  if (diff.abs() >= 7) {
    return false;
  }

  var min = a.isBefore(b) ? a : b;
  var max = a.isBefore(b) ? b : a;
  var result = max.weekday % 7 - min.weekday % 7 >= 0;
  return result;
}

bool isSameDay1(DateTime selectedDay, Task task) {
  DateFormat formatter = DateFormat("d MM y");
  var date = formatter.parse(task.day);
  var date1 = DateFormat("d MM y").format(date);
  var sel = DateFormat("d MM y").format(selectedDay);
  return date1 == sel;
}

List<Task> filterTask(DateTime selectedDay, List<Task> task) {
  return task.where((i) => isSameDay1(selectedDay, i)).toList();
}
