import 'package:get/get.dart';

import '../controllers/subject_list_controller.dart';

class SubjectListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubjectListController>(
      () => SubjectListController(),
    );
  }
}
