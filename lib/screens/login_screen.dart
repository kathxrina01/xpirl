import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xpirl/controller/user_controller.dart';
import '../controller/xp_state_controller.dart';
import '../model/user.dart';
import '../model/user_has_tasks.dart';
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

  Future<void> saveUsername() async {
    print("1.");
    await service.getUser(username).then((currentUser) {
      //prepareUserID(currentUser!);
      loadUserTasks(currentUser!);
    });
  }

  Future<void> loadUserTasks(User currentUser) async {
    print("UserID: " + currentUser.id.toString());
    await Future.delayed(Duration(seconds: 1));
    await service
        .getUserHasTaskListAll(currentUser?.getId())
        .then((taskListAll) {
      for (UserHasTasks uT5 in taskListAll!) {
        print("uT5: " + uT5.whichUser[0].toString());
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
          settings: RouteSettings(arguments: {
            'user': currentUser,
            'taskListAll': taskListAll,
          }),
        ),
      );
    });
  }

  /*
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
  }*/

  //TODO den rest der seite erst erscheinen lassen, wenn das willkommen vollständig animiert ist
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: service.colorList[2],
      body: Center(
        child: Container(
          height: 600.0,
          width: 350.0,
          decoration: BoxDecoration(
            color: service.colorList[3],
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: service.colorList[1],
              width: 3.0,
            ),
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: service.colorList[1],
                      width: 3.0,
                    ),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/xppotion.jpg'),
                      fit: BoxFit.cover,

                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              AnimatedTextKit(
                repeatForever: false,
                animatedTexts: [
                  TypewriterAnimatedText(
                    "Willkommen bei XPirl!",
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "SourceCodePro",
                      fontSize: 25,
                      decorationColor: service.colorList[4],
                      decorationThickness: 2.0,
                      shadows: [
                        Shadow(
                          color: service.colorList[4],
                          blurRadius: 0,
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Container(
                width: 300.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: service.colorList[1],
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter Your Name',
                    hintStyle: TextStyle(
                      color: service.colorList[0],
                      fontFamily: "SourceCodePro",
                    ),
                    prefixIcon: Icon(
                      Icons.person,
                      color: service.colorList[0],
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
                  backgroundColor: service.colorList[3],
                  foregroundColor: service.colorList[1],
                  elevation: 10,
                  shadowColor: service.colorList[4],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: service.colorList[1], width: 1.5),
                  ),
                ),
                child: Text(
                  "Absenden",
                  style: TextStyle(
                    fontFamily: "SourceCodePro",
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
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
    // Wenn der Benutzername leer ist oder Leerzeichen enthält, geben Sie eine Fehlermeldung aus und kehren Sie zurück
    if (username.isEmpty || username.contains(" ")) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Fehler",
          style: TextStyle(fontFamily: "Righteous", color: service.colorList[0]),),
          content: Text("Bitte geben Sie einen gültigen Benutzernamen ein.",
          style: TextStyle(fontFamily: "SourceCodePro", color: service.colorList[0]),),
          actions: [
            ElevatedButton(
              child: Text('OK',
                style: TextStyle(fontFamily: "SourceCodePro",),
              ),
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: service.colorList[2],
                foregroundColor: service.colorList[1],
              ),
            ),
          ],
        ),
      );
      return;
    }

    saveUsername();

    /*
  saveUsername().then((value) => loadUsername());
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => HomeScreen(),
    ),
  );
  */
  }
}
