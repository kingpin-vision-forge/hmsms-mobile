import 'package:get/get.dart';
import 'package:student_management/app/data/apis.dart';

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
  final activeStudents = 0.obs;
  final pendingAdmissions = 0.obs;

  // Student Distribution (Pie Chart)
  final studentDistribution = <Map<String, dynamic>>[].obs;
  final totalStudentsInDistribution = 0.obs;

  // Fees Collection (Bar Chart)
  final feesCollectionSummary = <String, dynamic>{}.obs;
  final monthlyFeesCollection = <Map<String, dynamic>>[].obs;

  // Class Performance (Line Chart)
  final currentYearPerformance = <Map<String, dynamic>>[].obs;
  final previousYearPerformance = <Map<String, dynamic>>[].obs;
  final performanceYear = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      // Fetch all dashboard data in parallel
      final results = await Future.wait([
        _fetchAdminStats(),
        _fetchStudentDistribution(),
        _fetchFeesCollection(),
        _fetchClassPerformance(),
      ]);

      // Check if any request failed
      if (results.any((success) => !success)) {
        // At least one request succeeded, show partial data
        if (results.every((success) => !success)) {
          hasError.value = true;
          errorMessage.value = 'Failed to load dashboard data';
        }
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> _fetchAdminStats() async {
    try {
      final response = await _apiService.fetchAdminStats();
      if (response.isSuccessful && response.body != null) {
        final data = response.body as Map<String, dynamic>;
        final statsData = data['data'] ?? data;

        totalStudents.value = statsData['totalStudents'] ?? 0;
        totalTeachers.value = statsData['totalTeachers'] ?? 0;
        totalStaff.value = statsData['totalStaff'] ?? 0;
        totalClasses.value = statsData['totalClasses'] ?? 0;
        totalSections.value = statsData['totalSections'] ?? 0;
        totalParents.value = statsData['totalParents'] ?? 0;
        activeStudents.value = statsData['activeStudents'] ?? 0;
        pendingAdmissions.value = statsData['pendingAdmissions'] ?? 0;
        return true;
      }
    } catch (e) {
      // Log error but don't fail entire dashboard
      print('Error fetching admin stats: $e');
    }
    return false;
  }

  Future<bool> _fetchStudentDistribution() async {
    try {
      final response = await _apiService.fetchStudentDistribution();
      if (response.isSuccessful && response.body != null) {
        final data = response.body as Map<String, dynamic>;
        final distributionData = data['data'] as List<dynamic>? ?? [];
        final meta = data['meta'] as Map<String, dynamic>? ?? {};

        studentDistribution.value = distributionData.cast<Map<String, dynamic>>();
        totalStudentsInDistribution.value = meta['total'] ?? 0;
        return true;
      }
    } catch (e) {
      print('Error fetching student distribution: $e');
    }
    return false;
  }

  Future<bool> _fetchFeesCollection() async {
    try {
      final response = await _apiService.fetchFeesCollection();
      if (response.isSuccessful && response.body != null) {
        final data = response.body as Map<String, dynamic>;
        final dataSection = data['data'] as Map<String, dynamic>? ?? {};

        feesCollectionSummary.value = dataSection['summary'] as Map<String, dynamic>? ?? {};

        final monthly = dataSection['monthly'] as List<dynamic>? ?? [];
        monthlyFeesCollection.value = monthly.cast<Map<String, dynamic>>();
        return true;
      }
    } catch (e) {
      print('Error fetching fees collection: $e');
    }
    return false;
  }

  Future<bool> _fetchClassPerformance() async {
    try {
      final response = await _apiService.fetchClassPerformance();
      if (response.isSuccessful && response.body != null) {
        final data = response.body as Map<String, dynamic>;
        final dataSection = data['data'] as Map<String, dynamic>? ?? {};

        final currentYear = dataSection['currentYear'] as List<dynamic>? ?? [];
        final previousYear = dataSection['previousYear'] as List<dynamic>? ?? [];

        currentYearPerformance.value = currentYear.cast<Map<String, dynamic>>();
        previousYearPerformance.value = previousYear.cast<Map<String, dynamic>>();
        performanceYear.value = dataSection['year'] ?? DateTime.now().year;
        return true;
      }
    } catch (e) {
      print('Error fetching class performance: $e');
    }
    return false;
  }

  void refresh() {
    fetchDashboardData();
  }

  // Helper methods for formatted display
  String get formattedTotalStudents {
    final value = totalStudents.value;
    if (value >= 1000) {
      return value.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
    }
    return value.toString();
  }

  String get formattedTotalStaff {
    final value = totalStaff.value;
    if (value >= 1000) {
      return value.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
    }
    return value.toString();
  }

  String get formattedTotalCollected {
    final collected = (feesCollectionSummary['totalCollected'] ?? 0) as num;
    if (collected >= 100000) {
      return '₹${(collected / 100000).toStringAsFixed(1)}L';
    } else if (collected >= 1000) {
      return '₹${(collected / 1000).toStringAsFixed(0)}K';
    }
    return '₹${collected.toStringAsFixed(0)}';
  }

  String get growthPercentageText {
    final growth = (feesCollectionSummary['growthPercentage'] ?? 0) as num;
    final prefix = growth >= 0 ? '+' : '';
    return '$prefix${growth.toStringAsFixed(1)}% from last month';
  }
}
