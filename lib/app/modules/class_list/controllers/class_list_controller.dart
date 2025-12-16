import 'package:get/get.dart';
import 'package:chopper/chopper.dart' as c;
import 'package:student_management/app/data/apis.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/global.dart';
import 'package:student_management/app/helpers/utilities/network_util.dart';
import 'package:student_management/app/modules/class_list/models/class_list_response.dart';

class ClassListController extends GetxController {
  final ApiService _apiService = ApiService.create();

  var isSearching = false.obs;
  var searchQuery = ''.obs;
  var isLoading = false.obs;
  var classList = <ClassData>[].obs;
  var filteredClassList = <ClassData>[].obs;
  @override
  void onInit() {
    super.onInit();
    fetchClasses();
    // Listen to search query changes
    ever(searchQuery, (_) => filterClasses());
  }

  // fetch classes

  fetchClasses() async {
    try {
      // Set loading state to indicate API call in progress
      isLoading.value = true;

      c.Response? res = await NetworkUtils.safeApiCall(
        () => _apiService.fetchClasses(),
      );

      if (res == null) return;
      if (res.isSuccessful) {
        if (res.body != null &&
            res.body['data'] != null &&
            res.body['success'] == true) {
          final response = ClassListResponse.fromJson(res.body);
          classList.value = response.data;
          filteredClassList.value = response.data;
        } else {
          // Handle API error responses
          serverError(res, () => fetchClasses());
        }
      }
    } catch (e) {
      // Handle unexpected errors

      errorUtil.handleAppError(
        apiName: 'fetchClasses',
        error: e,
        displayMessage: Constants.BOT_TOAST_MESSAGES['FAILED_FETCH_CLASSES']!,
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
    filteredClassList.value = classList;
  }

  /*
   * Filters classes based on search query
   */
  void filterClasses() {
    if (searchQuery.value.isEmpty) {
      filteredClassList.value = classList;
    } else {
      filteredClassList.value = classList.where((classData) {
        final query = searchQuery.value.toLowerCase();
        return classData.name.toLowerCase().contains(query) ||
            classData.code.toLowerCase().contains(query);
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
}
