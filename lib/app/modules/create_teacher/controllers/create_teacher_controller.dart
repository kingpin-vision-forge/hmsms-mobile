import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chopper/chopper.dart' as c;
import 'package:student_management/app/data/apis.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/global.dart';
import 'package:student_management/app/helpers/utilities/network_util.dart';
import 'package:student_management/app/routes/app_pages.dart';

class CreateTeacherController extends GetxController {
  final ApiService _apiService = ApiService.create();
  var isEditMode = false.obs;
  final formKey = GlobalKey<FormState>();
  var isLoading = false.obs;

  // Form controllers
  final firstNameController = TextEditingController();
  final middleNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final employeeCodeController = TextEditingController();
  final joinedDateController = TextEditingController();

  // Per-field error state
  final firstNameError = RxnString();
  final middleNameError = RxnString();
  final lastNameError = RxnString();
  final emailError = RxnString();
  final passwordError = RxnString();
  final phoneError = RxnString();
  final addressError = RxnString();
  final employeeCodeError = RxnString();
  final joinedDateError = RxnString();

  // Form state
  var isFormValid = false.obs;
  var selectedDate = Rxn<DateTime>();
  String? teacherId;

  @override
  void onInit() {
    super.onInit();

    // Check if in edit mode
    final args = Get.arguments;
    if (args != null && args['isEdit'] == true) {
      isEditMode.value = true;
      teacherId = args['teacherId'];
      _initializeEditMode(args);
    }

    // Listen to all field changes for real-time validation
    firstNameController.addListener(validateFirstName);
    lastNameController.addListener(validateLastName);
    emailController.addListener(validateEmail);
    passwordController.addListener(validatePassword);
    phoneController.addListener(validatePhone);
    employeeCodeController.addListener(validateEmployeeCode);
    joinedDateController.addListener(validateJoinedDate);
  }

  void _initializeEditMode(Map<String, dynamic> args) {
    firstNameController.text = args['firstName'] ?? '';
    middleNameController.text = args['middleName'] ?? '';
    lastNameController.text = args['lastName'] ?? '';
    emailController.text = args['email'] ?? '';
    phoneController.text = args['phone'] ?? '';
    addressController.text = args['address'] ?? '';
    employeeCodeController.text = args['employeeCode'] ?? '';
    joinedDateController.text = args['joinedDate'] ?? '';

    // Parse joined date if available
    if (args['joinedDate'] != null) {
      try {
        selectedDate.value = DateTime.parse(args['joinedDate']);
      } catch (_) {}
    }

    // Validate all fields to set initial form validity
    validateAllFields();
  }

  void validateAllFields() {
    validateFirstName();
    validateLastName();
    validateEmail();
    validatePhone();
    validateEmployeeCode();
    validateJoinedDate();
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
    } else if (!isEditMode.value && passwordController.text.trim().isEmpty) {
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
      final cleanedValue = value.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');
      if (!GetUtils.isNumericOnly(cleanedValue) || cleanedValue.length < 7) {
        phoneError.value = 'Enter a valid phone number';
      } else {
        phoneError.value = null;
      }
    }
    updateFormValidity();
  }

  void validateEmployeeCode() {
    employeeCodeError.value = employeeCodeController.text.trim().isEmpty
        ? 'Employee code is required'
        : null;
    updateFormValidity();
  }

  void validateJoinedDate() {
    joinedDateError.value = joinedDateController.text.trim().isEmpty
        ? 'Joined date is required'
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
      employeeCodeError.value,
      joinedDateError.value,
    ].every((element) => element == null);

    isFormValid.value = isValid;
  }

  void selectJoinedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      selectedDate.value = picked;
      joinedDateController.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      validateJoinedDate();
    }
  }

  // Create teacher
  createTeacher() async {
    validateAllFields();
    validatePassword();

    if (!isFormValid.value) {
      botToastError('Please correct the highlighted fields');
      return;
    }

    try {
      isLoading.value = true;

      Map<String, dynamic> payload = {
        'schoolId': schoolId,
        'firstName': firstNameController.text.trim(),
        'middleName': middleNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'email': emailController.text.trim(),
        'password': passwordController.text,
        'phone': phoneController.text.trim(),
        'address': addressController.text.trim(),
        'employeeCode': employeeCodeController.text.trim(),
        'joinedDate': joinedDateController.text.trim(),
      };

      c.Response? res = await NetworkUtils.safeApiCall(
        () => _apiService.createTeacher(payload),
      );

      if (res == null) return;
      if (res.isSuccessful) {
        if (res.body != null &&
            res.body['data'] != null &&
            res.body['success'] == true) {
          botToastSuccess(
            Constants.BOT_TOAST_MESSAGES['TEACHER_CREATED'] ??
                'Teacher created successfully',
          );
          Get.offAllNamed(Routes.TEACHER_LIST);
        } else {
          serverError(res, () => createTeacher());
        }
      }
    } catch (e) {
      errorUtil.handleAppError(
        apiName: 'createTeacher',
        error: e,
        displayMessage:
            Constants.BOT_TOAST_MESSAGES['FAILED_CREATE_TEACHER'] ??
            'Failed to create teacher',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update teacher
  void updateTeacher() async {
    validateAllFields();

    if (!isFormValid.value) {
      botToastError('Please correct the highlighted fields');
      return;
    }

    if (teacherId == null) return;

    try {
      isLoading.value = true;

      Map<String, dynamic> payload = {
        'firstName': firstNameController.text.trim(),
        'middleName': middleNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'email': emailController.text.trim(),
        if (passwordController.text.isNotEmpty)
          'password': passwordController.text,
        'phone': phoneController.text.trim(),
        'address': addressController.text.trim(),
        // 'employeeCode': employeeCodeController.text.trim(),
        'joinedDate': joinedDateController.text.trim(),
      };

      c.Response? res = await NetworkUtils.safeApiCall(
        () => _apiService.updateTeacher(teacherId!, payload),
      );

      if (res == null) return;
      if (res.isSuccessful) {
        if (res.body != null &&
            res.body['data'] != null &&
            res.body['success'] == true) {
          botToastSuccess(
            Constants.BOT_TOAST_MESSAGES['TEACHER_UPDATED'] ??
                'Teacher updated successfully',
          );
          Get.offAllNamed(
            Routes.TEACHER_DETAIL,
            arguments: {'teacher_id': teacherId},
          );
        } else {
          serverError(res, () => updateTeacher());
        }
      }
    } catch (e) {
      errorUtil.handleAppError(
        apiName: 'updateTeacher',
        error: e,
        displayMessage:
            Constants.BOT_TOAST_MESSAGES['FAILED_UPDATE_TEACHER'] ??
            'Failed to update teacher',
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    firstNameController.removeListener(validateFirstName);
    lastNameController.removeListener(validateLastName);
    emailController.removeListener(validateEmail);
    passwordController.removeListener(validatePassword);
    phoneController.removeListener(validatePhone);
    employeeCodeController.removeListener(validateEmployeeCode);
    joinedDateController.removeListener(validateJoinedDate);

    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    addressController.dispose();
    employeeCodeController.dispose();
    joinedDateController.dispose();
    super.onClose();
  }
}
