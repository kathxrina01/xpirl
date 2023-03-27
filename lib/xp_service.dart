import 'package:flutter/material.dart';

import 'model/task.dart';
import 'model/user.dart';
import 'model/user_has_tasks.dart';
import 'xpbackend_service_provider.dart';
import 'model/object_not_found_exception.dart';

class XPService {

  User? user;

  User? get currentUser => user;

  final colorList = <Color>[
    Color.fromARGB(255, 7, 8, 9),// dunkel blau-grau -> Schrift
    Color.fromARGB(255, 230, 230, 230),// weißgrau -> Schrift und Background
    Color.fromARGB(255, 113, 127, 143), // blau-grau (dunkel) -> noch nicht freigeschaltet
    Color.fromARGB(255, 130, 150, 160),// blau-grau (hell) -> freigeschaltet
    Color.fromARGB(255, 68, 217, 41), // grün -> Hintergrund -> freigeschaltet
    Color.fromARGB(150, 217, 37, 166),// pink -> Hintergrund -> noch nicht freigeschaltet
  ];

  List<int> levelXP = [0, 100, 300, 600, 1000, 1500, 2100, 2800, 3600, 4500, 5500, 6600, 7800, 9100, 10500, 12000, 13600, 15300, 17100, 19000, 21000, 23100, 25300, 27600, 30000, 32500, 35100, 37800, 40600, 43500, 46500, 49600, 52800, 56100, 59500, 63000, 66600, 70300, 74100, 78000, 82000, 86100, 90300, 94600, 99000, 103500, 108100, 112800, 117600, 122500, 127500, 132600, 137800, 143100, 148500, 154000, 159600, 165300, 171100, 177000, 183000, 189100, 195300, 201600, 208000, 214500, 221100, 227800, 234600, 241500, 248500, 255600, 262800, 270100, 277500, 285000, 292600, 300300, 308100, 316000, 324000, 332100, 340300, 348600, 357000, 365500, 374100, 382800, 391600, 400500, 409500, 418600, 427800, 437100, 446500, 456000, 465600, 475300, 485100, 495000];




  setUser(User user) {
    this.user = user;
  }


  /* Task */
  Future<List<Task>> getTaskList() async {
    return await XPBackendServiceProvider.getObjectList<Task>(
      resourcePath: "tasks",
      listFromJson: taskListFromJson,
    );
  }

  Future<List<UserHasTasks>?> getUserHasTaskListAll(int? id) async {
    return await XPBackendServiceProvider.getObjectListUserHasTaskListAll<UserHasTasks?>(
      resourcePath: "userhastasks",
      id: id,
      listFromJson: taskListByUserIdFromJson,

    );
  }

  // get list of tasks by their category name
  Future<List<Task>> getTasksByCategory(String category) async {
    return await XPBackendServiceProvider.getObjectsByCategory<Task>(
      resourcePath: "tasks",
      categoryName: category,
      //listByCategoryFromJson: taskListByCategoryFromJson,
      listByCategoryFromJson: (jsonString) =>
          taskListByCategoryFromJson(jsonString, category),
    );
  }

  /* User */
  // get user
  Future<User?> getUser(String username) async {
    return await XPBackendServiceProvider.getUser(
      resourcePath: "users",
      username: username,
      userFromJson: userFromJson,
      userListFromJson: userListFromJson,
    );
  }

  // get userID from specific
  Future<int?> getUserID(String username) async {
    return await XPBackendServiceProvider.getUserIDByUsername(
      resourcePath: "users",
      username: username,
      userFromJson: userTaskFromJson,
      userListFromJson: userTasksFromJson,
    );
  }

  // get UserhasTasks from specific IDs
  Future<int?> getUserHasTasksByID(int? userID, int taskID) async {
    return await XPBackendServiceProvider.getUserHasTasksByID(
      resourcePath: "users",
      userID: userID,
      taskID: taskID,
      userFromJson: userFromJson,
      userListFromJson: userListFromJson,
    );
  }


  /*
  // set user
  Future<User?> setUser(String username) async {
    return await XPBackendServiceProvider.setUser(
      resourcePath: "users",
      username: username,
      userFromJson: userFromJson,
    );
  }*/

  // get a list of all categories
  Future<List<String>> getCategoryList() async {
    return await XPBackendServiceProvider.getObjectCategoryList<String>(
      resourcePath: "tasks",
      listFromJson: categoryListFromTaskJson,
    );
  }


  Future<Task> getTaskById({required int id}) async {
    var result = await XPBackendServiceProvider.getObjectById<Task>(
      id: id,
      resourcePath: "tasks",
      objectFromJson: taskFromJson,
    );

    if (result.isEmpty) {
      throw ObjectNotFoundException();
    }

    return result[0]; // sollte nur ein Element enthalten
  }

  Future<bool> updateTaskById({required int id, required Task data}) async {
    var result = await XPBackendServiceProvider.updateObjectById<Task>(
      id: id,
      data: data,
      resourcePath: "tasks",
      objectToJson: taskToJson,
    );
    return result;
  }

  // Update User in database
  Future<bool> updateUser({required int? id, required User data}) async {
    var result = await XPBackendServiceProvider.updateObjectUserById<User>(
      id: id,
      data: data,
      resourcePath: "users",
      objectToJson: userToJson,
    );
    return result;
  }

  // Update UserHasTasks in database
  Future<bool> updateUserHasTasks({required int? id, required UserHasTasks? data}) async {
    var result = await XPBackendServiceProvider.updateObjectUserHasTasksById<UserHasTasks>(
      id: id,
      data: data,
      resourcePath: "userhastasks",
      objectToJson: userTasksSingleToJson,
    );
    return result;
  }

  // new user to database
  Future<bool> createUserEntry({required User data}) async {
    var result = await XPBackendServiceProvider.createObjectUser<User>(
      data: data,
      resourcePath: "users.json",
      toJson: userToJson,
    );
    return result;
  }

  Future<bool> createUserHasTaskEntry({required UserHasTasks userTask}) async {
    var result = await XPBackendServiceProvider.createObjectUserHasTasks<UserHasTasks>(
      data: userTask,
      resourcePath: "userhastasks.json",
      toJson: userTasksSingleToJson,
    );
    return result;
  }

  Future<bool> deleteTaskById({required int id}) async {
    var result = await XPBackendServiceProvider.deleteObjectById(
      id: id,
      resourcePath: "tasks",
    );
    return result;
  }
}
