//import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'model/task.dart';

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
    var url = Uri.https(host, '${apiPath}/${resourcePath}.json');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<T> data = listFromJson(response.body);
      return (data);
    } else {
      return [];
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
      //var data = json.decode(response.body);
      /*
      List<T> filteredData = listFromJson(data
          .map((item) => Task.fromJson(item))
          .where((task) => task.category == categoryName));*/
      //List<T> filteredData = data.where((item) => item['category'] == categoryName).toList();
      //List<T> filteredData = listFromJson(data.where((item) => item['category'] == categoryName));
      //List<T> data = listFromJson(response.body);

      /*
      List<T> filteredData = data
          .map((item) => Task.fromJson(item))
          .where((task) => task.category == categoryName)
          .toList();

      response.replaceRange(0, data.length, filteredData);*/
/*
      List<Task> filteredData = data
          .map((item) => Task.fromJson(item))
          .where((task) => task.category == categoryName)
          .toList();

      var jsonString = json.encode(filteredData);
      var contentBytes = utf8.encode(jsonString);

      response = http.Response.bytes(
        contentBytes,
        response.statusCode,
        headers: response.headers,
      );*/

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
      /*
      List<String> data = listFromJson(response.body);
      return (data);*/
    } else {
      return [];
    }
  }

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

  static Future<bool> updateObjectById<T>({
    required int id,
    required T data,
    required Function(T) objectToJson,
    required String resourcePath,
  }) async {
    var url = Uri.https(host, '${apiPath}/${resourcePath}/${id}.json');
    String json = objectToJson(data);

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
