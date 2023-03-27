import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:xpirl/model/user_has_tasks.dart';

import 'model/user.dart';

class XPBackendServiceProvider {
  //static String host = "localhost:8000";
  //static String host = "10.0.2.2:8000";
  //static String host = "193.174.29.13";
  static String host = "medsrv.informatik.hs-fulda.de";
  static String apiPath = "/xpbackend/api/v1";

  // get Task list
  static Future<List<T>> getObjectList<T>({
    required String resourcePath,
    required Function(String) listFromJson,
  }) async {
    var url = Uri.https(host, '${apiPath}/${resourcePath}.json');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<T> data = listFromJson(response.body);
      return (data);
    } else {
      return [];
    }
  }

  // Get list of all tasks a specific user has
  static Future<List<UserHasTasks>> getObjectListUserHasTaskListAll<T>({
    required String resourcePath,
    required Function(String, int) listFromJson,
    required int? id
  }) async {

    var url = Uri.https(host, '${apiPath}/${resourcePath}.json');
    var response = await http.get(url);
    if (response.statusCode == 200) {

      List<dynamic> userData = json.decode(response.body);

      List<UserHasTasks> userTasks = [];
      for (dynamic userTaskMap in userData) {
        Map<String, dynamic> userJson = userTaskMap as Map<String, dynamic>;
        for (int curID in userJson['whichUser']) {
          if (curID == id) {
            userTasks.add(UserHasTasks.fromJson(userJson));
            break;
          }
        }
      }

      userTasks ??= [];
      return (userTasks);
    } else {
      return [];
    }
  }

  // Get specific User
  static Future<User?> getUser({
    required String resourcePath,
    required String username,
    required Function(String, String) userFromJson,
    required Function(String) userListFromJson,
  }) async {
    var url = Uri.https(host, '${apiPath}/${resourcePath}.json');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> userData = json.decode(response.body);

      User? currentUser;
      for (dynamic userMap in userData) {
        Map<String, dynamic> userJson = userMap as Map<String, dynamic>;
        if (userJson['username'].startsWith(username)) {
          currentUser = User.fromJson(userJson); // Konvertiere das JSON-Objekt in eine User-Instanz
          break;// Beende die Schleife, wenn die gesuchte Instanz gefunden wurde
        }
      }

      currentUser ??= User(username: username, avatar: "assets/sadcat.jpeg");

      if (currentUser.username.endsWith("]")) {
        // User is from Database
        currentUser.translateUsernameFromDatabase();
      } else {
        // new user
        currentUser.usernameShort = username;
        currentUser.addEntryToDatabase();
      }

      return currentUser;
    } else {
      return null;
    }
  }

  // Get specific User
  static Future<int?> getUserIDByUsername({
    required String resourcePath,
    required String username,
    required Function(String, String) userFromJson,
    required Function(String) userListFromJson,
  }) async {
    var url = Uri.https(host, '${apiPath}/${resourcePath}.json');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> userData = json.decode(response.body);

      int id = 0;
      for (dynamic userMap in userData) {
        Map<String, dynamic> userJson = userMap as Map<String, dynamic>;
        if (userJson['username'] == username) {
          id = userJson['id'];
          break;
        }
      }

      return id;
    } else {
      return null;
    }
  }

  // Get specific UserHasTasks by userID & taskID
  static Future<int?> getUserHasTasksByID({
    required String resourcePath,
    required int? userID,
    required int taskID,
    required Function(String, String) userFromJson,
    required Function(String) userListFromJson,
  }) async {
    var url = Uri.https(host, '${apiPath}/${resourcePath}.json');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> userData = json.decode(response.body);

      int id = 0;
      for (dynamic userMap in userData) {
        Map<String, dynamic> userJson = userMap as Map<String, dynamic>;
        for (var i = 0; i < userJson['whichUser'].length; i++) {
          for (var j = 0; j < userJson['whichUser'].length; j++) {
            if ((userJson['whichUser'][i] == userID) && (userJson['whichTask'][j] == taskID)) {
              id = userJson['id'];
              break;
            }
          }
        }
      }

      return id;
    } else {
      return null;
    }
  }



  // return all Objects where the category name is a match
  static Future<List<T>> getObjectsByCategory<T>({
    required String resourcePath,
    required String categoryName,
    required Function(String) listByCategoryFromJson,
  }) async {
    //var url = Uri.https(host, '${apiPath}/${resourcePath}.json', {'category': categoryName});
    var url = Uri.https(host, '${apiPath}/${resourcePath}.json');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<T> resData = listByCategoryFromJson(response.body);
      return (resData);
    } else {
      return [];
    }
  }

  // get list of all categories
  static Future<List<T>> getObjectCategoryList<T>({
    required String resourcePath,
    required Function(String) listFromJson,
  }) async {
    var url = Uri.https(host, '${apiPath}/${resourcePath}');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List<T> data = listFromJson(response.body);
      return (data);
    } else {
      return [];
    }
  }


  // post new user to database
  static Future<bool> createObjectUser<T>({
    required T data,
    required Function(T) toJson,
    required String resourcePath,
  }) async {
    var url = Uri.https(host, '${apiPath}/${resourcePath}');
    String json = toJson(data);
    http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json,
    );
    if (response.statusCode == 201) {
      return true;
    }
    return false;
  }

  // post new userHasTask to database
  static Future<bool> createObjectUserHasTasks<T>({
    required T data,
    required Function(T) toJson,
    required String resourcePath,
  }) async {
    var url = Uri.https(host, '${apiPath}/${resourcePath}');
    String json = toJson(data);
    http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json,
    );
    if (response.statusCode == 201) {
      return true;
    }
    return false;
  }


  // Update User in Database
  static Future<bool> updateObjectUserById<T>({
    required int? id,
    required T data,
    required String Function(T) objectToJson,
    required String resourcePath,
  }) async {
    var url = Uri.https(host, '${apiPath}/${resourcePath}/${id}.json');
    String? json = objectToJson!(data);

    http.Response resonse = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json,
    );
    if (resonse.statusCode == 200) {
      return true;
    }
    return false;
  }


  // Update UserHasTasks in Database
  static Future<bool> updateObjectUserHasTasksById<T>({
    required int? id,
    required T? data,
    required String Function(T) objectToJson,
    required String resourcePath,
  }) async {
    var url = Uri.https(host, '${apiPath}/${resourcePath}/${id}.json');
    String? json = objectToJson!(data!);

    http.Response resonse = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json,
    );
    if (resonse.statusCode == 200) {
      return true;
    }
    return false;
  }
}
