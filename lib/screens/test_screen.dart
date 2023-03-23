import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:xpirl/screens/home_screen.dart';

import '../controller/xp_state_controller.dart';

class TestScreen extends StatefulWidget {


  TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  // Dieser Screen dient lediglich Testfällen.
  XPStateController _controller = Get.put(XPStateController());

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
          GestureDetector(
              onTap: () {
                _controller.onDelete();
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              child: Container(
                height: 200,
                width: 200,
                color: Colors.black12,
              )),
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
            animationDuration: Duration(milliseconds: 0),
          ),
        ],
      ),
    );
  }
}
