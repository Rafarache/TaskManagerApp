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
  }

  void _gestAllTasks() {
    helper.getAllTasks().then((list) {
      setState(() {
        tasks = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEF3F2),
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
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => TaskPage()));
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TaskPage()));
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
            CardTask(),
            SizedBox(height: 30),
            CardTask(),
            SizedBox(height: 30),
            CardTask(),
          ],
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
