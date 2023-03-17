import 'package:get/get.dart';

import '../model/model.dart';

class UserHasTaskController extends GetxController {
  // Hier wird darauf zugegriffen und ddann Model verändert
  var model = Model().obs; // obs -> observable
  var changed =
      0.obs; // Immer wenn was verändert wird hochzählen; Wert wird beobachtet

  //var tasks = List<Tasks>.empty(growable: true).obs; // Wenn man das benutzt, braucht man kein update (oder iwi doch)

  //var userTasks = List<Tasks>.empty(growable: true).obs; // Tasks, die zu User gehören



  void taskAchieved(int taskID) {

    model.update((val) {});
  }

  /*
  void _update() {
    model.update((val) {});
  }*/
}
