import 'package:get/get.dart';

class SectionListController extends GetxController {
  //TODO: Implement SectionListController

  final count = 0.obs;
  var isSearching = false.obs;
  var searchQuery = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
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

  void increment() => count.value++;
}
