import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskmanager/Model/taskHelper.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

class TaskPage extends StatefulWidget {
  DateTime selectedDay;
  final Task task;
  TaskPage({this.task, this.selectedDay});
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  static const Color guidePrimary = Color(0xFF6200EE);
  static const Color guidePrimaryVariant = Color(0xFF3700B3);
  static const Color guideSecondary = Color(0xFF03DAC6);
  static const Color guideSecondaryVariant = Color(0xFF018786);
  static const Color guideError = Color(0xFFB00020);
  static const Color guideErrorDark = Color(0xFFCF6679);
  static const Color blueBlues = Color(0xFF174378);

  Color dialogPickerColor;
  Task _editedTask;
  DateTime _firstDay = DateTime.now();
  final _titleController = TextEditingController();
  final _subjectController = TextEditingController();
  int selectedRadio = 0;
  bool changeValue = false;

  void initState() {
    dialogPickerColor = Colors.red;
    super.initState();
    if (widget.task == null) {
      _editedTask = Task();
      if (widget.selectedDay != null) {
        setState(() {
          _editedTask.dateDay = widget.selectedDay;
          _editedTask.day =
              DateFormat("d MM y", 'pt').format(widget.selectedDay);
        });
      }
    } else {
      _editedTask = Task.fromMap(widget.task.toMap());
      _titleController.text = _editedTask.title;
      _subjectController.text = _editedTask.subject;
      widget.task.priority = _editedTask.priority;
      selectedRadio = widget.task.priority;
      DateFormat format = DateFormat("d MM y");
      _editedTask.dateDay = format.parse(widget.task.day);
      _editedTask.day = widget.task.day;
      if (_editedTask.diference < 0) {
        setState(() {
          _firstDay = _editedTask.dateDay;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('pt_BR', null);
    return WillPopScope(
      onWillPop: () {
        if (changeValue && widget.task != null) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Descartar Alterações?",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  content: Text("Ao sair, as alterações serão descartadas."),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Descartar",
                        style: TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .subtitle1
                                .color),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        saveTask();
                      },
                      child: Text(
                        "Salvar",
                        style: TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .subtitle1
                                .color),
                      ),
                    ),
                  ],
                );
              });
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text(
            widget.task != null ? _titleController.text : 'Criar Tarefa',
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
                  color: Theme.of(context).accentColor,
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
                        changeValue = true;
                      });
                    },
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
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
                        changeValue = true;
                      });
                    },
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: colorPickerDialog, child: Text("olaaa")),
              Text("Cor da tarefa"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Prioridade:"),
                  Radio(
                    value: 1,
                    groupValue: selectedRadio,
                    activeColor: Colors.green,
                    onChanged: (value) {
                      setState(() {
                        selectedRadio = value;
                        _editedTask.priority = value;
                        changeValue = true;
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
                      setState(() {
                        selectedRadio = value;
                        _editedTask.priority = value;
                        changeValue = true;
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
                      setState(() {
                        selectedRadio = value;
                        _editedTask.priority = value;
                        changeValue = true;
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2.5,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        child: Text(
                          _editedTask.dateDay == null && widget.task == null ||
                                  _editedTask.dateDay == null
                              ? 'Data de conclusao'
                              : "Dia: ${DateFormat('d MM y', 'pt').format(_editedTask.dateDay)}",
                          style: TextStyle(
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .subtitle1
                                  .color),
                        ),
                        onPressed: datePickerDue,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2.5,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        child: Text("SALVAR",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        onPressed: saveTask,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> colorPickerDialog() async {
    return ColorPicker(
      color: dialogPickerColor,
      onColorChanged: (Color color) {
        setState(() {
          dialogPickerColor = color;
          _editedTask.color = color.toString();
        });
      },
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      heading: Text(
        'Selecione uma Cor',
      ),
      subheading: Text(
        'Tonalidade',
      ),
      wheelSubheading: Text(
        'Selected color and its shades',
      ),
      showMaterialName: false,
      showColorName: true,
      showColorCode: false,
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        longPressMenu: true,
      ),
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: true,
        ColorPickerType.primary: false,
        ColorPickerType.accent: false,
      },
    ).showPickerDialog(
      context,
      constraints:
          const BoxConstraints(minHeight: 200, minWidth: 300, maxWidth: 320),
    );
  }

  void saveTask() {
    if (widget.task != null && _editedTask.dateDay == null) {
      _editedTask.day = widget.task.day;
      DateFormat format = DateFormat("d MM y");
      _editedTask.dateDay = format.parse(widget.task.day);
    }
    if (_editedTask.title.isNotEmpty &&
        _editedTask.title != null &&
        _editedTask.dateDay != null) {
      if (_editedTask.subject == null) {
        _editedTask.subject = "";
      }
      Navigator.pop(context, _editedTask);
    } else {}
  }

  void datePickerDue() {
    showDatePicker(
      helpText: DateFormat('d MMM y').format(DateTime.now()),
      currentDate: DateTime.now(),
      context: context,
      initialDate: widget.task != null
          ? DateFormat("d MM y").parse(widget.task.day)
          : _editedTask.dateDay != null
              ? _editedTask.dateDay
              : DateTime.now(),
      //initialDate: _editedTask.dateStart,
      firstDate: _firstDay,
      lastDate: DateTime(DateTime.now().year + 2),
    ).then(
      (date) {
        setState(
          () {
            if (date != null) {
              _editedTask.dateDay = date;
              _editedTask.day = DateFormat("d MM y", 'pt').format(date);
              changeValue = true;
            }
          },
        );
      },
    );
  }
}
