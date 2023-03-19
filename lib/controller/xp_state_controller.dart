import 'package:get/get.dart';
import '../model/task.dart';

class XPStateController extends GetxController {
  // einfacher Ansatz, um auf (beliebige) Veränderungen zu reagieren
  var somethingChanged = 0.obs;

  void change() {
    somethingChanged++;
  }

  List<Task> taskListe = []; // TODO wird das noch benötigt?
}