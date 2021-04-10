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
  Map<DateTime, List<dynamic>> _events;
  CalendarController _controller;
  TextEditingController _eventsController;
  List<dynamic> _selectedEvents;

  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });
    return newMap;
  }

  Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
    Map<DateTime, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[DateTime.parse(key)] = map[key];
    });
    return newMap;
  }

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _eventsController = TextEditingController();
    _events;
    _selectedEvents = [];
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              TableCalendar(
                events: _events,
                locale: 'pt_Br',
                formatAnimation: FormatAnimation.scale,
                initialCalendarFormat: CalendarFormat.month,
                calendarStyle: CalendarStyle(
                  todayColor: Colors.blue[500],
                  selectedColor: Colors.orange[500],
                ),
                calendarController: _controller,
                onDaySelected: (date, events, events1) {
                  setState(() {
                    _selectedEvents = events;
                  });
                },
                builders: CalendarBuilders(
                    selectedDayBuilder: (context, date, events) => Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(color: Colors.white),
                        )),
                    todayDayBuilder: (context, date, events) => Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(color: Colors.white),
                        ))),
              ),
              ..._selectedEvents.map((event) => ListTile(
                    title: Text(event),
                  )),
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
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: _showAddDialog,
        ),
      ),
    );
  }

  _showAddDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: _eventsController,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (_eventsController.text.isEmpty) return;
                    setState(() {
                      if (_events[_controller.selectedDay] != null) {
                        _events[_controller.selectedDay]
                            .add(_eventsController.text);
                      } else {
                        _events[_controller.selectedDay] = [
                          _eventsController.text
                        ];
                      }
                      _eventsController.clear();
                      Navigator.pop(context);
                    });
                  },
                  child: Text("Save"),
                ),
              ],
            ));
  }
}
