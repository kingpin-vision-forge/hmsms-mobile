import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chopper/chopper.dart' as c;
import 'package:student_management/app/data/apis.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/global.dart';
import 'package:student_management/app/helpers/utilities/network_util.dart';
import 'package:student_management/app/modules/create_parent/models/student_list.dart';
import 'package:student_management/app/modules/create_section/models/fetch_classes_section.dart';
import 'package:student_management/app/routes/app_pages.dart';

class CreateParentController extends GetxController {
  final ApiService _apiService = ApiService.create();
  var isEditMode = false.obs;
  final formKey = GlobalKey<FormState>();
  var isLoading = false.obs;
  var studentList = <StudentDropdownData>[].obs;
  var isStudentLoading = false.obs;
  var selectStudent = <String>[].obs;

  // Form controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final whatsappNumberController = TextEditingController();

  // Per-field error state
  final firstNameError = RxnString();
  final lastNameError = RxnString();
  final emailError = RxnString();
  final passwordError = RxnString();
  final phoneError = RxnString();
  final addressError = RxnString();
  final whatsappNumberError = RxnString();
  final studentError = RxnString();

  // Form state
  var isFormValid = false.obs;
  var isWhatsappOptIn = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Check if in edit mode
    final args = Get.arguments;
    if (args != null && args['isEdit'] == true) {
      isEditMode.value = true;
      _initializeEditMode(args);
    }

