import 'package:get/get.dart';

import '../controllers/create_parent_controller.dart';

class CreateParentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateParentController>(
      () => CreateParentController(),
    );
  }
}
