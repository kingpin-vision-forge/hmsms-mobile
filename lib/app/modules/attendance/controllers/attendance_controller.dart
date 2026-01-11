import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      botToastError('Failed to load classes');
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
        sections.value = List<Map<String, dynamic>>.from(
          res.body['data'] ?? [],
        );
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
              studentSectionId != selectedSectionId.value)
            return false;
          return true;
        }).toList();

        // Convert to attendance entries
        students.value = filtered.map((s) {
          final user = s['user'] as Map<String, dynamic>?;
          final fullName = user != null
              ? [
                  user['firstName'],
                  user['middleName'],
                  user['lastName'],
                ].where((n) => n != null && n.toString().isNotEmpty).join(' ')
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
      botToastError('Failed to load students');
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
      botToastError('No students to mark attendance for');
      return;
    }

    isSubmitting.value = true;
    try {
      // Format date as YYYY-MM-DD
      final dateStr =
          '${selectedDate.value.year}-${selectedDate.value.month.toString().padLeft(2, '0')}-${selectedDate.value.day.toString().padLeft(2, '0')}';

      // Submit attendance for each student
      int successCount = 0;
      for (var student in students) {
        final body = {
          'date': dateStr,
          'studentId': student.studentId,
          'status': student.status,
          'remarks': student.remarks ?? '',
          'schoolId': schoolId,
        };

        final res = await apiService.markAttendance(body);
        if (res.isSuccessful && res.body['success'] == true) {
          successCount++;
        }
      }

      if (successCount == students.length) {
        botToastError('Attendance marked successfully for all students');
      } else {
        botToastError(
          'Attendance marked for $successCount/${students.length} students',
        );
      }
    } catch (e) {
      botToastError('Failed to submit attendance');
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
}
