import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    Colors.greenAccent,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              // War mal Expanded
              flex: 20,
              child: UserBar(
                dataMap: dataMap,
                colorList: colorList,
                type: 0,
              )),
          // Leiste oben
          Expanded(
              flex: 5,
              child: BackBar(
                title: "Übersicht",
                type: 0,
              )),
          Expanded(
            // War mal Expanded
            flex: 75,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Obx(() {
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
                  }),
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

  Widget buildButtonsBottomRight() {
    return /*Positioned(
          right: 0,
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                        radius: 20, child: Icon(Icons.message_outlined)),
                    Align(
                        alignment: Alignment.topRight,
                        child: CircleAvatar(radius: 5, child: Text("1"))),
                    // TODO an Anzahl der Anfragen anpassen
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                CircleAvatar(
                    radius: 20, child: Icon(Icons.settings_outlined)),
              ],
            ),
          ),
        );*/
        Container();
  }

  _buildCard(String category) {
    return Column(
      children: [
        SizedBox(height: 10), // TODO responsive
        InkWell(
          onTap: () {
            _controller.onDelete(); // TODO weg (war nur für Compiler :D
            // TODO Animation
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CategoryTaskOverviewScreen(category: category)));
          },
          child: Container(
            width: double.infinity,
            height: 120, // TODO responsive
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey,
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      child: Text(
                        category,
                        style: TextStyle(fontSize: 20),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
                Expanded(
                  // Anzeige unten  wie weit
                  flex: 4,
                  child: Row(
                    children: [
                      // TODO flex anpassn an %
                      Expanded(
                        flex: 66,
                        child: Container(
                          height: 5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.lightGreenAccent,
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 34,
                        child: Container(
                          height: 5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
