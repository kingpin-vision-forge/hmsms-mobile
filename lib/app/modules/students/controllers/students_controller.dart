import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_management/app/data/apis.dart';
import 'package:chopper/chopper.dart' as c;
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/global.dart';
import 'package:student_management/app/helpers/utilities/network_util.dart';
import 'package:student_management/app/modules/create_section/models/fetch_classes_section.dart';
import 'package:student_management/app/modules/students/models/fetch_parent.dart';
import 'package:student_management/app/routes/app_pages.dart';

class StudentsController extends GetxController {
  final ApiService _apiService = ApiService.create();

  final formKey = GlobalKey<FormState>();

  // Text editing controllers for form fields
  final firstNameController = TextEditingController();
  final middleNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final admissionNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  // Observable variables for form validation and selection
  var hasInteractedWithName = false.obs;
  var isFormValid = false.obs;
  var isLoading = false.obs;
  var selectedClassId = ''.obs;
  var selectedSectionId = ''.obs;
  var selectedParentId = ''.obs;
  var selectedGender = ''.obs;
  var dateOfBirth = Rx<DateTime?>(null);
  var isClassLoading = false.obs;
  var isParentLoading = false.obs;

  // Dropdown data
  var parentList = <ParentDropdownData>[].obs;
  var sectionList = <ClassDropdownData>[].obs;
  var classList = <ClassDropdownData>[].obs;

  // Edit mode variables
  var isEdit = false.obs;
  var studentId = '';

  @override
  void onInit() {
    super.onInit();
    firstNameController.addListener(checkFormValidity);
    emailController.addListener(checkFormValidity);
    phoneController.addListener(checkFormValidity);
    passwordController.addListener(checkFormValidity);
    admissionNumberController.addListener(checkFormValidity);

    // Check if we're in edit mode
    if (Get.arguments != null && Get.arguments['isEdit'] == true) {
      isEdit.value = true;
      _loadEditData();
    }

    fetchClasses();
    fetchParent();
  }

  // Load edit data from arguments
  Future<void> _loadEditData() async {
    try {
      final args = Get.arguments;
      studentId = args['student_id'];
      firstNameController.text = args['firstName'] ?? '';
      middleNameController.text = args['middleName'] ?? '';
      lastNameController.text = args['lastName'] ?? '';
      addressController.text = args['address'] ?? '';
      emailController.text = args['email'] ?? '';
      phoneController.text = args['phone'] ?? '';
      admissionNumberController.text = args['admissionNumber'] ?? '';
      selectedClassId.value = args['classId'] ?? '';
      // fetch sections for the selected class in edit mode, but do not reset selection
      await fetchSection(resetSelection: false);
      selectedSectionId.value = args['sectionId'] ?? '';
      selectedParentId.value = args['parentId'] ?? '';
      selectedGender.value = args['gender'] ?? '';

      // Parse date of birth
      if (args['dateOfBirth'] != null &&
          args['dateOfBirth'].toString().isNotEmpty) {
        try {
          dateOfBirth.value = DateTime.parse(args['dateOfBirth'].toString());
        } catch (e) {
          dateOfBirth.value = null;
        }
      }
    } catch (e) {
    }
  }

  // Check overall form validity
  void checkFormValidity() {
    // In edit mode, password is optional
    isFormValid.value =
        firstNameController.text.isNotEmpty &&
        admissionNumberController.text.isNotEmpty &&
        selectedClassId.value.isNotEmpty &&
        selectedSectionId.value.isNotEmpty &&
        selectedParentId.value.isNotEmpty &&
        selectedGender.value.isNotEmpty &&
        (isEdit.value || passwordController.text.isNotEmpty) &&
        emailController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        dateOfBirth.value != null;
  }

  // create student
  createStudent() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      // Set loading state to indicate API call in progress
      isLoading.value = true;
      Map<String, dynamic> payload = {
        'schoolId': schoolId,
        "firstName": firstNameController.text,
        "middleName": middleNameController.text,
        'password': passwordController.text,
        "lastName": lastNameController.text,
        "admissionNumber": admissionNumberController.text,
        "classId": selectedClassId.value,
        "sectionId": selectedSectionId.value,
        "dateOfBirth": dateOfBirth.value?.toIso8601String() ?? "",
        "gender": selectedGender.value,
        "parentId": selectedParentId.value,
        'phone': phoneController.text,
        'address': addressController.text,
        'email': emailController.text,
      };

      c.Response? res = await NetworkUtils.safeApiCall(
        () => _apiService.createStudent(payload),
      );

