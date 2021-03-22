import 'package:flutter/material.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
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
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Title',
                    border: InputBorder.none,
                  ),
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
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Subject',
                  ),
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
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Assigned',
                  ),
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
            Navigator.pop(context);
          },
          child: Icon(Icons.save),
        ),
      ),
    );
  }
}
