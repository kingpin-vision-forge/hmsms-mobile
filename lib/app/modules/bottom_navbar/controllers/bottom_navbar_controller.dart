import 'package:get/get.dart';

class BottomNavbarController extends GetxController {
  var selectedIndex = 0.obs;

  void setInitialIndex(int index) {
    selectedIndex.value = index;
  }

  void onItemTapped(int index) {
    selectedIndex.value = index;
  }
}