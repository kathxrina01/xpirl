import 'package:get/get.dart';

import '../model/model.dart';
import '../model/users.dart';

class UserController extends GetxController {
  var model = Model().obs;
  var changed = 0.obs;

  //Users currentUser = new Users("abc").obs;
  Users? currentUser;

  void addCurrentUser(Users currentUser) {
    this.currentUser = currentUser;
  }

  // XP Punkte hinzufügen
  void addLevelXP(int add) {
    if (add <= 0) return; // Falsche Eingabe
    model.value.currentUser!.levelXP += add;
    changed++;
    model.update((val) {});
  }

  void updateCoins(int value) {
    model.value.currentUser!.numCoins += value;
    changed++;
    model.update((val) {});
  }

  /*
  void _update() {
    model.update((val) {});
  }*/
}