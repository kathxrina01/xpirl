import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/xp_state_controller.dart';
import '../model/task.dart';
import '../xp_service.dart';
import 'home_screen.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';

class TaskScreen extends StatefulWidget {

  @override
  State<TaskScreen> createState() =>
      _TaskScreenState();
}

class _TaskScreenState
    extends State<TaskScreen> {
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
              flex: 2,
              child: UserBar(dataMap: dataMap, colorList: colorList),
            ),
            Expanded(
              flex: 8,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Expanded(
                      flex: 5,
                      child: Stack(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                              size: 15,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Align(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 9.0),
                              child: Text(
                                "Category oder so",
                                style: TextStyle(
                                  fontFamily: "RobotoMono",
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                            alignment: Alignment.topCenter,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Expanded(
                      flex: 5,
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
                                    style: TextStyle(fontSize: 18,  fontFamily: "RobotoMono",),
                                  ),
                                  SizedBox(width: 16),
                                  Icon(Icons.monetization_on_outlined, color: Colors.black),
                                  SizedBox(width: 8),
                                  Text(
                                    '10 Coins',
                                    style: TextStyle(fontSize: 18,  fontFamily: "RobotoMono",),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                height: 40,
                                width: _isButtonPressed ? 200 : 220,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: _isButtonPressed ? Colors.white : Colors.blueGrey, // Ändere die Hintergrundfarbe hier
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
                                      color: _isButtonPressed ? Colors.black : Colors.white, // Ändere die Schriftfarbe hier
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('Task erledigt'),
                                        SizedBox(width: 10),
                                        Icon(
                                          Icons.check,
                                          color: _isButtonPressed ? Colors.black : Colors.white, // Ändere die Schriftfarbe hier
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
          ],
        ),
      ),
    );
  }
}
