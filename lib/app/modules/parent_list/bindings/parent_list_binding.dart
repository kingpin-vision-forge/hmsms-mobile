import 'package:get/get.dart';

import '../controllers/parent_list_controller.dart';

class ParentListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParentListController>(
      () => ParentListController(),
    );
  }
}
