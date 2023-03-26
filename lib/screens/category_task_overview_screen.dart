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
import 'task_screen.dart';
import 'package:xpirl/screens/Set_and_Not_Button.dart';

class CategoryTaskOverviewScreen extends StatefulWidget {
  final String category;

  CategoryTaskOverviewScreen({Key? key, required this.category})
      : super(key: key);

  @override
  State<CategoryTaskOverviewScreen> createState() =>
      _CategoryTaskOverviewScreenState();
}

class _CategoryTaskOverviewScreenState
    extends State<CategoryTaskOverviewScreen> {
  // current category that we are in
  XPStateController _controller = Get.find();

  XPService service = XPService();

  List<Task> tasks = [];

  List<UserHasTasks> userTasks = [];

  // args
  User? currentUser;
  List<UserHasTasks>? taskListAll;

  Future<bool> _loadTasksInCategory() async {
    tasks = await service.getTasksByCategory(this.widget.category);
    await _loadUserHasTasks();
    return true;
  }

  Future<bool> _loadUserHasTasks() async {
    userTasks = (await service.getUserHasTaskListAll(currentUser?.id))!;
    return true;
  }

  bool unlocked = false;

  bool calcUnlocked(int taskID) {
    return userTasks.any((element) => element.whichTask.contains(taskID) && element.status == 1);
  }

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
                )),
            Expanded(
              flex: 5,
              child: BackBar(
                title: "Kategorie",// TODO Kategorie einfügen
                type: 1, // hi
              ),
            ),
            Expanded(
              flex: 75,
              child: Padding(
                padding: EdgeInsets.all(sqrt(MediaQuery.of(context).size.height * MediaQuery.of(context).size.width) * 0.01),
                child: Obx(() {
                  int change = _controller.somethingChanged.value;
                  return FutureBuilder<bool>(
                    future: _loadTasksInCategory(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return _buildListView(snapshot);
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return CircularProgressIndicator();
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SetandNotButton(),
    );
  }

  Container _buildListView(AsyncSnapshot<bool> snapshot) {
    return Container(
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {

            tasks[index].translateTaskTitleFromDatabase();
            unlocked = calcUnlocked(tasks[index].id);

            return Column(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    // TODO Animation
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 500),
                        pageBuilder: (_, __, ___) => TaskScreen(task: tasks[index],),
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
                    // TODO Korrekte leitung
                  },
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.17,
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
                    child: Row(
                      children: [
                        Expanded(flex: 5, child: SizedBox()),
                        Expanded(
                          flex: 90,
                          child: Align(
                            child: Text(
                              tasks[index].titleShort,
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.height * 0.038,
                              color: service.colorList[0],
                              fontFamily: "SourceCodePro",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                        Expanded(flex: 5, child: SizedBox()),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.008),
              ],
            );
          },
        ),
      ),
    );
  }
}
