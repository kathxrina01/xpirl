import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xpirl/model/user_has_tasks.dart';

import '../xp_service.dart';
import 'task.dart';

User userFromJson(String str, String username) => User.fromJson(json.decode(str));

List<User> userListFromJson(String str) => List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(User data) => json.encode(data.toJson());

class User {

  XPService service = XPService();

  User({
    this.id = 10,
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
});

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

  // translate categories from database
  String getUnlockedCategoriesString() {
    String result = unlockedCategories.toString();
    result = result.replaceAll(" ", "");
    result = result.replaceAll("[", "");
    result = result.replaceAll("]", "");
    return result;
  }

  // get UserID
  getIDFromDatabase() async {
    await service.getUserID(username).then((gottenID) {
      id = gottenID!;
    });
  }



  // XP Punkte hinzufügen
   addLevelXP(int add) async {
    print("adding XP");
    if (add <= 0) return; // Falsche Eingabe
    this.levelXP += add;
    updateCurrentLevel();
    await saveUser();
  }

  // change coins
  changeNumCoins(int change) async {
    if (numCoins - change < 0) {
      print("zu wenig Coins");
      return;
    }
    numCoins += change;
    await saveUser();
  }

  // change tickets
  changeNumTickets(int change) async {
    if (numTickets - change < 0) {
      print("zu wenig Tickets");
      return;
    }
    numTickets += change;
    await saveUser();
  }

  // translate long username from database to sth usefull
  translateUsernameFromDatabase() {
    usernameShort = username.substring(0, username.indexOf(" "));
    unlockedCategories = (username.substring(username.indexOf("{") + 1, username.indexOf("}"))).split(",");
    List<String> rest = (username.substring(username.indexOf("[") + 1, username.indexOf(",{"))).split(",");
    levelXP = int.parse(rest[0]);
    updateCurrentLevel();
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
    unlockCategory("Daily");
    username = exportUsername();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.id = await prefs.getInt('id') ?? 10;
    this.id++;

    await prefs.setInt('id', this.id).then((_) {
      return prefs.getInt('id');
    }).then((id) {
      this.id = id!;

      createUser();
    });
  }

  // create new Entry in DB
  void createUser() async {
    await Future.delayed(Duration(seconds: 1));
    await service.createUserEntry(data: this).then((worked) {
      // TODO UserHasTask & UserHasAchievement
      prepareUserID();
      linkUserAndTasks();
    });
  }

  // Prepare better userID
  Future<void> prepareUserID() async {
    await Future.delayed(Duration(seconds: 1));
    await this.getIDFromDatabase().then((oki) {
    });
  }

  // Link user with task
  linkUserAndTasks() async {
    await service.getTaskList().then((tasks) {
      createTasksForUser(tasks);
    });

  }

  // create all UserHasTasks for User
  Future<void> createTasksForUser(List<Task> tasks) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int idUserHastasks = prefs.getInt('idUserHastasks') ?? 10;
    idUserHastasks++;
    await prefs.setInt('idUserHastasks', idUserHastasks);
    UserHasTasks userTask = UserHasTasks(id: idUserHastasks, status: 0, dateAchieved: DateTime.now(), whichUser: [id], whichTask: [tasks[0].id]);
    await service.createUserHasTaskEntry(userTask: userTask).then((worked) async {
      if (tasks.length > 1) {
        await createTasksForUser(tasks.sublist(1));
      }
    });
  }

  // update user level
  void updateCurrentLevel() {
    if (levelXP >= service.levelXP[currentLevel]) {
      // Level Aufstieg
      for (var i = currentLevel; i < service.levelXP.length; i++) {
        if (levelXP >= service.levelXP[i]) currentLevel++;
        else break;
      }
    }
  }
}
