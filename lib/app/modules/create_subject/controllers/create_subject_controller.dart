import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chopper/chopper.dart' as c;
import 'package:student_management/app/data/apis.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/global.dart';
import 'package:student_management/app/helpers/utilities/network_util.dart';
import 'package:student_management/app/modules/create_section/models/fetch_classes_section.dart';
import 'package:student_management/app/routes/app_pages.dart';

class CreateSubjectController extends GetxController {
  final ApiService _apiService = ApiService.create();
  final nameController = TextEditingController();
  final codeController = TextEditingController();
  final classIdController = TextEditingController();
  var isLoading = false.obs;
  var isEditMode = false.obs;
  var subjectId = ''.obs;
  var selectedClassId = ''.obs;
  var isFormValid = false.obs;
  final formKey = GlobalKey<FormState>();
  var classList = <ClassDropdownData>[].obs;
  var isClassLoading = false.obs;
  var hasInteractedWithName = false.obs;
  var hasInteractedWithCode = false.obs;

  @override
  void onInit() {
    super.onInit();
    nameController.addListener(checkFormValidity);
    codeController.addListener(checkFormValidity);
    fetchClasses();

    // Accept the argument coming from the section detail for edit
    if (Get.arguments != null && Get.arguments['isEdit'] == true) {
      isEditMode.value = true;
      subjectId.value = Get.arguments['subject_id'] ?? '';
      nameController.text = Get.arguments['subject_name'] ?? '';
      codeController.text = Get.arguments['subject_code'] ?? '';

      final classId = Get.arguments['class_id'];
      if (classId != null && classId.isNotEmpty) {
        selectedClassId.value = classId;
      }
    }
  }

  // Check overall form validity
  void checkFormValidity() {
    if (isEditMode.value) {
      isFormValid.value =
          nameController.text.isNotEmpty &&
          selectedClassId.value.isNotEmpty &&
          codeController.text.isNotEmpty;
    } else {
      isFormValid.value =
          nameController.text.isNotEmpty &&
          selectedClassId.value.isNotEmpty &&
          codeController.text.isNotEmpty;
    }
  }

  // Validate class name
  String? validateName(String value) {
    if (value.isEmpty) {
      return 'Subject name cannot be empty';
    }
    if (value.length < 3) {
      return 'Subject name must be at least 3 characters';
    }
    return null;
  }

  // Validate subject code
  String? validateCode(String value) {
    if (value.isEmpty) {
      return 'Subject code cannot be empty';
    }
    if (value.length < 2) {
      return 'Subject code must be at least 2 characters';
    }
    return null;
  }

  createSubject() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      // Set loading state to indicate API call in progress
      isLoading.value = true;
      Map<String, dynamic> payload = {
        'name': nameController.text,
        'code': codeController.text,
        'classId': selectedClassId.value,
      };

      c.Response? res = await NetworkUtils.safeApiCall(
        () => _apiService.createSubject(payload),
      );

      if (res == null) return;
      if (res.isSuccessful) {
        // Validate response body structure and success status
        if (res.body != null &&
            res.body['data'] != null &&
            res.body['success'] == true) {
          // // Show success message and navigate to main app
          botToastSuccess(Constants.BOT_TOAST_MESSAGES['SUBJECT_CREATED']!);
          Get.offAllNamed(Routes.SUBJECT_LIST);
        } else {
          // Handle API error responses
          serverError(res, () => createSubject());
        }
      }
    } catch (e) {
      // Handle unexpected errors

      errorUtil.handleAppError(
        apiName: 'createSubject',
        error: e,
        displayMessage: Constants.BOT_TOAST_MESSAGES['FAILED_CREATE_SUBJECT']!,
      );
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
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

  //update subject
  updateSubject() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      // Set loading state to indicate API call in progress
      isLoading.value = true;
      Map<String, dynamic> payload = {
        'name': nameController.text,
        'code': codeController.text,
        'classId': selectedClassId.value,
      };

      c.Response? res = await NetworkUtils.safeApiCall(
        () => _apiService.updateSubject(subjectId.value, payload),
      );

      if (res == null) return;
      if (res.isSuccessful) {
        // Validate response body structure and success status
        if (res.body != null &&
            res.body['data'] != null &&
            res.body['success'] == true) {
          // // Show success message and navigate to main app
          botToastSuccess(Constants.BOT_TOAST_MESSAGES['SUBJECT_UPDATED']!);
          Get.offAllNamed(Routes.SUBJECT_DETAIL, arguments: {'subject_id': subjectId.value});
        } else {
          // Handle API error responses
          serverError(res, () => updateSubject());
        }
      } else {
        // Handle API error responses
        serverError(res, () => updateSubject());
      }
    } catch (e) {
      // Handle unexpected errors

      errorUtil.handleAppError(
        apiName: 'updateSubject',
        error: e,
        displayMessage: Constants.BOT_TOAST_MESSAGES['FAILED_UPDATE_SUBJECT']!,
      );
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    nameController.dispose();
    codeController.dispose();
    classIdController.dispose();
    super.onClose();
  }
}
