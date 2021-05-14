import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:taskmanager/Model/taskHelper.dart';
import 'package:taskmanager/View/Home/HomePage.dart';

class TaskCard extends StatefulWidget {
  int index;
  List<Task> tasks;
  List<Task> tasksDone;
  TaskHelper helper;
  TaskCard({this.helper, this.tasks, this.tasksDone, this.index});
  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  int _cardTap = -1;
  bool _cardBool = false;
  bool _favoriteTap = false;
  int _selectedTask = -1;
  bool darkmode = false;
  int _lastRemovedPos;
  Task _lastRemoved;

  Task _lastRemovedDone;
  int _lastRemovedDonePos;

  Widget _showTitle() {
    return Text(
      widget.tasks[widget.index]
          .title, // TITULO -------------------------------------
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 15,
      ),
      maxLines: (_cardTap == widget.index) && (_cardBool == true) ? 2 : 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _showSubject() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8),
      child: Text(
        widget.tasks[widget.index]
            .subject, // DESCRIÇÃO --------------------------------------------
        style: TextStyle(
          color: Colors.grey,
          fontSize: 13,
        ),
        maxLines: (_cardTap == widget.index) && (_cardBool == true) ? 10 : 2,
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
        color: widget.tasks[widget.index].priorityColor(),
      ),
      child: Column(
        children: [
          Text(
            widget.tasks[widget.index].diference > 1
                ? "${widget.tasks[widget.index].diference} "
                : "${widget.tasks[widget.index].diference} ",
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
              widget.tasks[widget.index].due,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _cardTap = widget.index;
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
            widget.tasks != widget.tasksDone
                ? _onDismissed(direction, widget.index)
                : _onDismissedTaskDone(direction, widget.index);
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
                      widget.tasks != widget.tasksDone
                          ? Radio(
                              visualDensity: VisualDensity.compact,
                              value: widget.index,
                              activeColor: Colors.green,
                              groupValue: _selectedTask,
                              splashRadius: 20,
                              onChanged: (value) {
                                setState(() {
                                  _selectedTask = value;
                                });
                                // _taskDone(widget.index);
                              },
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
                (_cardTap == widget.index) && (_cardBool == true)
                    ? Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        width: 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: widget.tasks != widget.tasksDone
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                      icon: Icon(Icons.edit), onPressed: null),
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
  }

  void _onDismissed(direction, index) {
    setState(() {
      //primeiro precisamos copiar o conato a ser excluido para uma variavel
      // essa variavel retornará o contato caso o usuário queira desfazer a exclusão
      _lastRemoved = widget.tasks[index];
      //deletamso o contato do banco de dados
      widget.helper.deleTask(widget.tasks[index].id);
      //deletamos o contato da lista
      widget.tasks.removeAt(index);
      // e copiamos a sua posição, quando o usuário desfaça a eclusão, o contato
      // retornará para sua posição inicial
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
                            style: TextStyle(fontWeight: FontWeight.bold)),
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
  }

  @override
  void initState() {
    super.initState();
    _gestAllTasks();
    widget.tasks.removeRange(0, widget.tasks.length);
  }

  void _gestAllTasks() {
    widget.helper.getAllTasks().then((list) {
      setState(() {
        widget.tasks = list;
      });
    });
  }

  void _onDismissedTaskDone(direction, index) {
    setState(() {
      _lastRemovedDone = widget.tasksDone[index];
      widget.tasksDone.removeAt(index);
      _lastRemovedDonePos = index;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).primaryColor,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.warning, color: Colors.red),
              Flexible(
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
                              text: "\" ${_lastRemovedDone.title}\"",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                          TextSpan(text: " foi removida"),
                        ])),
              ),
            ],
          ),
          action: SnackBarAction(
              textColor: Colors.white,
              label: 'Desfazer',
              onPressed: () {
                setState(() {
                  widget.tasksDone
                      .insert(_lastRemovedDonePos, _lastRemovedDone);
                });
              }),
          duration: Duration(seconds: 3),
        ),
      );
    });
  }
}
