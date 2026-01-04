import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:student_management/app/data/apis.dart';
import 'package:student_management/app/helpers/global.dart';
import 'package:student_management/app/modules/attendance/models/attendance_response.dart';

class AttendanceController extends GetxController {
  final ApiService apiService = ApiService.create();

  // Loading states
  final isLoading = false.obs;
  final isLoadingStudents = false.obs;
  final isSubmitting = false.obs;

  // Selected values
  final selectedClassId = ''.obs;
  final selectedSectionId = ''.obs;
  final selectedDate = DateTime.now().obs;

  // Data lists
  final classes = <Map<String, dynamic>>[].obs;
  final sections = <Map<String, dynamic>>[].obs;
  final students = <StudentAttendanceEntry>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadClasses();
  }

  Future<void> loadClasses() async {
    isLoading.value = true;
    try {
      final res = await apiService.fetchClassesForSection();
      if (res.isSuccessful && res.body['success'] == true) {
        classes.value = List<Map<String, dynamic>>.from(res.body['data'] ?? []);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load classes',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadSections(String classId) async {
    sections.clear();
    selectedSectionId.value = '';
    students.clear();
    if (classId.isEmpty) return;

    try {
      final res = await apiService.fetchSectionForClass(classId: classId);
      if (res.isSuccessful && res.body['success'] == true) {
        sections.value = List<Map<String, dynamic>>.from(res.body['data'] ?? []);
      }
    } catch (e) {
      // Handle silently
    }
  }

  Future<void> loadStudents() async {
    if (selectedClassId.value.isEmpty) return;

    isLoadingStudents.value = true;
    students.clear();

    try {
      // Fetch students for the selected class/section
      final res = await apiService.fetchStudentList();
      if (res.isSuccessful && res.body['success'] == true) {
        final studentList = res.body['data'] as List<dynamic>? ?? [];
        
        // Filter by class and section
        final filtered = studentList.where((s) {
          final studentClassId = s['classId'] ?? s['class']?['id'];
          final studentSectionId = s['sectionId'] ?? s['section']?['id'];
          
          if (studentClassId != selectedClassId.value) return false;
          if (selectedSectionId.value.isNotEmpty && 
              studentSectionId != selectedSectionId.value) return false;
          return true;
        }).toList();

        // Convert to attendance entries
        students.value = filtered.map((s) {
          final user = s['user'] as Map<String, dynamic>?;
          final fullName = user != null
              ? [user['firstName'], user['middleName'], user['lastName']]
                  .where((n) => n != null && n.toString().isNotEmpty)
                  .join(' ')
              : 'Unknown';
          
          return StudentAttendanceEntry(
            studentId: s['id'] ?? '',
            studentName: fullName,
            admissionNumber: s['admissionNumber'],
            status: 'PRESENT', // Default to present
          );
        }).toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load students',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoadingStudents.value = false;
    }
  }

  void selectClass(String classId) {
    selectedClassId.value = classId;
    loadSections(classId);
    loadStudents();
  }

  void selectSection(String sectionId) {
    selectedSectionId.value = sectionId;
    loadStudents();
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
  }

  void updateStudentStatus(int index, String status) {
    students[index].status = status;
    students.refresh();
  }

  void markAllPresent() {
    for (var student in students) {
      student.status = 'PRESENT';
    }
    students.refresh();
  }

  void markAllAbsent() {
    for (var student in students) {
      student.status = 'ABSENT';
    }
    students.refresh();
  }

  Future<void> submitAttendance() async {
    if (students.isEmpty) {
      Get.snackbar('Error', 'No students to mark attendance for',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isSubmitting.value = true;
    try {
      // Format date as YYYY-MM-DD
      final dateStr = '${selectedDate.value.year}-${selectedDate.value.month.toString().padLeft(2, '0')}-${selectedDate.value.day.toString().padLeft(2, '0')}';
      
      // Submit attendance for each student
      int successCount = 0;
      for (var student in students) {
        // Capture current time in HH:mm format
        final now = DateTime.now();
        final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
        
        final body = {
          'date': dateStr,
          'time': timeStr, // Time when attendance was marked
          'studentId': student.studentId,
          'status': student.status,
          'remarks': student.remarks ?? '',
          'schoolId': schoolId,
          'notifyParent': student.status == 'PRESENT', // Trigger parent notification for PRESENT
        };

        final res = await apiService.markAttendance(body);
        if (res.isSuccessful && res.body['success'] == true) {
          successCount++;
        }
      }

      if (successCount == students.length) {
        Get.snackbar('Success', 'Attendance marked successfully for all students',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Partial Success', 'Attendance marked for $successCount/${students.length} students',
            backgroundColor: Colors.orange, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit attendance',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      selectDate(picked);
    }
  }

  // ============ Report Download ============
  
  // Report date range
  final reportFromDate = Rx<DateTime>(DateTime.now().subtract(const Duration(days: 30)));
  final reportToDate = Rx<DateTime>(DateTime.now());
  final isDownloadingReport = false.obs;
  final selectedReportFormat = 'pdf'.obs; // 'pdf' or 'csv'

  /// Pick start date for report
  Future<void> pickReportFromDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: reportFromDate.value,
      firstDate: DateTime(2020),
      lastDate: reportToDate.value,
    );
    if (picked != null) {
      reportFromDate.value = picked;
    }
  }

  /// Pick end date for report
  Future<void> pickReportToDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: reportToDate.value,
      firstDate: reportFromDate.value,
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      reportToDate.value = picked;
    }
  }

  /// Format date as YYYY-MM-DD
  String _formatDateForApi(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Download attendance report
  Future<void> downloadAttendanceReport() async {
    if (selectedClassId.value.isEmpty) {
      Get.snackbar('Error', 'Please select a class first',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isDownloadingReport.value = true;

    try {
      final fromStr = _formatDateForApi(reportFromDate.value);
      final toStr = _formatDateForApi(reportToDate.value);

      final res = await apiService.downloadAttendanceReport(
        classId: selectedClassId.value,
        sectionId: selectedSectionId.value.isNotEmpty ? selectedSectionId.value : null,
        from: fromStr,
        to: toStr,
        format: selectedReportFormat.value,
      );

      if (res.isSuccessful && res.body != null) {
        // Handle the download URL from response
        if (res.body['success'] == true && res.body['downloadUrl'] != null) {
          final downloadUrl = res.body['downloadUrl'] as String;
          final uri = Uri.parse(downloadUrl);
          
          // Open download URL in browser
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
            Get.snackbar(
              'Success', 
              'Report download started',
              backgroundColor: Colors.green, 
              colorText: Colors.white,
            );
          } else {
            Get.snackbar('Error', 'Could not open download link',
                backgroundColor: Colors.red, colorText: Colors.white);
          }
        } else {
          Get.snackbar('Error', res.body['message'] ?? 'Failed to generate report',
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else {
        Get.snackbar('Error', 'Failed to download report',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to download report: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isDownloadingReport.value = false;
    }
  }
}
