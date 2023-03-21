import 'dart:convert';

User userFromJson(String str, String username) => User.fromJson(json.decode(str));


class User {

  User({
   required this. username,
    required this.avatar,
    required this.levelXP,
    required this.numCoins,
    required this.numTickets
}) {
    // TODO hier einen neuen Datenbankeintrag schreiben!
  }
  /*
  User(String username) {
    this.username = username;
  }*/

  factory User.fromJson(Map<String, dynamic> json) => User(
    username: json["username"],
    avatar: json["avatar"],
    levelXP: json["levelXP"],
    numCoins: json["numCoins"],
    numTickets: json["numTickets"],
  );

  String username;
  String avatar = "assets/sadcat.jpeg"; // TODO std Avatar einfügen (Link?)
  int levelXP = 0;
  int numCoins = 0;
  int numTickets = 0;

  /*
  User(String username, {String? avatar}) {
    this.username = username;
    if (avatar != null) this.avatar = "assets/sadcat.jpeg";
  }*/

  User? getInstance(String username) {
    if (true) // username schon vorhanden
      return null;
    //return new Users(username);
  }

  bool isUsernameTaken(String username) {
    // TODO
    // Datenbank durchschauen, ob es schon User mit Username gibt

    return true;
  }

  // den aktuellen User einloggen
  // wenn der username neu ist, wird eine neue Instanz erstellt
  userLogin(String username) {

  }

  getLevelXP() {
    return this.levelXP;
  }

  getNumCoins() {
    return this.numCoins;
  }

  // XP Punkte hinzufügen
  addLevelXP(int add) {
    if (add <= 0) return; // Falsche Eingabe
    this.levelXP += add;
    //model.value.currentUser!.levelXP += add;
    //changed++;
    //model.update((val) {});
  }

  /*
  void createUser() {
    if ()
  }*/
}
