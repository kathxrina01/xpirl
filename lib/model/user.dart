import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../xp_service.dart';

User userFromJson(String str, String username) => User.fromJson(json.decode(str));

List<User> userListFromJson(String str) => List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(User data) => json.encode(data.toJson());

class User {

  XPService service = XPService();

  User({
    required this.id,
    required this. username,
    this.usernameShort = "User123",
    this.avatar = "assets/sadcat.jpeg",
    this.levelXP = 0,
    this.currentLevel = 1,
    this.numCoins = 0,
    this.numTickets = 0,
    this.isFriendWith = const [],
    this.hasLevelXP = const [],
    this.unlockedCategories = const []
}) {
    // TODO hier einen neuen Datenbankeintrag schreiben!
  }

  User.empty({
    this.id = 10,
    this.username = 'User123',
    this.usernameShort = 'User123',
    this.avatar = "assets/sadcat.jpeg",
    this.levelXP = 0,
    this.currentLevel = 1,
    this.numCoins = 0,
    this.numTickets = 0,
    this.isFriendWith = const [],
    this.hasLevelXP = const [],
    this.unlockedCategories = const []
});

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"] as int,
    username: json["username"].toString(),
    avatar: json["avatar"].toString(),
    hasLevelXP: (json["hasLevelXP"] as List<dynamic>).map((level) => level as int).toList(),
    isFriendWith: (json["isFriendWith"] as List<dynamic>).map((friend) => friend as int).toList(),

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "avatar": avatar,
    "hasLevelXP": hasLevelXP,
    "isFriendWith": isFriendWith
  };

  int id;
  String username;
  String usernameShort;
  String avatar;
  int levelXP;
  int currentLevel;
  int numCoins;
  int numTickets;
  List<int> isFriendWith;
  List<int> hasLevelXP;

  List<String> unlockedCategories;


  /*
  User(String username, {String? avatar}) {
    this.username = username;
    if (avatar != null) this.avatar = "assets/sadcat.jpeg";
  }*/

  int getId() {
    return id;
  }

  String getUsername() {
    return username;
  }

  String getUsernameShort() {
    return usernameShort;
  }

  String getAvatar() {
    return avatar;
  }

  int getLevelXP() {
    return levelXP;
  }

  int getCurrentLevel() {
    return currentLevel;
  }

  int getNumCoins() {
    return numCoins;
  }

  int getNumTickets() {
    return numTickets;
  }

  List<int> getIsFriendWith() {
    return isFriendWith;
  }

  List<int> getHasLevelXP() {
    return hasLevelXP;
  }

  List<String> getUnlockedCategories() {
    return unlockedCategories;
  }



  String getUnlockedCategoriesString() {
    String result = unlockedCategories.toString();
    result = result.replaceAll(" ", "");
    result = result.replaceAll("[", "");
    result = result.replaceAll("]", "");
    return result;
  }



  // XP Punkte hinzufügen
   addLevelXP(int add) async {
    print("adding XP");
    if (add <= 0) return; // Falsche Eingabe
    this.levelXP += add;

    await saveUser();
    //model.value.currentUser!.levelXP += add;
    //changed++;
    //model.update((val) {});
  }/*

  // XP Punkte hinzufügen
  addLevelXP(int add) {
    print("adding XP");
    if (add <= 0) return; // Falsche Eingabe
    this.levelXP += add;

    //await saveUser();
    //model.value.currentUser!.levelXP += add;
    //changed++;
    //model.update((val) {});
  }*/

  changeNumCoins(int change) {
    if (numCoins - change < 0) {
      print("zu wenig Coins");
      return;
    }
    numCoins += change;
  }


  translateUsernameFromDatabase() {
    usernameShort = username.substring(0, username.indexOf(" "));
    unlockedCategories = (username.substring(username.indexOf("{") + 1, username.indexOf("}"))).split(",");
    List<String> rest = (username.substring(username.indexOf("[") + 1, username.indexOf(",{"))).split(",");
    levelXP = int.parse(rest[0]);
    numCoins = int.parse(rest[1]);
    numTickets = int.parse(rest[2]);
  }

  String exportUsername() {
    return usernameShort + " [" + levelXP.toString() + "," + numCoins.toString() + "," + numTickets.toString() + ",{" + getUnlockedCategoriesString() + "}]";
  }

  // User in Datenbank sichern
  saveUser() async {
    username = exportUsername();
    await service.updateUser(id: id, data: this).then((worked) {
      // User wurde geupdated
      print(worked);
    });
  }

  bool checkUserUnlockedCategory(String category) {
    return unlockedCategories.contains(category);
  }

  unlockCategory(String category) {
    unlockedCategories.add(category);
  }

  // prepare User for insertion into database
  void addEntryToDatabase() async {
    unlockedCategories = [];
    unlockCategory("category1"); // TODO welche sollen an anfang freigeschaltet sein?
    unlockCategory("category2"); // TODO "
    username = exportUsername();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getInt('id') ?? 10;
    id++;

    // print("---");
    // hasLevelXP = [];
    // hasLevelXP.add(1);
    // isFriendWith = [];
    // isFriendWith.add(1);
    // print("---");


    await prefs.setInt('id', id).then((yes) {
      createUser();
    });

    // User in DB laden (vorher ID unique machen)
    // UserHasTask & UserHasAchievement updaten
  }

  // create new Entry in DB
  void createUser() async {
    await service.createUserEntry(data: this).then((worked) {
      print("User hinzugefügt");
      // TODO UserHasTask & UserHasAchievement
    });
  }
}
