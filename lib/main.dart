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

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today), label: "Calendario"),
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "Adicionar"),
      BottomNavigationBarItem(
          icon: Icon(Icons.settings), label: "Configurações"),
    ];
  }

  void pageChanged(int index) {
    setState(() {
      _seletedPage = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      _seletedPage = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: [
        TableCalendarPage(),
        Home(),
        SettingsPage(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildPageView(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _seletedPage,
        onTap: (index) {
          bottomTapped(index);
        },
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Colors.white,
        // type: BottomNavigationBarType.fixed,
        items: buildBottomNavBarItems(),
      ),
    );
  }
}
