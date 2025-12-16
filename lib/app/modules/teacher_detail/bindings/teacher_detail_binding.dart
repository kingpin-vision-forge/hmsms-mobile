import 'package:get/get.dart';

import '../controllers/teacher_detail_controller.dart';

class TeacherDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TeacherDetailController>(
      () => TeacherDetailController(),
    );
  }
}
