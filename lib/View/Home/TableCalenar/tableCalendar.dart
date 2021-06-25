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

class _TableCalendarPageState extends State<TableCalendarPage> {
  DateTime _selectedDay = DateTime.now();

  //CalendarController _controller;
  Map<DateTime, List<dynamic>> _events = {};
  List<Task> data = [];

  List<dynamic> _selectedEvents = [];
  List<Widget> get _eventWidget =>
      _selectedEvents.map((e) => events(e)).toList();

  /* DateFormat format = DateFormat("d MM y");
        var dateUpdate = format.parse(data[1].due); */

  Widget events(var d) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
          decoration: BoxDecoration(
              border: Border(
            top: BorderSide(color: Theme.of(context).dividerColor),
          )),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(d, style: Theme.of(context).primaryTextTheme.bodyText1),
          ])),
    );
  }

  void _getAllTasks() {
    widget.helper.getAllTasks().then((list) {
      setState(() {
        data = list;
      });
    });
  }

  bool isSameDay(DateTime selectedDay, Task task) {
    DateFormat formatter = DateFormat("d MM y");
    var date = formatter.parse(task.due);
    var date1 = DateFormat("d MM y").format(date);
    var sel = DateFormat("d MM y").format(selectedDay);
    return date1 == sel;
  }

  List<Task> eventos = [];

  void filterTask(DateTime selectedDay, List<Task> task) {
    eventos = task.where((i) => isSameDay(selectedDay, i)).toList();
  }

  @override
  void initState() {
    super.initState();
    _getAllTasks();
    data.removeRange(0, data.length);
    setState(() {
      filterTask(DateTime.now(), data);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  String _lastUserId = null;
  String _lastPassword = null;

  Map<DateTime, Map<String, String>> _bookings = {
    DateTime.utc(2021, 6, 27): {"aaa": "AAA"},
    DateTime.utc(2021, 6, 29): {"aaa": "AAA"},
    DateTime.utc(2021, 6, 29): {"aaa": "AAA"},
    DateTime.utc(2021, 6, 30): {"aaa": "AAA"},
    DateTime.utc(2021, 7, 1): {"aaa": "AAA"},
    DateTime.utc(2021, 7, 5): {"aaa": "AAA"},
  };

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

  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  DateTime _focusedDay = DateTime.now();
  var teste = DateTime.now();
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
                eventLoader: bookingsOnDay,
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                calendarStyle: CalendarStyle(
                  markerDecoration: BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.circular(90)),
                  selectedDecoration: BoxDecoration(color: Colors.blue),
                  todayDecoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(50)),
                ),
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    // Call `setState()` when updating calendar format
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onDaySelected: (day, focusDay) {
                  setState(() {
                    teste = day;
                    _focusedDay = focusDay;
                    filterTask(day, data);
                  });
                  for (var i = 0; i < eventos.length; i++) {
                    print(eventos[i].title);
                  }
                },
              ),
              Divider(
                endIndent: 10,
              ),
              eventos.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 20.0, bottom: 10),
                      child: Text(
                        "Tarefas do dia ${DateFormat("d 'de' MMMM 'de' y", "pt").format(teste)}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 20),
                      child: Text(
                        "Não há nehuma tarefa para ${DateFormat("d 'de' MMMM", "pt").format(teste)}",
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
}
