import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskmanager/Model/taskHelper.dart';
import 'package:taskmanager/View/AddTask/TaskPage.dart';

class ListViewCard extends StatefulWidget {
  ListViewCard(this.tasks);
  List<Task> tasks = [];

  @override
  _ListViewCardState createState() => _ListViewCardState();
}

class _ListViewCardState extends State<ListViewCard> {
  TaskHelper helper = TaskHelper();
  int _cardTap = -1;
  bool _cardBool = false;
  List<Task> tasksDone = [];
  bool _pinned = false;
  int _lastRemovedPos;
  Task _lastRemoved;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: widget.tasks.length,
      itemBuilder: (context, index) {
        DateFormat format = DateFormat("d MM y");
        var dateUpdate = format.parse(widget.tasks[index].due);
        widget.tasks[index].diference =
            (dateUpdate.difference(DateTime.now()).inHours / 24).round();

        return Container(
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _cardTap = index;
                _cardBool = !_cardBool;
              });
            },
            child: Dismissible(
              key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
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
                  _lastRemoved = widget.tasks[index];
                  helper.deleTask(widget.tasks[index].id);
                  widget.tasks.removeAt(index);
                  _lastRemovedPos = index;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Theme.of(context).primaryColor,
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
                                        text: "\"${_lastRemoved.title}\"",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(text: " foi removida!"),
                                  ])),
                        ),
                      ],
                    ),
                    action: SnackBarAction(
                        textColor: Colors.white,
                        label: 'Desfazer',
                        onPressed: () {
                          setState(() {
                            widget.tasks.insert(_lastRemovedPos, _lastRemoved);
                            helper.saveTask(_lastRemoved);
                          });
                        }),
                    duration: Duration(seconds: 2),
                  ),
                );
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
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: widget.tasks[index].priorityColor(),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  widget.tasks[index].diference > 1
                                      ? "${widget.tasks[index].diference} "
                                      : "${widget.tasks[index].diference} ",
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.tasks[index]
                                      .title, // TITULO -------------------------------------
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                  maxLines:
                                      (_cardTap == index) && (_cardBool == true)
                                          ? 2
                                          : 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 8),
                                  child: Text(
                                    widget.tasks[index]
                                        .subject, // DESCRIÇÃO --------------------------------------------
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                    maxLines: (_cardTap == index) &&
                                            (_cardBool == true)
                                        ? 10
                                        : 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              widget.tasks[index].due,
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey,
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
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            width: 400,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: widget.tasks != tasksDone
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () {
                                            _showTask(
                                                task: widget.tasks[index]);
                                          }),
                                      IconButton(
                                          icon: Icon(CommunityMaterialIcons.pin,
                                              color:
                                                  widget.tasks[index].pinned ==
                                                          1
                                                      ? Colors.amber
                                                      : Colors.white),
                                          onPressed: () {
                                            setState(() {
                                              _pinned = !_pinned;
                                              if (widget.tasks[index].pinned ==
                                                  0) {
                                                widget.tasks[index].pinned = 1;
                                                helper.upDateTask(
                                                    widget.tasks[index]);
                                                _gestAllTasks();
                                              } else {
                                                widget.tasks[index].pinned = 0;
                                                helper.upDateTask(
                                                    widget.tasks[index]);
                                                //_gestAllTasks();
                                              }
                                            });
                                          }),
                                      IconButton(
                                          icon: Icon(CommunityMaterialIcons
                                              .bell_ring_outline),
                                          onPressed: null),
                                    ],
                                  )
                                : SizedBox(),
                          )
                        : SizedBox(height: 0),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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
        widget.tasks = list;
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
    }
    _gestAllTasks();
  }
}
