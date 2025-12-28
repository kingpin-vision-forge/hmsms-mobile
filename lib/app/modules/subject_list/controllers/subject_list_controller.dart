import 'package:get/get.dart';
import 'package:chopper/chopper.dart' as c;
import 'package:student_management/app/data/apis.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/global.dart';
import 'package:student_management/app/helpers/utilities/network_util.dart';
import 'package:student_management/app/modules/subject_list/models/subject_list_response.dart';

class SubjectListController extends GetxController {
  final ApiService _apiService = ApiService.create();

  final count = 0.obs;
  var isSearching = false.obs;
  var searchQuery = ''.obs;
  var isLoading = false.obs;
  var subjectList = <SubjectModel>[].obs;
  var filteredSubjectList = <SubjectModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSubjects();
    // Listen to search query changes
    ever(searchQuery, (_) => filterSubjects());
  }

  //fetch subjects

  fetchSubjects() async {
    try {
      // Set loading state to indicate API call in progress
      isLoading.value = true;

      c.Response? res = await NetworkUtils.safeApiCall(
        () => _apiService.fetchSubjects(),
      );

      if (res == null) return;
      if (res.isSuccessful) {
        if (res.body != null &&
            res.body['data'] != null &&
            res.body['success'] == true) {
          final response = SubjectListResponseModel.fromJson(res.body);
          subjectList.value = response.data;
          filteredSubjectList.value = response.data;
        } else {
          // Handle API error responses
          serverError(res, () => fetchSubjects());
        }
      }
    } catch (e) {
      // Handle unexpected errors

      errorUtil.handleAppError(
        apiName: 'fetchSubjects',
        error: e,
        displayMessage: Constants.BOT_TOAST_MESSAGES['FAILED_FETCH_SUBJECTS']!,
      );
    } finally {
      // Reset loading state
      isLoading.value = false;
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
    filteredSubjectList.value = subjectList;
  }

  /*
   * Filters subject based on search query
   */
  void filterSubjects() {
    if (searchQuery.value.isEmpty) {
      filteredSubjectList.value = subjectList;
    } else {
      filteredSubjectList.value = subjectList.where((subject) {
        final query = searchQuery.value.toLowerCase();
        return subject.name.toLowerCase().contains(query) ||
            subject.code.toLowerCase().contains(query);
      }).toList();
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
