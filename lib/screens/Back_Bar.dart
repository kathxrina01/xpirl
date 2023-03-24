import 'package:flutter/material.dart';

class BackBar extends StatelessWidget {
  BackBar({Key? key, required this.title, required this.type})
      : super(key: key);

  final String title;
  final int type; // 0-> kein Pfeil, 1->mit Pfeil

  @override
  Widget build(BuildContext context) {
    if (this.type == 0) {
      return Align(
        alignment: Alignment.center,
        child: Text(
          this.title,
          style: TextStyle(
            fontFamily: "RobotoMono",
            fontSize: 15,
            color: Colors.black,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }
    return Stack(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 15,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            this.title,
            style: TextStyle(
              fontFamily: "RobotoMono",
              fontSize: 15,
              color: Colors.black,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}