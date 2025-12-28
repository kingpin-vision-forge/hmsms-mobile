import 'package:get/get.dart';

import '../controllers/create_teacher_controller.dart';

class CreateTeacherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateTeacherController>(
      () => CreateTeacherController(),
    );
  }
}
