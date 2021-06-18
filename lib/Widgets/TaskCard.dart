import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskmanager/Model/taskHelper.dart';
import 'package:taskmanager/View/AddTask/TaskPage.dart';

// ignore: must_be_immutable
class Card1 extends StatefulWidget {
  Card1(this.helper, this.tasks, this.tasksDone, this.tasksPinned,
      this._getAllTasks, this._getAllTasksDone, this._getAllTasksPinned);
  Function _getAllTasks;
  Function _getAllTasksDone;
  Function _getAllTasksPinned;

  TaskHelper helper = TaskHelper();
  List<Task> tasks = [];
  List<Task> tasksPinned = [];
  List<Task> tasksDone = [];
  @override
  _Card1State createState() => _Card1State();
}

class _Card1State extends State<Card1> {
  int _cardTapPinned = -1;
  bool _cardBoolPinned = false;
  Task _lastRemoved;
  int _lastRemovedPos;
  int _cardTap = 1;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: ScrollPhysics(),
      primary: false,
      shrinkWrap: true,
      itemCount: widget.tasksPinned.length,
      itemBuilder: (context, index) {
        DateFormat format = DateFormat("d MM y");
        var dateUpdate = format.parse(widget.tasksPinned[index].due);
        widget.tasksPinned[index].diference =
            (dateUpdate.difference(DateTime.now()).inHours / 24).round();

        return Container(
          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _cardTapPinned = index;
                _cardBoolPinned = !_cardBoolPinned;
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
                  _cardTapPinned = -1;
                  _lastRemoved = widget.tasksPinned[index];
                  widget.helper.deleTask(widget.tasksPinned[index].id);
                  widget.tasksPinned.removeAt(index);
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
                            widget.tasksPinned
                                .insert(_lastRemovedPos, _lastRemoved);
                            widget.helper.saveTask(_lastRemoved);
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: widget.tasksPinned[index].priorityColor(),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  widget.tasksPinned[index].diference > 1
                                      ? "${widget.tasksPinned[index].diference} "
                                      : "${widget.tasksPinned[index].diference} ",
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
                                  widget.tasksPinned[index]
                                      .title, // TITULO -------------------------------------
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                  maxLines: (_cardTapPinned == index) &&
                                          (_cardBoolPinned == true)
                                      ? 2
                                      : 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    widget.tasksPinned[index]
                                        .subject, // DESCRIÇÃO --------------------------------------------
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                    maxLines: (_cardTapPinned == index) &&
                                            (_cardBoolPinned == true)
                                        ? 10
                                        : 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                !((_cardTapPinned == index) &&
                                        (_cardBoolPinned == true))
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                right: 15,
                                                bottom: 10.0,
                                                top: 10),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.calendar_today,
                                                  color: Colors.grey,
                                                  size: 16,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  widget.tasksPinned[index].due,
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
                        ],
                      ),
                    ),
                    (_cardTapPinned == index) && (_cardBoolPinned == true)
                        ? Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            width: 400,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      _showTask(
                                          task: widget.tasksPinned[index]);
                                    }),
                                IconButton(
                                    icon: Icon(CommunityMaterialIcons.pin,
                                        color:
                                            widget.tasksPinned[index].pinned ==
                                                    1
                                                ? Colors.amber
                                                : Colors.white),
                                    onPressed: () {
                                      setState(() {
                                        _cardTapPinned = -1;
                                        _cardTap = -1;
                                        widget.tasksPinned[index].pinned = 0;
                                        widget.helper.upDateTask(
                                            widget.tasksPinned[index]);
                                        widget._getAllTasks();
                                        widget._getAllTasksPinned();
                                      });
                                    }),
                                IconButton(
                                    icon: Icon(CommunityMaterialIcons
                                        .bell_ring_outline),
                                    onPressed: () {
                                      setState(() {
                                        _cardTapPinned = -1;
                                        _cardTap = -1;
                                        widget.tasksPinned[index].taskDone = 1;
                                        widget.tasksPinned[index].pinned = 0;
                                        widget.helper.upDateTask(
                                            widget.tasksPinned[index]);
                                        widget._getAllTasks();
                                        widget._getAllTasksDone();
                                        widget._getAllTasksPinned();
                                      });
                                    }),
                              ],
                            ))
                        : SizedBox(),
                    (_cardTapPinned == index) && (_cardBoolPinned == true)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(),
                              Container(
                                margin: const EdgeInsets.only(
                                    right: 30, bottom: 10.0, top: 0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      color: Colors.grey,
                                      size: 16,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      widget.tasksPinned[index].due,
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
    );
  }

  void _getAllTasksPinned() {
    widget.helper.getAPinnedTask().then((list) {
      setState(() {
        widget.tasksPinned = list;
      });
    });
  }

  void _getAllTasksDone() {
    widget.helper.getTaskDone().then((list) {
      setState(() {
        widget.tasksDone = list;
      });
    });
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
      widget._getAllTasks();
      widget._getAllTasksPinned();
    }
  }
}
