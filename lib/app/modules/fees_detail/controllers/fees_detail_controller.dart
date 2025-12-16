import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeesDetailController extends GetxController {
  final Rx<Map<String, dynamic>> studentFeesData = Rx<Map<String, dynamic>>({});
  final RxBool isLoading = true.obs;

  // Getters for easy access in view
  Map<String, dynamic> get studentInfo =>
      studentFeesData.value['studentInfo'] ?? {};
  Map<String, dynamic> get feesSummary =>
      studentFeesData.value['feesSummary'] ?? {};
  Map<String, dynamic> get currentFee =>
      studentFeesData.value['currentFee'] ?? {};
  List<Map<String, dynamic>> get paymentHistory =>
      (studentFeesData.value['paymentHistory'] as List?)?.cast<Map<String, dynamic>>() ?? [];
  List<Map<String, dynamic>> get pendingFees =>
      (studentFeesData.value['pendingFees'] as List?)?.cast<Map<String, dynamic>>() ?? [];

  @override
  void onInit() {
    super.onInit();
    loadStudentFeesData();
  }

  void loadStudentFeesData() {
    // Get student ID from arguments
    final args = Get.arguments as Map<String, dynamic>?;
    final String? studentId = args?['studentId'];

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 500), () {
      // Generate dummy data based on student ID
      studentFeesData.value = _generateDummyData(studentId ?? 'STU001');
      isLoading.value = false;
    });
  }

  Map<String, dynamic> _generateDummyData(String studentId) {
    // Dummy student and fees data
    return {
      'studentInfo': {
        'id': studentId,
        'name': 'Sarah Johnson',
        'phone': '+1 (555) 123-4567',
        'email': 'sarah.johnson@email.com',
        'grade': 'Grade 10',
        'section': 'Section A',
        'rollNumber': '10A-025',
        'admissionDate': '2023-04-15',
        'parentName': 'Michael Johnson',
        'parentPhone': '+1 (555) 987-6543',
      },
      'feesSummary': {
        'totalFees': 12500.00,
        'paidAmount': 8500.00,
        'pendingAmount': 4000.00,
        'overdueAmount': 1500.00,
      },
      'currentFee': {
        'feeType': 'Tuition Fee',
        'amount': 2500.00,
        'dueDate': '2025-11-15',
        'status': 'Pending',
        'term': 'Semester 2',
        'academicYear': '2024-25',
      },
      'paymentHistory': [
        {
          'feeType': 'Tuition Fee',
          'amount': 2500.00,
          'dueDate': '2025-09-15',
          'paidDate': '2025-09-10',
          'status': 'Paid',
          'paymentMethod': 'Credit Card',
          'txnId': 'TXN123456789',
          'receiptNo': 'RCP-2025-001',
        },
        {
          'feeType': 'Library Fee',
          'amount': 150.00,
          'dueDate': '2025-08-20',
          'paidDate': '2025-08-18',
          'status': 'Paid',
          'paymentMethod': 'Bank Transfer',
          'txnId': 'TXN987654321',
          'receiptNo': 'RCP-2025-002',
        },
        {
          'feeType': 'Sports Fee',
          'amount': 350.00,
          'dueDate': '2025-08-15',
          'paidDate': '2025-08-12',
          'status': 'Paid',
          'paymentMethod': 'UPI',
          'txnId': 'TXN555666777',
          'receiptNo': 'RCP-2025-003',
        },
        {
          'feeType': 'Lab Fee',
          'amount': 500.00,
          'dueDate': '2025-07-30',
          'paidDate': '2025-07-28',
          'status': 'Paid',
          'paymentMethod': 'Cash',
          'txnId': 'TXN111222333',
          'receiptNo': 'RCP-2025-004',
        },
      ],
      'pendingFees': [
        {
          'feeType': 'Tuition Fee',
          'amount': 2500.00,
          'dueDate': '2025-11-15',
          'status': 'Pending',
          'term': 'Semester 2',
        },
        {
          'feeType': 'Exam Fee',
          'amount': 1000.00,
          'dueDate': '2025-10-10',
          'status': 'Overdue',
          'term': 'Midterm',
        },
        {
          'feeType': 'Transport Fee',
          'amount': 500.00,
          'dueDate': '2025-10-01',
          'status': 'Overdue',
          'term': 'October',
        },
      ],
    };
  }

  // Get status color based on status string
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'overdue':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Get student initials
  String getStudentInitials(String name) {
    return name
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .take(2)
        .join();
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