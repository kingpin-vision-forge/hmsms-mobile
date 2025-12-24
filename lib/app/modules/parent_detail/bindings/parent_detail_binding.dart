import 'package:get/get.dart';

import '../controllers/parent_detail_controller.dart';

class ParentDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParentDetailController>(
      () => ParentDetailController(),
    );
  }
}
