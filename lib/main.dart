import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:taskmanager/Model/taskHelper.dart';
import 'package:taskmanager/blocs/theme.dart';
import 'View/Home/HomePage.dart';
import 'View/Home/TableCalenar/tableCalendar.dart';
import 'View/SettingsPage/settingsPage.dart';

void main() {
  Get.lazyPut<ThemeController>(() => ThemeController());
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    ThemeController.to.loadThemeMode();
    return MultiProvider(
      providers: [
        Provider<Task>(create: (_) => Task()),
        Provider<TaskHelper>(create: (_) => TaskHelper()),
      ],
      child: GetMaterialApp(
        theme: ThemeData(
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
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: 'San Francisco',
          primarySwatch: Colors.grey,
          accentColor: Colors.grey,
          cardColor: Colors.grey[900],
          visualDensity: VisualDensity.adaptivePlatformDensity,
          backgroundColor: Colors.grey[800],
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.grey[900],
              centerTitle: true,
              iconTheme: IconThemeData(
                color: Colors.white,
              )),
          accentTextTheme: TextTheme(
            headline6: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        themeMode: ThemeMode.system,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: [const Locale('pt', 'BR')],
        debugShowCheckedModeBanner: false,
        title: 'Task Manager App',
        home: FirsPage(),
      ),
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
