import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskmanager/Model/taskHelper.dart';
import 'package:intl/date_symbol_data_local.dart';

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

  int selectedRadio = 0;

  void initState() {
    super.initState();
    if (widget.task == null) {
      _editedTask = Task();
    } else {
      _editedTask = Task.fromMap(widget.task.toMap());
      _titleController.text = _editedTask.title;
      _subjectController.text = _editedTask.subject;
    }
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('pt_BR', null);
    return WillPopScope(
      onWillPop: null,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          title: Text(
            'Criar Tarefa',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin:
                    EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 20),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(right: 10),
                      hintText: 'Título',
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
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    maxLines: 4,
                    controller: _subjectController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Descrição',
                    ),
                    onChanged: (text) {
                      setState(() {
                        _editedTask.subject = text;
                      });
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Prioridade:"),
                  Radio(
                    value: 1,
                    groupValue: selectedRadio,
                    activeColor: Colors.green,
                    onChanged: (value) {
                      print("Radio1: $value");
                      setState(() {
                        selectedRadio = value;
                        _editedTask.priority = value;
                      });
                    },
                  ),
                  Text(
                    "Baixa",
                    style: TextStyle(
                      color: selectedRadio == 1 ? Colors.green : null,
                      fontWeight: selectedRadio == 1 ? FontWeight.bold : null,
                    ),
                  ),
                  Radio(
                    value: 2,
                    groupValue: selectedRadio,
                    activeColor: Colors.orange,
                    onChanged: (value) {
                      print("Radio1: $value");
                      setState(() {
                        selectedRadio = value;
                        _editedTask.priority = value;
                      });
                    },
                  ),
                  Text(
                    "Média",
                    style: TextStyle(
                      color: selectedRadio == 2 ? Colors.orange : null,
                      fontWeight: selectedRadio == 2 ? FontWeight.bold : null,
                    ),
                  ),
                  Radio(
                    value: 3,
                    groupValue: selectedRadio,
                    activeColor: Colors.red,
                    onChanged: (value) {
                      print("Radio1: $value");
                      setState(() {
                        selectedRadio = value;
                        _editedTask.priority = value;
                      });
                    },
                  ),
                  Text(
                    "Alta",
                    style: TextStyle(
                      color: selectedRadio == 3 ? Colors.red : null,
                      fontWeight: selectedRadio == 3 ? FontWeight.bold : null,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2.2,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        child: Text(
                          _editedTask.dateStart == null
                              ? "Início"
                              : "Início: ${DateFormat('d MM y').format(_editedTask.dateStart)}",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: datePickerStart,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2.3,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        child: Text(_editedTask.dateDue == null
                            ? "Fim"
                            : "Fim: ${DateFormat('d MM y', 'pt').format(_editedTask.dateDue)}"),
                        onPressed: _editedTask.dateStart == null
                            ? null
                            : datePickerDue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            if (_editedTask.title.isNotEmpty && _editedTask.title != null) {
              Navigator.pop(context, _editedTask);
            } else {}
          },
          child: Icon(
            Icons.save,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void datePickerStart() {
    showDatePicker(
      helpText: DateFormat('d MMM y', 'pt_Br').format(DateTime.now()),
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
            _editedTask.start = DateFormat('d m y').format(date);
          },
        );
      },
    );
  }

  void datePickerDue() {
    showDatePicker(
      helpText: DateFormat('d MMM y').format(DateTime.now()),
      currentDate: _editedTask.dateStart,
      context: context,
      initialDate: _editedTask.dateStart,
      firstDate: _editedTask.dateStart,
      lastDate: DateTime(DateTime.now().year + 2),
    ).then(
      (date) {
        setState(
          () {
            _editedTask.dateDue = date;
            _editedTask.due = DateFormat("d MM y", 'pt').format(date);
            _editedTask.diference = _editedTask.diferenceDate();
          },
        );
      },
    );
  }
}
