import 'package:flutter/material.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:taskmanager/themeChanger.dart';
import 'View/Home/HomePage.dart';
import 'View/Home/TableCalenar/tableCalendar.dart';

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
      home: FirsPage(),
    );
  }
}

class FirsPage extends StatefulWidget {
  @override
  _FirsPageState createState() => _FirsPageState();
}

class _FirsPageState extends State<FirsPage> {
  var _tabPages = [
    TableCalendarPage(),
    Home(),
    Home(),
  ];
  int _currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        currentIndex: _currentIndex,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_today,
            ),
            label: "Calendario",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: "Adicionar",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              IcoFontIcons.gearAlt,
            ),
            label: "Configurações",
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: _tabPages[_currentIndex],
    );
  }
}
