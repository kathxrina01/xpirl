import 'dart:convert';

List<UserHasTasks> userTasksFromJson(String str) =>
    List<UserHasTasks>.from(json.decode(str).map((x) => UserHasTasks.fromJson(x)));

UserHasTasks userTaskFromJson(String str, String username) => UserHasTasks.fromJson(json.decode(str));

String userTasksToJson(List<UserHasTasks> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

String userTasksSingleToJson(UserHasTasks data) => json.encode(data.toJson());

List<UserHasTasks> taskListByUserIdFromJson(String jsonString, int? userId) {
  final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
  List<UserHasTasks> filteredTasks = parsed
      .map((json) => UserHasTasks.fromJson(json))
      .where((userTask) => userTask.whichUser.contains(userId))
      .toList();
  print(filteredTasks.toString());
  return filteredTasks;
}


class UserHasTasks {
  UserHasTasks({
    this.id = 0,
    required this.status,
    required this.dateAchieved,
    required this.whichUser,
    required this.whichTask
  });

  int id;
  int status;
  DateTime dateAchieved;
  List<int> whichUser;
  List<int> whichTask;

  factory UserHasTasks.fromJson(Map<String, dynamic> json) => UserHasTasks(
    status: json["status"],
    dateAchieved: DateTime.parse(json["dateAchieved"]),
    whichUser: List<int>.from(json["whichUser"].map((x) => x)),
    whichTask: List<int>.from(json["whichTask"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "dateAchieved": dateAchieved.toIso8601String().substring(0, 10),
    "whichUser": List<dynamic>.from(whichUser.map((x) => x)),
    "whichTask": List<dynamic>.from(whichTask.map((x) => x)),
  };

  bool checkUserHasTask(int userID, int taskID) {
    return whichUser.contains(userID) && whichTask.contains(taskID);
  }
}