import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Task {
  int id;
  String title;
  String subject;
  String day;
  DateTime dateDay;
  num diference;
  int priority;
  int pinned = 0;
  int taskDone = 0;

  // ignore: missing_return
  Color priorityColor() {
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

  List<Task> done;

  Task();

  Task.fromMap(Map map) {
    id = map[idColumn];
    title = map[titleColumn];
    subject = map[subjectColumn];
    day = map[dayColumn];
    diference = map[diferenceColumn];
    priority = map[priorityColumn];
    pinned = map[pinnedColumn];
    taskDone = map[taskDoneColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      titleColumn: title,
      subjectColumn: subject,
      dayColumn: day,
      diferenceColumn: diference,
      priorityColumn: priority,
      pinnedColumn: pinned,
      taskDoneColumn: taskDone,
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Tarefa:($title,$day)";
  }
}

final String taskTable = "taskTable";
final String idColumn = "idColumn";
final String titleColumn = "titleColumn";
final String subjectColumn = "subjectColumn";
final String dayColumn = "dayColumn";
final String diferenceColumn = "diferenceColumn";
final String priorityColumn = "priorityColumn";
final String pinnedColumn = "pinnedColumn";
final String taskDoneColumn = "taskDoneColumn";

class TaskHelper extends ChangeNotifier {
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

    final path = join(databasesPath, "dataBase.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $taskTable($idColumn INTEGER PRIMARY KEY, $titleColumn TEXT, $subjectColumn TEXT,"
          "$dayColumn TEXT, $diferenceColumn INTEGER, $priorityColumn INTEGER,$pinnedColumn INTEGER,$taskDoneColumn INTEGER)");
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
          dayColumn,
          diferenceColumn,
          pinnedColumn,
          taskDoneColumn,
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
        await dbTask.rawQuery("SELECT COUNT(*) FROM $taskTable"));
  }

  Future close() async {
    Database dbTask = await db;
    await dbTask.close();
  }

  Future<List> getAllTasksDoing() async {
    Database dbTask = await db;
    List listMap = await dbTask.rawQuery(
        "SELECT * FROM $taskTable where $pinnedColumn =0 AND $taskDoneColumn =0 ORDER BY $diferenceColumn");
    List<Task> listTask = [];

    for (Map m in listMap) {
      listTask.add(Task.fromMap(m));
    }
    return listTask;
  }

  Future<List> getAllTasks() async {
    Database dbTask = await db;
    List listMap = await dbTask
        .rawQuery("SELECT * FROM $taskTable ORDER BY $diferenceColumn");
    List<Task> listTask = [];

    for (Map m in listMap) {
      listTask.add(Task.fromMap(m));
    }
    return listTask;
  }

  Future<List> getAPinnedTask() async {
    Database dbTask = await db;
    List listMap = await dbTask.rawQuery(
        "SELECT * FROM $taskTable where $pinnedColumn =1 AND $taskDoneColumn =0  ORDER BY $diferenceColumn");
    List<Task> listTask = [];

    for (Map m in listMap) {
      listTask.add(Task.fromMap(m));
    }
    return listTask;
  }

  Future<List> getTaskDone() async {
    Database dbTask = await db;
    List listMap = await dbTask.rawQuery(
        "SELECT * FROM $taskTable where  $taskDoneColumn =1  ORDER BY $diferenceColumn");
    List<Task> listTask = [];

    for (Map m in listMap) {
      listTask.add(Task.fromMap(m));
    }
    return listTask;
  }
}
