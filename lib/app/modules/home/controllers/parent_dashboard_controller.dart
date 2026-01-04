import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:student_management/app/data/apis.dart';
import 'package:student_management/app/modules/home/models/rank_response.dart';

/// Controller for Parent Dashboard
/// Fetches parent-specific dashboard data from API
class ParentDashboardController extends GetxController {
  final _apiService = ApiService.create();

  // Observable state
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // Dashboard data
  final parentName = ''.obs;
  final totalChildren = 0.obs;
  final children = <Map<String, dynamic>>[].obs;

  // Summary
  final totalPendingFees = 0.0.obs;
  final averageAttendance = 0.0.obs;
  final upcomingEvents = 0.obs;
  final unreadNotifications = 0.obs;

  // Children ranks - map of studentId to StudentRankData
  final childrenRanks = <String, StudentRankData>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final response = await _apiService.fetchParentDashboard();

      if (response.isSuccessful && response.body != null) {
        final data = response.body as Map<String, dynamic>;

        parentName.value = data['parentName'] ?? '';
        totalChildren.value = data['totalChildren'] ?? 0;

        // Parse children array
        final childrenList = data['children'] as List<dynamic>? ?? [];
        children.value = childrenList.cast<Map<String, dynamic>>();

        // Parse summary
        final summary = data['summary'] as Map<String, dynamic>? ?? {};
        totalPendingFees.value = (summary['totalPendingFees'] ?? 0).toDouble();
        averageAttendance.value = (summary['averageAttendance'] ?? 0).toDouble();
        upcomingEvents.value = summary['upcomingEvents'] ?? 0;
        unreadNotifications.value = summary['unreadNotifications'] ?? 0;

        // Fetch ranks for all children
        await fetchChildrenRanks();
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

  /// Fetch ranks for all children
  Future<void> fetchChildrenRanks() async {
    final ranks = <String, StudentRankData>{};
    
    for (final child in children) {
      final studentId = child['studentId'] ?? child['id'];
      if (studentId == null) continue;

      try {
        final response = await _apiService.fetchStudentRank(studentId);
        if (response.isSuccessful && response.body != null) {
          final rankResponse = StudentRankResponse.fromJson(response.body);
          if (rankResponse.success && rankResponse.data != null) {
            ranks[studentId] = rankResponse.data!;
          }
        }
      } catch (e) {
        // Silently ignore rank fetch errors for individual children
        debugPrint('Failed to fetch rank for $studentId: $e');
      }
    }
    
    childrenRanks.value = ranks;
  }

  /// Get rank for a specific child
  StudentRankData? getChildRank(String studentId) {
    return childrenRanks[studentId];
  }

  void refresh() {
    fetchDashboardData();
  }
}
