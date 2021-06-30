import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:taskmanager/Model/taskHelper.dart';
import 'package:taskmanager/View/TaskPage.dart';
import 'package:taskmanager/Widgets/TaskCard.dart';

// ignore: must_be_immutable
class TableCalendarPage extends StatefulWidget {
  TaskHelper helper = TaskHelper();
  TableCalendarPage(this.helper);
  @override
  _TableCalendarPageState createState() => _TableCalendarPageState();
}

class _TableCalendarPageState extends State<TableCalendarPage> {
  List<Task> data = [];
  DateTime _selectedDay = DateTime.now();
  List<Task> eventos = [];
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  List<DateTime> eventsDays = [];
  @override
  Widget build(BuildContext context) {
    if (eventos.length >= 4) {
      setState(() {
        _calendarFormat = CalendarFormat.twoWeeks;
      });
    } else {
      setState(() {
        _calendarFormat = CalendarFormat.month;
      });
    }
    return SafeArea(
      child: Scaffold(
          body: ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TableCalendar(
                  formatAnimationDuration: Duration(milliseconds: 600),
                  formatAnimationCurve: Curves.decelerate,
                  onPageChanged: (day) {
                    setState(() {
                      _focusedDay = day;
                    });
                  },
                  locale: 'pt,BR',
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 10, 16),
                  pageAnimationCurve: Curves.elasticIn,
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  calendarStyle: CalendarStyle(
                    markerDecoration: BoxDecoration(
                      color: Colors.pink,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                        color: Colors.blue, shape: BoxShape.circle),
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
                    setState(() {
                      _calendarFormat = format;
                    });
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
                Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                        color: Theme.of(context).backgroundColor,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            eventos.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20.0, left: 20.0, bottom: 20),
                                    child: Text(
                                      "Tarefas de ${DateFormat("d 'de' MMMM", "pt").format(_selectedDay)}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(
                                      top: 20.0,
                                      left: 20,
                                    ),
                                    child: Text(
                                      "Sem tarefa para ${DateFormat("d 'de' MMMM", "pt").format(_selectedDay)}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                            TaskCard(widget.helper, eventos, _getAllTasks, null,
                                _showTask),
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blue,
            onPressed: () {
              if (isSameDay(_selectedDay, DateTime.now()) ||
                  !_selectedDay.isBefore(DateTime.now())) {
                _showTask();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Theme.of(context).primaryColor,
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(),
                        Text(
                          "Não é possível adicionar tarefas no passado! ",
                          style: TextStyle(
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .headline6
                                  .color),
                        ),
                      ],
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: Icon(Icons.add),
          )),
    );
  }

  void _getAllTasks() {
    DateFormat formatter = DateFormat("d MM y");
    widget.helper.getAllTasks().then((list) {
      setState(() {
        data = list;
        eventsDays =
            data.map((element) => formatter.parse(element.day)).toList();
        filterTask(_selectedDay, data);
      });
    });
  }

  Route _createRouteAdd(Task task) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          TaskPage(task: task, selectedDay: _selectedDay),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1, 0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  void _showTask({
    Task task,
  }) async {
    final recTask = await Navigator.push(context, _createRouteAdd(task));
    if (recTask != null) {
      if (task != null) {
        await widget.helper.upDateTask(recTask);
      } else {
        await widget.helper.saveTask(recTask);
      }
      _getAllTasks();
      setState(() {
        filterTask(_selectedDay, data);
      });
      print(eventos);
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _getAllTasks();
    });
    data.removeRange(0, data.length);
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
}
