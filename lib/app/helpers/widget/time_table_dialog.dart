import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:student_management/app/data/apis.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/global.dart';

void showTimetableDialog() {
  final ApiService apiService = ApiService.create();
  final isLoading = false.obs;
  final isLoadingData = true.obs;

  // Form fields
  final selectedDay = 'MONDAY'.obs;
  final selectedClassId = ''.obs;
  final selectedSectionId = ''.obs;
  final selectedSubjectId = ''.obs;
  final selectedTeacherId = ''.obs;
  final startTime = ''.obs;
  final endTime = ''.obs;
  final periodNumberController = TextEditingController();

  // Data lists
  final classes = <Map<String, dynamic>>[].obs;
  final sections = <Map<String, dynamic>>[].obs;
  final subjects = <Map<String, dynamic>>[].obs;
  final teachers = <Map<String, dynamic>>[].obs;

  // Load dropdown data
  Future<void> loadData() async {
    try {
      final responses = await Future.wait([
        apiService.fetchClassesForSection(),
        apiService.fetchSubjects(),
        apiService.fetchTeachers(),
      ]);

      if (responses[0].isSuccessful && responses[0].body['success'] == true) {
        classes.value = List<Map<String, dynamic>>.from(
          responses[0].body['data'] ?? [],
        );
      }
      if (responses[1].isSuccessful && responses[1].body['success'] == true) {
        subjects.value = List<Map<String, dynamic>>.from(
          responses[1].body['data'] ?? [],
        );
      }
      if (responses[2].isSuccessful && responses[2].body['success'] == true) {
        teachers.value = List<Map<String, dynamic>>.from(
          responses[2].body['data'] ?? [],
        );
      }
    } catch (e) {
      // Handle error silently
    } finally {
      isLoadingData.value = false;
    }
  }

  // Load sections when class changes
  Future<void> loadSections(String classId) async {
    sections.clear();
    selectedSectionId.value = '';
    if (classId.isEmpty) return;

    try {
      final res = await apiService.fetchSectionForClass(classId: classId);
      if (res.isSuccessful && res.body['success'] == true) {
        sections.value = List<Map<String, dynamic>>.from(
          res.body['data'] ?? [],
        );
      }
    } catch (e) {
      // Handle error silently
    }
  }

  loadData();

  final days = [
    'MONDAY',
    'TUESDAY',
    'WEDNESDAY',
    'THURSDAY',
    'FRIDAY',
    'SATURDAY',
  ];

  Get.dialog(
    Obx(
      () => AlertDialog(
        backgroundColor: AppColors.secondaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedCalendar03,
              color: AppColors.callBtn,
              size: 28,
            ),
            const SizedBox(width: 10),
            const Text(
              'Add Timetable Slot',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: isLoadingData.value
            ? const SizedBox(
                height: 100,
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.callBtn),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Day Dropdown
                    _buildDropdownField(
                      label: 'Day',
                      value: selectedDay.value,
                      items: days,
                      onChanged: (value) => selectedDay.value = value!,
                    ),
                    const SizedBox(height: 12),

                    // Class Dropdown
                    if (classes.isNotEmpty)
                      _buildDropdownField(
                        label: 'Class',
                        value: selectedClassId.value.isEmpty
                            ? null
                            : selectedClassId.value,
                        items: classes.map((c) => c['id'] as String).toList(),
                        itemLabels: classes
                            .map((c) => c['name'] as String)
                            .toList(),
                        onChanged: (value) {
                          selectedClassId.value = value ?? '';
                          loadSections(value ?? '');
                        },
                        hint: 'Select Class',
                      ),
                    const SizedBox(height: 12),

                    // Section Dropdown
                    if (sections.isNotEmpty) ...[
                      _buildDropdownField(
                        label: 'Section',
                        value: selectedSectionId.value.isEmpty
                            ? null
                            : selectedSectionId.value,
                        items: sections.map((s) => s['id'] as String).toList(),
                        itemLabels: sections
                            .map((s) => s['name'] as String)
                            .toList(),
                        onChanged: (value) =>
                            selectedSectionId.value = value ?? '',
                        hint: 'Select Section (Optional)',
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Subject Dropdown
                    if (subjects.isNotEmpty)
                      _buildDropdownField(
                        label: 'Subject',
                        value: selectedSubjectId.value.isEmpty
                            ? null
                            : selectedSubjectId.value,
                        items: subjects.map((s) => s['id'] as String).toList(),
                        itemLabels: subjects
                            .map((s) => s['name'] as String)
                            .toList(),
                        onChanged: (value) =>
                            selectedSubjectId.value = value ?? '',
                        hint: 'Select Subject',
                      ),
                    const SizedBox(height: 12),

                    // Teacher Dropdown
                    if (teachers.isNotEmpty)
                      _buildDropdownField(
                        label: 'Teacher',
                        value: selectedTeacherId.value.isEmpty
                            ? null
                            : selectedTeacherId.value,
                        items: teachers.map((t) => t['id'] as String).toList(),
                        itemLabels: teachers.map((t) {
                          final user = t['user'] as Map<String, dynamic>?;
                          if (user != null) {
                            return [
                                  user['firstName'],
                                  user['middleName'],
                                  user['lastName'],
                                ]
                                .where(
                                  (n) => n != null && n.toString().isNotEmpty,
                                )
                                .join(' ');
                          }
                          return 'Unknown';
                        }).toList(),
                        onChanged: (value) =>
                            selectedTeacherId.value = value ?? '',
                        hint: 'Select Teacher',
                      ),
                    const SizedBox(height: 12),

                    // Period Number
                    TextField(
                      controller: periodNumberController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Period Number',
                        hintText: 'e.g., 1, 2, 3',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColors.callBtn,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Start Time
                    _buildTimePickerField(
                      label: 'Start Time',
                      timeValue: startTime,
                      hint: 'Select start time',
                    ),
                    const SizedBox(height: 12),

                    // End Time
                    _buildTimePickerField(
                      label: 'End Time',
                      timeValue: endTime,
                      hint: 'Select end time',
                    ),
                  ],
                ),
              ),
        actions: isLoadingData.value
            ? null
            : [
                TextButton(
                  onPressed: isLoading.value ? null : () => Get.back(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: AppColors.gray500),
                  ),
                ),
                ElevatedButton(
                  onPressed: isLoading.value
                      ? null
                      : () async {
                          // Validation
                          if (selectedClassId.value.isEmpty ||
                              selectedSubjectId.value.isEmpty ||
                              selectedTeacherId.value.isEmpty ||
                              periodNumberController.text.isEmpty ||
                              startTime.value.isEmpty ||
                              endTime.value.isEmpty) {
                            botToastError('Please fill in all required fields');
                            return;
                          }

                          isLoading.value = true;
                          try {
                            final body = {
                              'dayOfWeek': selectedDay.value,
                              'classId': selectedClassId.value,
                              'subjectId': selectedSubjectId.value,
                              'teacherId': selectedTeacherId.value,
                              'periodNumber': int.parse(
                                periodNumberController.text,
                              ),
                              'startTime': startTime.value,
                              'endTime': endTime.value,
                              // 'schoolId': schoolId,
                            };

                            if (selectedSectionId.value.isNotEmpty) {
                              body['sectionId'] = selectedSectionId.value;
                            }

                            final res = await apiService.createTimetableSlot(
                              body,
                            );

                            if (res.isSuccessful &&
                                res.body['success'] == true) {
                              Get.back();
                              botToastSuccess(
                                'Timetable slot created successfully',
                              );
                            } else {
                              botToastError(
                                res.body['message'] ??
                                    'Failed to create timetable slot',
                              );
                            }
                          } catch (e) {
                            botToastError('Failed to create timetable slot');
                          } finally {
                            isLoading.value = false;
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.callBtn,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: isLoading.value
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.secondaryColor,
                          ),
                        )
                      : const Text(
                          'Create',
                          style: TextStyle(color: AppColors.secondaryColor),
                        ),
                ),
              ],
      ),
    ),
  );
}

