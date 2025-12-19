import 'package:get/get.dart';
import 'package:chopper/chopper.dart' as c;
import 'package:student_management/app/data/apis.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/global.dart';
import 'package:student_management/app/helpers/utilities/network_util.dart';
import 'package:student_management/app/modules/section_list/models/section_response.dart';

class SectionListController extends GetxController {
  final ApiService _apiService = ApiService.create();

  final count = 0.obs;
  var isSearching = false.obs;
  var searchQuery = ''.obs;
  var isLoading = false.obs;
  var sectionList = <SectionData>[].obs;
  var filteredSectionList = <SectionData>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSection();
    // Listen to search query changes
    ever(searchQuery, (_) => filterSections());
  }

  //fetch sections

  fetchSection() async {
    try {
      // Set loading state to indicate API call in progress
      isLoading.value = true;

      c.Response? res = await NetworkUtils.safeApiCall(
        () => _apiService.fetchSections(),
      );

      if (res == null) return;
      if (res.isSuccessful) {
        if (res.body != null &&
            res.body['data'] != null &&
            res.body['success'] == true) {
          final response = SectionResponse.fromJson(res.body);
          sectionList.value = response.data;
          filteredSectionList.value = response.data;
        } else {
          // Handle API error responses
          serverError(res, () => fetchSection());
        }
      }
    } catch (e) {
      // Handle unexpected errors

      errorUtil.handleAppError(
        apiName: 'fetchSections',
        error: e,
        displayMessage: Constants.BOT_TOAST_MESSAGES['FAILED_FETCH_SECTIONS']!,
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
    filteredSectionList.value = sectionList;
  }

  /*
   * Filters sections based on search query
   */
  void filterSections() {
    if (searchQuery.value.isEmpty) {
      filteredSectionList.value = sectionList;
    } else {
      filteredSectionList.value = sectionList.where((section) {
        final query = searchQuery.value.toLowerCase();
        return section.name.toLowerCase().contains(query) ||
            section.classInfo.name.toLowerCase().contains(query) ||
            section.classInfo.code.toLowerCase().contains(query);
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
