import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user.dart';
import '../xp_service.dart';
import 'profile_screen.dart';

class UserBar extends StatefulWidget {
  const UserBar({
    Key? key,
    required this.dataMap,
    required this.colorList,
    required this.type,
  }) : super(key: key);

  final Map<String, double> dataMap;
  final List<Color> colorList;
  final int type;

  @override
  State<UserBar> createState() => _UserBarState();
}

class _UserBarState extends State<UserBar> {
  User? user;
  var levelXP = 0;
  var numCoins = 0;
  var tickets = 0;
  late int _type;

  final Map<String, double> dataMap1 = <String, double>{
    "User": 5, // Aktueller XP Wert von User
  };
  final List<Color> colorList1 = <Color>[
    Color.fromARGB(255, 68, 217, 41),
  ];

  XPService service = XPService();

  String? username;

  Future<String> loadUsername() async {
    print("loadUsername() ausgeführt");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String loadedUsername = await prefs.getString('username') ?? '';
    return loadedUsername;
    /*
    setState(() {
      username = loadedUsername;
    });

    getUser();*/
  }

  Future<User?> getUser() async {
    print("getUser() ausgeführt");
    String currentUsername = username ?? await loadUsername();
    return await service.getUser(currentUsername);
    /*
    setState(() {
      user = currentUser;
    });
    print("XP: " + user!.getLevelXP().toString());*/
    return user;
  }

  Future<String?> loadNumCoins() async {
    print("loadNumCoins() ausgeführt");
    User? currentUser = user ?? await getUser();
    return currentUser?.numCoins.toString();
  }

/*
  loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
    });
  }*/

  /*
  Future<bool> _loadUser() async {
    user = await service.getUser();
    return true;
  }*/

  /*
  loadUserStats() async {
    user = await service.getUser(username);
    levelXP = user?.getLevelXP();
    numCoins = user?.getNumCoins();

    return true;
  }*/

  @override
  void initState() {
    super.initState();
    _type = widget.type;
    loadUsername();
    // loadUserStats();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: service.colorList[2],
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: Column(
                children: [
                  Expanded(
                    flex: 6,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'XPirl',
                        style: TextStyle(
                          fontSize: 30, // TODO Responsive machen
                          fontFamily: "Righteous",
                          shadows: [
                            Shadow(
                              color: Color.fromARGB(255, 68, 217, 41),
                              blurRadius: 1,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Icon(Icons.monetization_on_outlined),
                        /*FutureBuilder<String?>(
                          future: loadNumCoins(),
                          builder: (BuildContext context,
                              AsyncSnapshot<String?> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator(); // Ladeindikator anzeigen
                            } else if (snapshot.hasError) {
                              return Text(
                                  "Fehler beim Laden"); // Fehlermeldung anzeigen
                            } else {
                              return Text(
                                  snapshot.data ?? '0'); // Text anzeigen
                            }
                          },
                        ),*/
                        Text("0"),
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
              child: buildRightPart(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRightPart(BuildContext context) {
    return _type == 0 ? buildProfile(context) : buildUsername(context);
  }

  Widget buildProfile(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          // TODO Animation
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ProfileScreen()));
        },
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: CircleAvatar(
                  backgroundImage: AssetImage("assets/sadcat.jpeg"),
                ),
              ),
              // TODO Größe responsive machen
              //bottom: MediaQuery.of(context).size.height * 0.01,
              //left: MediaQuery.of(context).size.height * 0.01,
              //right: MediaQuery.of(context).size.height * 0.01,
              //top: MediaQuery.of(context).size.height * 0.01,
              //right: 0,
            ),
            Positioned.fill(
              //right: 0,
              child: IgnorePointer(
                ignoring: true,
                child: GFProgressBar(
                  percentage: 0.1,
                  // TODO according to levelXP
                  // width:100,
                  circleWidth: MediaQuery.of(context).size.height * 0.015,
                  radius: MediaQuery.of(context).size.height * 0.178,
                  type: GFProgressType.circular,
                  backgroundColor: Colors.black12,
                  progressBarColor: colorList1[0],
                  circleStartAngle: 145,
                ),
              ),
              //bottom: MediaQuery.of(context).size.height * 0.01,
              // left: MediaQuery.of(context).size.height * 0.01,
              // right: MediaQuery.of(context).size.height * 0.01,
              //top: MediaQuery.of(context).size.height * 0.01,
            ),
            Positioned(
              right: MediaQuery.of(context).size.width * 0.06,
              bottom: 0,
              child: CircleAvatar(
                backgroundColor: Colors.black,
                radius: MediaQuery.of(context).size.height * 0.03,
                child: Text(
                  "1", // TODO Level anpassen
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
    );
  }

  Widget buildUsername(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Text(
        "Username",
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.height *
              0.035,
          fontFamily: 'Righteous',
          //fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: Color.fromARGB(255, 68, 217, 41),
              blurRadius: 1,
              offset: Offset(2, 2),
            ),
          ],
        ),
      ),
    );
  }
}
