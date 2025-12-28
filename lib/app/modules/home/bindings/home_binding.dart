import 'package:get/get.dart';

import 'package:student_management/app/modules/home/controllers/firebase_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FirebaseController>(
      () => FirebaseController(),
    );
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
