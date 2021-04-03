import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskmanager/Model/taskHelper.dart';

class TaskPage extends StatefulWidget {
  final Task task;
  TaskPage({this.task});
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  Task _editedTask;
  String date1 = DateTime.now().toString();

  final _titleController = TextEditingController();
  final _subjectController = TextEditingController();
  final _assignedController = TextEditingController();

  void initState() {
    super.initState();
    if (widget.task == null) {
      _editedTask = Task();
    } else {
      _editedTask = Task.fromMap(widget.task.toMap());
      _titleController.text = _editedTask.title;
      _subjectController.text = _editedTask.subject;
      _assignedController.text = _editedTask.assigned;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: null,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor,
          ),
          centerTitle: true,
          title: Text(
            'TaskPage',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0XFFEEF2FA),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 20),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(right: 10),
                    hintText: 'Title',
                    border: InputBorder.none,
                  ),
                  onChanged: (text) {
                    setState(() {
                      _editedTask.title = text;
                    });
                  },
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color(0XFFEEF2FA),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  maxLines: 8,
                  controller: _subjectController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Subject',
                  ),
                  onChanged: (text) {
                    setState(() {
                      _editedTask.subject = text;
                    });
                  },
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color(0XFFEEF2FA),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 20),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: TextField(
                  controller: _assignedController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Assigned',
                  ),
                  onChanged: (text) {
                    setState(() {
                      _editedTask.assigned = text;
                    });
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(
                    width: 170,
                    decoration: BoxDecoration(
                      color: Color(0XFFEEF2FA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ElevatedButton(
                      child: Text(_editedTask.dateStart == null
                          ? "Start"
                          : "Start: ${DateFormat('d MM y').format(_editedTask.dateStart)}"),
                      onPressed: () {
                        showDatePicker(
                          // locale: Locale('us'),
                          helpText:
                              DateFormat('d MMM y').format(DateTime.now()),
                          currentDate: DateTime.now(),
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(DateTime.now().year + 2),
                        ).then(
                          (date) {
                            setState(
                              () {
                                _editedTask.dateStart = date;
                                _editedTask.start =
                                    DateFormat('d m y').format(date);
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Container(
                    width: 170,
                    decoration: BoxDecoration(
                      color: Color(0XFFEEF2FA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ElevatedButton(
                      child: Text("Due"),
                      onPressed: _editedTask.dateStart != null
                          ? () {
                              showDatePicker(
                                // locale: Locale('us'),
                                helpText: DateFormat('d MMM y')
                                    .format(DateTime.now()),
                                currentDate: _editedTask.dateStart != null
                                    ? _editedTask.dateStart
                                    : DateTime.now(),
                                context: context,
                                initialDate: _editedTask.dateStart == null
                                    ? DateTime.now()
                                    : _editedTask.dateStart,
                                firstDate: _editedTask.dateStart != null
                                    ? _editedTask.dateStart
                                    : DateTime.now(),
                                lastDate: DateTime(DateTime.now().year + 2),
                              ).then(
                                (date) {
                                  setState(
                                    () {
                                      _editedTask.dateDue = date;
                                      _editedTask.due =
                                          DateFormat("d MM y").format(date);
                                      _editedTask.diference =
                                          _editedTask.diferenceDate(
                                              _editedTask.dateDue,
                                              _editedTask.dateStart);
                                    },
                                  );
                                },
                              );
                            }
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            if (_editedTask.title.isNotEmpty && _editedTask.title != null) {
              Navigator.pop(context, _editedTask);
            } else {}
          },
          child: Icon(Icons.save),
        ),
      ),
    );
  }
}
