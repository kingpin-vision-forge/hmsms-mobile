import 'package:get/get.dart';
import 'package:chopper/chopper.dart' as c;
import 'package:student_management/app/data/apis.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/global.dart';
import 'package:student_management/app/helpers/utilities/network_util.dart';
import 'package:student_management/app/helpers/rbac/roles.dart';
import 'package:student_management/app/modules/timetable/models/timetable_response.dart';

class TimetableController extends GetxController {
  final ApiService _apiService = ApiService.create();

  var isLoading = false.obs;
  var timetableSlots = <TimetableSlot>[].obs;
  var selectedDayIndex = 0.obs;

  static const List<String> daysOfWeek = [
    'MONDAY',
    'TUESDAY',
    'WEDNESDAY',
    'THURSDAY',
    'FRIDAY',
    'SATURDAY',
  ];

  static const List<String> dayLabels = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
  ];

  // Get current user role
  UserRole get currentUserRole {
    if (userData == null || userData is! Map) {
      return UserRole.STUDENT;
    }
    final roleStr = (userData['role'] ?? '').toString().toUpperCase();
    return UserRole.values.firstWhere(
      (e) => e.name == roleStr,
      orElse: () => UserRole.STUDENT,
    );
  }

  @override
  void onInit() {
    super.onInit();
    // Set to current day (0 = Monday, 5 = Saturday)
    final now = DateTime.now();
    final dayIndex = now.weekday - 1; // weekday is 1-7, we need 0-5
    if (dayIndex >= 0 && dayIndex < 6) {
      selectedDayIndex.value = dayIndex;
    }
    fetchTimetable();
  }

  Future<void> fetchTimetable() async {
    try {
      isLoading.value = true;

      c.Response? res;

      // Fetch based on user role
      if (currentUserRole == UserRole.TEACHER) {
        // For teachers, fetch by teacher ID
        final teacherId = userData['teacher']?['id'];
        if (teacherId != null) {
          res = await NetworkUtils.safeApiCall(
            () => _apiService.fetchTimetableByTeacher(teacherId),
          );
        }
      } else if (currentUserRole == UserRole.STUDENT) {
        // For students, fetch by class ID
        final classId = userData['student']?['classId'];
        if (classId != null) {
          res = await NetworkUtils.safeApiCall(
            () => _apiService.fetchTimetableByClass(classId),
          );
        }
      } else {
        // For admin/parent, fetch all
        res = await NetworkUtils.safeApiCall(
          () => _apiService.fetchTimetable(),
        );
      }

      if (res == null) return;
      if (res.isSuccessful && res.body != null && res.body['success'] == true) {
        final response = TimetableResponse.fromJson(res.body);
        timetableSlots.value = response.data;
      } else {
        serverError(res, () => fetchTimetable());
      }
    } catch (e) {
      errorUtil.handleAppError(
        apiName: 'fetchTimetable',
        error: e,
        displayMessage: 'Failed to load timetable',
      );
    } finally {
      isLoading.value = false;
    }
  }

  List<TimetableSlot> get slotsForSelectedDay {
    final selectedDay = daysOfWeek[selectedDayIndex.value];
    return timetableSlots
        .where((slot) => slot.dayOfWeek.toUpperCase() == selectedDay)
        .toList()
      ..sort((a, b) => a.periodNumber.compareTo(b.periodNumber));
  }

  void selectDay(int index) {
    selectedDayIndex.value = index;
  }

  Future<void> refresh() async {
    await fetchTimetable();
  }
}
