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

  Future<bool> deleteTaskById({required int id}) async {
    var result = await XPBackendServiceProvider.deleteObjectById(
      id: id,
      resourcePath: "tasks",
    );
    return result;
  }
}
