import 'package:flutter/material.dart';
import 'package:taskmanager/Model/taskHelper.dart';
import 'package:taskmanager/Widgets/TaskCard.dart';

// ignore: must_be_immutable
class SearchPage extends StatefulWidget {
  SearchPage(
      {this.helper, this.getAllTasks, this.getAllTasksDone, this.showTask});
  Function getAllTasks;
  Function getAllTasksDone;
  Function showTask;
  TaskHelper helper = TaskHelper();
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var keyword;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          title: Container(
            padding: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Theme.of(context).cardColor,
            ),
            child: TextField(
              autofocus: true,
              decoration: InputDecoration(
                  hintText: "Buscar Tarefa",
                  border: InputBorder.none,
                  icon: Icon(Icons.search)),
              onChanged: (text) {
                setState(() {
                  keyword = text;
                });
              },
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: FutureBuilder(
            future: widget.helper.searchTask(keyword),
            builder: (context, snapshot) {
              widget.getAllTasks();
              if (snapshot.hasError) print("Error");
              var data = snapshot.data;
              return snapshot.hasData
                  ? TaskCard(widget.helper, data, widget.getAllTasks,
                      widget.getAllTasksDone, widget.showTask, true)
                  : SizedBox();
            },
          ),
        ));
  }
}
