import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xpirl/controller/user_controller.dart';
import '../controller/xp_state_controller.dart';
import '../xp_service.dart';
import 'home_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  XPStateController _controller = Get.put(XPStateController());

  final _formKey = GlobalKey<FormState>();

  XPService service = XPService();

  String username = "";

  loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
    });
  }

  saveUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
   // await UserController.setUser(username);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
  }


  //TODO den rest der seite erst erscheinen lassen, wenn das willkommen vollständig animiert ist
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
              Center(
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/sadcat.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),
              AnimatedTextKit(
                repeatForever: false,
                animatedTexts: [
                  TypewriterAnimatedText(
                    "Willkommen bei XPirl!",
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      decorationColor: Colors.lightGreenAccent,
                      decorationThickness: 2.0,
                      shadows: [
                        Shadow(
                          color: Colors.lightGreenAccent.withOpacity(0.7),
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    speed: Duration(milliseconds: 250),
                  ),
                ],
                totalRepeatCount: 1,
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
                child: TextFormField(
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
                  onChanged: (value) {
                    username = value;
                  },
                  onFieldSubmitted: (value) {
                    submit();
                  },
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(180, 180, 180, 1),
                  elevation: 10,
                  shadowColor: Colors.lightGreenAccent.withOpacity(0.8),
                ),
                child: Text(
                  "Absenden",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    decorationColor: Colors.lightGreenAccent,
                    decorationThickness: 2.0,
                  ),
                ),
                onPressed: () {
                  submit();
                  /*
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    addStringToSF() async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setString('currentUser', "username1");
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                    );
                  }*/
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  submit() {
    if (username.isEmpty) {
      // TODO Fehermeldung -> was eintragen
      print("leeres Feld");
      return;
    }
    saveUsername();
    //saveUsername().then((value) => loadUsername());
    /*
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );*/
  }
}
