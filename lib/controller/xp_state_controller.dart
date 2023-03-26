import 'package:get/get.dart';
import '../model/task.dart';

class XPStateController extends GetxController {
  var somethingChanged = 0.obs;

  void change() {
    somethingChanged++;
  }

  List<Task> taskListe = []; // TODO wird das noch benötigt?
}