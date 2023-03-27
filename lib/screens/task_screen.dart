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
import 'package:xpirl/screens/Set_and_Not_Button.dart';
import 'package:getwidget/getwidget.dart';



class TaskScreen extends StatefulWidget {
  TaskScreen({Key? key, required this.task}) : super(key: key);

  Task task;

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
  int whichU = 0;
  List<String> text = [];
  List<String> image = [];

  UserHasTasks? curentUserTask;

  int userTaskID = 0;

  bool _isButtonPressed = false;
  List<bool> friendCheckboxValues = [false, false, false];
  List<Map<String, dynamic>> selectedFriends = [];

  bool unlocked = false;

  bool calcUnlocked() {
    if (curentUserTask?.status == 1) return true;
    return false;
  }

  List<UserHasTasks> userTasks = [];

  UserHasTasks? currentUserHasTasks;

  Future<bool> _loadUserHasTasks() async {

    userTasks = (await service.getUserHasTaskListAll(currentUser?.id))!;

    //await service.getUserHasTasksByID(currentUser?.id, widget.task.id);
    //print("--> " + userTasks[0].whichTask[0].toString() ?? " ");
    print(widget.task.id.toString());
    await Future.forEach(userTasks, (UserHasTasks userTask) async {
      print("Nö");
      if (userTask.whichTask.contains(widget.task.id)) {print("Huii");
        curentUserTask = userTask;
        return true;
      }
    });
    // print(curentUserTask?.whichTask[0]);
    return true;
  }



  /*@override
  Future<void> setState(VoidCallback fn) async {
    // TODO: implement setState
    super.setState(fn);
    // TODO hier prüfen, ob Task schon erledigt
    print("Ayy");
    await _loadUserHasTasks();
  }*/

  @override
  void initState() {
    super.initState();
    //_loadUserHasTasks();
  }


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
    unlocked = calcUnlocked();

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
                    color: unlocked ? service.colorList[3] : service.colorList[2],
                    boxShadow: [
                      BoxShadow(
                        color: unlocked ? service.colorList[4] : service.colorList[5],
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
                          widget.task.titleShort,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height * 0.04,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Righteous",
                            color: service.colorList[0],
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                        Text(
                          widget.task.description,
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
                              (widget.task.rewardXP.toString() ?? '') + ' XP',
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
                              (widget.task.rewardCoins.toString() ?? '') + ' Coins',
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
                            onPressed: () async {
                              if (!_isButtonPressed) {
                                await _loadUserHasTasks();
                                if (curentUserTask != null) {  // Überprüfen, ob curentUserTask nicht null ist
                                  // Zukunft: In Datenbank in Tabelle UserHasTasks im passenden Eintrag status auf 1 setzen
                                  await service.updateUserHasTasks(id: curentUserTask!.id, data: curentUserTask!);
                                } else {
                                  print('curentUserTask is null');
                                }
                                setState(() {
                                  _isButtonPressed = !_isButtonPressed;
                                });
                              }
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
      floatingActionButton: SetandNotButton(currentUser: currentUser),
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
                        text[index],
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
                          backgroundImage: AssetImage(image[index]),
                        ),
                      ),
                      size: MediaQuery.of(context).size.height * 0.025,
                      activeBgColor: service.colorList[4],
                      type: GFCheckboxType.circle,
                      activeIcon: Icon(
                        Icons.check,
                        size: MediaQuery.of(context).size.height * 0.025,
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
                    backgroundColor: service.colorList[2],
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
