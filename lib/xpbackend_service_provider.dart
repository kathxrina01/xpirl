//import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:xpirl/model/user_has_tasks.dart';

import 'model/task.dart';
import 'model/user.dart';
import 'model/user.dart';
import 'model/user.dart';

class XPBackendServiceProvider {
  //static String host = "localhost:8000";
  //static String host = "10.0.2.2:8000";
  //static String host = "193.174.29.13";
  static String host = "medsrv.informatik.hs-fulda.de";
  static String apiPath = "/xpbackend/api/v1";

  /* HELPER */

  static Future<List<T>> getObjectList<T>({
    required String resourcePath,
    required Function(String) listFromJson,
  }) async {
    print("7.");
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

      // for (UserHasTasks uT1 in userTasks) {
      //   print("uT2:" + uT1.whichUser[0].toString());
      // }
      userTasks ??= [];
      return (userTasks);
    } else {
      return [];
    }
  }
  //
  // // Get list of specific tasks a specific user has
  // static Future<List<UserHasTasks>> getObjectListUserHasTaskListByID<T>({
  //   required String resourcePath,
  //   required Function(String, int) listFromJson,
  //   required int? userID,
  //   required
  // }) async {
  //
  //   var url = Uri.https(host, '${apiPath}/${resourcePath}.json');
  //   var response = await http.get(url);
  //   if (response.statusCode == 200) {
  //
  //     List<dynamic> userData = json.decode(response.body);
  //
  //     List<UserHasTasks> userTasks = [];
  //     for (dynamic userTaskMap in userData) {
  //       Map<String, dynamic> userJson = userTaskMap as Map<String, dynamic>;
  //       for (int curID in userJson['whichUser']) {
  //         if (curID == id) {
  //           userTasks.add(UserHasTasks.fromJson(userJson));
  //           break;
  //         }
  //       }
  //     }
  //     userTasks ??= [];
  //     return (userTasks);
  //   } else {
  //     return [];
  //   }
  // }

  // Get specific User
  static Future<User?> getUser({
    required String resourcePath,
    required String username,
    required Function(String, String) userFromJson,
    required Function(String) userListFromJson,
  }) async {
    var url = Uri.https(host, '${apiPath}/${resourcePath}.json');
    var response = await http.get(url);

    print("2.");
    if (response.statusCode == 200) {
      List<dynamic> userData = json.decode(response.body);
/*
      User? user = userData
          .map((e) => userFromJson(json.encode(e), username))
          .firstWhere((e) => e!.username == username, orElse: () => User(username: username, avatar: "assets/sadcat.jpeg", levelXP: 0, numCoins: 0, numTickets: 0)); // TODO hier Fehler?
*/
      User? currentUser;
      for (dynamic userMap in userData) {
        Map<String, dynamic> userJson = userMap as Map<String, dynamic>;
        if (userJson['username'].startsWith(username)) {
          currentUser = User.fromJson(userJson); // Konvertiere das JSON-Objekt in eine User-Instanz
          break;// Beende die Schleife, wenn die gesuchte Instanz gefunden wurde
        }
      }

      //currentUser ??= User(id: Random().nextInt(pow(2, 32).toInt()), username: username, avatar: "assets/sadcat.jpeg");
      currentUser ??= User(username: username, avatar: "assets/sadcat.jpeg");

      // print("CID: " + currentUser.id.toString());
      if (currentUser.username.endsWith("]")) {
        // User is from Database
        currentUser.translateUsernameFromDatabase();
      } else {
        currentUser.usernameShort = username;
        currentUser.addEntryToDatabase();
      }
      // print("CID: " + currentUser.id.toString());
      //List<User> userList = userListFromJson(response.body);
      //return userList[0];

      print("User wurde erstellt oder aus der Datenbank geladen");
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

      print("Useritus");
      int id = 0;
      for (dynamic userMap in userData) {
        print(userMap.toString());
        Map<String, dynamic> userJson = userMap as Map<String, dynamic>;
        if (userJson['username'] == username) {
          id = userJson['id'];
          break;// Beende die Schleife, wenn die gesuchte Instanz gefunden wurde
        }
      }
      print("UseritusID: " + id.toString());

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


  // TODO weg?
  static Future<List<T>> getObjectById<T>({
    required int id,
    required String resourcePath,
    required Function(String) objectFromJson,
  }) async {
    var url = Uri.https(host, '${apiPath}/${resourcePath}/${id}.json');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      T object = objectFromJson(response.body);
      return ([object]);
    } else {
      return [];
    }
  }

  // TODO weg?
  static Future<bool> createObject<T>({
    required T data,
    required Function(T) toJson,
    required String resourcePath,
  }) async {
    var url = Uri.https(host, '${apiPath}/${resourcePath}');
    String json = toJson(data);

    http.Response resonse = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json,
    );
    if (resonse.statusCode == 201) {
      return true;
    }
    return false;
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
    print("10.");
    // print(url);
    // print("davor");
    String json = toJson(data);
    String goodjson = '{"id":20,"status":0,"dateAchieved":"2023-03-26","whichUser":[13],"whichTask":[378]}';
    // String json1 = goodjson.substring(goodjson.indexOf("dateAchieved") + "dateAchieved".length + 2, goodjson.indexOf("dateAchieved") + "dateAchieved".length + 14);
    // json = json.substring(0, json.indexOf("dateAchieved") + "dateAchieved".length) + json1 + json.substring(json.indexOf("dateAchieved") + "dateAchieved".length + 14, json.length);
    //json = goodjson.substring(0, goodjson.indexOf(',"status')) + json.substring(json.indexOf(',"status'), json.length);

    //print(json1);
    // print(json);

    //json = goodjson;
    // print(json);
    http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json,
    );
    // print("Code: " + response.statusCode.toString());
    if (response.statusCode == 201) {
      return true;
    }
    return false;
  }

  // TODO weg?
  static Future<bool> updateObjectById<T>({
    required int id,
    required T data,
    required Function(T)? objectToJson,
    required String resourcePath,
  }) async {
    var url = Uri.https(host, '${apiPath}/${resourcePath}/${id}.json');
    String json = objectToJson!(data);

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


  // Update User in Database
  static Future<bool> updateObjectUserHasTasksById<T>({
    required int? id,
    required T? data,
    required String Function(T) objectToJson,
    required String resourcePath,
  }) async {print("Oke");
    var url = Uri.https(host, '${apiPath}/${resourcePath}/${id}.json');
    print("jdhoaiwd");
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


  // TODO weg?
  static Future<bool> deleteObjectById({
    required int id,
    required String resourcePath,
  }) async {
    var url = Uri.https(host, '${apiPath}/${resourcePath}/${id}.json');

    http.Response resonse = await http.delete(
      url,
    );
    if (resonse.statusCode == 204) {
      return true;
    }
    return false;
  }
}
