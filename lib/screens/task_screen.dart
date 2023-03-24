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
    Colors.pinkAccent,
  ];

  bool _isButtonPressed = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                title: "Aufgabe",
                type: 1,
              ),
            ),
            Expanded(
              flex: 75,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.blueGrey,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pinkAccent.withOpacity(0.5),
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  width: MediaQuery.of(context).size.width - 20,
                  height: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Titel: Das ist der titel',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Righteous",
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Beschreibung: das ist die beschreibung',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: "RobotoMono",
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.star_outline, color: Colors.black),
                            SizedBox(width: 8),
                            Text(
                              '200 XP',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: "RobotoMono",
                              ),
                            ),
                            SizedBox(width: 16),
                            Icon(Icons.monetization_on_outlined,
                                color: Colors.black),
                            SizedBox(width: 8),
                            Text(
                              '10 Coins',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: "RobotoMono",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        GFIconButton(
                          onPressed:(){
                            addFriends();
                          },
                          icon: Icon(Icons.person_add),
                          shape: GFIconButtonShape.circle,
                          color: Colors.blueGrey,
                          borderSide: BorderSide(color: Colors.white, width: 2.0),
                        ),
                        SizedBox(height: 10),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          height: 40,
                          width: _isButtonPressed ? 200 : 220,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: _isButtonPressed
                                ? Colors.white
                                : Colors.blueGrey,
                            // Ändere die Hintergrundfarbe hier
                            border: Border.all(color: Colors.white, width: 2),
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
                                fontFamily: "RobotoMono",
                                color: _isButtonPressed
                                    ? Colors.black
                                    : Colors
                                        .white, // Ändere die Schriftfarbe hier
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Task erledigt'),
                                  SizedBox(width: 10),
                                  Icon(
                                    Icons.check,
                                    color: _isButtonPressed
                                        ? Colors.black
                                        : Colors.white,
                                    // Ändere die Schriftfarbe hier
                                    size: 20,
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
            title: Text("Freunde zur Task hinzufügen"),
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
          child: Text('Profil aufrufen'),
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
