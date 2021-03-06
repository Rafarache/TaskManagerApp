import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:taskmanager/Assets/image/Image.dart';
import 'package:taskmanager/Model/taskHelper.dart';
import 'package:taskmanager/Model/userPreferences.dart';
import 'package:taskmanager/View/TaskPage.dart';
import 'package:taskmanager/View/searchPage.dart';
import 'package:taskmanager/Widgets/TaskCard.dart';
import 'package:taskmanager/blocs/theme.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  Home(this.helper);
  TaskHelper helper = TaskHelper();
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Task> tasks = [];
  List<Task> tasksDoing = [];
  List<Task> tasksDone = [];
  String keyword;
  int _menuIndex;
  bool showPinned;

  ThemeController controller = ThemeController.to;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Obx(() => controller.isDark.value
              ? const Icon(Icons.brightness_7)
              : const Icon(Icons.brightness_2)),
          onPressed: () => controller.changeTheme(),
        ),
        centerTitle: true,
        title: const Text(
          'Tarefas',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchPage(
                            helper: widget.helper,
                            getAllTasks: _getAllTasks,
                            getAllTasksDone: _getAllTasksDone,
                            showTask: _showTask,
                          )));
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              
              children: [
               Spacer(),
                GestureDetector(
                  onTap: () {
                    UserPreferences().showPinned = !showPinned;
                    setState(() {
                      showPinned = UserPreferences().showPinned;
                    });
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0,top: 10,bottom: 10),
                      child: Row(
                        children: [
                          Icon(Icons.wb_incandescent,color: tasksDoing.isNotEmpty ? Colors.yellow[700]:Colors.grey,),
                          const SizedBox(width: 5,),
                          Text("Fazendo(${tasksDoing.length})"),
                          !showPinned
                              ? const Icon(Icons.keyboard_arrow_up)
                              : const Icon(Icons.keyboard_arrow_down)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if(showPinned)
                TaskCard(widget.helper, tasksDoing, _getAllTasks,
                    _getAllTasksDone, _showTask),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            UserPreferences().data = 1;
                            setState(() {
                              _menuIndex = UserPreferences().data;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Container(
                                padding: EdgeInsets.all(10),
                                color: Colors.transparent,
                                child: Text("A fazer(${tasks.length})",
                                    style: TextStyle(
                                        fontWeight: _menuIndex == 1
                                            ? FontWeight.bold
                                            : null))),
                          )),
                      GestureDetector(
                          onTap: () {
                            UserPreferences().data = 0;
                            setState(() {
                              _menuIndex = UserPreferences().data;
                            });
                          },
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              color: Colors.transparent,
                              child: Text("Feitos(${tasksDone.length})",
                                  style: TextStyle(
                                      fontWeight: _menuIndex == 0
                                          ? FontWeight.bold
                                          : null)))),
                    ],
                  ),
                ),
              ],
            ),
            if(_menuIndex == 1)
                Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: GestureDetector(
                      onTap: _showTask,
                      child: new Container(
                        width: MediaQuery.of(context).size.width / 1.10,
                        height: MediaQuery.of(context).size.height / 15,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blue,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add),
                           const Text("ADICIONAR TAREFA",
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    ),
                  ),
           const  SizedBox(height: 20),
            _menuIndex == 1
                ? tasks.isNotEmpty ? TaskCard(widget.helper, tasks, _getAllTasks, _getAllTasksDone,
                    _showTask)
                 : Padding(
                   padding: const EdgeInsets.only(top:40.0),
                   child: Column(
                     children: [
                       Image.asset(Assets.emptyState,),
                       Text("N??o h?? tarefa pendente", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                       Text("Adicione uma nova tarefa", style: TextStyle(fontSize: 16),)
                     ],
                   ),
                 )

                : TaskCard(widget.helper, tasksDone, _getAllTasks,
                    _getAllTasksDone, _showTask),
          ],
        ),
      ),
    );
  }

  void _getAllTasks() {
    widget.helper.getAllTasksDoing().then((list) {
      setState(() {
        tasks = list;
      });
    });
    widget.helper.getAPinnedTask().then((list) {
      setState(() {
        tasksDoing = list;
      });
    });
  }

  void _getAllTasksDone() {
    widget.helper.getTaskDone().then((list) {
      setState(() {
        tasksDone = list;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _menuIndex = UserPreferences().data;
    showPinned = UserPreferences().showPinned;
    _getAllTasks();
    _getAllTasksDone();
    tasks.removeRange(0, tasks.length);
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

  void _showTask({Task task}) async {
    final recTask = await Navigator.push(context, _createRouteAdd(task));
    if (recTask != null) {
      if (task != null) {
        await widget.helper.upDateTask(recTask);
      } else {
        await widget.helper.saveTask(recTask);
      }
      _getAllTasks();
    }
  }
}
