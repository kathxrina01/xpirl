import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter/services.dart';
import 'package:xpirl/screens/category_task_overview_screen.dart';

import '../controller/xp_state_controller.dart';
import '../model/task.dart';
import '../xp_service.dart';

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

  // Load to-do list from the server
  Future<bool> _loadUsers() async {
    tasks = await service.getTaskList();

    return true;
  }

  Future<bool> _loadCategories() async {
    categories = await service.getCategoryList();
    return true;
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
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                  // War mal Expanded
                  flex: 2,
                  child: UserBar(dataMap: dataMap, colorList: colorList)),
              // Leiste oben

              Expanded(
                // War mal Expanded
                flex: 8,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Obx(() {
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
                ),
              ),
            ],
          ),
          Positioned(
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
          ),
        ],
      ),
    );
  }

  _buildCard(String category) {
    return Column(
      children: [
        SizedBox(height: 10), // TODO responsive
        GestureDetector(
          // -> aus Widget Interaktionselement machen
          onTap: () {
            _controller.onDelete(); // TODO weg (war nur für Compiler :D
            // TODO Animation
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CategoryTaskOverviewScreen()));
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
                        category, // TODO Kategorie anpassen
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

class UserBar extends StatelessWidget {
  const UserBar({
    Key? key,
    required this.dataMap,
    required this.colorList,
  }) : super(key: key);

  final Map<String, double> dataMap;
  final List<Color> colorList;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      height: 200,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Expanded(
              flex: 6,
              child: Column(
                children: [
                  Expanded(
                    flex: 6,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "XPirl",
                        style: TextStyle(
                          fontSize: 30, // TODO Responsive machen
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Icon(Icons.monetization_on_outlined),
                        Text("20"), // TODO an User anpassen
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Icon(Icons.airplane_ticket_outlined),
                        Text("0"), // TODO an User anpassen
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Stack(
                children: [
                  /*
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Positioned.fill(child: CircleAvatar(backgroundImage: AssetImage("assets/sadcat.jpeg"), )),
                  ),*/
                  Positioned.fill(
                    child: CircleAvatar(
                      backgroundImage: AssetImage("assets/sadcat.jpeg"),
                    ),
                    // TODO Größe responsive machen
                    bottom: 10,
                    left: 10,
                    right: 10,
                    top: 10,
                  ),
                  //Expanded(child: CircleAvatar(backgroundImage: AssetImage("assets/sadcat.jpeg"), ), flex: 1,),
                  //Expanded(child: CircleAvatar(backgroundImage: AssetImage("assets/sadcat.jpeg"), )),
                  //Container(color: Colors.black, width: 100, height: 100, child: Image.asset("assets/sadcat.jpeg"),),
                  PieChart(
                    // TODO Zu Button machen -> Zu Profil gelangen
                    dataMap: dataMap,
                    chartType: ChartType.ring,
                    baseChartColor: Colors.grey[50]!.withOpacity(0.15),
                    colorList: colorList,
                    chartValuesOptions: ChartValuesOptions(
                      showChartValuesInPercentage: true,
                      showChartValues: false,
                    ),
                    totalValue: 20,
                    // TODO Hier MaxXP von Level + so viel, dass Level von Lvl Kreis bis Lvl Kreis geht
                    initialAngleInDegree: 45,
                    ringStrokeWidth: 12,
                    legendOptions: LegendOptions(showLegends: false),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 30,
                      child: Text(
                        "1",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
