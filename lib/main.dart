import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get.dart';
import 'package:taskmanager/Model/userPreferences.dart';
import 'package:taskmanager/blocs/theme.dart';
import 'View/mainPage.dart';
import 'package:flutter/services.dart';

void main() async {
  Get.lazyPut<ThemeController>(() => ThemeController());
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences().init();
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    ThemeController.to.loadThemeMode();
    return GetMaterialApp(
      theme: ThemeData(
        primaryTextTheme: TextTheme(
          subtitle1: TextStyle(color: Colors.blue),
        ),
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
        accentColor: Colors.grey[400],
        cardColor: Colors.grey[800],
        visualDensity: VisualDensity.adaptivePlatformDensity,
        backgroundColor: Colors.grey[900],
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
    );
  }
}
