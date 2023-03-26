import 'dart:convert';

List<UserHasTasks> userTasksFromJson(String str) =>
    List<UserHasTasks>.from(json.decode(str).map((x) => UserHasTasks.fromJson(x)));

String userTasksToJson(List<UserHasTasks> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


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
    required this.id,
    required this.status,
    required this.dateAchieved,
    required this.whichUser,
    required this.whichTask
  });

  int id;
  int status;
  String dateAchieved;
  List<int> whichUser;
  List<int> whichTask;

  factory UserHasTasks.fromJson(Map<String, dynamic> json) => UserHasTasks(
    id: json["id"],
    status: json["status"],
    dateAchieved: json["dateAchieved"],
    whichUser: List<int>.from(json["whichUser"].map((x) => x)),
    whichTask: List<int>.from(json["whichUser"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "dateAchieved": dateAchieved,
    "whichUser": List<dynamic>.from(whichUser.map((x) => x)),
    "whichTask": List<dynamic>.from(whichTask.map((x) => x)),
  };

  bool checkUserHasTask(int userID, int taskID) {
    return whichUser.contains(userID) && whichTask.contains(taskID);
  }
}