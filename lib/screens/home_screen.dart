import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xpirl/model/user_has_tasks.dart';
import 'package:xpirl/screens/category_task_overview_screen.dart';

import '../controller/xp_state_controller.dart';
import '../model/task.dart';
import '../model/user.dart';
import '../xp_service.dart';
import 'Back_Bar.dart';
import 'User_Bar.dart';
import 'package:xpirl/screens/Set_and_Not_Button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XPStateController _controller = Get.find();

  XPService service = XPService();

  // args
  User? currentUser;
  List<UserHasTasks>? taskListAll;

  List<Task> tasks = [];
  List<String> categories = [];
  String username = '';

  List<UserHasTasks> userTasks = [];

  bool notClaimedToday = true;

  // Load to-do list from the server
  Future<bool> _loadUsers() async {
    tasks = await service.getTaskList();
    return true;
  }

  Future<bool> _loadCategories() async {
    categories = await service.getCategoryList();
    await _loadUserHasTasks();
    await _loadAllTasks();
    return true;
  }

  List<Task> allTasks = [];
  Future<bool> _loadAllTasks() async {
    allTasks = (await service.getTaskList())!;
    return true;
  }

  /*Future<String> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? '';
  }*/

  final dataMap = <String, double>{
    "User": 5, // Aktueller XP Wert von User
  };

  final colorList = <Color>[
    Color.fromARGB(255, 68, 217, 41),
  ];

  Future<bool> _loadUserHasTasks() async {
    userTasks = (await service.getUserHasTaskListAll(currentUser?.id))!;
    return true;
  }

  int getPercentageForCategory(String category) {
    int achieved = 0;
    int notAchieved = 0;
    for (Task nextTask in allTasks) {
      for (UserHasTasks userTask in userTasks) {
        if (nextTask.category == category) {
          if (nextTask.id == userTask.whichTask[0]) {
            if (userTask.status == 1) {
              achieved++;
            } else {
              notAchieved++;
            }
          }
        }
      }
    }
    if (achieved == 0 && notAchieved == 0) notAchieved = 1;
    int result = achieved + notAchieved;
    result = ((achieved * 100) / result).round();

    if (category == "Daily" && achieved == 8 && notClaimedToday) {
      // User bekommt ein Ticket
      notClaimedToday = false;
    }
    //int result = ((achieved / (achieved + notAchieved)) * 100).round();
    return result;
  }

  bool _isUnlocked = false;
  //int _buttonId = 1; // Unique ID for the button

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    currentUser = args['user'];
    taskListAll = args['taskListAll'];

    return Scaffold(
      backgroundColor: service.colorList[1],
      body: Column(
        children: [
          Expanded(
              flex: 20,
              child: UserBar(
                type: 0,
                user: currentUser,
              )),
          Expanded(
              flex: 5,
              child: BackBar(
                title: "Übersicht",
                type: 0,
              )),
          Expanded(
            flex: 75,
            child: Padding(
              padding: EdgeInsets.all(sqrt(MediaQuery.of(context).size.height *
                      MediaQuery.of(context).size.width) *
                  0.01),
              child: Stack(
                children: [
                  Obx(
                    () {
                      int change = _controller.somethingChanged.value;
                      return FutureBuilder<bool>(
                        future: _loadCategories(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return _buildListView(snapshot);
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }
                          return CircularProgressIndicator();
                        },
                      );
                    },
                  ),
                  //buildButtonsBottomRight(),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: SetandNotButton(),
    );
  }

  _buildCard(String category) {
    _isUnlocked = currentUser?.checkUserUnlockedCategory(category) ?? false || false;
    return Column(
      children: [
        InkWell(
          onTap: () {
            _controller.onDelete(); // TODO weg (war nur für Compiler :D
            // TODO Animation
            _isUnlocked = (currentUser?.getUnlockedCategories().contains(category) ?? false) || false;
            if (_isUnlocked == true) {

              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 500),
                  pageBuilder: (_, __, ___) => CategoryTaskOverviewScreen(category: category),
                  settings: RouteSettings(arguments: {
                    'user': currentUser,
                    'taskListAll': taskListAll,
                  }),
                  transitionsBuilder: (_, animation, __, child) {
                    return SlideTransition(
                      position: Tween(
                        begin: Offset(1, 0),
                        end: Offset(0, 0),
                      ).animate(animation),
                      child: child,
                    );
                  },
                ),
              );

            }
          },
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.17,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.height * 0.015),
              color: _isUnlocked ? service.colorList[3] : service.colorList[2],
              boxShadow: [
                BoxShadow(
                  color:
                      _isUnlocked ? service.colorList[4] : service.colorList[5],
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(flex: 5, child: Container()),
                Expanded(
                  flex: 80,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 8,
                        child: Align(
                          child: Text(
                            category,
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.038,
                              fontFamily: "SourceCodePro",
                              fontWeight: FontWeight.bold,
                              color: service.colorList[0],
                            ),
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                      Expanded(
                        // Anzeige unten  wie weit
                        flex: 2,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Row(
                            children: [
                              // TODO flex anpassn an %
                              Expanded(
                                flex: getPercentageForCategory(category),
                                child: Container(
                                  height: 5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        MediaQuery.of(context).size.height *
                                            0.015),
                                    color: service.colorList[4],
                                  ),
                                ),
                              ),

                              Expanded(
                                flex: 100 - getPercentageForCategory(category), // TODO hier auch
                                child: Container(
                                  height: 5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        MediaQuery.of(context).size.height *
                                            0.015),
                                    color: Colors.black12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 15,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (!_isUnlocked)
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: service.colorList[1],
                                  title: Text('Kategorie freischalten',
                                    style: TextStyle(fontFamily: "Righteous", color: service.colorList[0]),
                                  ),
                                  content: Text(
                                      'Möchtest du diese Kategorie für 250 Goldmünzen freischalten?',
                                  style: TextStyle(fontFamily: "SourceCodePro", color: service.colorList[0]),),
                                  actions: [
                                    TextButton(
                                      child: Text('Abbrechen',
                                      style: TextStyle(fontFamily: "SourceCodePro", color: service.colorList[2]),),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: service.colorList[2], // Hintergrundfarbe des Buttons
                                      ),
                                      child: Text('Freischalten',
                                        style: TextStyle(fontFamily: "SourceCodePro", color: service.colorList[1]),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        _buyCategory(category);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.lock),
                          iconSize: sqrt(MediaQuery.of(context).size.height * MediaQuery.of(context).size.width) * 0.05,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.008),
      ],
    );
  }

  Widget _buildListView(AsyncSnapshot<bool> snapshot) {
    return Container(
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            //final user = tasks[index];
            final category = categories[index];
            return _buildCard(category);
          },
        ),
      ),
    );
  }

  void _buyCategory(String category) {
    if ((currentUser?.getNumCoins() ?? 0) >= 250) {
      setState(() {
        _isUnlocked = true;
        currentUser?.changeNumCoins(-250); // TODO Backend -> Datenbank updaten
        currentUser?.unlockCategory(category);
        currentUser?.saveUser();
      });
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: service.colorList[1],
            title: Text('Nicht genügend Goldmünzen',
                style: TextStyle(fontFamily: "Righteous", color: service.colorList[0])),
            content: Text(
                'Du hast nicht genügend Goldmünzen, um diese Kategorie freizuschalten.',
                style: TextStyle(fontFamily: "SourceCodePro", color: service.colorList[0]),),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: service.colorList[2], // Hintergrundfarbe des Buttons
                ),
                child: Text('OK',
          style: TextStyle(fontFamily: "SourceCodePro", color: service.colorList[1]),),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    }
  }
}
