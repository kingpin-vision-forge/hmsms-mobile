import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chopper/chopper.dart' as c;
import 'package:student_management/app/data/apis.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/global.dart';
import 'package:student_management/app/helpers/utilities/network_util.dart';
import 'package:student_management/app/modules/create_section/models/fetch_classes_section.dart';

class CreateParentController extends GetxController {
  final ApiService _apiService = ApiService.create();
  var isEditMode = false.obs;
  final formKey = GlobalKey<FormState>();
  var isLoading = false.obs;
  var classList = <ClassDropdownData>[].obs;
  var isClassLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchClasses();
  }

  // fetch classes dropdown
  fetchClasses() async {
    try {
      // Set loading state to indicate API call in progress
      isClassLoading.value = true;

      c.Response? res = await NetworkUtils.safeApiCall(
        () => _apiService.fetchClassesForSection(),
      );

      if (res == null) return;
      if (res.isSuccessful) {
        if (res.body != null &&
            res.body['data'] != null &&
            res.body['success'] == true) {
          final response = FetchClassesSectionResponse.fromJson(res.body);
          classList.value = response.data;
        } else {
          // Handle API error responses
          serverError(res, () => fetchClasses());
        }
      }
    } catch (e) {
      // Handle unexpected errors

      errorUtil.handleAppError(
        apiName: 'fetchClasses',
        error: e,
        displayMessage: Constants.BOT_TOAST_MESSAGES['FAILED_FETCH_CLASSES']!,
      );
    } finally {
      // Reset loading state
      isClassLoading.value = false;
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
