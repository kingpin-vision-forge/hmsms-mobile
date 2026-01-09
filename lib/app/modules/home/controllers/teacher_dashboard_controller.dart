import 'package:get/get.dart';
import 'package:student_management/app/data/apis.dart';

/// Controller for Teacher Dashboard
/// Fetches teacher-specific dashboard data from API
class TeacherDashboardController extends GetxController {
  final _apiService = ApiService.create();

  // Observable state
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // Dashboard data
  final teacherName = ''.obs;
  final totalClasses = 0.obs;
  final totalStudents = 0.obs;
  final todayClassesCount = 0.obs;
  final pendingAttendance = 0.obs;
  final todaySchedule = <Map<String, dynamic>>[].obs;
  final assignedClasses = <Map<String, dynamic>>[].obs;
  final attendanceStats = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final response = await _apiService.fetchTeacherDashboard();

      if (response.isSuccessful && response.body != null) {
        final data = response.body as Map<String, dynamic>;

        teacherName.value = data['teacherName'] ?? '';

        // Parse stats
        final stats = data['stats'] as Map<String, dynamic>? ?? {};
        totalClasses.value = stats['totalClasses'] ?? 0;
        totalStudents.value = stats['totalStudents'] ?? 0;
        todayClassesCount.value = stats['todayClassesCount'] ?? 0;
        pendingAttendance.value = stats['pendingAttendance'] ?? 0;

        // Parse today's schedule
        final schedule = data['todaySchedule'] as List<dynamic>? ?? [];
        todaySchedule.value = schedule.cast<Map<String, dynamic>>();

        // Parse assigned classes
        final classes = data['assignedClasses'] as List<dynamic>? ?? [];
        assignedClasses.value = classes.cast<Map<String, dynamic>>();

        // Parse attendance stats
        attendanceStats.value = data['attendanceStats'] as Map<String, dynamic>? ?? {};
      } else {
        hasError.value = true;
        errorMessage.value = 'Failed to load dashboard data';
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void refresh() {
    fetchDashboardData();
  }
}
