import 'package:get/get.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/global.dart';
import 'package:student_management/app/helpers/rbac/rbac.dart';
import 'package:student_management/app/data/apis.dart';
import 'package:student_management/app/helpers/utilities/network_util.dart';
import 'package:chopper/chopper.dart' as c;

class FeesController extends GetxController {
  final ApiService _apiService = ApiService.create();

  final feesList = [].obs;
  var isSearching = false.obs;
  var searchQuery = ''.obs;
  var isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadFeesData();
  }

  /// Load fees data with role-based access control
  /// - PARENT: See only fees for their associated students
  /// - STUDENT: See only their own fees
  /// - ADMIN: See all fees
  Future<void> _loadFeesData() async {
    try {
      isLoading.value = true;
      final rbac = Get.find<RbacService>();
      
      // Role-based fees data loading
      if (rbac.isParent) {
        await _loadParentStudentsFees();
      } else if (rbac.isStudent) {
        await _loadStudentFees();
      } else if (rbac.isAdmin) {
        await _loadAllFees();
      } else {
        // Teacher or other roles - no fees access
        feesList.clear();
      }
    } catch (e) {
      errorUtil.handleAppError(
        apiName: 'loadFeesData',
        error: e,
        displayMessage: 'Failed to load fees data',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Load all fees (for Admin)
  Future<void> _loadAllFees() async {
    c.Response? res = await NetworkUtils.safeApiCall(
      () => _apiService.fetchFees(),
    );
    
    if (res != null && res.isSuccessful && res.body?['data'] != null) {
      final feesData = res.body['data'] as List;
      feesList.value = feesData.map((fee) => _mapFeeToDisplay(fee)).toList();
    } else {
      feesList.clear();
    }
  }

  /// Load fees for parent's associated students
  Future<void> _loadParentStudentsFees() async {
    final storedUserData = await readFromStorage(
      Constants.STORAGE_KEYS['USER_DATA']!,
    );
    final parentId = storedUserData?['roleId'];
    
    if (parentId != null) {
      c.Response? res = await NetworkUtils.safeApiCall(
        () => _apiService.fetchFeesByParent(parentId),
      );
      
      if (res != null && res.isSuccessful && res.body?['data'] != null) {
        final feesData = res.body['data'] as List;
        feesList.value = feesData.map((fee) => _mapFeeToDisplay(fee)).toList();
      } else {
        feesList.clear();
      }
    } else {
      feesList.clear();
    }
  }

  /// Load fees for the logged-in student
  Future<void> _loadStudentFees() async {
    final storedUserData = await readFromStorage(
      Constants.STORAGE_KEYS['USER_DATA']!,
    );
    final studentId = storedUserData?['roleId'];
    
    if (studentId != null) {
      c.Response? res = await NetworkUtils.safeApiCall(
        () => _apiService.fetchFeesByStudent(studentId),
      );
      
      if (res != null && res.isSuccessful && res.body?['data'] != null) {
        final feesData = res.body['data'] as List;
        feesList.value = feesData.map((fee) => _mapFeeToDisplay(fee)).toList();
      } else {
        feesList.clear();
      }
    } else {
      feesList.clear();
    }
  }

  /// Map API response to display format
  Map<String, dynamic> _mapFeeToDisplay(Map<String, dynamic> fee) {
    return {
      'id': fee['id'] ?? '',
      'name': fee['studentName'] ?? '',
      'studentEmail': fee['studentEmail'] ?? '',
      'grade': fee['className'] ?? '-',
      'section': fee['sectionName'] ?? '-',
      'feeType': 'Tuition Fee', // Default fee type since API doesn't provide it
      'amount': fee['totalAmount'] ?? 0,
      'totalPaid': fee['totalPaid'] ?? 0,
      'balanceAmount': fee['balanceAmount'] ?? 0,
      'dueDate': fee['dueDate'] ?? '',
      'status': fee['status'] ?? 'PENDING',
      'payments': fee['payments'] ?? [],
    };
  }

  /* 
   * Initiates search mode for invoice filtering.
   */
  void startSearch() {
    isSearching.value = true;
    isSearching.refresh();
  }

  /* 
   * Stops search mode and resets search state.
   */
  void stopSearch() {
    isSearching.value = false;
    isSearching.refresh();
    searchQuery.value = '';
  }

  /// Refresh fees data
  Future<void> refreshFees() async {
    await _loadFeesData();
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
