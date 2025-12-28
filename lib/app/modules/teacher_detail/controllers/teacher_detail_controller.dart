import 'package:get/get.dart';
import 'package:chopper/chopper.dart' as c;
import 'package:student_management/app/data/apis.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/global.dart';
import 'package:student_management/app/helpers/utilities/network_util.dart';
import 'package:student_management/app/modules/teacher_list/models/teacher_response.dart';

class TeacherDetailController extends GetxController {
  final ApiService _apiService = ApiService.create();

  var isLoading = false.obs;
  var isUpdating = false.obs;
  var teacher = Rxn<Teacher>();

  String? teacherId;

  @override
  void onInit() {
    super.onInit();
    // Get teacher ID from route arguments
    teacherId = Get.arguments?['id'] ?? Get.parameters['id'];
    if (teacherId != null) {
      fetchTeacherDetails();
    }
  }

  /// Fetch teacher details from API
  fetchTeacherDetails() async {
    if (teacherId == null) return;

    try {
      isLoading.value = true;

      c.Response? res = await NetworkUtils.safeApiCall(
        () => _apiService.teacherDetails(teacherId!),
      );

      if (res == null) return;
      if (res.isSuccessful) {
        if (res.body != null &&
            res.body['data'] != null &&
            res.body['success'] == true) {
          teacher.value = Teacher.fromJson(res.body['data']);
        } else {
          serverError(res, () => fetchTeacherDetails());
        }
      }
    } catch (e) {
      errorUtil.handleAppError(
        apiName: 'teacherDetails',
        error: e,
        displayMessage: Constants.BOT_TOAST_MESSAGES['FAILED_FETCH_TEACHER'] ?? 'Failed to fetch teacher details',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Update teacher details
  updateTeacher(Map<String, dynamic> data) async {
    if (teacherId == null) return;

    try {
      isUpdating.value = true;

      c.Response? res = await NetworkUtils.safeApiCall(
        () => _apiService.updateTeacher(teacherId!, data),
      );

      if (res == null) return;
      if (res.isSuccessful) {
        if (res.body != null && res.body['success'] == true) {
          // Refresh teacher details after update
          await fetchTeacherDetails();
          Get.snackbar('Success', 'Teacher updated successfully');
        } else {
          serverError(res, () => updateTeacher(data));
        }
      }
    } catch (e) {
      errorUtil.handleAppError(
        apiName: 'updateTeacher',
        error: e,
        displayMessage: Constants.BOT_TOAST_MESSAGES['FAILED_UPDATE_TEACHER'] ?? 'Failed to update teacher',
      );
    } finally {
      isUpdating.value = false;
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
