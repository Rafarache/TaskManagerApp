import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Task {
  int id;
  String title;
  String subject;
  String assigned;
  String start; // acho que são variáveis desnecessárias, confirma depois
  String due; // acho que são variáveis desnecessárias, confirma depois
  DateTime dateStart;
  DateTime dateDue;
  int diference;
  int priority;

  int diferenceDate() {
    if ((this.dateStart != null) && (this.dateDue != null)) {
      return this.dateDue.difference(DateTime.now()).inDays;
    } else {
      return 0;
    }
  }

//var teste = Timer.periodic(duration, (timer) { });

  // ignore: missing_return
  Color priorityColor() {
    if (diference <= 1) {
      return Colors.red;
    } else {
      switch (this.priority) {
        case 1:
          return Colors.green;
          break;
        case 2:
          return Colors.orange;
          break;
        case 3:
          return Colors.red;
          break;
        default:
          return Colors.purple;
          break;
      }
    }
  }

  List<Task> done;

  Task();

  Task.fromMap(Map map) {
    id = map[idColumn];
    title = map[titleColumn];
    subject = map[subjectColumn];
    assigned = map[assignedColumn];
    start = map[startColumn];
    due = map[dueColumn];
    diference = map[diferenceColumn];
    priority = map[priorityColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      titleColumn: title,
      subjectColumn: subject,
      assignedColumn: assigned,
      startColumn: start,
      dueColumn: due,
      diferenceColumn: diference,
      priorityColumn: priority,
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Task(id: $id, title: $title, subject: $subject, assigned: $assigned,start: $start ,due: $due, diference: $diference, priority: $priority)";
  }
}

final String taskTable = "taskTable";
final String idColumn = "idColumn";
final String titleColumn = "titleColumn";
final String subjectColumn = "subjectColumn";
final String assignedColumn = "assignedColumn";
final String startColumn = "startColumn";
final String dueColumn = "dueColumn";
final String diferenceColumn = "diferenceColumn";
final String priorityColumn = "priorityColumn";

class TaskHelper {
  //TaskHelper poderá possuir apenas 1 único objeto com 1 banco de dados
  static final TaskHelper _instance = TaskHelper.internal();
  factory TaskHelper() => _instance;
  TaskHelper.internal();

  //Essa variável é o banco de dados
  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();

    final path = join(databasesPath, "tasks101.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $taskTable($idColumn INTEGER PRIMARY KEY, $titleColumn TEXT, $subjectColumn TEXT,"
          "$assignedColumn TEXT, $startColumn TEXT, $dueColumn TEXT, $diferenceColumn INTEGER, $priorityColumn INTEGER)");
    });
  }

  Future<Task> saveTask(Task task) async {
    Database dbTask = await db;
    task.id = await dbTask.insert(taskTable, task.toMap());
    return task;
  }

  Future<Task> getTask(int id) async {
    Database dbTask = await db;

    List<Map> maps = await dbTask.query(taskTable,
        columns: [
          idColumn,
          titleColumn,
          subjectColumn,
          assignedColumn,
          startColumn,
          dueColumn,
          diferenceColumn,
        ],
        where: "$idColumn = ?",
        whereArgs: [id]);

    if (maps.length > 0) {
      return Task.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleTask(int id) async {
    Database dbTask = await db;
    return await dbTask
        .delete(taskTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> upDateTask(Task task) async {
    Database dbTask = await db;
    return await dbTask.update(
      taskTable,
      task.toMap(),
      where: "$idColumn = ?",
      whereArgs: [task.id],
    );
  }

  Future<int> getNumber() async {
    Database dbTask = await db;
    return Sqflite.firstIntValue(
      await dbTask.rawQuery("SELECT COUNT(*) FROM $taskTable"),
    );
  }

  Future close() async {
    Database dbTask = await db;
    await dbTask.close();
  }

  Future<List> getAllTasks() async {
    Database dbTask = await db;
    List listMap = await dbTask.rawQuery("SELECT * FROM $taskTable");
    List<Task> listTask = [];

    for (Map m in listMap) {
      listTask.add(Task.fromMap(m));
    }
    return listTask;
  }
}
