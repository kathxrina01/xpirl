

import 'dart:convert';

List<Task> taskListFromJson(String str) =>
    List<Task>.from(json.decode(str).map((x) => Task.fromJson(x)));

String taskListToJson(List<Task> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Task taskFromJson(String str) => Task.fromJson(json.decode(str));

String taskToJson(Task data) => json.encode(data.toJson());

class Task {

  static List<String> _categories = ["Daily"];
  static int nrCategories = 1;

  Task({
    required this.id,
    required this.title,
    required this.category,
    required this.rewardCoins,
    required this.rewardTickets,
    required this.hasRewardXp
  }) {
    _addCategory();
  }

  int id;
  String title;
  String category;
  int rewardCoins;
  int rewardTickets;
  List<int> hasRewardXp;

  Task.empty({
    this.id = 0,
    this.title = "title",
    this.category = "category",
    this.rewardCoins = 0,
    this.rewardTickets = 0,
    this.hasRewardXp = const [],
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json["id"],
    title: json["title"],
    category: json["category"],
    rewardCoins: json["rewardCoins"],
    rewardTickets: json["rewardTickets"],
    hasRewardXp: List<int>.from(json["hasRewardXP"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "category": category,
    "rewardCoins": rewardCoins,
    "rewardTickets": rewardTickets,
    "hasRewardXP": List<dynamic>.from(hasRewardXp.map((x) => x)),
  };

  /*
  // get list with all categories
  List<String> _getAllCategories() {
    return _categories;
  }
  */

  // add a category
  _addCategory() {
    // only if category is new

    if (!Task._categories.contains(this.category)) {
      // New Category
      Task._categories.add(this.category);
      Task.nrCategories++;
    }
  }
}


/*
class Tasks {
  int _taskID = 0;
  String title = "";
  String category = "";
  int rewardXP = 0;
  int rewardCoins = 0;
  int rewardTickets = 0;

  Task(taskID, title, category, rewardXP, rewardCoins, rewardTickets) {
    this._taskID = taskID;
    this.title = title;
    this.rewardXP = rewardXP;
    this.rewardCoins = this.rewardCoins;
    this.rewardTickets = this.rewardTickets;
  }

  //Task getInstance()

  int getRewardXP(int id) {
    return this.rewardXP;
  }
}
*/