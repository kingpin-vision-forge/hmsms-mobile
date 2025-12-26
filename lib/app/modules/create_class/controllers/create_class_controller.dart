import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chopper/chopper.dart' as c;
import 'package:student_management/app/data/apis.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/global.dart';
import 'package:student_management/app/helpers/utilities/network_util.dart';
import 'package:student_management/app/routes/app_pages.dart';

class CreateClassController extends GetxController {
  final ApiService _apiService = ApiService.create();
  // Text editing controllers for form fields
  final nameController = TextEditingController();
  final codeController = TextEditingController();
  final schoolIdController = TextEditingController();

  // Observable variables for form validation
  var hasInteractedWithName = false.obs;
  var hasInteractedWithCode = false.obs;
  var hasInteractedWithSchoolId = false.obs;
  var isFormValid = false.obs;
  var isLoading = false.obs;
  var isEditMode = false.obs;
  final formKey = GlobalKey<FormState>();
  var classId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Add listeners to form fields for validation
    nameController.addListener(checkFormValidity);
    codeController.addListener(checkFormValidity);
    schoolIdController.addListener(checkFormValidity);

    // Accept the argument coming from the class detail for edit
    if (Get.arguments != null && Get.arguments['isEdit'] == true) {
      isEditMode.value = true;
      classId.value = Get.arguments['class_id'] ?? '';
      nameController.text = Get.arguments['class_name'] ?? '';
      codeController.text = Get.arguments['class_code'] ?? '';
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    // Dispose controllers to prevent memory leaks
    nameController.dispose();
    codeController.dispose();
    schoolIdController.dispose();
    super.onClose();
  }

  // Check overall form validity
  void checkFormValidity() {
    isFormValid.value =
        nameController.text.isNotEmpty && codeController.text.isNotEmpty;
    // schoolIdController.text.isNotEmpty;
  }

  // Validate class name
  String? validateName(String value) {
    if (value.isEmpty) {
      return 'Class name cannot be empty';
    }
    if (value.length < 2) {
      return 'Class name must be at least 2 characters';
    }
    return null;
  }

  // Validate class code
  String? validateCode(String value) {
    if (value.isEmpty) {
      return 'Class code cannot be empty';
    }
    if (value.length < 2) {
      return 'Class code must be at least 2 characters';
    }
    return null;
  }

  // Validate school ID
  // String? validateSchoolId(String value) {
  //   if (value.isEmpty) {
  //     return 'School ID cannot be empty';
  //   }
  //   return null;
  // }

  // Create class method
  createClass() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      // Set loading state to indicate API call in progress
      isLoading.value = true;
      Map<String, dynamic> payload = {
        'name': nameController.text,
        'code': codeController.text,
        // 'schoolId': schoolIdController.text,
      };

      c.Response? res = await NetworkUtils.safeApiCall(
        () => _apiService.createClass(payload),
      );

      if (res == null) return;
      if (res.isSuccessful) {
        // Validate response body structure and success status
        if (res.body != null &&
            res.body['data'] != null &&
            res.body['success'] == true) {
          // // Show success message and navigate to main app
          botToastSuccess(Constants.BOT_TOAST_MESSAGES['CLASS_CREATED']!);
          Get.offAllNamed(Routes.CLASS_LIST);
        } else {
          // Handle API error responses
          serverError(res, () => createClass());
        }
      }
    } catch (e) {
      // Handle unexpected errors

      errorUtil.handleAppError(
        apiName: 'createClass',
        error: e,
        displayMessage: Constants.BOT_TOAST_MESSAGES['FAILED_CREATE_CLASS']!,
      );
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
  }

  updateClass() async {
    // Similar implementation to createSection with necessary modifications
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      // Set loading state to indicate API call in progress
      isLoading.value = true;
      Map<String, dynamic> payload = {
        'name': nameController.text,
        'code': codeController.text,
      };

      c.Response? res = await NetworkUtils.safeApiCall(
        () => _apiService.updateClass(classId.value, payload),
      );

      if (res == null) return;
      if (res.isSuccessful) {
        // Validate response body structure and success status
        if (res.body != null &&
            res.body['data'] != null &&
            res.body['success'] == true) {
          // // Show success message and navigate to main app
          botToastSuccess(Constants.BOT_TOAST_MESSAGES['CLASS_UPDATED']!);
           Get.offAllNamed(Routes.CLASS_DETAIL, arguments: {'class_id': classId.value});
        } else {
          // Handle API error responses
          serverError(res, () => updateClass());
        }
      }
    } catch (e) {
      // Handle unexpected errors

      errorUtil.handleAppError(
        apiName: 'updateSection',
        error: e,
        displayMessage: Constants.BOT_TOAST_MESSAGES['FAILED_UPDATE_SECTION']!,
      );
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
  }
}
