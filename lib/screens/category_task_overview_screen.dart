import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class CategoryTaskOverviewScreen extends StatelessWidget {
  CategoryTaskOverviewScreen({Key? key}) : super(key: key);

  final dataMap = <String, double>{
    "User": 5, // Aktueller XP Wert von User
  };

  final colorList = <Color>[
    Colors.greenAccent,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Expanded(
                flex: 2,
                child: UserBar(dataMap: dataMap, colorList: colorList)),
            Expanded(
                flex: 8,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        GestureDetector(
                            // -> aus Widget Interaktionselement machen
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.arrow_back)),
                        Align(
                            child: Text("Daily"), alignment: Alignment.center),
                      ],
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
