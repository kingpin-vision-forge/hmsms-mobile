import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:student_management/app/data/apis.dart';
import 'package:student_management/app/helpers/global.dart';
import 'package:student_management/app/modules/home/models/rank_response.dart';

/// Controller for Student Dashboard
/// Fetches student-specific dashboard data from API
class StudentDashboardController extends GetxController {
  final _apiService = ApiService.create();

  // Observable state
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // Dashboard data
  final studentName = ''.obs;
  final admissionNumber = ''.obs;
  final className = ''.obs;
  final sectionName = ''.obs;
  final rollNumber = 0.obs;

  // Stats
  final attendancePercentage = 0.0.obs;
  final totalClassesToday = 0.obs;
  final upcomingExams = 0.obs;

  // Timetable
  final todayTimetable = <Map<String, dynamic>>[].obs;

  // Attendance Summary
  final attendanceSummary = <String, dynamic>{}.obs;

  // Recent Grades
  final recentGrades = <Map<String, dynamic>>[].obs;

  // Pending Fees
  final pendingFees = Rxn<Map<String, dynamic>>();

  // Student Rank
  final studentRank = Rxn<StudentRankData>();
  final isLoadingRank = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final response = await _apiService.fetchStudentDashboard();

      if (response.isSuccessful && response.body != null) {
        final data = response.body as Map<String, dynamic>;

        studentName.value = data['studentName'] ?? '';

        // Parse student info
        final info = data['studentInfo'] as Map<String, dynamic>? ?? {};
        admissionNumber.value = info['admissionNumber'] ?? '';
        className.value = info['className'] ?? 'N/A';
        sectionName.value = info['sectionName'] ?? '';
        rollNumber.value = info['rollNumber'] ?? 0;

        // Parse stats
        final stats = data['stats'] as Map<String, dynamic>? ?? {};
        attendancePercentage.value = (stats['attendancePercentage'] ?? 0).toDouble();
        totalClassesToday.value = stats['totalClassesToday'] ?? 0;
        upcomingExams.value = stats['upcomingExams'] ?? 0;

        // Parse today's timetable
        final timetable = data['todayTimetable'] as List<dynamic>? ?? [];
        todayTimetable.value = timetable.cast<Map<String, dynamic>>();

        // Parse attendance summary
        attendanceSummary.value = data['attendanceSummary'] as Map<String, dynamic>? ?? {};

        // Parse recent grades
        final grades = data['recentGrades'] as List<dynamic>? ?? [];
        recentGrades.value = grades.cast<Map<String, dynamic>>();

        // Parse pending fees
        pendingFees.value = data['pendingFees'] as Map<String, dynamic>?;

        // Fetch student rank
        await fetchStudentRank();
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

  /// Fetch student rank from API
  Future<void> fetchStudentRank() async {
    // Get studentId from global userData
    final studentId = userData['studentId'] ?? userData['id'];
    if (studentId == null) return;

    isLoadingRank.value = true;
    try {
      final response = await _apiService.fetchStudentRank(studentId);

      if (response.isSuccessful && response.body != null) {
        final rankResponse = StudentRankResponse.fromJson(response.body);
        if (rankResponse.success && rankResponse.data != null) {
          studentRank.value = rankResponse.data;
        }
      }
    } catch (e) {
      // Silently fail for rank - it's supplementary info
      debugPrint('Failed to fetch student rank: $e');
    } finally {
      isLoadingRank.value = false;
    }
  }

  void refresh() {
    fetchDashboardData();
  }
}