      if (res == null) return;
      if (res.isSuccessful) {
        // Validate response body structure and success status
        if (res.body != null &&
            res.body['data'] != null &&
            res.body['success'] == true) {
          botToastSuccess(Constants.BOT_TOAST_MESSAGES['STUDENT_CREATED']!);
          Get.offAllNamed(Routes.STUDENT_LIST);
        } else {
          // Handle API error responses
          serverError(res, () => createStudent());
        }
      }
    } catch (e) {
      // Handle unexpected errors

      errorUtil.handleAppError(
        apiName: 'createStudent',
        error: e,
        displayMessage: Constants.BOT_TOAST_MESSAGES['FAILED_CREATE_STUDENT']!,
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

  //fetch section based on class selected
  fetchSection({bool resetSelection = true}) async {
    try {
      // Set loading state to indicate API call in progress
      isClassLoading.value = true;

      if (selectedClassId.value.isEmpty) {
        sectionList.clear();
        return;
      }

      c.Response? res = await NetworkUtils.safeApiCall(
        () => _apiService.fetchSectionForClass(classId: selectedClassId.value),
      );

      if (res == null) return;
      if (res.isSuccessful) {
        if (res.body != null &&
            res.body['data'] != null &&
            res.body['success'] == true) {
          final response = FetchClassesSectionResponse.fromJson(res.body);
          sectionList.value = response.data;
          // Reset section selection when class changes, unless preserving for edit
          if (resetSelection) {
            selectedSectionId.value = '';
          }
        } else {
          // Handle API error responses
          serverError(res, () => fetchSection());
        }
      }
    } catch (e) {
      // Handle unexpected errors

      errorUtil.handleAppError(
        apiName: 'fetchSection',
        error: e,
        displayMessage: Constants.BOT_TOAST_MESSAGES['FAILED_FETCH_SECTIONS']!,
      );
    } finally {
      // Reset loading state
      isClassLoading.value = false;
    }
  }

  // fetch parent dropdown
  fetchParent() async {
    try {
      // Set loading state to indicate API call in progress
      isParentLoading.value = true;
      // Resolve schoolId from storage with fallback to global userData
      final storedUserData = await readFromStorage(
        Constants.STORAGE_KEYS['USER_DATA']!,
      );
      final String? storageSchoolId = (storedUserData is Map<String, dynamic>)
          ? storedUserData['schoolId']
          : null;
      final String? globalSchoolId = (userData is Map<String, dynamic>)
          ? userData['schoolId']
          : null;
      final String? effectiveSchoolId = storageSchoolId ?? globalSchoolId;

      c.Response? res = await NetworkUtils.safeApiCall(
        () => _apiService.fetchParentForStudent(schoolId: effectiveSchoolId),
      );

      if (res == null) return;
      if (res.isSuccessful) {
        if (res.body != null &&
            res.body['data'] != null &&
            res.body['success'] == true) {
          final response = FetchParentResponse.fromJson(res.body);
          parentList.value = response.data;
        } else {
          // Handle API error responses
          serverError(res, () => fetchParent());
        }
      }
    } catch (e) {
      // Handle unexpected errors

      errorUtil.handleAppError(
        apiName: 'fetchParent',
        error: e,
        displayMessage: Constants.BOT_TOAST_MESSAGES['FAILED_FETCH_PARENT']!,
      );
    } finally {
      // Reset loading state
      isParentLoading.value = false;
    }
  }

  //upate student
  updateStudent() async {
    try {
      // Set loading state to indicate API call in progress
      isLoading.value = true;
      Map<String, dynamic> payload = {
        "firstName": firstNameController.text,
        "middleName": middleNameController.text,
        "lastName": lastNameController.text,
        "classId": selectedClassId.value,
        "sectionId": selectedSectionId.value,
        "dateOfBirth": dateOfBirth.value?.toIso8601String() ?? "",
        "gender": selectedGender.value,
        "parentId": selectedParentId.value,
        'phone': phoneController.text,
        'address': addressController.text,
        'email': emailController.text,
      };

      // Only include password if provided during edit
      if (passwordController.text.isNotEmpty) {
        payload['password'] = passwordController.text;
      }

      c.Response? res = await NetworkUtils.safeApiCall(
        () => _apiService.updateStudent(studentId, payload),
      );

      if (res == null) return;
      if (res.isSuccessful) {
        // Validate response body structure and success status
        if (res.body != null &&
            res.body['data'] != null &&
            res.body['success'] == true) {
          // // Show success message and navigate to main app
          botToastSuccess(Constants.BOT_TOAST_MESSAGES['STUDENT_UPDATED']!);
           Get.offAllNamed(Routes.STUDENT_DETAIL, arguments: {'student_id': studentId});
        } else {
          // Handle API error responses
          serverError(res, () => updateStudent());
        }
      } else {
        // Handle API error responses
        serverError(res, () => updateStudent());
      }
    } catch (e) {
      // Handle unexpected errors

      errorUtil.handleAppError(
        apiName: 'updateStudent',
        error: e,
        displayMessage: Constants.BOT_TOAST_MESSAGES['FAILED_UPDATE_STUDENT']!,
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
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    admissionNumberController.dispose();
    super.onClose();
  }
}
