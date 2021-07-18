import 'package:flutter/material.dart';
import 'package:icofont_flutter/icofont_flutter.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage();
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _showAcount = false;
  bool _showStyle = false;
  bool _showNotification = false;

  @override
  Widget build(BuildContext context) {
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
                      color: Colors.blue,
                      child: Column(
                        children: [
                          Text('EM PROGRESSO!'),
                          Text('EM PROGRESSO!'),
                          Text('EM PROGRESSO!'),
                          Text('EM PROGRESSO!'),
                          Text('EM PROGRESSO!'),
                        ],
                      ),
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                Icon(IcoFontIcons.moon),
                                SizedBox(width: 10),
                                Text("Dark Mode "),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                Icon(Icons.wb_sunny),
                                SizedBox(width: 10),
                                Text("Light Mode: "),
                              ],
                            ),
                          ),
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
                      color: Colors.red,
                      child: Column(
                        children: [
                          Text('EM PROGRESSO!'),
                          Text('EM PROGRESSO!'),
                          Text('EM PROGRESSO!'),
                          Text('EM PROGRESSO!'),
                          Text('EM PROGRESSO!'),
                        ],
                      ),
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
