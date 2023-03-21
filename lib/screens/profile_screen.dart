import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import '../model/task.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  List<Task> tasks = [];
  List<String> categories = [];

  List<Map<String, dynamic>> achievements = [
    {'name': 'Name Erfolg'},
    {'name': 'Name Erfolg'},
    {'name': 'Name Erfolg'},
  ];
  List<Map<String, dynamic>> friends = [
    {'name': 'Name Friend', 'image': 'assets/sadcat.jpeg'},
    {'name': 'Name Friend', 'image': 'assets/sadcat.jpeg'},
    {'name': 'Name Friend', 'image': 'assets/sadcat.jpeg'},
  ];

  final dataMap = <String, double>{
    "User": 5, // Aktueller XP Wert von User
  };

  final colorList = <Color>[
    Colors.greenAccent,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                // Leiste oben
                flex: 2,
                child: UserBar(dataMap: dataMap, colorList: colorList),
              ),
              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 106),
                      child: Text(
                        'Profil',
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: InkWell(
                  onTap: () {
                    // TODO: navigate to profile picture change screen
                  },
                  child: Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/sadcat.jpeg'),
                        radius: 40,
                      ),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Opacity(
                          opacity: 0.6,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 20, top: 31),
                              child: Text(
                                'Profilbild wechseln',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Text(
                    "Level 3",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                width: 200.0,
                height: 20.0,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: 100.0,
                      height: 20.0,
                      decoration: BoxDecoration(
                        //TODO entscheidenmit oder ohne opacity
                        color: Colors.pinkAccent.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '700XP',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //Name ändern
              /* Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 80, right: 80, top: 15),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Neuer Username',
                      hintStyle: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                      ),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.black.withOpacity(0.7),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(
                          color: Colors.lightGreenAccent.withOpacity(0.5),
                          width: 2.0,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0), // Anpassen der Innenabstände
                      isDense: true, // Verkleinert den Abstand um das Textfeld herum
                    ),
                  ),
                ),
              ), */
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Container(
                  child: ElevatedButton(
                    onPressed: () {
                      //TODO: implement button action
                    },
                    child: Text('Änderungen speichern'),
                    style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                      backgroundColor: Colors.blueGrey,
                      minimumSize: Size(50, 30),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                ),
              ),
              const Expanded(
                // War mal Expanded
                flex: 6,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                ),
              ),
            ],
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.blueGrey,
                        child: IconButton(
                          icon: Icon(Icons.message_outlined, color: Colors.black),
                          onPressed: () {
                            setState(() {
                              _showDialog();
                            });
                          },
                        ),
                      ),




                      Align(
                        alignment: Alignment.topRight,
                        child: CircleAvatar(
                          backgroundColor: Colors.blueGrey,
                          radius: 5,
                          child: Text(
                            "1",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      // TODO an Anzahl der Anfragen anpassen
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blueGrey,
                      child:
                          Icon(Icons.settings_outlined, color: Colors.black)),
                ],
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 465, left: 166),
              child: Text(
                'Erfolge',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 505),
            child: Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: achievements.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Icon(
                        Icons.emoji_events,
                        color: Colors.black.withOpacity(0.7),
                      ),
                      SizedBox(height: 8),
                      Text(
                        achievements[index]['name'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.04),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 560, left: 160),
            child: ElevatedButton(
              onPressed: () {
                //TODO: implement button action
              },
              child: Text('Alle Erfolge'),
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                ),
                backgroundColor: Colors.blueGrey,
                minimumSize: Size(70, 25),
                padding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 620, left: 166),
              child: Text(
                'Freunde',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 650.0),
            child: Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: friends.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(friends[index]['image']),
                        radius: 25,
                      ),
                      SizedBox(height: 8),
                      Text(
                        friends[index]['name'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.04),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 725, left: 160),
            child: ElevatedButton(
              onPressed: () {
                //TODO: implement button action
              },
              child: Text('Alle Freunde'),
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04),
                backgroundColor: Colors.blueGrey,
                minimumSize: Size(70, 25),
                padding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }


  void _showDialog() {
    List<Map<String, dynamic>> friends = [    {'name': 'Max', 'avatar': Icons.person, 'task': 'Hausaufgaben'},    {'name': 'Lisa', 'avatar': Icons.person, 'task': 'Einkaufen'},    {'name': 'Tom', 'avatar': Icons.person, 'task': 'Gartenarbeit'},  ]; // Hier werden Freunde mit ihren Avataren und Aufgaben definiert

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Freunde-Benachrichtigung'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${friends.length} ${friends.length == 1 ? "Freund" : "Freunde"} möchten mit dir eine Task zusammen lösen.'),
              SizedBox(height: 16),
              Text('Freunde:'),
              SizedBox(height: 8),
              ...friends.map((friend) {
                return Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          child: Icon(friend['avatar'], color: Colors.white),
                        ),
                        SizedBox(width: 8),
                        Text(friend['name']),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text('Möchte ${friend['task']} erledigen.'),
                    SizedBox(height: 16),
                  ],
                );
              }).toList(),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Schließen'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }


}

class UserBar extends StatelessWidget {
  const UserBar({
    Key? key,
    required this.dataMap,
    required this.colorList,
  }) : super(key: key);

  final Map<String, double> dataMap;
  final List<Color> colorList;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.blueGrey,
          height: 200,
          width: double.infinity,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(),
              ),
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "XPirl",
                          style: TextStyle(
                            fontSize: 30, // TODO Responsive machen
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.pinkAccent,
                                blurRadius: 1,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: const [
                          Icon(Icons.monetization_on_outlined),
                          Text("20"), // TODO an User anpassen
                        ],
                      ),
                    ),
                    //TODO space bissel zwischen beiden icons
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: const [
                          Icon(Icons.airplane_ticket_outlined),
                          Text("0"), // TODO an User anpassen
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Username",
                          style: TextStyle(
                            fontSize: 30, // TODO Responsive machen
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.pinkAccent,
                                blurRadius: 1,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
