import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/xp_state_controller.dart';
import '../model/task.dart';
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

  Future<bool> _loadTasksInCategory() async {
    tasks = await service.getTasksByCategory(this.widget.category);
    return true;
  }

  final dataMap = <String, double>{
    "User": 5, // Aktueller XP Wert von User
  };

  final colorList = <Color>[
    Colors.pinkAccent,
  ];

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
                )),
            Expanded(
              flex: 5,
              child: BackBar(
                title: "Kategorie",// TODO Kategorie einfügen
                type: 1,
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
            return Column(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    // TODO Animation
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                TaskScreen())); // TODO Korrekte leitung
                  },
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.17,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.015),
                      color: Colors.blueGrey, // TODO grauer, wenn nicht freigeschaltet
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pinkAccent.withOpacity(0.5), // TODO grün, wenn freigeschaltet?
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
                              tasks[index].title,
                              // TODO Kategorie anpassen
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.height * 0.038,

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
