import 'package:get/get.dart';

import '../model/model.dart';
import '../model/user.dart';

class UserController extends GetxController {
  var model = Model().obs;
  var changed = 0.obs;

  //Users currentUser = new Users("abc").obs;
  String? currentUserUsername;

  void configCurrentUser(String username) {
    this.currentUserUsername = username;
  }




  List<int> LevelXP = [0, 10, 30];
  var currentLevel = 1;
  var currenctXP = 0;

  updateLevel() {
    if (currenctXP >= LevelXP[currentLevel]) {
      // Level Aufstieg
      for (var i = currentLevel; i < LevelXP.length; i++) {
        if (currenctXP >= LevelXP[i]) currentLevel++;
        else break;
      }
    }
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