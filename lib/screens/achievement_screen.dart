import 'dart:math';
import 'package:xpirl/xp_service.dart';
import 'package:flutter/material.dart';
import 'package:xpirl/screens/Back_Bar.dart';

import 'User_Bar.dart';

class AchievementScreen extends StatelessWidget {
  AchievementScreen({Key? key}) : super(key: key);

  XPService service = XPService();

  List<String> achievements = ["Der Puls senkt sich", "Ahoy Abenteuer", "Breiter als der Türsteher","Achtung, Nerd Alarm", "Der Held von nebenan"];
  List<String> descrip = ["4 berufliche Herausforderungen erfolgreich meistern, wie z.B. eine schwierige Präsentation halten", "5 besondere Events erfolgreich besucht haben und eine unvergessliche Erfahrung machen", "Erreiche Level 80", "2 neue Fachgebiete erfolgreich studieren und eine Prüfung bestehen", " 4 ehrenamtliche Tätigkeiten erfolgreich ausgeübt und dabei eine positive Wirkung erzielt haben"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: service.colorList[1],
      body: Column(
        children: [
          Expanded(
              flex: 20,
              child: UserBar(
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
                                              flex: 3,
                                              child: Align(
                                                  alignment: Alignment.bottomLeft,
                                                  child: Text(achievement,style: TextStyle(
                                                      fontSize:
                                                      MediaQuery.of(context).size.height * 0.022, fontFamily: "SourceCodePro", color: service.colorList[0],
                                                    fontWeight: FontWeight.bold,),)),
                                            ),
                                            Expanded(flex: 1,child: SizedBox()),
                                            Expanded(flex: 6,child: Align(alignment: Alignment.topLeft, child: Text(descrip[index],style: TextStyle(
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
                                              children: [Icon(Icons.star_outline, color: service.colorList[0],),
                                                SizedBox(width: MediaQuery.of(context).size.height * 0.006),
                                                Text(
                                                  '500 XP', // TODO Backend
                                                  style: TextStyle(
                                                    fontSize: MediaQuery.of(context).size.height * 0.018,
                                                    fontFamily: "RobotoMono",
                                                    color: service.colorList[0],
                                                  ),
                                                ),],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [Icon(Icons.monetization_on_outlined,
                                                color: service.colorList[0],),
                                                SizedBox(width: MediaQuery.of(context).size.height * 0.006),
                                                Text(
                                                    '20 Coins', // TODO Backend
                                                  style: TextStyle(
                                                    fontSize: MediaQuery.of(context).size.height * 0.018,
                                                    fontFamily: "RobotoMono",
                                                    color: service.colorList[0],
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
