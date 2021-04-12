import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:taskmanager/Model/taskHelper.dart';
import 'package:taskmanager/View/AddTask/TaskPage.dart';
import 'package:taskmanager/View/Home/TableCalenar/tableCalendar.dart';
import 'package:taskmanager/View/SettingsPage/settingsPage.dart';
import 'Widgets/quickTask.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

enum MenuOption { Prority, Date, Inserion }

class _HomeState extends State<Home> {
  TaskHelper helper = TaskHelper();
  List<Task> tasks = [];

  int _lastRemovedPos;
  Task _lastRemoved;

  int _menuIndex = 1;
  int _cardTap = -1;
  bool _cardBool = false;
  bool _favoriteTap = false;
  int _selectedTask = -1;

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
            icon: Icon(Icons.settings),
            onPressed: () {
              _showSettingsPage();
              //_showClendar(task)
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
                              "Fazendo(${tasks.length})",
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
                          "Feitos(0)",
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
                  child: IconButton(icon: Icon(Icons.menu), onPressed: null),
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
    Widget _showTitle() {
      return Text(
        tasks[index].title, // TITULO -------------------------------------
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 15,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    Widget _showSubject() {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
        child: Text(
          tasks[index]
              .subject, // DESCRIÇÃO --------------------------------------------
          style: TextStyle(
            color: Colors.grey,
            fontSize: 13,
          ),
          maxLines: (_cardTap == index) && (_cardBool == true) ? 10 : 2,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    Widget _showDifferenceDay() {
      return Container(
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: tasks[index].priorityColor(),
        ),
        child: Column(
          children: [
            Text(
              tasks[index].diference > 1
                  ? "${tasks[index].diference} "
                  : "${tasks[index].diference} ",
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "dias",
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    Widget _showDate() {
      return Container(
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: Colors.grey,
              size: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                tasks[index].due,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: EdgeInsets.all(20),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _cardTap = index;
            _cardBool = !_cardBool;
          });
        },
        child: Dismissible(
          key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
          direction: DismissDirection.startToEnd,
          background: Container(
            color: Colors.red,
            child: Align(
              alignment: Alignment(-0.9, 0),
              child: Icon(Icons.delete, color: Colors.white),
            ),
          ),
          onDismissed: (direction) {
            setState(() {
              //primeiro precisamos copiar o conato a ser excluido para uma variavel
              // essa variavel retornará o contato caso o usuário queira desfazer a exclusão
              _lastRemoved = tasks[index];
              //deletamso o contato do banco de dados
              helper.deleTask(tasks[index].id);
              //deletamos o contato da lista
              tasks.removeAt(index);
              // e copiamos a sua posição, quando o usuário desfaça a eclusão, o contato
              // retornará para sua posição inicial
              _lastRemovedPos = index;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Theme.of(context).primaryColor,
                  content: RichText(
                      text: TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          children: [
                        TextSpan(
                            text: "\"${_lastRemoved.title}\"",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: " foi removido da lista de tarefas"),
                      ])),
                  action: SnackBarAction(
                      label: 'Desfazer',
                      onPressed: () {
                        setState(() {
                          tasks.insert(_lastRemovedPos, _lastRemoved);
                          helper.saveTask(_lastRemoved);
                        });
                      }),
                  duration: Duration(seconds: 20),
                ),
              );
            });
          },
          child: Container(
            padding: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Theme.of(context).cardColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(
                    top: 10.0,
                    left: 15.0,
                    bottom: 10.0,
                    right: 12.0,
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _showDifferenceDay(),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _showTitle(),
                            _showSubject(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(),
                                _showDate(),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Radio(
                        visualDensity: VisualDensity.compact,
                        value: index,
                        activeColor: Colors.green,
                        groupValue: _selectedTask,
                        onChanged: (value) {
                          setState(() {
                            _selectedTask = value;
                          });
                        },
                      )
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
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
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
                                icon: Icon(
                                    CommunityMaterialIcons.bell_ring_outline),
                                onPressed: null),
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

  Route _createRouteSettings() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SettingsPage(),
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
    for (int i = 0; i < tasks.length; i++) {
      tasks[i].diference = tasks[i].diferenceDate();
    }
    _gestAllTasks();
    tasks.removeRange(0, tasks.length);
  }

  void _gestAllTasks() {
    helper.getAllTasks().then((list) {
      setState(() {
        tasks = list;
      });
    });
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

  void _showClendar(List<Task> task) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => TableCalendarPage(task)));
  }

  void _showSettingsPage() {
    Navigator.push(context, _createRouteSettings());
  }
}
