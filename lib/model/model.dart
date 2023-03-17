import 'users.dart';

import 'package:http/http.dart' as http;

class Model {
  //Users user = new Users();
  Users? currentUser; // Aktueller User

  void createUser(String username) async {
    var url = Uri.https('http://localhost:8000/xpbackend/api/', '/users');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      // http Request hat geklappt

      /*
      bool exists = false;
      for (var i = 0; i < response.body.length; i++) {
        if (response.body.username.equals(username)) {
          exists = true;
          break;
        }
      }

      if (exists) {
        // alten User einfügen
      } else {
        // Neuen User-Eintrag erstellen
        currentUser = new Users(username); // TODO username aus Form einfügen
      }
      setState(() { // Wenn Zeile darunter ausgeführt -> Status updaten
        liste = entryFromJson(response.body);
      });

      print("erfolgreich");

       */
    } else {
      print("so n Mist");
    }
  }

}