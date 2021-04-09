import 'package:flutter/material.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:taskmanager/Model/taskHelper.dart';

// ignore: must_be_immutable
class TableCalendarPage extends StatefulWidget {
  final List<Task> tasks;
  TableCalendarPage([this.tasks]);
  @override
  _TableCalendarPageState createState() => _TableCalendarPageState();
}

class _TableCalendarPageState extends State<TableCalendarPage> {
  CalendarController _calendarController;
  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    super.dispose();
    _calendarController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              TableCalendar(
                formatAnimation: FormatAnimation.scale,
                initialCalendarFormat: CalendarFormat.twoWeeks,
                calendarStyle: CalendarStyle(
                    todayColor: Colors.blue[500],
                    selectedColor: Colors.orange[500]),
                calendarController: _calendarController,
                builders: CalendarBuilders(),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    )),
                height: MediaQuery.of(context).size.height / 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
