import 'package:get/get.dart';

import '../controllers/create_section_controller.dart';

class CreateSectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateSectionController>(
      () => CreateSectionController(),
    );
  }
}
