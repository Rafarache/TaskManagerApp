import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:taskmanager/Model/taskHelper.dart';

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
    // _controller = CalendarController();
  }

  @override
  void dispose() {
    super.dispose();
    //_controller.dispose();
  }

  void _onDaySelected(DateTime day, List events, _) {
    setState(() {
      _selectedDay = day;
      _selectedEvents = events;
    });
  }

  var focusDay = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 10, 16),
                focusedDay: focusDay,
                onDaySelected: (day, focusDay) {
                  setState(() {
                    focusDay = focusDay;
                    _selectedDay = day;
                    filterTask(day, data);
                  });
                  for (var i = 0; i < eventos.length; i++) {
                    print(eventos[i].title);
                  }
                },
              ),
              Column(
                children: [
                  Container(
                    child: Text("${_selectedDay.toString()} - ${data[0].due}"),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
