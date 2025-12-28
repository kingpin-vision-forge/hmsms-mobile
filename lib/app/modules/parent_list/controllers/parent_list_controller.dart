import 'package:get/get.dart';
import 'package:chopper/chopper.dart' as c;
import 'package:student_management/app/data/apis.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/global.dart';
import 'package:student_management/app/helpers/utilities/network_util.dart';
import 'package:student_management/app/modules/parent_list/models/parent_response.dart';

class ParentListController extends GetxController {
  final ApiService _apiService = ApiService.create();

  var isSearching = false.obs;
  var searchQuery = ''.obs;
  var isLoading = false.obs;
  var parentList = <ParentModel>[].obs;
  var filteredParentList = <ParentModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchParents();
    // Listen to search query changes
    ever(searchQuery, (_) => filterParents());
  }

  //fetch parent

  fetchParents() async {
    try {
      // Set loading state to indicate API call in progress
      isLoading.value = true;

      c.Response? res = await NetworkUtils.safeApiCall(
        () => _apiService.fetchParents(),
      );

      if (res == null) return;
      if (res.isSuccessful) {
        if (res.body != null &&
            res.body['data'] != null &&
            res.body['success'] == true) {
          final response = ParentResponseModel.fromJson(res.body);
          parentList.value = response.data;
          filteredParentList.value = response.data;
        } else {
          // Handle API error responses
          serverError(res, () => fetchParents());
        }
      }
    } catch (e) {
      // Handle unexpected errors

      errorUtil.handleAppError(
        apiName: 'fetchParents',
        error: e,
        displayMessage: Constants.BOT_TOAST_MESSAGES['FAILED_FETCH_PARENTS']!,
      );
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
  }

  /* 
   * Initiates search mode for parent filtering.
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
    filteredParentList.value = parentList;
  }

  /*
   * Filters parents based on search query
   */
  void filterParents() {
    if (searchQuery.value.isEmpty) {
      filteredParentList.value = parentList;
    } else {
      filteredParentList.value = parentList.where((parent) {
        final query = searchQuery.value.toLowerCase();
        return parent.user.firstName.toLowerCase().contains(query) ||
            parent.user.lastName.toLowerCase().contains(query);
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
