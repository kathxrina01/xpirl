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
                      Align(child: Text("Daily"), alignment: Alignment.center),
                    ],
                  ),
                  Container(color: Colors.grey, height: 20, width: double.infinity,),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            SizedBox(height: 10), // TODO responsive
/*                            GestureDetector(
                              // -> aus Widget Interaktionselement machen
                              onTap: () {
                                // TODO Animation
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CategoryTaskOverviewScreen()));
                              },
                              child: Container(
                                width: double.infinity,
                                height: 120, // TODO responsive
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey,
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
                                                      "Daily",
                                                      // TODO Kategorie anpassen
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                    alignment:
                                                        Alignment.centerLeft,
                                                  )),
                                              Expanded(
                                                  flex: 2,
                                                  child: Icon(Icons
                                                      .lock_outline_rounded)),
                                              // TODO nur anzeigen, wenn noch nicht freigeschlten
                                            ],
                                          )),
                                      Expanded(
                                        flex: 4,
                                        child: Row(
                                          children: [
                                            // TODO flex anpassn an %
                                            Expanded(
                                              flex: 66,
                                              child: Container(
                                                height: 5,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color:
                                                      Colors.lightGreenAccent,
                                                ),
                                              ),
                                            ),

                                            Expanded(
                                              flex: 34,
                                              child: Container(
                                                height: 5,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
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
                            ),*/
                          ],
                        );
                      },
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
}
