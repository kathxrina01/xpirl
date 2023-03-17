import 'dart:convert';

List<UserHasTasks> userTasksFromJson(String str) =>
    List<UserHasTasks>.from(json.decode(str).map((x) => UserHasTasks.fromJson(x)));

String userTasksToJson(List<UserHasTasks> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserHasTasks {
  String? username;
  int? taskID;
  String? status;
  String? dateCompleted;

  UserHasTasks({
    this.username, this.taskID, this.status, this.dateCompleted,
});
  factory UserHasTasks.fromJson(Map<String, dynamic> json) => UserHasTasks(
    username: json["username"],
    taskID: json["taskid"],
    status: json["status"],
    dateCompleted: json["dateCompleted"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "taskID": taskID,
    "status": status,
    "dateCompleted": dateCompleted,
  };
}