import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_management/app/data/apis.dart';
import 'package:student_management/app/helpers/global.dart';
import 'package:student_management/app/helpers/utilities/network_util.dart';

/// Controller for Admin/Super Admin Dashboard
/// Fetches admin-specific dashboard data from API
class AdminDashboardController extends GetxController {
  final _apiService = ApiService.create();

  // Observable state
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // Stats data
  final totalStudents = 0.obs;
  final totalTeachers = 0.obs;
  final totalStaff = 0.obs;
  final totalClasses = 0.obs;
  final totalSections = 0.obs;
  final totalParents = 0.obs;

  // Student distribution (pie chart)
  final studentDistribution = <Map<String, dynamic>>[].obs;
  final distributionTotal = 0.obs;

  // Fees collection (bar chart)
  final feesCollected = 0.0.obs;
  final feesPending = 0.0.obs;
  final collectionRate = 0.0.obs;
  final growthPercentage = 0.0.obs;
  final monthlyFees = <Map<String, dynamic>>[].obs;

  // Class performance data (line chart)
  final classPerformance = <Map<String, dynamic>>[].obs;
  final previousYearPerformance = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllData();
  }

  /// Fetch all dashboard data
  Future<void> fetchAllData() async {
    isLoading.value = true;
    hasError.value = false;

    try {
      await Future.wait([
        fetchStats(),
        fetchStudentDistribution(),
        fetchFeesCollection(),
        fetchClassPerformance(),
      ]);
    } catch (e) {
      debugPrint('Error fetching admin dashboard: $e');
      hasError.value = true;
      errorMessage.value = 'Failed to load dashboard data';
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch aggregated stats
  Future<void> fetchStats() async {
    try {
      final response = await NetworkUtils.safeApiCall(
        () => _apiService.fetchAdminStats(schoolId: schoolId),
      );

      if (response != null && response.isSuccessful && response.body != null) {
        final body = response.body as Map<String, dynamic>;
        if (body['success'] == true && body['data'] != null) {
          final data = body['data'] as Map<String, dynamic>;
          totalStudents.value = data['totalStudents'] ?? 0;
          totalTeachers.value = data['totalTeachers'] ?? 0;
          totalStaff.value = data['totalStaff'] ?? 0;
          totalClasses.value = data['totalClasses'] ?? 0;
          totalSections.value = data['totalSections'] ?? 0;
          totalParents.value = data['totalParents'] ?? 0;
        }
      }
    } catch (e) {
      debugPrint('Error fetching admin stats: $e');
    }
  }

  /// Fetch student distribution by class
  Future<void> fetchStudentDistribution() async {
    try {
      debugPrint('📊 Fetching student distribution for schoolId: $schoolId');
      final response = await NetworkUtils.safeApiCall(
        () => _apiService.fetchStudentDistribution(schoolId: schoolId),
      );

      debugPrint('📊 Student distribution response: ${response?.body}');
      
      if (response != null && response.isSuccessful && response.body != null) {
        final body = response.body as Map<String, dynamic>;
        if (body['success'] == true && body['data'] != null) {
          final data = body['data'] as List<dynamic>;
          studentDistribution.value = data.cast<Map<String, dynamic>>();
          debugPrint('✅ Loaded ${data.length} distribution items');
          
          // Get total from meta
          if (body['meta'] != null) {
            distributionTotal.value = body['meta']['total'] ?? 0;
          }
        }
      }
    } catch (e) {
      debugPrint('❌ Error fetching student distribution: $e');
    }
  }

  /// Fetch fees collection data
  Future<void> fetchFeesCollection() async {
    try {
      final response = await NetworkUtils.safeApiCall(
        () => _apiService.fetchFeesCollection(
          schoolId: schoolId,
          months: 6,
        ),
      );

      if (response != null && response.isSuccessful && response.body != null) {
        final body = response.body as Map<String, dynamic>;
        if (body['success'] == true && body['data'] != null) {
          final data = body['data'] as Map<String, dynamic>;
          
          // Parse summary
          if (data['summary'] != null) {
            final summary = data['summary'] as Map<String, dynamic>;
            feesCollected.value = (summary['totalCollected'] ?? 0).toDouble();
            feesPending.value = (summary['totalPending'] ?? 0).toDouble();
            collectionRate.value = (summary['collectionRate'] ?? 0).toDouble();
            growthPercentage.value = (summary['growthPercentage'] ?? 0).toDouble();
          }
          
          // Parse monthly data
          if (data['monthly'] != null) {
            final monthly = data['monthly'] as List<dynamic>;
            monthlyFees.value = monthly.cast<Map<String, dynamic>>();
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching fees collection: $e');
    }
  }

  /// Fetch class performance data for line chart
  Future<void> fetchClassPerformance() async {
    try {
      final response = await NetworkUtils.safeApiCall(
        () => _apiService.fetchClassPerformance(
          schoolId: schoolId,
          year: DateTime.now().year,
        ),
      );

      if (response != null && response.isSuccessful && response.body != null) {
        final body = response.body as Map<String, dynamic>;
        if (body['success'] == true && body['data'] != null) {
          final data = body['data'] as Map<String, dynamic>;
          
          // Parse current year performance
          if (data['currentYear'] != null) {
            final current = data['currentYear'] as List<dynamic>;
            classPerformance.value = current.cast<Map<String, dynamic>>();
          }
          
          // Parse previous year performance for comparison
          if (data['previousYear'] != null) {
            final previous = data['previousYear'] as List<dynamic>;
            previousYearPerformance.value = previous.cast<Map<String, dynamic>>();
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching class performance: $e');
    }
  }

  /// Get line chart spots for current year
  List<double> getCurrentYearSpots() {
    if (classPerformance.isNotEmpty) {
      return classPerformance.map<double>((e) => (e['percentage'] ?? 0.0).toDouble()).toList();
    }
    // Fallback values
    return [75.0, 82.0, 90.0, 68.0];
  }

  /// Get line chart spots for previous year
  List<double> getPreviousYearSpots() {
    if (previousYearPerformance.isNotEmpty) {
      return previousYearPerformance.map<double>((e) => (e['percentage'] ?? 0.0).toDouble()).toList();
    }
    // Fallback values
    return [70.0, 78.0, 83.0, 65.0];
  }

  /// Get class names for line chart labels
  List<String> getClassLabels() {
    if (classPerformance.isNotEmpty) {
      return classPerformance.map((e) => e['className']?.toString() ?? 'Class').toList();
    }
    // Fallback labels
    return ['Class 1st', 'Class 2nd', 'Class 3rd', 'Oth'];
  }

  /// Refresh all data
  Future<void> refresh() async {
    await fetchAllData();
  }

  /// Format amount for display (e.g., 820000 → "₹8.2L")
  String formatLakhAmount(double amount) {
    if (amount >= 100000) {
      final lakhs = amount / 100000;
      return '₹${lakhs.toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      final thousands = amount / 1000;
      return '₹${thousands.toStringAsFixed(0)}K';
    }
    return '₹${amount.toStringAsFixed(0)}';
  }

  /// Get color from hex string
  Color getColorFromHex(String hexColor) {
    try {
      return Color(int.parse(hexColor.replaceFirst('#', '0xFF')));
    } catch (e) {
      return const Color(0xFF6C5CE7);
    }
  }
}
