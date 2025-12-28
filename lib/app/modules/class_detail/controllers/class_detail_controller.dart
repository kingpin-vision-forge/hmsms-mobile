import 'package:get/get.dart';
import 'package:chopper/chopper.dart' as c;
import 'package:student_management/app/data/apis.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/global.dart';
import 'package:student_management/app/helpers/utilities/network_util.dart';
import 'package:student_management/app/modules/class_detail/models/class_detail_response.dart';
import 'package:student_management/app/routes/app_pages.dart';

class ClassDetailController extends GetxController {
  final ApiService _apiService = ApiService.create();
  var isLoading = false.obs;
  var classId;
  Rx<ClassDetailData?> classDetailData = Rx<ClassDetailData?>(null);

  @override
  void onInit() {
    super.onInit();
    classId = Get.arguments['class_id'];
    fetchClassDetail();
  }

  // fetchClassDetail
  fetchClassDetail() async {
    try {
      // Set loading state
      isLoading(true);
      c.Response? res = await NetworkUtils.safeApiCall(
        () => _apiService.classDetails(classId),
      );
      if (res == null) return;
      // Handle successful response
      if (res.isSuccessful) {
        if (res.body != null &&
            res.body.runtimeType != String &&
            res.body['data'] != null &&
            res.body['success'] == true) {
          final parsedData = ClassDetailData.fromJson(res.body['data']);
          classDetailData.value = parsedData;
        }
      } else {
        // Handle API errors
        serverError(res, () => fetchClassDetail());
      }
    } catch (e) {
      // Handle unexpected errors
      errorUtil.handleAppError(
        apiName: 'fetch class detail',
        error: e,
        displayMessage:
            Constants.BOT_TOAST_MESSAGES['FAILED_FETCH_CLASS_DETAIL']!,
      );
    } finally {
      // Reset loading states
      isLoading(false);
    }
  }

  passEditClassArguments() {
    if (classDetailData.value != null) {
      final classData = classDetailData.value!;
      Get.toNamed(
        Routes.CREATE_CLASS,
        arguments: {
          'isEdit': true,
          'class_id': classData.id,
          'class_name': classData.name,
          'class_code': classData.code,
        },
      );
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
