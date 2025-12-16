import 'package:get/get.dart';

class TeacherListController extends GetxController {
  var teachers = [].obs;
  var isSearching = false.obs;
  var searchQuery = ''.obs;
  @override
  void onInit() {
    super.onInit();
    fetchTeacherList();
  }

  /// Dummy function to assign teacher data
  void fetchTeacherList() {
    teachers.assignAll([
      {
        'id': 'TCH001',
        'name': 'Alice Johnson',
        'subject': 'Mathematics',
        'status': 'Active',
      },
      {
        'id': 'TCH002',
        'name': 'Bob Smith',
        'subject': 'Science',
        'status': 'On Leave',
      },
      {
        'id': 'TCH003',
        'name': 'Clara Davis',
        'subject': 'History',
        'status': 'Inactive',
      },
      {
        'id': 'TCH004',
        'name': 'David Lee',
        'subject': 'Art',
        'status': 'Active',
      },
    ]);
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
