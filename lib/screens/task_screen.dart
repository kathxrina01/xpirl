import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/xp_state_controller.dart';
import '../model/task.dart';
import '../model/user.dart';
import '../model/user_has_tasks.dart';
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

  // args
  User? currentUser;
  List<UserHasTasks>? taskListAll;

  bool _isButtonPressed = false;


  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    currentUser = args['user'];
    taskListAll = args['taskListAll'];

    return Scaffold(
      backgroundColor: service.colorList[1],
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 20,
              child: UserBar(
                type: 0,
                user: currentUser,
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
    List<String> friends = [    "Freund 1",    "Freund 2",    "Freund 3",    "Freund 4",    "Freund 5"  ];

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: service.colorList[1],
            title: Text("Freunde zur Task hinzufügen",
              style: TextStyle(fontFamily: "SourceCodePro", color: service.colorList[0],),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: friends.map((friend) {
                  return ListTile(
                    leading: GestureDetector(
                      onTapDown: (TapDownDetails details) {
                        RenderBox box = context.findRenderObject() as RenderBox;
                        Offset position = box.localToGlobal(details.globalPosition);
                        _showProfileMenu(context, position);
                      },
                      child: CircleAvatar(
                        child: Text(friend[0]),
                      ),
                    ),
                    title: Text(friend),
                    trailing: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        // Hier können Sie den Freund zur Task hinzufügen
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text("Schließen"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
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
