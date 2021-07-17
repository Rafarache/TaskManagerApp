import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:intl/intl.dart';
import 'package:taskmanager/Model/taskHelper.dart';

// ignore: must_be_immutable
class TaskCard extends StatefulWidget {
  TaskCard(this.helper, this.tasks, this._getAllTasks, this._getAllTasksDone,
      this._showTask,
      [this.isSearchPage = false]);
  bool isSearchPage;
  Function _getAllTasks;
  Function _getAllTasksDone;

  Function _showTask;

  TaskHelper helper = TaskHelper();

  List<Task> tasks = [];

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
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
        var dateUpdate = format.parse(widget.tasks[index].day);
        widget.tasks[index].diference =
            (dateUpdate.difference(DateTime.now()).inDays);

        return Container(
          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
          child: Dismissible(
              key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
              direction: widget.isSearchPage != true
                  ? DismissDirection.endToStart
                  : DismissDirection.none,
              background: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 20),
                color: Theme.of(context).errorColor,
                child: const Icon(Icons.delete, color: Colors.white, size: 30),
              ),
              onDismissed: (_) {
                if (widget.isSearchPage) return;
                setState(() {
                  _lastRemoved = widget.tasks[index];
                  widget.helper.deleTask(widget.tasks[index].id);
                  widget.tasks.removeAt(index);
                  _lastRemovedPos = index;
                  if (widget._getAllTasksDone != null) {
                    widget._getAllTasksDone();
                  }
                  widget._getAllTasks();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Theme.of(context).primaryColor,
                      content: Row(
                        children: [
                          const Icon(Icons.warning, color: Colors.yellow),
                          Expanded(
                            child: RichText(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                    children: [
                                      const TextSpan(text: "A tarefa "),
                                      TextSpan(
                                          text: "\"${_lastRemoved.title}\"",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      const TextSpan(text: " foi removida!"),
                                    ])),
                          ),
                        ],
                      ),
                      action: SnackBarAction(
                          textColor: Colors.white,
                          label: 'Desfazer',
                          onPressed: () {
                            print(_lastRemoved.title);

                            widget.tasks.insert(_lastRemovedPos, _lastRemoved);
                            widget.helper.saveTask(_lastRemoved);
                            if (widget._getAllTasksDone != null) {
                              widget._getAllTasksDone();
                            }
                            widget._getAllTasks();
                          }),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                });
              },
              child: CardTask(
                  widget.tasks[index],
                  widget.helper,
                  widget._getAllTasks,
                  widget._getAllTasksDone,
                  widget._showTask,
                  index,
                  widget.isSearchPage)),
        );
      },
    );
  }
}

// ignore: must_be_immutable
class CardTask extends StatefulWidget {
  Task tasks;
  TaskHelper helper = TaskHelper();

  CardTask(this.tasks, this.helper, this._getAllTasks, this._getAllTasksDone,
      this._showTask, this.index,
      [this.isSearchPage = false]);
  bool isSearchPage;
  int index;
  Function _getAllTasks;
  Function _getAllTasksDone;
  Function _showTask;

  @override
  _CardTaskState createState() => _CardTaskState();
}

class _CardTaskState extends State<CardTask> {
  bool _cardBool = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _cardBool = !_cardBool;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 1.10,
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
                    padding: widget.tasks.taskDone == 1
                        ? null
                        : widget.tasks.pinned == 1
                            ? null
                            : const EdgeInsets.all(20),
                    decoration: widget.tasks.taskDone == 1
                        ? null
                        : BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.tasks.colorTask,
                          ),
                    child: Column(
                      children: [
                        widget.tasks.taskDone == 1
                            ? Container(
                                padding: const EdgeInsets.all(17),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                ),
                                child: const Icon(
                                  Icons.done,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              )
                            : widget.tasks.pinned == 1
                                ? Container(
                                    padding: const EdgeInsets.all(17),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      //color: Colors.green,
                                    ),
                                    child: const Icon(
                                      Icons.timer,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  )
                                : Column(
                                    children: [
                                      Text(
                                        "${widget.tasks.diference} ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const Text(
                                        "dias",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  )
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.tasks
                              .title, // TITULO -------------------------------------
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                          maxLines: (_cardBool == true) ? 2 : 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            widget.tasks
                                .subject, // DESCRIÇÃO --------------------------------------------
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                            maxLines: (_cardBool == true) ? 20 : 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!((_cardBool == true) &&
                            widget.tasks.taskDone == 0))
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(),
                              Container(
                                margin: const EdgeInsets.only(
                                    right: 10, bottom: 10.0, top: 10),
                                child: Row(
                                  children: [
                                    if (widget.tasks.priority != null)
                                      Icon(
                                        Icons.priority_high,
                                        color: widget.tasks.priorityColor,
                                        size: 16,
                                      ),
                                    const Icon(
                                      Icons.calendar_today,
                                      color: Colors.grey,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      widget.tasks.day,
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if ((_cardBool == true) && (widget.tasks.taskDone == 0))
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: (widget.isSearchPage == false)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Spacer(),
                          IconButton(
                              icon: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue,
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  )),
                              onPressed: () {
                                widget._showTask(task: widget.tasks);
                              }),
                          IconButton(
                              icon: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.amber[300],
                                  ),
                                  child:  Icon(
                                    Icons.wb_incandescent,
                                    color: widget.tasks.pinned == 1 ? Colors.orange : Colors.white,
                                  )),
                              onPressed: () {
                                setState(() {
                                  if (widget.tasks.pinned == 0) {
                                    widget.tasks.pinned = 1;
                                  } else {
                                    widget.tasks.pinned = 0;
                                  }
                                  widget.helper.upDateTask(widget.tasks);
                                  widget._getAllTasks();
                                });
                              }),
                          IconButton(
                              icon: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green,
                                  ),
                                  child: const Icon(
                                    Icons.done,
                                    color: Colors.white,
                                  )),
                              onPressed: () {
                                setState(() {
                                  widget.tasks.taskDone = 1;
                                  widget.tasks.pinned = 0;
                                  widget.helper.upDateTask(widget.tasks);
                                  widget._getAllTasks();
                                  if (widget._getAllTasksDone != null) {
                                    widget._getAllTasksDone();
                                  }
                                });
                              }),
                        ],
                      )
                    : SizedBox(),
              ),
            if ((_cardBool == true) && (widget.tasks.taskDone == 0) )
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  Container(
                    margin:
                        const EdgeInsets.only(right: 22, bottom: 10.0, top: 0),
                    child: Row(
                      children: [
                        if (widget.tasks.priority != null)
                          Icon(
                            Icons.priority_high,
                            color: widget.tasks.priorityColor,
                            size: 16,
                          ),
                        const Icon(
                          Icons.calendar_today,
                          color: Colors.grey,
                          size: 16,
                        ),
                        Text(
                          widget.tasks.day,
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
          ],
        ),
      ),
    );
  }
}
