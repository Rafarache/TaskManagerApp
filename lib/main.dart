import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:provider/provider.dart';

import 'package:taskmanager/blocs/theme.dart';
import 'View/Home/HomePage.dart';
import 'View/Home/TableCalenar/tableCalendar.dart';
import 'View/SettingsPage/settingsPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  var _myTheme = ThemeData(
    fontFamily: 'San Francisco',
    primaryColor: Color(0xFF024ACE),
    primaryColorDark: Color(0xFF024ACE),
    accentColor: Colors.white,
    brightness: Brightness.light,
    visualDensity: VisualDensity.adaptivePlatformDensity,
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
  );
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeChanger>(
      create: (_) => ThemeChanger(ThemeData.dark()),
      child: MaterialAppWithTheme(),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [const Locale('pt', 'BR')],
      debugShowCheckedModeBanner: false,
      title: 'Task Manager App',
      theme: theme.getTheme(),
      home: FirsPage(),
    );
  }
}

class FirsPage extends StatefulWidget {
  @override
  _FirsPageState createState() => _FirsPageState();
}

class _FirsPageState extends State<FirsPage> {
  int _seletedPage = 1;
  PageController pageController =
      PageController(initialPage: 1, keepPage: true);

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today), label: "Calendário"),
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
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
          duration: Duration(milliseconds: 400), curve: Curves.decelerate);
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
