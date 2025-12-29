import 'package:get/get.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/global.dart';
import 'package:student_management/app/helpers/utilities/network_util.dart';
import 'package:chopper/chopper.dart' as c;
import 'package:student_management/app/data/apis.dart';
import 'package:student_management/app/modules/teacher_list/models/teacher_response.dart';

class TeacherListController extends GetxController {
  final ApiService _apiService = ApiService.create();
  var isSearching = false.obs;
  var searchQuery = ''.obs;
  var isLoading = false.obs;
  var teacherList = <Teacher>[].obs;
  var filteredTeacherList = <Teacher>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to search query changes
    ever(searchQuery, (_) => filterTeachers());
    fetchTeacherList();
  }

  /// Fetch teachers from API
  fetchTeacherList() async {
    try {
      // Set loading state to indicate API call in progress
      isLoading.value = true;

      c.Response? res = await NetworkUtils.safeApiCall(
        () => _apiService.fetchTeachers(),
      );

      if (res == null) return;
      if (res.isSuccessful) {
        if (res.body != null &&
            res.body['data'] != null &&
            res.body['success'] == true) {
          final response = TeacherListResponse.fromJson(res.body);
          teacherList.value = response.data;
          filteredTeacherList.value = response.data;
        } else {
          // Handle API error responses
          serverError(res, () => fetchTeacherList());
        }
      }
    } catch (e) {
      // Handle unexpected errors
      errorUtil.handleAppError(
        apiName: 'fetchTeachers',
        error: e,
        displayMessage: Constants.BOT_TOAST_MESSAGES['FAILED_FETCH_TEACHERS'] ?? 'Failed to fetch teachers',
      );
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
  }

  /*
   * Filters teachers based on search query
   */
  void filterTeachers() {
    if (searchQuery.value.isEmpty) {
      filteredTeacherList.value = teacherList;
    } else {
      filteredTeacherList.value = teacherList.where((teacher) {
        final query = searchQuery.value.toLowerCase();
        return teacher.fullName.toLowerCase().contains(query) ||
            (teacher.employeeCode?.toLowerCase().contains(query) ?? false) ||
            (teacher.email?.toLowerCase().contains(query) ?? false);
      }).toList();
    }
  }

  /* 
   * Initiates search mode for teacher filtering.
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
    filteredTeacherList.value = teacherList;
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
