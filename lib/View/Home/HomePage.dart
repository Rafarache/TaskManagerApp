import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:taskmanager/Model/taskHelper.dart';
import 'package:taskmanager/View/AddTask/TaskPage.dart';
import 'package:taskmanager/Widgets/listViewCard.dart';
import 'package:taskmanager/Widgets/quickTask.dart';
import 'package:taskmanager/blocs/theme.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TaskHelper helper = TaskHelper();
  List<Task> tasks = [];
  List<Task> tasksPinned = [];

  List<Task> tasksDone = [];
  int _menuIndex = 1;

  var controller = ThemeController.to;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {},
          child: Icon(Icons.menu_open),
        ),
        centerTitle: true,
        title: Text(
          'Tarefas',
          style: TextStyle(
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
            icon: Obx(() => controller.isDark.value
                ? Icon(Icons.brightness_7)
                : Icon(Icons.brightness_2)),
            onPressed: () => controller.changeTheme(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /*  GestureDetector(
              onTap: () {
                _showTask();
              },
              child: QuickTask(),
            ), */
            ListViewCard(tasksPinned),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: GestureDetector(
                            child: Container(
                              padding: EdgeInsets.all(15),
                              color: Colors.transparent,
                              child: Text(
                                "Fazendo(${tasks.length})",
                                style: TextStyle(
                                  fontWeight:
                                      _menuIndex == 1 ? FontWeight.bold : null,
                                ),
                              ),
                            ),
                            onTap: () {
                              /*  setState(() {
                                _menuIndex = 1;
                              }); */
                            },
                          )),
                      GestureDetector(
                        child: Container(
                          padding: EdgeInsets.all(15),
                          //color: Colors.transparent,

                          child: Text(
                            "Feitos(${tasksDone.length})",
                            style: TextStyle(
                              fontWeight:
                                  _menuIndex == 0 ? FontWeight.bold : null,
                            ),
                          ),
                        ),
                        onTap: () {
                          /* setState(() {
                            _menuIndex = 0;
                          }); */
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: IconButton(icon: Icon(Icons.menu), onPressed: null),
                ),
              ],
            ),
            SizedBox(height: 30),
            ListViewCard(tasks),
          ],
        ),
      ),
    );
  }

  Route _createRouteAdd(Task task) {
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

  void _gestAllTasks() {
    helper.getAllTasks().then((list) {
      setState(() {
        tasks = list;
      });
    });
  }

  void _gestAllTasksPinned() {
    helper.getAPinnedTask().then((list) {
      setState(() {
        tasksPinned = list;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _gestAllTasks();
    _gestAllTasksPinned();
    tasks.removeRange(0, tasks.length);
  }

  void _showTask({Task task}) async {
    final recTask = await Navigator.push(context, _createRouteAdd(task));
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
