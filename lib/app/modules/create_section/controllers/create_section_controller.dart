import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chopper/chopper.dart' as c;
import 'package:student_management/app/data/apis.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/global.dart';
import 'package:student_management/app/helpers/utilities/network_util.dart';
import 'package:student_management/app/routes/app_pages.dart';
import 'package:student_management/app/modules/create_section/models/fetch_classes_section.dart';

class CreateSectionController extends GetxController {
  final ApiService _apiService = ApiService.create();
  // Text editing controllers for form fields
  final nameController = TextEditingController();
  final schoolIdController = TextEditingController();

  // Observable variables for form validation
  var hasInteractedWithName = false.obs;
  var isFormValid = false.obs;
  var isLoading = false.obs;
  var selectClass = <String>[].obs;
  var selectedSingleClass = ''.obs; // For edit mode - single class
  var classList = <ClassDropdownData>[].obs;
  var isClassLoading = false.obs;
  final formKey = GlobalKey<FormState>();
  var sectionId = ''.obs;
  var isEditMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    nameController.addListener(checkFormValidity);
    fetchClasses();

    // Accept the argument coming from the section detail for edit
    if (Get.arguments != null && Get.arguments['isEdit'] == true) {
      isEditMode.value = true;
      sectionId.value = Get.arguments['section_id'] ?? '';
      nameController.text = Get.arguments['section_name'] ?? '';

      // Set the selected class for edit mode (single selection)
      final classId = Get.arguments['class_id'];
      if (classId != null && classId.isNotEmpty) {
        selectedSingleClass.value = classId;
      }
    }
  }

  // Check overall form validity
  void checkFormValidity() {
    if (isEditMode.value) {
      isFormValid.value =
          nameController.text.isNotEmpty &&
          selectedSingleClass.value.isNotEmpty;
    } else {
      isFormValid.value =
          nameController.text.isNotEmpty && selectClass.isNotEmpty;
    }
  }

  // Validate class name
  String? validateName(String value) {
    if (value.isEmpty) {
      return 'Section name cannot be empty';
    }
    if (value.length < 1) {
      return 'Section name must be at least 1 character';
    }
    return null;
  }

  createSection() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      // Set loading state to indicate API call in progress
      isLoading.value = true;
      Map<String, dynamic> payload = {
        'name': nameController.text,
        'classIds': selectClass.toList(),
      };

      c.Response? res = await NetworkUtils.safeApiCall(
        () => _apiService.createSection(payload),
      );

      if (res == null) return;
      if (res.isSuccessful) {
        // Validate response body structure and success status
        if (res.body != null &&
            res.body['data'] != null &&
            res.body['success'] == true) {
          // // Show success message and navigate to main app
          botToastSuccess(Constants.BOT_TOAST_MESSAGES['SECTION_CREATED']!);
          Get.offAllNamed(Routes.SECTION_LIST);
        } else {
          // Handle API error responses
          serverError(res, () => createSection());
        }
      }
    } catch (e) {
      // Handle unexpected errors

      errorUtil.handleAppError(
        apiName: 'createSection',
        error: e,
        displayMessage: Constants.BOT_TOAST_MESSAGES['FAILED_CREATE_SECTION']!,
      );
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
  }

  updateSection() async {
    // Similar implementation to createSection with necessary modifications
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      // Set loading state to indicate API call in progress
      isLoading.value = true;
      Map<String, dynamic> payload = {
        'name': nameController.text,
        'classId': selectedSingleClass.value,
      };

      c.Response? res = await NetworkUtils.safeApiCall(
        () => _apiService.updateSection(sectionId.value, payload),
      );

      if (res == null) return;
      if (res.isSuccessful) {
        // Validate response body structure and success status
        if (res.body != null &&
            res.body['data'] != null &&
            res.body['success'] == true) {
          // // Show success message and navigate to main app
          botToastSuccess(Constants.BOT_TOAST_MESSAGES['SECTION_UPDATED']!);
          Get.offAllNamed(Routes.SECTION_LIST);
        } else {
          // Handle API error responses
          serverError(res, () => updateSection());
        }
      } else {
        // Handle API error responses
        serverError(res, () => updateSection());
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
