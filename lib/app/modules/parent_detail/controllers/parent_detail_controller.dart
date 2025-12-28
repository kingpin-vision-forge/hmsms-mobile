import 'package:get/get.dart';
import 'package:chopper/chopper.dart' as c;
import 'package:student_management/app/data/apis.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/global.dart';
import 'package:student_management/app/helpers/utilities/network_util.dart';
import 'package:student_management/app/modules/parent_detail/models/parent_detail_response.dart';
import 'package:student_management/app/routes/app_pages.dart';

class ParentDetailController extends GetxController {
  final ApiService _apiService = ApiService.create();
  var isLoading = false.obs;
  var parentId;
  Rx<ParentDetailResponseModel?> parentDetailData =
      Rx<ParentDetailResponseModel?>(null);
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    parentId = Get.arguments['parent_id'];
    fetchParentDetail();
  }

  // parent detail
  fetchParentDetail() async {
    try {
      // Set loading state
      isLoading(true);
      c.Response? res = await NetworkUtils.safeApiCall(
        () => _apiService.parentDetail(parentId),
      );
      if (res == null) return;
      // Handle successful response
      if (res.isSuccessful) {
        if (res.body != null &&
            res.body.runtimeType != String &&
            res.body['data'] != null &&
            res.body['success'] == true) {
          final parsedData = ParentDetailResponseModel.fromJson(res.body);
          parentDetailData.value = parsedData;
        }
      } else {
        // Handle API errors
        serverError(res, () => fetchParentDetail());
      }
    } catch (e) {
      // Handle unexpected errors
      errorUtil.handleAppError(
        apiName: 'fetch parent detail',
        error: e,
        displayMessage:
            Constants.BOT_TOAST_MESSAGES['FAILED_FETCH_PARENT_DETAIL']!,
      );
    } finally {
      // Reset loading states
      isLoading(false);
    }
  }

  passEditParentArguments() async {
    if (parentDetailData.value?.data != null) {
      final parentData = parentDetailData.value!.data!;
      Get.toNamed(
        Routes.CREATE_PARENT,
        arguments: {
          'isEdit': true,
          'parentId': parentData.id,
          'userId': parentData.userId,
          'firstName': parentData.user.firstName,
          'lastName': parentData.user.lastName,
          'email': parentData.user.email,
          'phone': parentData.phone,
          'address': parentData.address,
          'whatsappNumber': parentData.whatsappNumber ?? '',
          'whatsappOptIn': parentData.whatsappOptIn,
          'students': parentData.students.map((s) => s.id).toList(),
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
