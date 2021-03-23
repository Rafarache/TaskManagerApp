import 'package:flutter/material.dart';
import 'package:taskmanager/Model/taskHelper.dart';
import 'package:taskmanager/View/AddTask/TaskPage.dart';
import 'Widgets/card.dart';
import 'Widgets/quickTask.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TaskHelper helper = TaskHelper();
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _gestAllTasks();
    tasks.removeRange(0, tasks.length);
  }

  void _gestAllTasks() {
    helper.getAllTasks().then((list) {
      print(list);
      setState(() {
        tasks = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Color(0xFFEEF3F2),
        backgroundColor: Colors.blue[200],
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              print("ola");
            },
            child: Icon(Icons.menu_open),
          ),
          centerTitle: true,
          title: Text(
            'Task Manager',
            style: TextStyle(
              fontFamily: 'San Francisco',
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _showTask();
              },
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: null,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  _showTask();
                },
                child: QuickTask(),
              ),
              SizedBox(height: 40),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      'Upcoming(4)',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(width: 20),
                  Text('Done(13)')
                ],
              ),
              SizedBox(height: 30),
              ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return _taskCard(context, index);
                },
              ),
            ],
          ),
        ));
  }

  Widget _taskCard(context, index) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, bottom: 10, right: 15),
      child: ClipPath(
        clipper: ShapeBorderClipper(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 15,
            bottom: 10,
            right: 12,
          ),
          width: 340.0,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(color: Colors.amber, width: 7.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tasks[index]
                    .title, // TITULO -------------------------------------
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 20),
                child: Text(
                  tasks[index]
                      .subject, // DESCRIÇÃO --------------------------------------------
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.person_outline_rounded,
                    color: Colors.grey,
                    size: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Text(
                      tasks[index]
                          .assigned, // AUTOR -------------------------------------
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.calendar_today,
                    color: Colors.grey,
                    size: 16,
                  ),
                  Text(
                    '16.03.2021',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Route _createRoute(Task task) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          TaskPage(task: task),
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

  void _showTask({Task task}) async {
    final recTask = await Navigator.push(context, _createRoute(task));
    if (recTask != null) {
      if (task != null) {
        await helper.upDateTask(recTask);
      } else {
        await helper.saveTask(recTask);
      }
      _gestAllTasks();
    }
  }
}
