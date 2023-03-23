import 'dart:convert';

User userFromJson(String str, String username) => User.fromJson(json.decode(str));

List<User> userListFromJson(String str) => List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

class User {

  User({
    this.id = 0,
   required this. username,
    this.avatar = "assets/sadcat.jpeg",
    this.levelXP = 0,
    this.numCoins = 0,
    this.numTickets = 0,
    this.isFriendWith = const [],
    this.hasLevelXP = const []
}) {
    // TODO hier einen neuen Datenbankeintrag schreiben!
  }
  User.empty({
    this.id = 0,
    this.username = 'User123',
    this.avatar = "assets/sadcat.jpeg",
    this.levelXP = 0,
    this.numCoins = 0,
    this.numTickets = 0,
    this.isFriendWith = const [],
    this.hasLevelXP = const []
});

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    username: json["username"],
    avatar: json["avatar"],
    levelXP: json["levelXP"],
    numCoins: json["numCoins"],
    numTickets: json["numTickets"],
    isFriendWith: json["isFriendWith"],
    hasLevelXP: json["hasLevelXP"]
  );

  int id;
  String username;
  String avatar;
  int levelXP;
  int numCoins;
  int numTickets;
  List<String> isFriendWith;
  List<int> hasLevelXP;

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
