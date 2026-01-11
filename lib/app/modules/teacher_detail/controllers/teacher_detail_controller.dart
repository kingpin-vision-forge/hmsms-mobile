import 'package:get/get.dart';
import 'package:chopper/chopper.dart' as c;
import 'package:student_management/app/data/apis.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/global.dart';
import 'package:student_management/app/helpers/utilities/network_util.dart';
import 'package:student_management/app/modules/teacher_detail/models/teacher_detail_response.dart';
import 'package:student_management/app/routes/app_pages.dart';

class TeacherDetailController extends GetxController {
  final ApiService _apiService = ApiService.create();

  var isLoading = false.obs;
  var isUpdating = false.obs;
  var teacher = Rxn<TeacherDetailResponse>();

  String? teacherId;

  @override
  void onInit() {
    super.onInit();
    // Get teacher ID from route arguments
    teacherId = Get.arguments?['teacher_id'] ?? Get.parameters['teacher_id'];
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
          teacher.value = TeacherDetailResponse.fromJson(res.body);
        } else {
          serverError(res, () => fetchTeacherDetails());
        }
      }
    } catch (e) {
      errorUtil.handleAppError(
        apiName: 'teacherDetails',
        error: e,
        displayMessage:
            Constants.BOT_TOAST_MESSAGES['FAILED_FETCH_TEACHER'] ??
            'Failed to fetch teacher details',
      );
    } finally {
      isLoading.value = false;
    }
  }

  passEditTeacherArguments() {
    if (teacherId == null || teacher.value == null) return;

    final teacherData = teacher.value!.data;
    final teacherUser = teacherData.user;

    Get.toNamed(
      Routes.CREATE_TEACHER,
      arguments: {
        'isEdit': true,
        'teacherId': teacherId,
        'firstName': teacherUser.firstName,
        'middleName': teacherUser.middleName ?? '',
        'lastName': teacherUser.lastName,
        'email': teacherUser.email,
        'phone': teacherUser.phone ?? '',
        'address': teacherUser.address ?? '',
        'employeeCode': teacherData.employeeCode,
        'joinedDate': _formatDate(teacherData.joinedDate.toString()),
      },
    );
  }

  String _formatDate(String dateString) {
    try {
      if (dateString.isEmpty) return '';
      final date = DateTime.parse(dateString);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
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
