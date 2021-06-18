import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskmanager/Model/taskHelper.dart';
import 'package:taskmanager/View/AddTask/TaskPage.dart';

// ignore: must_be_immutable
class TaskCard extends StatefulWidget {
  TaskCard(this.helper, this.tasks, this._getAllTasks, this._getAllTasksDone,
      this._showTask);
  Function _getAllTasks;
  Function _getAllTasksDone;

  Function _showTask;

  TaskHelper helper = TaskHelper();

  List<Task> tasks = [];

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  int _cardTap = -1;
  bool _cardBool = false;
  Task _lastRemoved;
  int _lastRemovedPos;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: ScrollPhysics(),
      primary: false,
      shrinkWrap: true,
      itemCount: widget.tasks.length,
      itemBuilder: (context, index) {
        DateFormat format = DateFormat("d MM y");
        var dateUpdate = format.parse(widget.tasks[index].due);
        widget.tasks[index].diference =
            (dateUpdate.difference(DateTime.now()).inHours / 24).round();

        return Container(
          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
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
                  widget.helper.deleTask(widget.tasks[index].id);
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
                              color: widget.tasks[index].priorityColor(),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "${widget.tasks[index].diference} ",
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
                                  padding: const EdgeInsets.only(top: 8.0),
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
                                !((_cardTap == index) && (_cardBool == true))
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
                                                  widget.tasks[index].due,
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
                    (_cardTap == index) && (_cardBool == true)
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
                                      widget._showTask(
                                          task: widget.tasks[index]);
                                    }),
                                IconButton(
                                    icon: Icon(CommunityMaterialIcons.pin,
                                        color: widget.tasks[index].pinned == 1
                                            ? Colors.amber
                                            : Colors.white),
                                    onPressed: () {
                                      setState(() {
                                        _cardTap = -1;
                                        if (widget.tasks[index].pinned == 0) {
                                          widget.tasks[index].pinned = 1;
                                        } else {
                                          widget.tasks[index].pinned = 0;
                                        }
                                        widget.helper
                                            .upDateTask(widget.tasks[index]);
                                        widget._getAllTasks();
                                      });
                                    }),
                                IconButton(
                                    icon: Icon(CommunityMaterialIcons
                                        .bell_ring_outline),
                                    onPressed: () {
                                      setState(() {
                                        _cardTap = -1;
                                        widget.tasks[index].taskDone = 1;
                                        widget.tasks[index].pinned = 0;
                                        widget.helper
                                            .upDateTask(widget.tasks[index]);
                                        widget._getAllTasks();
                                        widget._getAllTasksDone();
                                      });
                                    }),
                              ],
                            ))
                        : SizedBox(),
                    (_cardTap == index) && (_cardBool == true)
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
                                      widget.tasks[index].due,
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
}
