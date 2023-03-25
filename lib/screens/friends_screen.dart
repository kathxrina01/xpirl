import 'dart:math';

import 'package:flutter/material.dart';

import '../xp_service.dart';
import 'Back_Bar.dart';
import 'User_Bar.dart';

class FriendsScreen extends StatelessWidget {
  FriendsScreen({Key? key}) : super(key: key);

  XPService service = XPService();

  final dataMap = <String, double>{
    "User": 5, // Aktueller XP Wert von User
  };

  final colorList = <Color>[
    Color.fromARGB(255, 68, 217, 41),
  ];

  List<String> friends = ["User1", "User2"];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: service.colorList[1],
      body: Column(
        children: [
          Expanded(
              flex: 20,
              child: UserBar(
                dataMap: dataMap,
                colorList: colorList,
                type: 1,
              )),
          Expanded(
              flex: 5,
              child: BackBar(
                title: "Alle Freunde",
                type: 1,
              )),
          Expanded(
              flex: 75,
              child: Padding(
                padding: EdgeInsets.all(sqrt(
                    MediaQuery.of(context).size.height *
                        MediaQuery.of(context).size.width) *
                    0.01),
                child: ListView.builder(
                    itemCount: friends.length,
                    itemBuilder: (context, index) {
                      final friend = friends[index];
                      return Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.17,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.height * 0.015),
                              //color: Colors.blueGrey,
                                color: service.colorList[2],
                              // TODO grauer, wenn nicht freigeschaltet
                              boxShadow: [
                                BoxShadow(
                                  color: service.colorList[5],
                                  // TODO grün, wenn freigeschaltet?
                                  offset: Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(flex: 5, child: SizedBox()),
                                Expanded(
                                  flex: 90,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child: Column(
                                          children: [
                                            Expanded(
                                                flex: 10, child: SizedBox()),
                                            Expanded(
                                                flex: 65,
                                                child: Align(
                                                    alignment:
                                                    Alignment.bottomCenter,
                                                    child: FittedBox(
                                                      fit: BoxFit.fitHeight,
                                                      child: CircleAvatar(
                                                        backgroundImage: AssetImage('assets/sadcat.jpeg'), radius: MediaQuery.of(context).size.width * 0.1,
                                                      ),
                                                    ),),),
                                            Expanded(
                                              flex: 5, child: SizedBox()),
                                            Expanded(
                                              flex: 20,
                                              child: Align(
                                                  alignment:
                                                  Alignment.topCenter,
                                                  child: Text(
                                                    friend,
                                                    style: TextStyle(
                                                      fontSize:
                                                      MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                          0.022,
                                                      fontFamily:
                                                      "SourceCodePro",
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: service.colorList[0],
                                                    ),
                                                  )),
                                            ),
                                            Expanded(
                                                flex: 10, child: SizedBox()),

                                          ],
                                        ),
                                      ),
                                      Expanded(
                                          flex: 3,
                                          child: ElevatedButton(onPressed: () { // Hier passiert in der Zukunft etwas
                                            },child: Text("Zum Profil"),style: ElevatedButton.styleFrom(
                                            textStyle: TextStyle(
                                              fontSize: MediaQuery.of(context).size.height * 0.018,
                                              fontFamily: "SourceCodePro",
                                              color: service.colorList[1],
                                            ),
                                            backgroundColor: service.colorList[2],
                                            minimumSize: Size(70, 35),
                                            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.02),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              side: BorderSide(color: service.colorList[1], width: 2),
                                            ),
                                          ),)),
                                    ],
                                  ),
                                ),
                                Expanded(flex: 5, child: SizedBox()),
                              ],
                            ),
                          ),
                          SizedBox(
                              height:
                              MediaQuery.of(context).size.height * 0.008),
                        ],
                      );
                    }),
              ))
        ],
      ),
    );
  }
}
