import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:taskmanager/Model/taskHelper.dart';
import 'package:taskmanager/View/AddTask/TaskPage.dart';
import 'Widgets/quickTask.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

enum MenuOption { Prority, Date, Inserion }

class _HomeState extends State<Home> {
  Widget popMenu(context) {
    return PopupMenuButton<MenuOption>(itemBuilder: (BuildContext context) {
      return <PopupMenuEntry<MenuOption>>[
        PopupMenuItem(
          child: Text("Order By Priority"),
          value: MenuOption.Prority,
        ),
        PopupMenuItem(
          child: Text("Order By Date"),
          value: MenuOption.Date,
        ),
        PopupMenuItem(
          child: Text("Order By Insertion"),
          value: MenuOption.Inserion,
        ),
      ];
    });
  }

  TaskHelper helper = TaskHelper();
  List<Task> tasks = [];

  int _menuIndex = 1;
  int _cardTap = -1;
  bool _cardBool = false;
  bool _favoriteTap = false;

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
          'Task Manager',
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
            icon: Icon(IcoFontIcons.fullNight),
            onPressed: () {
              print("object");
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                _showTask();
                print(tasks);
              },
              child: QuickTask(),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: GestureDetector(
                            child: Text(
                              "UpComming(${tasks.length})",
                              style: TextStyle(
                                fontWeight:
                                    _menuIndex == 1 ? FontWeight.bold : null,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _menuIndex = 1;
                              });
                            },
                          )),
                      SizedBox(width: 40),
                      GestureDetector(
                        child: Text(
                          "Done(${tasks.length})",
                          style: TextStyle(
                            fontWeight:
                                _menuIndex == 0 ? FontWeight.bold : null,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _menuIndex = 0;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: IconButton(
                      icon: Icon(Icons.menu), onPressed: () => popMenu),
                ),
              ],
            ),
            SizedBox(height: 30),
            _menuIndex == 1
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
      padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 10),
      child: ClipPath(
        clipper: ShapeBorderClipper(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            setState(() {
              _cardTap = index;
              _cardBool = !_cardBool;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              border: Border(
                left: BorderSide(
                    color: tasks[index].priorityColor(tasks[index].priority),
                    width: 7.0),
              ),
            ),
            child: Column(
              children: [
                AnimatedContainer(
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
                          maxLines: (_cardTap == index) && (_cardBool == true)
                              ? 10
                              : 3,
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
                            tasks[index].due,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(width: 20),
                          Text(
                            "${tasks[index].diference}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            " ",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                (_cardTap == index) && (_cardBool == true)
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
                                icon: Icon(CommunityMaterialIcons.pin,
                                    color: _favoriteTap == true
                                        ? Colors.amber
                                        : Colors.white),
                                onPressed: () {
                                  setState(() {
                                    _favoriteTap = !_favoriteTap;
                                  });
                                }),
                            IconButton(
                                icon: Icon(Icons.delete), onPressed: null),
                          ],
                        ),
                      )
                    : SizedBox(height: 0)
              ],
            ),
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
