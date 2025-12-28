import 'package:get/get.dart';

import '../controllers/create_subject_controller.dart';

class CreateSubjectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateSubjectController>(
      () => CreateSubjectController(),
    );
  }
}
