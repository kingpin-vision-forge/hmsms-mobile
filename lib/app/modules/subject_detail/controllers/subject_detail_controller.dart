import 'package:get/get.dart';
import 'package:chopper/chopper.dart' as c;
import 'package:student_management/app/data/apis.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/global.dart';
import 'package:student_management/app/helpers/utilities/network_util.dart';
import 'package:student_management/app/modules/subject_detail/models/subject_detail_response.dart';
import 'package:student_management/app/routes/app_pages.dart';

class SubjectDetailController extends GetxController {
  final ApiService _apiService = ApiService.create();
  var isLoading = false.obs;
  var subjectId;
  Rx<SubjectDetailResponseModel?> subjectDetailData =
      Rx<SubjectDetailResponseModel?>(null);

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    subjectId = Get.arguments['subject_id'];
    fetchSubjectDetail();
  }

  //fetch subject detail
  fetchSubjectDetail() async {
    try {
      // Set loading state
      isLoading(true);
      c.Response? res = await NetworkUtils.safeApiCall(
        () => _apiService.subjectDetails(subjectId),
      );
      if (res == null) return;
      // Handle successful response
      if (res.isSuccessful) {
        if (res.body != null &&
            res.body.runtimeType != String &&
            res.body['data'] != null &&
            res.body['success'] == true) {
          final parsedData = SubjectDetailResponseModel.fromJson(res.body);
          subjectDetailData.value = parsedData;
        }
      } else {
        // Handle API errors
        serverError(res, () => fetchSubjectDetail());
      }
    } catch (e) {
      // Handle unexpected errors
      errorUtil.handleAppError(
        apiName: 'fetch subject detail',
        error: e,
        displayMessage:
            Constants.BOT_TOAST_MESSAGES['FAILED_FETCH_SUBJECT_DETAIL']!,
      );
    } finally {
      // Reset loading states
      isLoading(false);
    }
  }

  void passEditSubjectArguments() {
    final data = subjectDetailData.value?.data;
    if (data != null) {
      Get.toNamed(
        Routes.CREATE_SUBJECT,
        arguments: {
          'isEdit': true,
          'subject_id': subjectId,
          'subject_name': data.name,
          'subject_code': data.code,
          'class_id': data.classInfo.id,
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

  void increment() => count.value++;
}
