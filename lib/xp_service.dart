import 'model/task.dart';
import 'model/user.dart';
import 'xpbackend_service_provider.dart';
import 'model/object_not_found_exception.dart';

class XPService {
  /* Task */
  Future<List<Task>> getTaskList() async {
    return await XPBackendServiceProvider.getObjectList<Task>(
      resourcePath: "tasks",
      listFromJson: taskListFromJson,
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

  Future<bool> deleteTaskById({required int id}) async {
    var result = await XPBackendServiceProvider.deleteObjectById(
      id: id,
      resourcePath: "tasks",
    );
    return result;
  }
}
