import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xpirl/screens/home_screen.dart';

import '../controller/xp_state_controller.dart';

class TestScreen extends StatelessWidget {

  // Dieser Screen dient lediglich Testfällen.
  // Er ist derzeit notwendig, da HomeScreen über einen Screen aufgerfuen werden muss, bei dem GetX bekannt sein muss, was
  // mit main.dart nicht geht
  XPStateController _controller = Get.put(XPStateController());
  TestScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
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
    );
  }
}
