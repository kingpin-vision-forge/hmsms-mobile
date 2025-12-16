import 'package:get/get.dart';

class FeesController extends GetxController {
  //TODO: Implement FeesController

  final feesList = [].obs;
  var isSearching = false.obs;
  var searchQuery = ''.obs;
  @override
  void onInit() {
    super.onInit();
    _loadDummyFeesData();
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
