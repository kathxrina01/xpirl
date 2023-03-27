import 'package:get/get.dart';

class XPStateController extends GetxController {
  var somethingChanged = 0.obs;

  void change() {
    somethingChanged++;
  }
}