Widget _buildDropdownField({
  required String label,
  required String? value,
  required List<String> items,
  List<String>? itemLabels,
  required ValueChanged<String?> onChanged,
  String? hint,
}) {
  // Ensure value is null if it's not in the items list
  final validValue = (value != null && items.contains(value)) ? value : null;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 6),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grayBorder),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButton<String>(
          value: validValue,
          isExpanded: true,
          underline: const SizedBox(),
          hint: Text(hint ?? 'Select $label'),
          items: items.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            return DropdownMenuItem(
              value: item,
              child: Text(itemLabels?[idx] ?? item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    ],
  );
}

Widget _buildTimePickerField({
  required String label,
  required RxString timeValue,
  required String hint,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 6),
      GestureDetector(
        onTap: () async {
          // Parse existing time or default to 9:00 AM
          TimeOfDay initialTime = const TimeOfDay(hour: 9, minute: 0);
          if (timeValue.value.isNotEmpty) {
            final parts = timeValue.value.split(':');
            if (parts.length == 2) {
              initialTime = TimeOfDay(
                hour: int.tryParse(parts[0]) ?? 9,
                minute: int.tryParse(parts[1]) ?? 0,
              );
            }
          }

          final TimeOfDay? picked = await showTimePicker(
            context: Get.context!,
            initialTime: initialTime,
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: AppColors.callBtn,
                    onPrimary: AppColors.secondaryColor,
                    surface: AppColors.secondaryColor,
                    onSurface: AppColors.primaryColor,
                  ),
                ),
                child: child!,
              );
            },
          );

          if (picked != null) {
            // Format as HH:mm
            final hour = picked.hour.toString().padLeft(2, '0');
            final minute = picked.minute.toString().padLeft(2, '0');
            timeValue.value = '$hour:$minute';
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.grayBorder),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Obx(
                  () => Text(
                    timeValue.value.isEmpty ? hint : timeValue.value,
                    style: TextStyle(
                      fontSize: 16,
                      color: timeValue.value.isEmpty
                          ? AppColors.gray500
                          : AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
              HugeIcon(
                icon: HugeIcons.strokeRoundedClock01,
                color: AppColors.callBtn,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
