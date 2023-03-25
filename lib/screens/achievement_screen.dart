import 'dart:math';

import 'package:flutter/material.dart';
import 'package:xpirl/screens/Back_Bar.dart';

import 'User_Bar.dart';

class AchievementScreen extends StatelessWidget {
  AchievementScreen({Key? key}) : super(key: key);

  final dataMap = <String, double>{
    "User": 5, // Aktueller XP Wert von User
  };

  final colorList = <Color>[
    Colors.greenAccent,
  ];

  List<String> achievements = ["Erfolg1", "Erfolg2"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                title: "Alle Erfolge",
                type: 1,
              )),
          Expanded(
              flex: 75,
              child: Padding(
                padding: EdgeInsets.all(sqrt(MediaQuery.of(context).size.height * MediaQuery.of(context).size.width) * 0.01),
                child: ListView.builder(
                    itemCount: achievements.length,
                    itemBuilder: (context, index) {
                      final achievement = achievements[index];
                      return Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.17,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.height * 0.015),
                              color: Colors.blueGrey,
                              // TODO grauer, wenn nicht freigeschaltet
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.pinkAccent.withOpacity(0.5),
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
                                              flex: 3,
                                              child: Align(
                                                  alignment: Alignment.bottomLeft,
                                                  child: Text(achievement,style: TextStyle(
                                                      fontSize:
                                                      MediaQuery.of(context).size.height * 0.022, fontFamily: "SourceCodePro",
                                                    fontWeight: FontWeight.bold,),)),
                                            ),
                                            Expanded(flex: 1,child: SizedBox()),
                                            Expanded(flex: 6,child: Align(alignment: Alignment.topLeft, child: Text("Hier steht die Beschreibung",style: TextStyle(
                                              fontSize: MediaQuery.of(context).size.height * 0.018,

                                              fontFamily: "SourceCodePro",
                                            ),)))
                                          ],
                                        ),
                                      ),
                                      Expanded(flex: 3,child: Column(
                                        children: [
                                          Expanded(flex: 3, child: SizedBox()),
                                          Expanded(
                                            flex: 2,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [Icon(Icons.star_outline, color: Colors.black),
                                                SizedBox(width: MediaQuery.of(context).size.height * 0.006),
                                                Text(
                                                  '200 XP', // TODO Backend
                                                  style: TextStyle(
                                                    fontSize: MediaQuery.of(context).size.height * 0.018,
                                                    fontFamily: "RobotoMono",
                                                  ),
                                                ),],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [Icon(Icons.monetization_on_outlined,
                                                color: Colors.black),
                                                SizedBox(width: MediaQuery.of(context).size.height * 0.006),
                                                Text(
                                                    '10 Coins', // TODO Backend
                                                  style: TextStyle(
                                                    fontSize: MediaQuery.of(context).size.height * 0.018,
                                                    fontFamily: "RobotoMono",
                                                  ),
                                                ),],
                                            ),
                                          ), Expanded(flex: 3, child: SizedBox()),

                                        ],
                                      ))
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
