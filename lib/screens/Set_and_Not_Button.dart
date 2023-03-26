import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:xpirl/xp_service.dart';

class SetandNotButton extends StatefulWidget {
  final VoidCallback? onPressedButton1;
  final VoidCallback? onPressedButton2;

  const SetandNotButton({
    Key? key,
    this.onPressedButton1,
    this.onPressedButton2,
  }) : super(key: key);

  @override
  _SetandNotButtonState createState() => _SetandNotButtonState();
}

class _SetandNotButtonState extends State<SetandNotButton> {
  XPService service = XPService();
  void _showFriend() {
    List<Map<String, dynamic>> friends = [    {'name': 'Max', 'avatar': Icons.person, 'task': 'Hausaufgaben'},    {'name': 'Lisa', 'avatar': Icons.person, 'task': 'Einkaufen'},    {'name': 'Tom', 'avatar': Icons.person, 'task': 'Gartenarbeit'},  ]; // Hier werden Freunde mit ihren Avataren und Aufgaben definiert

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: service.colorList[1],
          title: Text('Freunde-Benachrichtigung',
          style: TextStyle(fontFamily: "Righteous",color: service.colorList[0],),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${friends.length} ${friends.length == 1 ? "Freund" : "Freunde"} möchten mit dir eine Task zusammen lösen.',
                style: TextStyle(fontFamily: "SourceCodePro",color: service.colorList[0],),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Text('Freunde:',
                style: TextStyle(fontFamily: "SourceCodePro",color: service.colorList[0],),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.015),
              ...friends.map((friend) {
                return Column(
                  children: [
                    Row(
                      children: [
                        //TODO anstatt icon avatar bilder hinzufügen
                        CircleAvatar(
                          child: Icon(friend['avatar'], color: Colors.white),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.height * 0.015),
                        Text(friend['name'],
                        style: TextStyle(fontFamily: "SourceCodePro",color: service.colorList[0],),),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                    Text('Möchte ${friend['task']} erledigen.',
                    style: TextStyle(fontFamily: "SourceCodePro",color: service.colorList[0],),),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  ],
                );
              }).toList(),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Schließen',
                style: TextStyle(fontFamily: "SourceCodePro",color: service.colorList[1],),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: service.colorList[2],
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSettings() {
    bool _notificationsEnabled = true; // Benachrichtigungen aktiviert/deaktiviert
    bool _darkModeEnabled = false; // Dark Mode aktiviert/deaktiviert
    String _language = 'Deutsch'; // Ausgewählte Sprache
    double _volume = 0.5; // Lautstärke des Sounds

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: service.colorList[1],
          title: Text(
            'Einstellungen',
            style: TextStyle(fontFamily: "Righteous",color: service.colorList[0],),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sound',
                    style: TextStyle(fontFamily: "SourceCodePro",color: service.colorList[0],),
                  ),
                  Slider(
                    value: _volume,
                    onChanged: (double value) {
                      setState(() {
                        _volume = value;
                      });
                    },
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                    label: _volume.toStringAsFixed(1),
                    activeColor: service.colorList[2],
                    inactiveColor: service.colorList[3],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Benachrichtigungen',
                    style: TextStyle(fontFamily: "SourceCodePro",color: service.colorList[0],),
                  ),
                  Switch(
                    value: _notificationsEnabled,
                    onChanged: (bool? value) {
                      setState(() {
                        _notificationsEnabled = value ?? false;
                      });
                    },
                    activeColor: service.colorList[2],
                    inactiveThumbColor: service.colorList[1],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sprache',
                    style: TextStyle(fontFamily: "SourceCodePro",color: service.colorList[0],),
                  ),
                  DropdownButton<String>(
                    value: _language,
                    onChanged: (String? newValue) {
                      setState(() {
                        _language = newValue ?? 'Deutsch';
                      });
                    },
                    items: <String>[
                      'Deutsch',
                      'Englisch',
                      'Französisch',
                      'Japanisch',
                      'Arabisch'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontFamily: "SourceCodePro",color: service.colorList[0],),
                        ),
                      );
                    }).toList(),
                    iconEnabledColor: service.colorList[2],
                  ),
                ],
              ),
              //test
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dark Mode',
                    style: TextStyle(fontFamily: "SourceCodePro",color: service.colorList[0],),
                  ),
                  Switch(
                    value: _darkModeEnabled,
                    onChanged: (bool? value) {
                      setState(() {
                        _darkModeEnabled = value ?? false;
                      });
                    },
                    inactiveThumbColor: service.colorList[1],
                    activeColor: service.colorList[2],
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Support',
                style: TextStyle(fontFamily: "SourceCodePro", color: service.colorList[1],),
              ),
              onPressed: () {
// Hier können Sie Ihre Hilfe/Support-Funktion aufrufen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: service.colorList[2],
                foregroundColor: service.colorList[1],
              ),
            ),
            ElevatedButton(
              child: Text('Schließen',
                style: TextStyle(fontFamily: "SourceCodePro",),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: service.colorList[2],
                foregroundColor: service.colorList[1],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GFIconBadge(
          child: GFIconButton(
            onPressed: widget.onPressedButton1 ?? () => _showFriend(),
            icon: Icon(Icons.notifications, color: service.colorList[1]),
            shape: GFIconButtonShape.circle,
            color: service.colorList[2],
            borderSide: BorderSide(color: service.colorList[1], width: MediaQuery.of(context).size.height * 0.0025),
          ),
          counterChild: GFBadge(
            child: Text("3",
              style: TextStyle(fontFamily: "SourceCodePro", color: service.colorList[1]),
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        GFIconButton(
          onPressed: widget.onPressedButton1 ?? () => _showSettings(),
          icon: Icon(Icons.settings,color: service.colorList[1] ),
          shape: GFIconButtonShape.circle,
          color: service.colorList[2],
          borderSide: BorderSide(color: service.colorList[1], width: MediaQuery.of(context).size.height * 0.0025),
        ),
      ],
    );
  }
}








