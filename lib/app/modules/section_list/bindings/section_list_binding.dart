import 'package:get/get.dart';

import '../controllers/section_list_controller.dart';

class SectionListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SectionListController>(
      () => SectionListController(),
    );
  }
}
