import 'package:get/get.dart';

import '../controllers/teacher_list_controller.dart';

class TeacherListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TeacherListController>(
      () => TeacherListController(),
    );
  }
}