    fetchStudents();
  }

  void _initializeEditMode(Map<String, dynamic> args) {
    firstNameController.text = args['firstName'] ?? '';
    lastNameController.text = args['lastName'] ?? '';
    emailController.text = args['email'] ?? '';
    phoneController.text = args['phone'] ?? '';
    addressController.text = args['address'] ?? '';
    whatsappNumberController.text = args['whatsappNumber'] ?? '';
    isWhatsappOptIn.value = args['whatsappOptIn'] ?? false;

    // Set selected students
    final students = args['students'] as List<dynamic>?;
    if (students != null) {
      selectStudent.value = students.cast<String>();
    }

    // Validate all fields to set initial form validity
    validateFirstName();
    validateLastName();
    validateEmail();
    validatePhone();
    validateAddress();
    validateWhatsappNumber();
    validateStudentSelection();
  }

  // Field-level validations
  void validateFirstName() {
    firstNameError.value = firstNameController.text.trim().isEmpty
        ? 'First name is required'
        : null;
    updateFormValidity();
  }

  void validateLastName() {
    lastNameError.value = lastNameController.text.trim().isEmpty
        ? 'Last name is required'
        : null;
    updateFormValidity();
  }

  void validateEmail() {
    final value = emailController.text.trim();
    if (value.isEmpty) {
      emailError.value = 'Email is required';
    } else if (!GetUtils.isEmail(value)) {
      emailError.value = 'Enter a valid email address';
    } else {
      emailError.value = null;
    }
    updateFormValidity();
  }

  void validatePassword() {
    if (isEditMode.value && passwordController.text.trim().isEmpty) {
      passwordError.value = null;
    } else if (passwordController.text.trim().isEmpty) {
      passwordError.value = 'Password is required';
    } else if (passwordController.text.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
    } else {
      passwordError.value = null;
    }
    updateFormValidity();
  }

  void validatePhone() {
    final value = phoneController.text.trim();
    if (value.isEmpty) {
      phoneError.value = 'Phone is required';
    } else {
      // Remove common formatting characters
      final cleanedValue = value.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');

      // Check if it's numeric and at least 7 digits (flexible for international formats)
      if (!GetUtils.isNumericOnly(cleanedValue) || cleanedValue.length < 7) {
        phoneError.value =
            'Enter a valid phone number (e.g., 1234567890 or +91-1234567890)';
      } else {
        phoneError.value = null;
      }
    }
    updateFormValidity();
  }

  void validateAddress() {
    addressError.value = addressController.text.trim().isEmpty
        ? 'Address is required'
        : null;
    updateFormValidity();
  }

  void validateWhatsappNumber() {
    if (!isWhatsappOptIn.value &&
        whatsappNumberController.text.trim().isEmpty) {
      whatsappNumberError.value = null;
    } else if (whatsappNumberController.text.trim().isEmpty) {
      whatsappNumberError.value = 'WhatsApp number is required when opted in';
    } else if (whatsappNumberController.text.length < 7) {
      whatsappNumberError.value = 'Enter a valid WhatsApp number';
    } else {
      whatsappNumberError.value = null;
    }
    updateFormValidity();
  }

  void validateStudentSelection() {
    studentError.value = selectStudent.isEmpty
        ? 'Please select at least one student'
        : null;
    updateFormValidity();
  }

  void updateFormValidity() {
    final isValid = [
      firstNameError.value,
      lastNameError.value,
      emailError.value,
      passwordError.value,
      phoneError.value,
      addressError.value,
      whatsappNumberError.value,
      studentError.value,
    ].every((element) => element == null);

    isFormValid.value = isValid;
  }

  //create parent
  createParent() async {
    if (!isFormValid.value) {
      botToastError('Please correct the highlighted fields');
      return;
    }

    try {
      // Set loading state to indicate API call in progress
      isLoading.value = true;
      Map<String, dynamic> payload = {
        'schoolId': schoolId,
        "firstName": firstNameController.text,
        "lastName": lastNameController.text,
        "email": emailController.text,
        if (passwordController.text.isNotEmpty)
          "password": passwordController.text,
        "phone": phoneController.text,
        "address": addressController.text,
        "whatsappNumber": whatsappNumberController.text,
        "whatsappOptIn": isWhatsappOptIn.value,
        'studentIds': selectStudent.toList(),
      };

      c.Response? res = await NetworkUtils.safeApiCall(
        () => _apiService.createParent(payload),
      );

      if (res == null) return;
      if (res.isSuccessful) {
        // Validate response body structure and success status
        if (res.body != null &&
            res.body['data'] != null &&
            res.body['success'] == true) {
          // // Show success message and navigate to main app
          botToastSuccess(Constants.BOT_TOAST_MESSAGES['PARENT_CREATED']!);
          Get.offAllNamed(Routes.PARENT_LIST);
        } else {
          // Handle API error responses
          serverError(res, () => createParent());
        }
      }
    } catch (e) {
      // Handle unexpected errors

      errorUtil.handleAppError(
        apiName: 'createParent',
        error: e,
        displayMessage: Constants.BOT_TOAST_MESSAGES['FAILED_CREATE_PARENT']!,
      );
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
  }

  void updateParent() async {
    if (!isFormValid.value) {
      botToastError('Please correct the highlighted fields');
      return;
    }

    try {
      // Set loading state to indicate API call in progress
      isLoading.value = true;

      final parentId = Get.arguments['parentId'];

      Map<String, dynamic> payload = {
        "firstName": firstNameController.text,
        "lastName": lastNameController.text,
        "email": emailController.text,
        if (passwordController.text.isNotEmpty)
          "password": passwordController.text,
        "phone": phoneController.text,
        "address": addressController.text,
        "whatsappNumber": whatsappNumberController.text,
        "whatsappOptIn": isWhatsappOptIn.value,
        'studentIds': selectStudent.toList(),
      };

      c.Response? res = await NetworkUtils.safeApiCall(
        () => _apiService.updateParent(parentId, payload),
      );

      if (res == null) return;
      if (res.isSuccessful) {
        // Validate response body structure and success status
        if (res.body != null &&
            res.body['data'] != null &&
            res.body['success'] == true) {
          // Show success message and navigate back
          botToastSuccess(Constants.BOT_TOAST_MESSAGES['PARENT_UPDATED']!);
          Get.offAllNamed(
            Routes.PARENT_DETAIL,
            arguments: {'parent_id': parentId.value},
          );
        } else {
          // Handle API error responses
          serverError(res, () => updateParent());
        }
      }
    } catch (e) {
      // Handle unexpected errors
      errorUtil.handleAppError(
        apiName: 'updateParent',
        error: e,
        displayMessage: Constants.BOT_TOAST_MESSAGES['FAILED_UPDATE_PARENT']!,
      );
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
  }

  // fetch classes dropdown
  fetchStudents() async {
    try {
      // Set loading state to indicate API call in progress
      isStudentLoading.value = true;

      c.Response? res = await NetworkUtils.safeApiCall(
        () => _apiService.fetchStudentForParent(),
      );

      if (res == null) return;
      if (res.isSuccessful) {
        if (res.body != null &&
            res.body['data'] != null &&
            res.body['success'] == true) {
          final response = FetchStudentForParentResponse.fromJson(res.body);
          studentList.value = response.data;
        } else {
          // Handle API error responses
          serverError(res, () => fetchStudents());
        }
      }
    } catch (e) {
      // Handle unexpected errors

      errorUtil.handleAppError(
        apiName: 'fetchStudents',
        error: e,
        displayMessage: Constants.BOT_TOAST_MESSAGES['FAILED_FETCH_STUDENTS']!,
      );
    } finally {
      // Reset loading state
      isStudentLoading.value = false;
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    addressController.dispose();
    whatsappNumberController.dispose();
    super.onClose();
  }
}
