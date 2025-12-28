import 'package:get/get.dart';
import 'package:chopper/chopper.dart' as c;
import 'package:student_management/app/data/apis.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/global.dart';
import 'package:student_management/app/helpers/utilities/network_util.dart';
import 'package:student_management/app/modules/section_detail/models/section_Detail_response.dart';
import 'package:student_management/app/routes/app_pages.dart';

class SectionDetailController extends GetxController {
  final ApiService _apiService = ApiService.create();
  var isLoading = false.obs;
  var sectionId;
  Rx<SectionDetailResponse?> sectionDetailData = Rx<SectionDetailResponse?>(
    null,
  );
  @override
  void onInit() {
    super.onInit();
    sectionId = Get.arguments['section_id'];
    fetchSectionDetail();
  }

  // fetch section detail
  fetchSectionDetail() async {
    try {
      // Set loading state
      isLoading(true);
      c.Response? res = await NetworkUtils.safeApiCall(
        () => _apiService.sectionDetails(sectionId),
      );
      if (res == null) return;
      // Handle successful response
      if (res.isSuccessful) {
        if (res.body != null &&
            res.body.runtimeType != String &&
            res.body['data'] != null &&
            res.body['success'] == true) {
          final parsedData = SectionDetailResponse.fromJson(res.body);
          sectionDetailData.value = parsedData;
        }
      } else {
        // Handle API errors
        serverError(res, () => fetchSectionDetail());
      }
    } catch (e) {
      // Handle unexpected errors
      errorUtil.handleAppError(
        apiName: 'fetch section detail',
        error: e,
        displayMessage:
            Constants.BOT_TOAST_MESSAGES['FAILED_FETCH_SECTION_DETAIL']!,
      );
    } finally {
      // Reset loading states
      isLoading(false);
    }
  }

  passEditSectionArguments() {
    if (sectionDetailData.value?.data != null) {
      final sectionData = sectionDetailData.value!.data!;
      Get.toNamed(
        Routes.CREATE_SECTION,
        arguments: {
          'isEdit': true,
          'section_id': sectionData.id,
          'section_name': sectionData.name,
          'class_id': sectionData.classId,
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
