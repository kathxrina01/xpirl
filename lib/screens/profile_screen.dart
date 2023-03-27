import 'dart:math';
import 'package:xpirl/xp_service.dart';
import 'package:flutter/material.dart';
import 'package:xpirl/screens/achievement_screen.dart';
import 'package:xpirl/screens/friends_screen.dart';
import '../model/task.dart';
import '../model/user.dart';
import '../model/user_has_tasks.dart';
import 'Back_Bar.dart';
import 'User_Bar.dart';
import 'package:xpirl/screens/Set_and_Not_Button.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  XPService service = XPService();
  List<Task> tasks = [];
  List<String> categories = [];
  List<Map<String, dynamic>> friendsreq = [    {'name': 'Max', 'avatar': Icons.person, 'task': 'Hausaufgaben'},    {'name': 'Lisa', 'avatar': Icons.person, 'task': 'Einkaufen'},    {'name': 'Tom', 'avatar': Icons.person, 'task': 'Gartenarbeit'},  ];


  // args
  User? currentUser;
  List<UserHasTasks>? taskListAll;


  List<Map<String, dynamic>> achievements = [
    {'name': 'Der Puls senkt sich'},
    {'name': 'Ahoy Abenteuer'},
    {'name': 'Breiter als der Türsteher'},
  ];

  int whichU = 0;
  List<String> text = [];
  List<String> image = [];

  @override
  Widget build(BuildContext context) {
    print("juuup");
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


    print(currentUser?.getUsernameShort());
    //var levelPercent = ((currentUser?.getLevelXP() ?? 0)-(service.levelXP[(currentUser?.getCurrentLevel() ?? 0) - 1]))/((service.levelXP[(currentUser?.getCurrentLevel() ?? 0)])-(service.levelXP[(currentUser?.getCurrentLevel() ?? 1) - 1]));
    var levelPercent = 0.5;
    print("juuup");
    return Scaffold(
      backgroundColor: service.colorList[1],
      body: Column(
        children: [
          Expanded(
            // Leiste oben
            flex: 20,
            child: UserBar(type: 1, user: currentUser,),
          ),
          Expanded(
          flex: 5,
            child: BackBar(title: "Profil", type: 1),
          ),
          Expanded(
            flex: 75,
            child: Padding(
              padding: EdgeInsets.all(sqrt(MediaQuery.of(context).size.height * MediaQuery.of(context).size.width) * 0.01),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        // TODO: navigate to profile picture change screen
                      },
                      child: Stack(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage(currentUser?.getAvatar() ?? 'assets/sadcat.jpeg'),
                            radius: MediaQuery.of(context).size.width * 0.1,
                          ),
                          Positioned.fill(
                            child: Opacity(
                              opacity: 0.6,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Profilbild wechseln',
                                    style: TextStyle(
                                      color: service.colorList[1],
                                      fontSize: MediaQuery.of(context).size.height * 0.015,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "SourceCodePro",
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:EdgeInsets.all(MediaQuery.of(context).size.height * 0.005),
                      child: Text(
                        "Level " +( currentUser?.getCurrentLevel().toString() ?? ""),
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.022,
                          fontWeight: FontWeight.bold,
                          fontFamily: "SourceCodePro",
                          color: service.colorList[0],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(flex: 30, child: SizedBox()),
                        Expanded(
                          flex: 40,
                          child: Stack(
                            children: [Container(
                              height: MediaQuery.of(context).size.height * 0.024,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: (levelPercent * 100).toInt(),
                                    child: Container(
                                    height: MediaQuery.of(context).size.height * 0.024,
                                    decoration: BoxDecoration(
                                      //TODO entscheidenmit oder ohne opacity
                                      color: service.colorList[4],
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  ),Expanded(
                                    flex: 100 - (levelPercent * 100).toInt(),
                                    child: SizedBox(),
                                  ),

                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: MediaQuery.of(context).size.height * 0.004),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    (currentUser?.getLevelXP().toString() ?? '') + '/' + ((service.levelXP[(currentUser?.getCurrentLevel() ?? 0)]).toString() ?? '') + 'XP', // TODO Backend  Darf nicht Null sein
                                    style: TextStyle(
                                      color: service.colorList[0],
                                      fontSize: MediaQuery.of(context).size.height * 0.018,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "SourceCodePro",
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(flex: 30, child: SizedBox()),
                      ],
                    ),
                    //Name ändern
                    /* Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 80, right: 80, top: 15),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Neuer Username',
                      hintStyle: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                      ),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.black.withOpacity(0.7),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(
                          color: Colors.lightGreenAccent.withOpacity(0.5),
                          width: 2.0,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0), // Anpassen der Innenabstände
                      isDense: true, // Verkleinert den Abstand um das Textfeld herum
                    ),
                  ),
                ),
          ), */
                    /*
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Container(
                        child: ElevatedButton(
                          onPressed: () {
                            //TODO: implement button action
                          },
                          child: Text('Änderungen speichern'),
                          style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(
                              fontSize: 15,
                              fontFamily: "SourceCodePro",
                              //fontFamily: "JosefinSans",
                            ),

                            backgroundColor: Color.fromARGB(255, 113, 127, 143),
                            minimumSize: Size(50, 30),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                          ),
                        ),
                      ),
                    ),
                    const Expanded(
                      // War mal Expanded
                      flex: 6,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                      ),
                    ),*/
                    SizedBox(height: MediaQuery.of(context).size.height * 0.035,),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Erfolge',
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height * 0.034,
                          fontFamily: "Righteous",
                          color: service.colorList[0],
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.008,),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: GridView.builder(
                        shrinkWrap: true,
                        itemCount: achievements.length < 3 ? achievements.length : 3,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          //mainAxisSpacing: 16,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              Icon(
                                Icons.emoji_events,
                                color: Colors.black.withOpacity(0.7),
                                size: MediaQuery.of(context).size.height * 0.055,
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                              Text(
                                achievements[index]['name'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.height * 0.018,
                                    fontFamily: "SourceCodePro",
                                  color: service.colorList[0],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.001,),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: Duration(milliseconds: 500),
                              pageBuilder: (_, __, ___) => AchievementScreen(),
                              transitionsBuilder: (_, animation, __, child) {
                                return ScaleTransition(
                                  scale: Tween(begin: 0.0, end: 1.0).animate(
                                    CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.fastOutSlowIn,
                                    ),
                                  ),
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        child: Text('Alle Erfolge',
                          style: TextStyle(color: service.colorList[1]),
                        ),
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(
                            fontSize: MediaQuery.of(context).size.height * 0.018,
                            fontFamily: "SourceCodePro",
                            color: service.colorList[1],
                          ),
                          backgroundColor: service.colorList[2],
                          minimumSize: Size(70, 25),
                          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.02),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.035,),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Freunde',
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height * 0.034,
                            fontFamily: "Righteous",
                          color: service.colorList[0],
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.008,),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: text.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          //mainAxisSpacing: 16,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage(
                                  image[index],
                                ),
                                //radius: 25,
                                radius: MediaQuery.of(context).size.height * 0.055 / 2,
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                              Text(
                                text[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.height * 0.018,
                                  fontFamily: "SourceCodePro",
                                  color: service.colorList[0],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.001,),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: Duration(milliseconds: 500),
                              pageBuilder: (_, __, ___) => FriendsScreen(),
                              settings: RouteSettings(arguments: {
                                'user': currentUser,
                                'taskListAll': taskListAll,
                              }),
                              transitionsBuilder: (_, animation, __, child) {
                                return ScaleTransition(
                                  scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                                    CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.fastOutSlowIn,
                                    ),
                                  ),
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        child: Text('Alle Freunde',
                          style: TextStyle(color: service.colorList[1]),),
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(
                            fontSize: MediaQuery.of(context).size.height * 0.018,
                            fontFamily: "SourceCodePro",
                            color: service.colorList[1],
                          ),
                          backgroundColor: service.colorList[2],
                          minimumSize: Size(70, 25),
                          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.02),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: SetandNotButton(currentUser: currentUser),
    );
  }
}
