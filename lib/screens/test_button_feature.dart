import 'package:flutter/material.dart';
//test
class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  bool _isUnlocked = false;
  int _goldCoins = 10;

  void _buyCategory() {
    if (_goldCoins >= 5) {
      setState(() {
        _isUnlocked = true;
        _goldCoins -= 5;
      });
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Nicht genügend Goldmünzen'),
            content: Text('Du hast nicht genügend Goldmünzen, um diese Kategorie freizuschalten.'),
            actions: [
              ElevatedButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lockedIcon = Icon(Icons.lock);
    final unlockedIcon = Icon(Icons.lock_open);

    return Scaffold(
      appBar: AppBar(title: Text('Kategorien')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(width: 1.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  _isUnlocked ? unlockedIcon : lockedIcon,
                  SizedBox(height: 10),
                  Text('Kategorie 1'),
                  SizedBox(height: 10),
                  if (!_isUnlocked)
                    ElevatedButton(
                      child: Text('Freischalten (5 Goldmünzen)'),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Kategorie freischalten'),
                              content: Text('Möchtest du diese Kategorie für 5 Goldmünzen freischalten?'),
                              actions: [
                                TextButton(
                                  child: Text('Abbrechen'),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                                ElevatedButton(
                                  child: Text('Freischalten'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _buyCategory();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(width: 1.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  unlockedIcon,
                  SizedBox(height: 10),
                  Text('Kategorie 2'),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50.0,
          child: Center(
            child: Text('Goldmünzen: $_goldCoins'),
          ),
        ),
      ),
    );
  }
}