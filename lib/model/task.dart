

import 'dart:convert';

List<Task> taskListFromJson(String str) =>
    List<Task>.from(json.decode(str).map((x) => Task.fromJson(x)));

List<Task> taskListByCategoryFromJson(String jsonString, String categoryName) {
  final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
  List<Task> filteredTasks = parsed
      .map<Task>((json) => Task.fromJson(json))
      .where((task) => task.category == categoryName)
      .toList();
  return filteredTasks;
}

List<String> categoryListFromTaskJson(String jsonData) {
  List<dynamic> taskList = json.decode(jsonData);
  Set<String> categories = Set<String>();
  for (var taskJson in taskList) {
    categories.add(taskJson['category']);
  }
  return categories.toList();
}

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
    this.titleShort = "title",
    this.description = "description",
    this.rewardXP = 0,
    required this.category,
    required this.rewardCoins,
    required this.rewardTickets,
    this.hasRewardXp = const []
  }) {
    _addCategory();
  }

  int id;
  String title;
  String titleShort;
  String description;
  int rewardXP;
  String category;
  int rewardCoins;
  int rewardTickets;
  List<int> hasRewardXp;

  Task.empty({
    this.id = 0,
    this.title = "title",
    this.titleShort = "shortTitle",
    this.description = "description",
    this.rewardXP = 0,
    this.category = "category1",
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

  // add a category
  _addCategory() {
    // only if category is new
    if (!Task._categories.contains(this.category)) {
      // New Category
      Task._categories.add(this.category);
      Task.nrCategories++;
    }
  }

  // Translate the long task title from the database to sth usefull
  translateTaskTitleFromDatabase() {
    List<String> parts = title.split(" | ");
    titleShort = parts[0];
    description = parts[1];
    rewardXP = int.parse(parts[2]);
  }
}
