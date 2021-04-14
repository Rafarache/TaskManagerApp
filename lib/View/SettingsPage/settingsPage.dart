import 'package:flutter/material.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taskmanager/blocs/theme.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage();
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _showAcount = false;
  bool _showStyle = false;
  bool _showNotification = false;

  var _darkTheme = ThemeData(
    fontFamily: 'San Francisco',
    primaryColor: Colors.grey[900],
    primaryColorDark: Colors.black54,
    accentColor: Colors.grey[500],
    brightness: Brightness.dark,
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
  );
  var _lightTheme = ThemeData(
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
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text(
          'Configurações',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              setState(() {
                _showAcount = !_showAcount;
                _showStyle = false;
                _showNotification = false;
              });
            },
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Conta",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Icon(Icons.chevron_right)
                ],
              ),
            ),
          ),
          _showAcount == true
              ? Column(
                  children: [
                    Divider(),
                    Container(
                      height: 30,
                      width: 30,
                      color: Colors.blue,
                    ),
                  ],
                )
              : SizedBox(),
          Divider(),
          GestureDetector(
            onTap: () {
              setState(() {
                _showStyle = !_showStyle;
                _showAcount = false;
                _showNotification = false;
              });
            },
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Aparencia",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Icon(Icons.chevron_right)
                ],
              ),
            ),
          ),
          _showStyle == true
              ? Column(
                  children: [
                    Divider(),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(IcoFontIcons.moon),
                          onPressed: () => _themeChanger.setTheme(_darkTheme),
                        ),
                        IconButton(
                          icon: Icon(Icons.wb_sunny),
                          onPressed: () => _themeChanger.setTheme(_lightTheme),
                        ),
                      ],
                    ),
                  ],
                )
              : SizedBox(),
          Divider(),
          GestureDetector(
            onTap: () {
              setState(() {
                _showNotification = !_showNotification;
                _showAcount = false;
                _showStyle = false;
              });
            },
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Notificação",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Icon(Icons.chevron_right)
                ],
              ),
            ),
          ),
          _showNotification == true
              ? Column(
                  children: [
                    Divider(),
                    Container(
                      height: 30,
                      width: 30,
                      color: Colors.red,
                    ),
                  ],
                )
              : SizedBox(),
          Divider(),
        ],
      ),
    );
  }
}
