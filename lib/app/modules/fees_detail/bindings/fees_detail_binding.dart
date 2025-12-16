import 'package:get/get.dart';

import '../controllers/fees_detail_controller.dart';

class FeesDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeesDetailController>(
      () => FeesDetailController(),
    );
  }
}
