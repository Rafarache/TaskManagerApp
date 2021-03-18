import 'package:flutter/material.dart';
import 'Widgets/card.dart';
import 'Widgets/quickTask.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEF3F2),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            print("ola");
          },
          child: Icon(Icons.menu_open),
        ),
        centerTitle: true,
        title: Text('Task Manager'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: null,
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: null,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                print('Clicou');
              },
              child: QuickTask(),
            ),
            SizedBox(height: 40),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'Upcoming(4)',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(width: 20),
                Text('Done(13)')
              ],
            ),
            SizedBox(height: 30),
            CardTask(),
            SizedBox(height: 30),
            CardTask(),
            SizedBox(height: 30),
            CardTask(),
          ],
        ),
      ),
    );
  }
}
