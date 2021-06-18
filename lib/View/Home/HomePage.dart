import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:taskmanager/Model/taskHelper.dart';
import 'package:taskmanager/View/AddTask/TaskPage.dart';
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

  int _lastRemovedPos;
  Task _lastRemoved;

  int _cardTap = -1;
  int _cardTapPinned = -1;
  int _cardTapDone = -1;
  int _menuIndex = 1;

  bool _cardBool = false;
  bool _cardBoolPinned = false;
  bool _cardBoolDone = false;
  bool showPinned = false;

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      showPinned = !showPinned;
                    });
                  },
                  child: Row(
                    children: [
                      Icon(CommunityMaterialIcons.pin),
                      Text("Fixos(${tasksPinned.length})"),
                      !showPinned
                          ? Icon(Icons.keyboard_arrow_up)
                          : Icon(Icons.keyboard_arrow_down)
                    ],
                  ),
                ),
              ],
            ),
            !showPinned
                ? SizedBox()
                : ListView.builder(
                    physics: ScrollPhysics(),
                    primary: false,
                    shrinkWrap: true,
                    itemCount: tasksPinned.length,
                    itemBuilder: (context, index) {
                      DateFormat format = DateFormat("d MM y");
                      var dateUpdate = format.parse(tasksPinned[index].due);
                      tasksPinned[index].diference =
                          (dateUpdate.difference(DateTime.now()).inHours / 24)
                              .round();

                      return Container(
                        margin: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 10),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _cardTapPinned = index;
                              _cardBoolPinned = !_cardBoolPinned;
                            });
                          },
                          child: Dismissible(
                            key: Key(DateTime.now()
                                .millisecondsSinceEpoch
                                .toString()),
                            direction: DismissDirection.horizontal,
                            background: Container(
                              color: Colors.red,
                              child: Align(
                                alignment: Alignment(-0.9, 0),
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                            ),
                            onDismissed: (direction) {
                              setState(() {
                                _cardTapPinned = -1;
                                _lastRemoved = tasksPinned[index];
                                helper.deleTask(tasksPinned[index].id);
                                tasksPinned.removeAt(index);
                                _lastRemovedPos = index;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  content: Row(
                                    children: [
                                      Icon(Icons.warning, color: Colors.yellow),
                                      Expanded(
                                        child: RichText(
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                            text: TextSpan(
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                                children: [
                                                  TextSpan(text: "A tarefa "),
                                                  TextSpan(
                                                      text:
                                                          "\"${_lastRemoved.title}\"",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  TextSpan(
                                                      text: " foi removida!"),
                                                ])),
                                      ),
                                    ],
                                  ),
                                  action: SnackBarAction(
                                      textColor: Colors.white,
                                      label: 'Desfazer',
                                      onPressed: () {
                                        setState(() {
                                          tasksPinned.insert(
                                              _lastRemovedPos, _lastRemoved);
                                          helper.saveTask(_lastRemoved);
                                        });
                                      }),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Theme.of(context).cardColor),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                      top: 10.0,
                                      left: 15.0,
                                      // bottom: 10.0,
                                      right: 12.0,
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          padding: const EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: tasksPinned[index]
                                                .priorityColor(),
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                tasksPinned[index].diference > 1
                                                    ? "${tasksPinned[index].diference} "
                                                    : "${tasksPinned[index].diference} ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              Text(
                                                "dias",
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                tasksPinned[index]
                                                    .title, // TITULO -------------------------------------
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15,
                                                ),
                                                maxLines:
                                                    (_cardTapPinned == index) &&
                                                            (_cardBoolPinned ==
                                                                true)
                                                        ? 2
                                                        : 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Text(
                                                  tasksPinned[index]
                                                      .subject, // DESCRIÇÃO --------------------------------------------
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 13,
                                                  ),
                                                  maxLines: (_cardTapPinned ==
                                                              index) &&
                                                          (_cardBoolPinned ==
                                                              true)
                                                      ? 10
                                                      : 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              !((_cardTapPinned == index) &&
                                                      (_cardBoolPinned == true))
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        SizedBox(),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 15,
                                                                  bottom: 10.0,
                                                                  top: 10),
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .calendar_today,
                                                                color:
                                                                    Colors.grey,
                                                                size: 16,
                                                              ),
                                                              SizedBox(
                                                                  width: 4),
                                                              Text(
                                                                tasksPinned[
                                                                        index]
                                                                    .due,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 11,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : SizedBox()
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  (_cardTapPinned == index) &&
                                          (_cardBoolPinned == true)
                                      ? Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          width: 400,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              IconButton(
                                                  icon: Icon(Icons.edit),
                                                  onPressed: () {
                                                    _showTask(
                                                        task:
                                                            tasksPinned[index]);
                                                  }),
                                              IconButton(
                                                  icon: Icon(
                                                      CommunityMaterialIcons
                                                          .pin,
                                                      color: tasksPinned[index]
                                                                  .pinned ==
                                                              1
                                                          ? Colors.amber
                                                          : Colors.white),
                                                  onPressed: () {
                                                    setState(() {
                                                      _cardTapPinned = -1;
                                                      _cardTap = -1;
                                                      tasksPinned[index]
                                                          .pinned = 0;
                                                      helper.upDateTask(
                                                          tasksPinned[index]);
                                                      _getAllTasks();
                                                      _getAllTasksPinned();
                                                    });
                                                  }),
                                              IconButton(
                                                  icon: Icon(
                                                      CommunityMaterialIcons
                                                          .bell_ring_outline),
                                                  onPressed: () {
                                                    setState(() {
                                                      _cardTapPinned = -1;
                                                      _cardTap = -1;
                                                      tasksPinned[index]
                                                          .taskDone = 1;
                                                      tasksPinned[index]
                                                          .pinned = 0;
                                                      helper.upDateTask(
                                                          tasksPinned[index]);
                                                      _getAllTasks();
                                                      _getAllTasksDone();
                                                      _getAllTasksPinned();
                                                    });
                                                  }),
                                            ],
                                          ))
                                      : SizedBox(),
                                  (_cardTapPinned == index) &&
                                          (_cardBoolPinned == true)
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  right: 30,
                                                  bottom: 10.0,
                                                  top: 0),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.calendar_today,
                                                    color: Colors.grey,
                                                    size: 16,
                                                  ),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    tasksPinned[index].due,
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      : SizedBox()
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: TextButton(
                            style: TextButton.styleFrom(
                                textStyle: TextStyle(
                              fontWeight:
                                  _menuIndex == 1 ? FontWeight.bold : null,
                            )),
                            onPressed: () {
                              setState(() {
                                _menuIndex = 1;
                              });
                            },
                            child: Text(
                              "Fazendo(${tasks.length + tasksPinned.length})",
                            ),
                          )),
                      Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              textStyle: TextStyle(
                                fontWeight:
                                    _menuIndex == 0 ? FontWeight.bold : null,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _menuIndex = 0;
                              });
                            },
                            child: Text(
                              "Feitos(${tasksDone.length})",
                            ),
                          )),
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
                      DateFormat format = DateFormat("d MM y");
                      var dateUpdate = format.parse(tasks[index].due);
                      tasks[index].diference =
                          (dateUpdate.difference(DateTime.now()).inHours / 24)
                              .round();

                      return Container(
                        margin: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 10),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _cardTap = index;
                              _cardBool = !_cardBool;
                            });
                          },
                          child: Dismissible(
                            key: Key(DateTime.now()
                                .millisecondsSinceEpoch
                                .toString()),
                            direction: DismissDirection.horizontal,
                            background: Container(
                              color: Colors.red,
                              child: Align(
                                alignment: Alignment(-0.9, 0),
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                            ),
                            onDismissed: (direction) {
                              setState(() {
                                _cardTap = -1;
                                _lastRemoved = tasks[index];
                                helper.deleTask(tasks[index].id);
                                tasks.removeAt(index);
                                _lastRemovedPos = index;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  content: Row(
                                    children: [
                                      Icon(Icons.warning, color: Colors.yellow),
                                      Expanded(
                                        child: RichText(
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                            text: TextSpan(
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                                children: [
                                                  TextSpan(text: "A tarefa "),
                                                  TextSpan(
                                                      text:
                                                          "\"${_lastRemoved.title}\"",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  TextSpan(
                                                      text: " foi removida!"),
                                                ])),
                                      ),
                                    ],
                                  ),
                                  action: SnackBarAction(
                                      textColor: Colors.white,
                                      label: 'Desfazer',
                                      onPressed: () {
                                        setState(() {
                                          tasks.insert(
                                              _lastRemovedPos, _lastRemoved);
                                          helper.saveTask(_lastRemoved);
                                        });
                                      }),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Theme.of(context).cardColor),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                      top: 10.0,
                                      left: 15.0,
                                      bottom: 10.0,
                                      right: 12.0,
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          padding: const EdgeInsets.all(20),
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
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                tasks[index]
                                                    .title, // TITULO -------------------------------------
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15,
                                                ),
                                                maxLines: (_cardTap == index) &&
                                                        (_cardBool == true)
                                                    ? 2
                                                    : 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0, bottom: 8),
                                                child: Text(
                                                  tasks[index]
                                                      .subject, // DESCRIÇÃO --------------------------------------------
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 13,
                                                  ),
                                                  maxLines: (_cardTap ==
                                                              index) &&
                                                          (_cardBool == true)
                                                      ? 10
                                                      : 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              (_cardTap == index) &&
                                                      (_cardBool == true)
                                                  ? SizedBox()
                                                  : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        SizedBox(),
                                                        Container(
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .calendar_today,
                                                                color:
                                                                    Colors.grey,
                                                                size: 16,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            8.0),
                                                                child: Text(
                                                                  tasks[index]
                                                                      .due,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  (_cardTap == index) && (_cardBool == true)
                                      ? Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          width: 400,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              IconButton(
                                                  icon: Icon(Icons.edit),
                                                  onPressed: () {
                                                    _showTask(
                                                        task: tasks[index]);
                                                  }),
                                              IconButton(
                                                  icon: Icon(
                                                      CommunityMaterialIcons
                                                          .pin,
                                                      color:
                                                          tasks[index].pinned ==
                                                                  1
                                                              ? Colors.amber
                                                              : Colors.white),
                                                  onPressed: () {
                                                    setState(() {
                                                      _cardTapPinned = -1;
                                                      _cardTap = -1;
                                                      tasks[index].pinned = 1;
                                                      helper.upDateTask(
                                                          tasks[index]);
                                                      _getAllTasks();
                                                      _getAllTasksPinned();

                                                      //_gestAllPinnedTasks();
                                                    });
                                                  }),
                                              IconButton(
                                                  icon: Icon(
                                                      CommunityMaterialIcons
                                                          .bell_ring_outline),
                                                  onPressed: () {
                                                    setState(() {
                                                      _cardTap = -1;
                                                      tasks[index].taskDone = 1;
                                                      tasks[index].pinned = 0;
                                                      helper.upDateTask(
                                                          tasks[index]);
                                                      _getAllTasks();
                                                      _getAllTasksDone();
                                                      _getAllTasksPinned();
                                                    });
                                                  }),
                                            ],
                                          ))
                                      : SizedBox(height: 0),
                                  (_cardTap == index) && (_cardBool == true)
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  right: 30,
                                                  bottom: 10.0,
                                                  top: 0),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.calendar_today,
                                                    color: Colors.grey,
                                                    size: 16,
                                                  ),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    tasks[index].due,
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      : SizedBox()
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: tasksDone.length,
                    itemBuilder: (context, index) {
                      DateFormat format = DateFormat("d MM y");
                      var dateUpdate = format.parse(tasksDone[index].due);
                      tasksDone[index].diference =
                          (dateUpdate.difference(DateTime.now()).inHours / 24)
                              .round();

                      return Container(
                        margin: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 10),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _cardTapDone = index;
                              _cardBoolDone = !_cardBoolDone;
                            });
                          },
                          child: Dismissible(
                            key: Key(DateTime.now()
                                .millisecondsSinceEpoch
                                .toString()),
                            direction: DismissDirection.horizontal,
                            background: Container(
                              color: Colors.red,
                              child: Align(
                                alignment: Alignment(-0.9, 0),
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                            ),
                            onDismissed: (direction) {
                              setState(() {
                                _cardTapDone = -1;
                                _lastRemoved = tasksDone[index];
                                helper.deleTask(tasksDone[index].id);
                                tasksDone.removeAt(index);
                                _lastRemovedPos = index;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  content: Row(
                                    children: [
                                      Icon(Icons.warning, color: Colors.yellow),
                                      Expanded(
                                        child: RichText(
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                            text: TextSpan(
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                                children: [
                                                  TextSpan(text: "A tarefa "),
                                                  TextSpan(
                                                      text:
                                                          "\"${_lastRemoved.title}\"",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  TextSpan(
                                                      text: " foi removida!"),
                                                ])),
                                      ),
                                    ],
                                  ),
                                  action: SnackBarAction(
                                      textColor: Colors.white,
                                      label: 'Desfazer',
                                      onPressed: () {
                                        setState(() {
                                          tasksDone.insert(
                                              _lastRemovedPos, _lastRemoved);
                                          helper.saveTask(_lastRemoved);
                                        });
                                      }),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Theme.of(context).cardColor),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                      top: 10.0,
                                      left: 15.0,
                                      bottom: 10.0,
                                      right: 12.0,
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.green,
                                          ),
                                          child: Icon(
                                            Icons.done,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        ),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                tasksDone[index]
                                                    .title, // TITULO -------------------------------------
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15,
                                                ),
                                                maxLines: (_cardTap == index) &&
                                                        (_cardBool == true)
                                                    ? 2
                                                    : 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0, bottom: 8),
                                                child: Text(
                                                  tasksDone[index]
                                                      .subject, // DESCRIÇÃO --------------------------------------------
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 13,
                                                  ),
                                                  maxLines:
                                                      (_cardTapDone == index) &&
                                                              (_cardBoolDone ==
                                                                  true)
                                                          ? 10
                                                          : 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              (_cardTapDone == index) &&
                                                      (_cardBoolDone == true)
                                                  ? Icon(CommunityMaterialIcons
                                                      .restart)
                                                  : SizedBox(),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(),
                                                  Container(
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.calendar_today,
                                                          color: Colors.grey,
                                                          size: 16,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8.0),
                                                          child: Text(
                                                            tasksDone[index]
                                                                .due,
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  void _getAllTasks() {
    helper.getAllTasks().then((list) {
      setState(() {
        tasks = list;
      });
    });
  }

  void _getAllTasksPinned() {
    helper.getAPinnedTask().then((list) {
      setState(() {
        tasksPinned = list;
      });
    });
  }

  void _getAllTasksDone() {
    helper.getTaskDone().then((list) {
      setState(() {
        tasksDone = list;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getAllTasks();
    _getAllTasksPinned();
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
        await helper.upDateTask(recTask);
      } else {
        await helper.saveTask(recTask);
      }
      _getAllTasks();
      _getAllTasksPinned();
    }
  }
}
