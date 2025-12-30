import 'package:get/get.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/global.dart';
import 'package:student_management/app/helpers/utilities/network_util.dart';
import 'package:student_management/app/helpers/rbac/rbac.dart';
import 'package:student_management/app/routes/app_pages.dart';
import 'package:chopper/chopper.dart' as c;
import 'package:student_management/app/data/apis.dart';
import 'package:student_management/app/modules/student_list/models/student_response.dart';

class StudentListController extends GetxController {
  final ApiService _apiService = ApiService.create();
  var students = [].obs;
  var isSearching = false.obs;
  var searchQuery = ''.obs;
  var isLoading = false.obs;
  var studentList = <Student>[].obs;
  var filteredStudentList = <Student>[].obs;
  @override
  void onInit() {
    super.onInit();
    // Listen to search query changes
    ever(searchQuery, (_) => filterSections());
    fetchStudentList();
  }

  /// Fetch student list with role-based access control
  /// - STUDENT: Redirected to their own student detail page
  /// - PARENT: See only their associated children
  /// - ADMIN/TEACHER: See all students
  fetchStudentList() async {
    try {
      // Check user role for access control
      final rbac = Get.find<RbacService>();
      
      // If user is a STUDENT, redirect to their own detail page
      if (rbac.isStudent) {
        final storedUserData = await readFromStorage(
          Constants.STORAGE_KEYS['USER_DATA']!,
        );
        final studentId = storedUserData?['roleId'];
        if (studentId != null) {
          Get.offAllNamed(Routes.STUDENT_DETAIL, arguments: {'student_id': studentId});
          return;
        }
      }
      
      // Set loading state to indicate API call in progress
      isLoading.value = true;

      c.Response? res;
      
      // If user is a PARENT, fetch only their associated children
      if (rbac.isParent) {
        final storedUserData = await readFromStorage(
          Constants.STORAGE_KEYS['USER_DATA']!,
        );
        final parentId = storedUserData?['roleId'];
        if (parentId != null) {
          res = await NetworkUtils.safeApiCall(
            () => _apiService.fetchStudentsByParent(parentId),
          );
        }
      } else {
        // Admin/Teacher: Fetch all students
        res = await NetworkUtils.safeApiCall(
          () => _apiService.fetchStudentList(),
        );
      }

      if (res == null) return;
      if (res.isSuccessful) {
        if (res.body != null &&
            res.body['data'] != null &&
            res.body['success'] == true) {
          final response = StudentListResponse.fromJson(res.body);
          studentList.value = response.data;
          filteredStudentList.value = response.data;
        } else {
          // Handle API error responses
          serverError(res, () => fetchStudentList());
        }
      }
    } catch (e) {
      // Handle unexpected errors

      errorUtil.handleAppError(
        apiName: 'fetchStudents',
        error: e,
        displayMessage: Constants.BOT_TOAST_MESSAGES['FAILED_FETCH_STUDENTS']!,
      );
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
  }

  /*
   * Filters sections based on search query
   */
  void filterSections() {
    if (searchQuery.value.isEmpty) {
      filteredStudentList.value = studentList;
    } else {
      filteredStudentList.value = studentList.where((student) {
        final query = searchQuery.value.toLowerCase();
        return student.firstName?.toLowerCase().contains(query) ?? false;
      }).toList();
    }
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
