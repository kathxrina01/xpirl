import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user.dart';
import '../model/user_has_tasks.dart';
import '../xp_service.dart';
import 'profile_screen.dart';

class UserBar extends StatefulWidget {
  const UserBar({
    Key? key,
    required this.type,
    this.user,
  }) : super(key: key);

  final int type;
  final User? user;

  @override
  State<UserBar> createState() => _UserBarState();
}

class _UserBarState extends State<UserBar> {
  User? user;
  var levelXP = 0;
  var numCoins = 250;
  var tickets = 0;
  late int _type;

  XPService service = XPService();

  // args
  User? currentUser;
  List<UserHasTasks>? taskListAll;

  String? username;

  Future<String> loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String loadedUsername = await prefs.getString('username') ?? '';
    return loadedUsername;
  }

  Future<User?> getUser() async {
    String currentUsername = username ?? await loadUsername();
    return await service.getUser(currentUsername);
  }

  Future<String?> loadNumCoins() async {
    User? currentUser = user ?? await getUser();
    return currentUser?.numCoins.toString();
  }


  @override
  void initState() {
    super.initState();
    _type = widget.type;
    loadUsername();
    user = widget.user;
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
                          fontSize: MediaQuery.of(context).size.height * 0.04,
                          fontFamily: "Righteous",
                          color: service.colorList[0],
                          shadows: [
                            Shadow(
                              color: service.colorList[4],
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
                        Icon(Icons.monetization_on_outlined, color: service.colorList[0],),
                        Text(user?.getNumCoins().toString() ?? "0",
                          style: TextStyle(color: service.colorList[0], fontFamily: "SourceCodePro"),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Icon(Icons.airplane_ticket_outlined, color: service.colorList[0]),
                        Text(user?.getNumTickets().toString() ?? "0",
                          style: TextStyle(color: service.colorList[0], fontFamily: "SourceCodePro"),
                        ),
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

    var levelPercent = ((user?.getLevelXP() ?? 0)-(service.levelXP[(user?.getCurrentLevel() ?? 0) - 1]))/((service.levelXP[(user?.getCurrentLevel() ?? 0)])-(service.levelXP[(user?.getCurrentLevel() ?? 1) - 1]));

    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () async {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 500),
              pageBuilder: (_, __, ___) => ProfileScreen(),
              settings: RouteSettings(arguments: {
              'user': user,
              'taskListAll': taskListAll,
            }),
              transitionsBuilder: (_, animation, __, child) {
                return SlideTransition(
                  position: Tween(
                    begin: Offset(0, 1),
                    end: Offset(0, 0),
                  ).animate(animation),
                  child: child,
                );
              },
            ),
          );
        },
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: CircleAvatar(
                  backgroundImage: AssetImage(user?.getAvatar() ?? "assets/sadcat.jpeg"),
                ),
              ),
            ),
            Positioned.fill(
              //right: 0,
              child: IgnorePointer(
                ignoring: true,
                child: GFProgressBar(
                  percentage: levelPercent,
                  circleWidth: MediaQuery.of(context).size.height * 0.015,
                  radius: MediaQuery.of(context).size.height * 0.178,
                  type: GFProgressType.circular,
                  backgroundColor: Colors.black12,
                  progressBarColor: service.colorList[4],
                  circleStartAngle: 145,
                ),
              ),
            ),
            Positioned(
              right: MediaQuery.of(context).size.width * 0.06,
              bottom: 0,
              child: CircleAvatar(
                backgroundColor: service.colorList[0],
                radius: MediaQuery.of(context).size.height * 0.03,
                child: Text(
                  user?.getCurrentLevel().toString() ?? "1",
                  style: TextStyle(
                    color: service.colorList[1],
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
        user?.getUsernameShort() ?? "",
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.height *
              0.035,
          fontFamily: 'Righteous',
          color: service.colorList[0],
          shadows: [
            Shadow(
              color: service.colorList[4],
              blurRadius: 1,
              offset: Offset(2, 2),
            ),
          ],
        ),
      ),
    );
  }
}
