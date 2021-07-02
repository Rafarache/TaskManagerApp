import 'package:flutter/material.dart';
import 'package:taskmanager/Model/taskHelper.dart';
import 'package:taskmanager/View/tableCalendar.dart';

import 'HomePage.dart';

class FirsPage extends StatefulWidget {
  @override
  _FirsPageState createState() => _FirsPageState();
}

class _FirsPageState extends State<FirsPage> {
  TaskHelper helper = TaskHelper();
  int _seletedPage = 1;
  PageController pageController =
      PageController(initialPage: 1, keepPage: true);

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today), label: "Calendário"),
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      /* BottomNavigationBarItem(
          icon: Icon(Icons.settings), label: "Configurações"), */
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
          duration: Duration(milliseconds: 300), curve: Curves.ease);
    });
  }

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: [
        TableCalendarPage(helper),
        Home(helper),
        //   SettingsPage(),
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
