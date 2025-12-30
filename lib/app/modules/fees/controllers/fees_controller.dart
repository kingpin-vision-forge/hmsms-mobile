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
  /// - ADMIN/TEACHER: See all fees
  Future<void> _loadFeesData() async {
    try {
      isLoading.value = true;
      final rbac = Get.find<RbacService>();
      
      // Role-based fees data loading
      if (rbac.isParent) {
        // Parent: Fetch fees for their associated students only
        await _loadParentStudentsFees();
      } else if (rbac.isStudent) {
        // Student: Fetch only their own fees
        await _loadStudentFees();
      } else {
        // Admin/Teacher: Load all fees (using dummy data for now as API not implemented)
        _loadDummyFeesData();
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

  /// Load fees for parent's associated students
  Future<void> _loadParentStudentsFees() async {
    final storedUserData = await readFromStorage(
      Constants.STORAGE_KEYS['USER_DATA']!,
    );
    final parentId = storedUserData?['roleId'];
    
    if (parentId != null) {
      // Fetch students by parent
      c.Response? res = await NetworkUtils.safeApiCall(
        () => _apiService.fetchStudentsByParent(parentId),
      );
      
      if (res != null && res.isSuccessful && res.body?['data'] != null) {
        final students = res.body['data'] as List;
        // Create fees list from associated students
        // Note: This uses placeholder fees data until a fees API is implemented
        feesList.value = students.map((student) {
          final user = student['user'] ?? {};
          return {
            'name': '${user['firstName'] ?? ''} ${user['lastName'] ?? ''}'.trim(),
            'id': student['id'] ?? '',
            'grade': student['class']?['name'] ?? '-',
            'feeType': 'Monthly Tuition',
            'amount': 1500,
            'dueDate': '2024-12-30',
            'paymentDate': '',
            'paymentMethod': '',
            'txnId': '',
            'status': 'Pending',
          };
        }).toList();
      } else {
        feesList.clear();
      }
    }
  }

  /// Load fees for the logged-in student
  Future<void> _loadStudentFees() async {
    final storedUserData = await readFromStorage(
      Constants.STORAGE_KEYS['USER_DATA']!,
    );
    final studentId = storedUserData?['roleId'];
    final firstName = storedUserData?['firstName'] ?? '';
    final lastName = storedUserData?['lastName'] ?? '';
    
    if (studentId != null) {
      // For now, create a single fee entry for the student
      // This will be replaced with actual fees API when available
      feesList.value = [
        {
          'name': '$firstName $lastName'.trim(),
          'id': studentId,
          'grade': '-',
          'feeType': 'Monthly Tuition',
          'amount': 1500,
          'dueDate': '2024-12-30',
          'paymentDate': '',
          'paymentMethod': '',
          'txnId': '',
          'status': 'Pending',
        },
      ];
    }
  }

  void _loadDummyFeesData() {
    feesList.value = [
      {
        'name': 'Emma Johnson',
        'id': 'STD001',
        'grade': '2nd Grade',
        'feeType': 'Monthly Tuition',
        'amount': 1500,
        'dueDate': '2024-09-30',
        'paymentDate': '2024-09-25',
        'paymentMethod': 'Credit Card',
        'txnId': 'TXN123456789',
        'status': 'Paid',
      },
      {
        'name': 'Liam Wilson',
        'id': 'STD002',
        'grade': '1st Grade',
        'feeType': 'Monthly Tuition',
        'amount': 1500,
        'dueDate': '2024-09-30',
        'paymentDate': '',
        'paymentMethod': '',
        'txnId': '',
        'status': 'Pending',
      },
      {
        'name': 'Sophia Davis',
        'id': 'STD003',
        'grade': '4th Grade',
        'feeType': 'Lab Fee',
        'amount': 200,
        'dueDate': '2024-10-15',
        'paymentDate': '',
        'paymentMethod': '',
        'txnId': '',
        'status': 'Pending',
      },
      {
        'name': 'Noah Brown',
        'id': 'STD004',
        'grade': '5th Grade',
        'feeType': 'Monthly Tuition',
        'amount': 1200,
        'dueDate': '2024-09-15',
        'paymentDate': '',
        'paymentMethod': '',
        'txnId': '',
        'status': 'Overdue',
      },
    ];
  }

  /* 
   * Initiates search mode for invoice filtering.
   */
  void startSearch() {
    // Enable search mode
    isSearching.value = true;
    isSearching.refresh();
  }

  /* 
   * Stops search mode and resets search state.
   */
  void stopSearch() {
    // Disable search mode and clear query
    isSearching.value = false;
    isSearching.refresh();
    searchQuery.value = '';

    // Refresh invoices list
    // fetchTeacherList();
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
