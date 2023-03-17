import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';


//TODO bei bedarf die ganzen shadowColors ändern zu einer farbe, die besser passt


class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(180, 180, 180, 1),
      body: Center(
        child: Container(
          height: 600.0,
          width: 350.0,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //TODO animation soll nicht loopen
              //TODO maybe animation verlangsamen
              AnimatedTextKit(
                repeatForever: false,
                animatedTexts: [
                  TypewriterAnimatedText("Willkommen bei XPirl!",
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      decorationColor: Colors.pink,
                      decorationThickness: 2.0,
                      shadows: [
                        Shadow(
                          color: Colors.pinkAccent.withOpacity(0.5),
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ],
                onTap: () {
                  print("Tap Event");
                },
              ),
              SizedBox(height: 25),
              Container(
                width: 300.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter Your Name',
                    hintStyle: TextStyle(
                      color: Colors.black.withOpacity(0.7),
                    ),
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.black.withOpacity(0.7),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(180, 180, 180, 1),
                  elevation: 10,
                  shadowColor: Colors.pinkAccent.withOpacity(0.5),
                ),
                child: Text(
                  "Absenden",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    decorationColor: Colors.pink,
                    decorationThickness: 2.0,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


