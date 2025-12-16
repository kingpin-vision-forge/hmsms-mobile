import 'package:get/get.dart';

class HomeController extends GetxController {
  var selectedMenu = 'Dashboard'.obs;
  var signedUrl = ''.obs;
  @override
  void onInit() {
    super.onInit();
  }

  void selectMenu(String menu) {
    selectedMenu.value = menu;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
