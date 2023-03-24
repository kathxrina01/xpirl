import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

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
  void _showFriend() {
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

  void _showSettings() {
    bool _notificationsEnabled = true; // Benachrichtigungen aktiviert/deaktiviert
    bool _darkModeEnabled = false; // Dark Mode aktiviert/deaktiviert
    String _language = 'Deutsch'; // Ausgewählte Sprache
    double _volume = 0.5; // Lautstärke des Sounds


    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Einstellungen'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Sound'),
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
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Benachrichtigungen'),
                  Switch(
                    value: _notificationsEnabled,
                    onChanged: (bool? value) {
                      setState(() {
                        _notificationsEnabled = value ?? false;
                      });
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Sprache'),
                  DropdownButton<String>(
                    value: _language,
                    onChanged: (String? newValue) {
                      setState(() {
                        _language = newValue ?? 'Deutsch';
                      });
                    },
                    items: <String>['Deutsch', 'Englisch', 'Französisch', 'Japanisch', 'Arabisch']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              //test
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Dark Mode'),
                  Switch(
                    value: _darkModeEnabled,
                    onChanged: (bool? value) {
                      setState(() {
                        _darkModeEnabled = value ?? false;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Support'),
              onPressed: () {
                // Hier können Sie Ihre Hilfe/Support-Funktion aufrufen
              },
            ),
            ElevatedButton(
              child: Text('Schließen'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      right: 16,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GFIconBadge(
            child: GFIconButton(
              onPressed: widget.onPressedButton1 ?? () => _showFriend(),
              icon: Icon(Icons.notifications),
              shape: GFIconButtonShape.circle,
              color: Colors.blueGrey,
              borderSide: BorderSide(color: Colors.white, width: 2.0),
            ),
            counterChild: GFBadge(
              child: Text("3"),
            ),
          ),
          SizedBox(height: 10),
          GFIconButton(
            onPressed: widget.onPressedButton1 ?? () => _showSettings(),
            icon: Icon(Icons.settings),
            shape: GFIconButtonShape.circle,
            color: Colors.blueGrey,
            borderSide: BorderSide(color: Colors.white, width: 2.0),
          ),
        ],
      ),
    );
  }
}








