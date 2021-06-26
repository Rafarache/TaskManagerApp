import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:taskmanager/Model/taskHelper.dart';
import 'package:taskmanager/Widgets/TaskCard.dart';

// ignore: must_be_immutable
class TableCalendarPage extends StatefulWidget {
  TaskHelper helper = TaskHelper();
  TableCalendarPage(this.helper);
  @override
  _TableCalendarPageState createState() => _TableCalendarPageState();
}

class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

class _TableCalendarPageState extends State<TableCalendarPage> {
  List<Task> data = [];
  DateTime _selectedDay = DateTime.now();
  List<Task> eventos = [];
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  DateTime _focusedDay = DateTime.now();

  String _lastUserId = null;
  String _lastPassword = null;
  Map<DateTime, Map<String, String>> _bookings = {
    DateTime.utc(2021, 6, 27): {"aaa": "AAA"},
    DateTime.utc(2021, 6, 29): {"aaa": "AAA"},
    DateTime.utc(2021, 6, 29): {"aaa": "AAA"},
    DateTime.utc(2021, 6, 30): {"aaa": "AAA"},
    DateTime.utc(2021, 7, 14): {"aaa": "AAA"},
    DateTime.utc(2021, 7, 5): {"aaa": "AAA"},
  };
  List<DateTime> dias = [];

  @override
  Widget build(BuildContext context) {
    print(dias);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TableCalendar(
                locale: 'pt,BR',
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 10, 16),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                calendarStyle: CalendarStyle(
                  markerDecoration: BoxDecoration(
                    color: Colors.pink,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration:
                      BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                  weekendTextStyle: TextStyle(color: Colors.red),
                  todayDecoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                eventLoader: (day) {
                  var test = [];
                  var test1 = [];
                  test =
                      dias.where((element) => isSameDay(day, element)).toList();
                  for (var i = 0; i < test.length; i++) {
                    test1.add(1);
                  }
                  return test1;
                  /*   if (dias.where((element) => isSameDay(day, element)).length >
                      0) {
                    return [1];
                  } else
                    return []; */
                },
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    // Call `setState()` when updating calendar format
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                      filterTask(selectedDay, data);
                    });
                  }
                },
              ),
              Divider(endIndent: 10),
              eventos.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 20.0, bottom: 20),
                      child: Text(
                        "Tarefas de ${DateFormat("d 'de' MMMM 'de' y", "pt").format(_selectedDay)}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                        left: 20,
                      ),
                      child: Text(
                        "Não há nehuma tarefa para ${DateFormat("d 'de' MMMM", "pt").format(_selectedDay)}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
              TaskCard(widget.helper, eventos, _getAllTasks, null, null),
            ],
          ),
        ),
      ),
    );
  }

  void _getAllTasks() {
    DateFormat formatter = DateFormat("d MM y");
    widget.helper.getAllTasks().then((list) {
      setState(() {
        data = list;
        dias = data.map((element) => formatter.parse(element.due)).toList();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _getAllTasks();
    });
    data.removeRange(0, data.length);
    setState(() {
      filterTask(DateTime.now(), data);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isSameDay1(DateTime selectedDay, Task task) {
    DateFormat formatter = DateFormat("d MM y");
    var date = formatter.parse(task.due);
    var date1 = DateFormat("d MM y").format(date);
    var sel = DateFormat("d MM y").format(selectedDay);
    return date1 == sel;
  }

  void filterTask(DateTime selectedDay, List<Task> task) {
    eventos = task.where((i) => isSameDay1(selectedDay, i)).toList();
  }

  List<int> bookingsOnDay(DateTime day) {
    Map<String, String> b = _bookings[day];
    if (b == null) return [];
    if (_lastUserId != null) {
      var pw = b[_lastUserId];
      if (pw != null && pw == _lastPassword) {
        return [b.length, 1];
      }
    }
    return [b.length];
  }
}
