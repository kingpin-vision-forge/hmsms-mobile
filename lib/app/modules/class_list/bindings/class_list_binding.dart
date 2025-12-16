import 'package:get/get.dart';

import '../controllers/class_list_controller.dart';

class ClassListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClassListController>(
      () => ClassListController(),
    );
  }
}
