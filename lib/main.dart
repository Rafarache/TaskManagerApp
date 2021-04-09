import 'package:flutter/material.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'View/Home/HomePage.dart';
import 'View/Home/TableCalenar/tableCalendar.dart';
import 'View/SettingsPage/settingsPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var _myTheme = ThemeData(
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
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager App',
      theme: //ThemeData.dark(),
          _myTheme,
      home: FirsPage(),
    );
  }
}

class FirsPage extends StatefulWidget {
  @override
  _FirsPageState createState() => _FirsPageState();
}

class _FirsPageState extends State<FirsPage> {
  var _tabPages = [TableCalendarPage(), Home(), SettingsPage()];

  int _seletedPage = 1;
  PageController pageController =
      PageController(initialPage: 1, keepPage: true);

  void pageChanged(int index) {
    setState(() {
      _seletedPage = index;
    });
  }

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today), label: "Calendario"),
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "Adicionar"),
      BottomNavigationBarItem(
          icon: Icon(Icons.settings), label: "Configurações"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: [
          TableCalendarPage(),
          Home(),
          SettingsPage(),
        ],
        onPageChanged: (index) {
          setState(() {
            pageChanged(index);
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        items: buildBottomNavBarItems(),
        currentIndex: _seletedPage,
        onTap: (index) {
          setState(() {
            pageController = PageController(initialPage: index);
            print(pageController);
          });
        },
      ),
    );
  }
}
