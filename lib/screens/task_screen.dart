import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/xp_state_controller.dart';
import '../model/task.dart';
import '../xp_service.dart';
import 'Back_Bar.dart';
import 'User_Bar.dart';
import 'home_screen.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:xpirl/screens/Set_and_Not_Button.dart';
import 'package:getwidget/getwidget.dart';



class TaskScreen extends StatefulWidget {
  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  // current category that we are in
  XPStateController _controller = Get.find();
  XPService service = XPService();
  List<Task> tasks = [];
  final dataMap = <String, double>{
    "User": 5, // Aktueller XP Wert von User
  };
  final colorList = <Color>[
    Color.fromARGB(255, 217, 37, 166),
  ];

  bool _isButtonPressed = false;
  List<bool> friendCheckboxValues = [false, false, false];
  List<Map<String, dynamic>> selectedFriends = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: service.colorList[1],
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 20,
              child: UserBar(
                dataMap: dataMap,
                colorList: colorList,
                type: 0,
              ),
            ),
            Expanded(
              flex: 5,
              child: BackBar(
                title: "Aufgabe", // TODO Backend?
                type: 1,
              ),
            ),
            Expanded(
              flex: 75,
              child: Padding(
                padding: EdgeInsets.all(sqrt(MediaQuery.of(context).size.height * MediaQuery.of(context).size.width) * 0.01),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.015),
                    color: service.colorList[2],
                    boxShadow: [
                      BoxShadow(
                        color: service.colorList[5],
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  //width: MediaQuery.of(context).size.width - 20, // brauchen wir das?
                  //height: 300,// TODO responsive bzw brauchen wir das überhaupt?
                  child: Padding(
                    padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Titel: Das ist der titel',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height * 0.04,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Righteous",
                            color: service.colorList[0],
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                        Text(
                          'Beschreibung: das ist die beschreibung', // TODO Backend
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height * 0.03,
                            fontFamily: "SourceCodePro",
                            color: service.colorList[0],
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.012),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.star_outline, color: Colors.black),
                            SizedBox(width: MediaQuery.of(context).size.height * 0.006),
                            Text(
                              '200 XP', // TODO Backend
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.height * 0.03,
                                fontFamily: "SourceCodePro",
                                color: service.colorList[0],
                              ),
                            ),
                            SizedBox(width: MediaQuery.of(context).size.height * 0.045),
                            Icon(Icons.monetization_on_outlined,
                                color: Colors.black),
                            SizedBox(width: MediaQuery.of(context).size.height * 0.006),
                            Text(
                              '10 Coins', // TODO Backend
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.height * 0.03,
                                fontFamily: "SourceCodePro",
                                color: service.colorList[0],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.012),
                        GFIconButton(
                          onPressed:(){
                            addFriends();
                          },
                          icon: Icon(Icons.person_add),
                          shape: GFIconButtonShape.circle,
                          color: service.colorList[2],
                          borderSide: BorderSide(color: service.colorList[1], width: MediaQuery.of(context).size.height * 0.003),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.012),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          height: MediaQuery.of(context).size.height * 0.08,
                          width: _isButtonPressed ? MediaQuery.of(context).size.width * 0.4 : MediaQuery.of(context).size.width * 0.45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.015),
                            color: _isButtonPressed
                                ? service.colorList[1]
                                : service.colorList[2],
                            // Ändere die Hintergrundfarbe hier
                            border: Border.all(color: service.colorList[1], width: MediaQuery.of(context).size.height * 0.003),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isButtonPressed = !_isButtonPressed;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.zero,
                            ),
                            child: AnimatedDefaultTextStyle(
                              duration: Duration(milliseconds: 200),
                              style: TextStyle(
                                fontFamily: "SourceCodePro",
                                color: _isButtonPressed
                                    ? service.colorList[0]
                                    : service.colorList[1] // Ändere die Schriftfarbe hier
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Task erledigt',
                                    style: TextStyle(fontFamily:"SourceCodePro", color: service.colorList[0],),
                                  ),
                                  SizedBox(width: MediaQuery.of(context).size.height * 0.012),
                                  Icon(
                                    Icons.check,
                                    color: _isButtonPressed
                                        ? service.colorList[0]
                                        : service.colorList[1],
                                    // Ändere die Schriftfarbe hier
                                    size: MediaQuery.of(context).size.height * 0.025,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SetandNotButton(),
    );
  }

  void addFriends() {
    List<Map<String, dynamic>> friends = [    {      'name': 'Arthur Shelby',      'avatar': AssetImage('assets/sadcat.jpeg'),    },    {      'name': 'Thomas Shelby',      'avatar': AssetImage('assets/sadcat.jpeg'),    },    {      'name': 'Shelby Shelby',      'avatar': AssetImage('assets/sadcat.jpeg'),    },  ];
    //List<bool> friendCheckboxValues = [false, false, false];
    List<bool> selectedFriends = List.from(friendCheckboxValues);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: service.colorList[1],
              title: Text(
                "Freunde zur Task hinzufügen",
                style: TextStyle(
                  fontFamily: "Righteous",
                  color: service.colorList[0],
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: friends.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> friend = entry.value;
                    return GFCheckboxListTile(
                      title: Text(
                        friend['name'],
                        style: TextStyle(
                          fontFamily: 'SourceCodePro',
                          color: service.colorList[0],
                        ),
                      ),
                      avatar: GestureDetector(
                        onTapUp: (TapUpDetails details) {
                          _showProfileMenu(context, details.globalPosition);
                        },
                        child: GFAvatar(
                          backgroundImage: friend['avatar'],
                        ),
                      ),
                      size: 25,
                      activeBgColor: service.colorList[4],
                      type: GFCheckboxType.circle,
                      activeIcon: Icon(
                        Icons.check,
                        size: 15,
                        color: service.colorList[0],
                      ),
                      onChanged: (value) {
                        setState(() {
                          selectedFriends[index] = value;
                        });
                      },
                      value: selectedFriends[index],
                      inactiveIcon: null,
                      inactiveBgColor: service.colorList[1],
                    );
                  }).toList(),
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: service.colorList[2],
                  ),
                  child: Text(
                    "Schließen",
                    style: TextStyle(
                      fontFamily: "SourceCodePro",
                      color: service.colorList[1],
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      friendCheckboxValues = List.from(selectedFriends);
                    });
                  },
                )
              ],
            );

          },
        );
      },
    );
  }



  void _showProfileMenu(BuildContext context, Offset position) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy - 40.0, // Anpassen der Y-Position um 30 Einheiten nach unten
        position.dx + 10,
        position.dy - 40.0,
      ),
      items: [
        PopupMenuItem(
          child: Text('Profil aufrufen',
          style: TextStyle(color: service.colorList[0], fontFamily: "SourceCodePro"),),
          value: 1,
        ),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value == 1) {
        // Hier kann die Aktion ausgeführt werden, wenn "Profil aufrufen" ausgewählt wird
      }
    });
  }
}
