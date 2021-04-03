import 'package:flutter/material.dart';
import 'package:taskmanager/themeChanger.dart';
import 'View/Home/HomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager App',
      theme: ThemeData(
        fontFamily: 'San Francisco',
        primaryColor: Color(0xFF024ACE),
        primaryColorDark: Color(0xFF024ACE),
        brightness: Brightness.light,
        accentColor: Colors.white,
        backgroundColor: Colors.blue[100],
        appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFF024ACE),
            centerTitle: true,
            iconTheme: IconThemeData(
              color: Colors.white,
            )),
        accentTextTheme: TextTheme(
          headline6: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}
