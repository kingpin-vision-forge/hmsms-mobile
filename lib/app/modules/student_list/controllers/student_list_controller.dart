import 'package:get/get.dart';

class StudentListController extends GetxController {
  var students = [].obs;
  var isSearching = false.obs;
  var searchQuery = ''.obs;
  @override
  void onInit() {
    super.onInit();
    fetchStudentList();
  }

  /// Dummy function to assign teacher data
  void fetchStudentList() {
    students.assignAll([
      {
        'id': 'STD001',
        'name': 'Aarav Mehta',
        'grade': '1',
        'section': 'A',
        'rollNumber': '01',
        'attendance': '96%',
        'status': 'Present',
      },
      {
        'id': 'STD002',
        'name': 'Priya Sharma',
        'grade': '3',
        'section': 'B',
        'rollNumber': '07',
        'attendance': '92%',
        'status': 'Present',
      },
      {
        'id': 'STD003',
        'name': 'Rohan Patel',
        'grade': '4',
        'section': 'A',
        'rollNumber': '04',
        'attendance': '68%',
        'status': 'Absent',
      },
      {
        'id': 'STD004',
        'name': 'Sara Khan',
        'grade': '3',
        'section': 'C',
        'rollNumber': '10',
        'attendance': '85%',
        'status': 'On Leave',
      },
      {
        'id': 'STD005',
        'name': 'Vikram Iyer',
        'grade': '2',
        'section': 'B',
        'rollNumber': '03',
        'attendance': '98%',
        'status': 'Present',
      },
      {
        'id': 'STD006',
        'name': 'Meera Das',
        'grade': '5',
        'section': 'A',
        'rollNumber': '02',
        'attendance': '74%',
        'status': 'Inactive',
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
