import 'package:get/get.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/global.dart';
import 'package:student_management/app/helpers/utilities/network_util.dart';
import 'package:chopper/chopper.dart' as c;
import 'package:student_management/app/data/apis.dart';
import 'package:student_management/app/modules/student_detail/models/student_Detail_response.dart';
import 'package:student_management/app/routes/app_pages.dart';

class StudentDetailController extends GetxController {
  final ApiService _apiService = ApiService.create();

  var studentId;
  var isLoading = false.obs;
  Rx<StudentDetailResponse?> studentDetailData = Rx<StudentDetailResponse?>(
    null,
  );

  @override
  void onInit() {
    super.onInit();
    studentId = Get.arguments['student_id'];
    studentDetails();
  }

  studentDetails() async {
    try {
      // Set loading state
      isLoading(true);
      c.Response? res = await NetworkUtils.safeApiCall(
        () => _apiService.studentDetails(studentId),
      );
      if (res == null) return;
      // Handle successful response
      if (res.isSuccessful) {
        if (res.body != null &&
            res.body.runtimeType != String &&
            res.body['data'] != null &&
            res.body['success'] == true) {
          final parsedData = StudentDetailResponse.fromJson(res.body);
          studentDetailData.value = parsedData;
        }
      } else {
        // Handle API errors
        serverError(res, () => studentDetails());
      }
    } catch (e) {
      // Handle unexpected errors
      errorUtil.handleAppError(
        apiName: 'fetch student detail',
        error: e,
        displayMessage:
            Constants.BOT_TOAST_MESSAGES['FAILED_FETCH_STUDENT_DETAIL']!,
      );
    } finally {
      // Reset loading states
      isLoading(false);
    }
  }

  passEditStudentArguments() {
    if (studentDetailData.value?.data != null) {
      final studentData = studentDetailData.value!.data!;
      Get.toNamed(
        Routes.STUDENTS,
        arguments: {
          'isEdit': true,
          'student_id': studentData.id,
          'firstName': studentData.firstName,
          'middleName': studentData.middleName,
          'lastName': studentData.lastName,
          'address': studentData.address,
          'email': studentData.email,
          'phone': studentData.phone,
          'admissionNumber': studentData.admissionNumber,
          'classId': studentData.classId,
          'sectionId': studentData.sectionId,
          'dateOfBirth': studentData.dateOfBirth,
          'gender': studentData.gender,
          'parentId': studentData.parentId,
          'parentName': studentData.parentName,
          'parentMobile': studentData.parentMobile,
          'className': studentData.className,
          'sectionName': studentData.sectionName,
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
