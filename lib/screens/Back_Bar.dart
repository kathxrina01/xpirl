import 'package:flutter/material.dart';
import 'package:xpirl/xp_service.dart';

class BackBar extends StatelessWidget {
  BackBar({Key? key, required this.title, required this.type})
      : super(key: key);

  XPService service = XPService();
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
            fontFamily: "Righteous",
            fontSize: MediaQuery.of(context).size.height * 0.032,
            color: service.colorList[0],
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
              color: service.colorList[0],
              size: MediaQuery.of(context).size.height * 0.032,
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
              fontFamily: "Righteous",
              fontSize: MediaQuery.of(context).size.height * 0.032,
              color: service.colorList[0],
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}
