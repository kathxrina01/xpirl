import 'dart:math';
import 'package:xpirl/xp_service.dart';
import 'package:flutter/material.dart';
import '../model/user.dart';
import '../model/user_has_tasks.dart';
import 'Back_Bar.dart';
import 'User_Bar.dart';
import 'package:xpirl/screens/Set_and_Not_Button.dart';

class FriendsScreen extends StatelessWidget {
  FriendsScreen({Key? key}) : super(key: key);

  XPService service = XPService();

  List<String> friends = ["User1", "User2"];
  // args
  User? currentUser;
  List<UserHasTasks>? taskListAll;
  int whichU = 0;
  List<String> text = [];
  List<String> image = [];


  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    currentUser = args['user'];
    taskListAll = args['taskListAll'];

    if(currentUser?.getUsernameShort() == "Cari") {
      whichU = 1;
    }
    if(currentUser?.getUsernameShort() == "Veronika") {
      whichU = 2;
    }
    if(currentUser?.getUsernameShort() == "Blake") {
      whichU = 3;
    }
    if(currentUser?.getUsernameShort() == "Malte") {
      whichU = 4;
    }

    if (whichU == 1) {
      text = ['Blake', 'Malte', 'Veronika'];
      image = ["assets/sadcat.jpeg", "assets/blush.jpg", "assets/yummy.jpg"];
    }
    if (whichU == 2) {
      text = ['Blake', 'Malte', 'Cari'];
      image = ["assets/sadcat.jpeg", "assets/blush.jpg", "assets/mouse.png"];
    }
    if (whichU == 3) {
      text = ['Veronika', 'Malte', 'Cari'];
      image = ["assets/yummy.jpg", "assets/blush.jpg", "assets/mouse.png"];
    }
    if (whichU == 4) {
      text = ['Blake', 'Veronika', 'Cari'];
      image = ["assets/sadcat.jpeg", "assets/yummy.jpg", "assets/mouse.png"];
    }
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
                    itemCount: text.length,
                    itemBuilder: (context, index) {
                      final friend = text[index];
                      return Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.17,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.height * 0.015),
                                color: service.colorList[2],
                              boxShadow: [
                                BoxShadow(
                                  color: service.colorList[4],
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
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          border: Border.all(
                                                            color: Colors.white,
                                                            width: 3.0,
                                                          ),
                                                        ),
                                                        child: CircleAvatar(
                                                          backgroundImage: AssetImage(image[index]),
                                                          radius: MediaQuery.of(context).size.width * 0.1,
                                                        ),
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
      floatingActionButton: SetandNotButton(currentUser: currentUser),
    );
  }
}
