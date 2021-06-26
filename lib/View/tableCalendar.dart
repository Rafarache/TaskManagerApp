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
  List<DateTime> eventsDays = [];

  @override
  Widget build(BuildContext context) {
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
                  //Filtra todas os eventos do mesmo dia que o paremetro [day]
                  List<DateTime> eventsForDay = eventsDays
                      .where((element) => isSameDay(day, element))
                      .toList();
                  // eventLength é responsavel pela quantidade de "bolinhas"
                  List<int> eventLength = [];
                  for (var i = 0; i < eventsForDay.length; i++) {
                    //para cada do dia, adiciono um elemento no eventLength
                    // o 1 não faz diferença, pode ser qualquer inteiro no .add
                    eventLength.add(1);
                  }
                  // se  eventsForDay tem 5 eventos, o eventLenth fica [1,1,1,1,1]
                  //se eventsForDay tem 2 eventos, o eventLength fica [1,1] ...
                  // a quantidade de elementos do eventLegth é a quantidade de bolinhas
                  return eventLength;
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
        eventsDays =
            data.map((element) => formatter.parse(element.day)).toList();
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
    var date = formatter.parse(task.day);
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
