import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  List<Task> tasks = [];
  List<String> categories = [];
  String username = '';

  // Load to-do list from the server
  Future<bool> _loadUsers() async {
    tasks = await service.getTaskList();
    return true;
  }

  Future<bool> _loadCategories() async {
    categories = await service.getCategoryList();
    return true;
  }

  Future<String> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? '';
  }

  final dataMap = <String, double>{
    "User": 5, // Aktueller XP Wert von User
  };

  final colorList = <Color>[
    Color.fromARGB(255, 68, 217, 41),
  ];

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
                type: 0,
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
              padding: EdgeInsets.all(sqrt(MediaQuery.of(context).size.height * MediaQuery.of(context).size.width) * 0.01),
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
    return Column(
      children: [
        InkWell(
          onTap: () {
            _controller.onDelete(); // TODO weg (war nur für Compiler :D
            // TODO Animation
            Navigator.push(
                context,
                //PageTransition(type: PageTransitionType.rightToLeftWithFade, child: CategoryTaskOverviewScreen(category: category)));
                MaterialPageRoute(
                    builder: (context) =>
                        CategoryTaskOverviewScreen(category: category)));
          },
          child: Container(
            width: double.infinity,
            height:
                MediaQuery.of(context).size.height * 0.17,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.height * 0.015),
              color: Color.fromARGB(255, 113, 127, 143), // TODO grauer, wenn nicht freigeschaltet
              boxShadow: [
                 BoxShadow(
                  color: Color.fromARGB(150, 217, 37, 166), // TODO grün, wenn freigeschaltet?
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
                              fontWeight: FontWeight.bold
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
                                flex: 66,
                                child: Container(
                                  height: 5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.015),
                                    color: Color.fromARGB(255, 68, 217, 41),
                                  ),
                                ),
                              ),

                              Expanded(
                                flex: 34,
                                child: Container(
                                  height: 5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.015),
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
                    child: Icon(
                      // TODO Daraus einen Button machen -> freischalten (+weg, wenn freigeschaltet)
                        Icons.lock_outline_rounded,
                        size: MediaQuery.of(context).size.height * 0.05)),
              ],
            ),
          ),
        ),
        SizedBox(
            height:
                MediaQuery.of(context).size.height * 0.008),
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
}
