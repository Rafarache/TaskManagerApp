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
    DateTime.utc(2021, 6, 11): {"aaa": "AAA"},
    DateTime.utc(2021, 6, 21): {"aaa": "AAA"},
    DateTime.utc(2021, 6, 29): {"aaa": "AAA"},
    DateTime.utc(2021, 7, 7): {"aaa": "AAA"},
    DateTime.utc(2021, 7, 13): {"aaa": "AAA"},
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

  var focusDay = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue[100],
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TableCalendar(
                eventLoader: bookingsOnDay,
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 10, 16),
                focusedDay: focusDay,
                onDaySelected: (day, focusDay) {
                  setState(() {
                    focusDay = focusDay;
                    filterTask(day, data);
                  });
                  for (var i = 0; i < eventos.length; i++) {
                    print(eventos[i].title);
                  }
                },
              ),
              TaskCard(widget.helper, eventos, _getAllTasks, null, null),
            ],
          ),
        ),
      ),
    );
  }
}
