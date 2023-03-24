import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/xp_state_controller.dart';
import '../model/task.dart';
import '../xp_service.dart';
import 'User_Bar.dart';
import 'home_screen.dart';
import 'task_screen.dart';

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
                flex: 2,
                child: UserBar(dataMap: dataMap, colorList: colorList, type: 0,)),
            Expanded(
              flex: 8,
              child: Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: Stack(
                      // bar on top that tells the category and lets you go back
                      children: [
                        GestureDetector(
behavior: HitTestBehavior.opaque,
                            // -> aus Widget Interaktionselement machen
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.arrow_back)),
                        Align(
                            child: Text(this.widget.category),
                            alignment: Alignment.center),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 95,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
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
                  )
                ],
              ),
            ),
          ],
        ),
      ),
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
                SizedBox(height: 10), // TODO responsive
                GestureDetector(
behavior: HitTestBehavior.opaque,
                  // -> aus Widget Interaktionselement machen
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
                    height: 120, // TODO responsive
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blueGrey,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pinkAccent.withOpacity(0.5),
                          offset: Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 6,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 8,
                                  child: Align(
                                    child: Text(
                                      tasks[index].title,
                                      // TODO Kategorie anpassen
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontFamily: "SourceCodePro",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    alignment: Alignment.centerLeft,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
