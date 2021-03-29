import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';

import 'package:taskmanager/Model/taskHelper.dart';
import 'package:taskmanager/View/AddTask/TaskPage.dart';
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

  int menu = 1;
  int cardTap = -1;
  bool cardBool = false;
  bool favorite = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xFFEEF3F2),
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {},
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
                    child: GestureDetector(
                      child: Text(
                        "UpComming(${tasks.length})",
                        style: TextStyle(
                          fontWeight: menu == 1 ? FontWeight.bold : null,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          menu = 1;
                        });
                      },
                    )),
                SizedBox(width: 20),
                GestureDetector(
                  child: Text(
                    "Done(${tasks.length})",
                    style: TextStyle(
                      fontWeight: menu == 0 ? FontWeight.bold : null,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      menu = 0;
                    });
                  },
                ),
              ],
            ),
            Container(
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 150),
                    margin: menu == 1
                        ? EdgeInsets.only(left: 25, top: 10)
                        : EdgeInsets.only(left: 55, top: 5),
                    height: 8,
                    width: menu == 1 ? 105 : 50,
                    decoration: BoxDecoration(
                        color: menu == 1
                            ? Theme.of(context).primaryColor
                            : Colors.blueGrey,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 150),
                    margin: menu == 0
                        ? EdgeInsets.only(left: 50, top: 10)
                        : EdgeInsets.only(left: 40, top: 5),
                    height: 8,
                    width: menu == 0 ? 50 : 25,
                    decoration: BoxDecoration(
                      color: menu == 0
                          ? Theme.of(context).primaryColor
                          : Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            menu == 1
                ? ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return _taskCard(context, index);
                    },
                  )
                : Container(color: Colors.red),
            Container(color: Colors.blue),
          ],
        ),
      ),
    );
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
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(color: Colors.amber, width: 7.0),
            ),
          ),
          child: Column(
            children: [
              GestureDetector(
                key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
                onTap: () {
                  setState(() {
                    cardTap = index;
                    cardBool = !cardBool;
                    print("index:$index");
                    print("cardTap:$cardTap");
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(seconds: 2),
                  padding: EdgeInsets.only(
                    top: 10,
                    left: 15,
                    bottom: 10,
                    right: 12,
                  ),
                  width: 340.0,
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                          maxLines:
                              (cardTap == index) && (cardBool == true) ? 10 : 3,
                          overflow: TextOverflow.ellipsis,
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
                      ),
                    ],
                  ),
                ),
              ),
              (cardTap == index) && (cardBool == true)
                  ? Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      height: 50,
                      width: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.blue[200],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.offline_pin_sharp),
                            onPressed: null,
                          ),
                          IconButton(icon: Icon(Icons.edit), onPressed: null),
                          IconButton(
                              icon: Icon(Icons.favorite,
                                  color: favorite == true
                                      ? Colors.red
                                      : Colors.white),
                              onPressed: () {
                                setState(() {
                                  favorite = !favorite;
                                });
                              }),
                          IconButton(icon: Icon(Icons.delete), onPressed: null),
                        ],
                      ),
                    )
                  : SizedBox(height: 0)
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
