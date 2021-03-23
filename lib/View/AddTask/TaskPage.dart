import 'package:flutter/material.dart';
import 'package:taskmanager/Model/taskHelper.dart';

class TaskPage extends StatefulWidget {
  final Task task;
  TaskPage({this.task});
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  Task _editedTask;

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
        backgroundColor: Colors.blue[200],
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
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Start',
                        border: InputBorder.none,
                        suffixIcon: Icon(Icons.calendar_today),
                        contentPadding: EdgeInsets.only(left: 10, top: 15),
                      ),
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
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Due',
                        border: InputBorder.none,
                        suffixIcon: Icon(Icons.calendar_today),
                        contentPadding: EdgeInsets.only(left: 10, top: 15),
                      ),
                    ),
                  ),
                ),
              ],
            )
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
