import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:student_management/app/data/apis.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/global.dart';
import 'package:student_management/app/helpers/rbac/roles.dart';
import 'package:student_management/app/helpers/rbac/role_widgets.dart';
import 'package:student_management/app/routes/app_pages.dart';

class GlobalFAB extends StatelessWidget {
  const GlobalFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColors.callBtn,
      onPressed: () => _showAddNewSheet(context),
      child: const Icon(Icons.add, color: AppColors.secondaryColor, size: 35),
    );
  }

  void _showAddNewSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.black,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.secondaryColor, AppColors.secondaryColor],
              begin: Alignment.centerLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Add New",
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.all(0),
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.primaryColor,
                      ),
                      onPressed: () => Get.back(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Student
              _buildOption(
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedStudent,
                  color: AppColors.primaryColor,
                  size: 30,
                ),
                title: "Student",
                subtitle: "You can add new student here",
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.STUDENTS);
                },
              ),
              // parent
              _buildOption(
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedUserMultiple,
                  color: AppColors.primaryColor,
                  size: 30,
                ),
                title: "Parent",
                subtitle: "You can add new parent here",
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.CREATE_PARENT);
                },
              ),
              // Teacher
              _buildOption(
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedTeaching,
                  color: AppColors.primaryColor,
                  size: 30,
                ),
                title: "Staff",
                subtitle: "You can add new staff here",
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.TEACHERS);
                },
              ),
              //subject
              _buildOption(
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedPencil,
                  color: AppColors.primaryColor,
                  size: 30,
                ),
                title: "Subject",
                subtitle: "You can add new subject here",
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.CREATE_SUBJECT);
                },
              ),
              // section
              _buildOption(
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedCells,
                  color: AppColors.primaryColor,
                  size: 30,
                ),
                title: "Section",
                subtitle: "You can add new section here",
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.CREATE_SECTION);
                },
              ),

              //class
              _buildOption(
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedBoardMath,
                  color: AppColors.primaryColor,
                  size: 30,
                ),
                title: "Class",
                subtitle: "You can add new class here",
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.CREATE_CLASS);
                },
              ),

              // Fees
              _buildOption(
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedDollarSquare,
                  color: AppColors.primaryColor,
                  size: 30,
                ),
                title: "Fees",
                subtitle: "You can see fees details here",
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.FEES);
                },
              ),

              // Announcement - Admin only
              RoleWidget(
                allowedRoles: [UserRole.SUPER_ADMIN, UserRole.ADMIN],
                child: _buildOption(
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedMegaphone01,
                    color: AppColors.primaryColor,
                    size: 30,
                  ),
                  title: "Announcement",
                  subtitle: "Send announcement to all users",
                  onTap: () {
                    Get.back();
                    _showAnnouncementDialog();
                  },
                ),
              ),

              // Timetable - Admin only
              RoleWidget(
                allowedRoles: [UserRole.SUPER_ADMIN, UserRole.ADMIN],
                child: _buildOption(
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedCalendar03,
                    color: AppColors.primaryColor,
                    size: 30,
                  ),
                  title: "Timetable",
                  subtitle: "Add new timetable slot",
                  onTap: () {
                    Get.back();
                    _showTimetableDialog();
                  },
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOption({
    required Widget icon, // <-- changed from IconData to Widget
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.callBtn.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.all(8),
              child: icon,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAnnouncementDialog() {
    final titleController = TextEditingController();
    final messageController = TextEditingController();
    final selectedType = 'GENERAL'.obs;
    final isLoading = false.obs;
    final ApiService apiService = ApiService.create();

    Get.dialog(
      Obx(() => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedMegaphone01,
              color: AppColors.callBtn,
              size: 28,
            ),
            const SizedBox(width: 10),
            const Text(
              'New Announcement',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification Type Dropdown
              const Text(
                'Type',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.grayBorder),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: selectedType.value,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: ['HOLIDAY', 'EXAM', 'EVENT', 'GENERAL']
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) selectedType.value = value;
                  },
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter announcement title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.callBtn),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: messageController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Message',
                  hintText: 'Enter announcement message',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.callBtn),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
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
                    if (titleController.text.isEmpty ||
                        messageController.text.isEmpty) {
                      Get.snackbar(
                        'Error',
                        'Please fill in all fields',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                      return;
                    }

                    isLoading.value = true;
                    try {
                      final res = await apiService.createAnnouncement({
                        'type': selectedType.value,
                        'title': titleController.text,
                        'message': messageController.text,
                        'schoolId': schoolId,
                      });

                      if (res.isSuccessful && res.body['success'] == true) {
                        Get.back();
                        Get.snackbar(
                          'Success',
                          'Announcement sent successfully',
                          backgroundColor: AppColors.callBtn,
                          colorText: AppColors.secondaryColor,
                        );
                      } else {
                        Get.snackbar(
                          'Error',
                          res.body['message'] ?? 'Failed to send announcement',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    } catch (e) {
                      Get.snackbar(
                        'Error',
                        'Failed to send announcement',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
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
                    'Send',
                    style: TextStyle(color: AppColors.secondaryColor),
                  ),
          ),
        ],
      )),
    );
  }

  void _showTimetableDialog() {
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
          classes.value = List<Map<String, dynamic>>.from(responses[0].body['data'] ?? []);
        }
        if (responses[1].isSuccessful && responses[1].body['success'] == true) {
          subjects.value = List<Map<String, dynamic>>.from(responses[1].body['data'] ?? []);
        }
        if (responses[2].isSuccessful && responses[2].body['success'] == true) {
          teachers.value = List<Map<String, dynamic>>.from(responses[2].body['data'] ?? []);
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
          sections.value = List<Map<String, dynamic>>.from(res.body['data'] ?? []);
        }
      } catch (e) {
        // Handle error silently
      }
    }

    loadData();

    final days = ['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY'];

    Get.dialog(
      Obx(() => AlertDialog(
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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
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
                    _buildDropdownField(
                      label: 'Class',
                      value: selectedClassId.value.isEmpty ? null : selectedClassId.value,
                      items: classes.map((c) => c['id'] as String).toList(),
                      itemLabels: classes.map((c) => c['name'] as String).toList(),
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
                        value: selectedSectionId.value.isEmpty ? null : selectedSectionId.value,
                        items: sections.map((s) => s['id'] as String).toList(),
                        itemLabels: sections.map((s) => s['name'] as String).toList(),
                        onChanged: (value) => selectedSectionId.value = value ?? '',
                        hint: 'Select Section (Optional)',
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Subject Dropdown
                    _buildDropdownField(
                      label: 'Subject',
                      value: selectedSubjectId.value.isEmpty ? null : selectedSubjectId.value,
                      items: subjects.map((s) => s['id'] as String).toList(),
                      itemLabels: subjects.map((s) => s['name'] as String).toList(),
                      onChanged: (value) => selectedSubjectId.value = value ?? '',
                      hint: 'Select Subject',
                    ),
                    const SizedBox(height: 12),

                    // Teacher Dropdown
                    _buildDropdownField(
                      label: 'Teacher',
                      value: selectedTeacherId.value.isEmpty ? null : selectedTeacherId.value,
                      items: teachers.map((t) => t['id'] as String).toList(),
                      itemLabels: teachers.map((t) {
                        final user = t['user'] as Map<String, dynamic>?;
                        if (user != null) {
                          return [user['firstName'], user['middleName'], user['lastName']]
                              .where((n) => n != null && n.toString().isNotEmpty)
                              .join(' ');
                        }
                        return 'Unknown';
                      }).toList(),
                      onChanged: (value) => selectedTeacherId.value = value ?? '',
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
                          borderSide: const BorderSide(color: AppColors.callBtn),
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
                            Get.snackbar(
                              'Error',
                              'Please fill in all required fields',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            return;
                          }

                          isLoading.value = true;
                          try {
                            final body = {
                              'dayOfWeek': selectedDay.value,
                              'classId': selectedClassId.value,
                              'subjectId': selectedSubjectId.value,
                              'teacherId': selectedTeacherId.value,
                              'periodNumber': int.parse(periodNumberController.text),
                              'startTime': startTime.value,
                              'endTime': endTime.value,
                              'schoolId': schoolId,
                            };
                            
                            if (selectedSectionId.value.isNotEmpty) {
                              body['sectionId'] = selectedSectionId.value;
                            }

                            final res = await apiService.createTimetableSlot(body);

                            if (res.isSuccessful && res.body['success'] == true) {
                              Get.back();
                              Get.snackbar(
                                'Success',
                                'Timetable slot created successfully',
                                backgroundColor: AppColors.callBtn,
                                colorText: AppColors.secondaryColor,
                              );
                            } else {
                              Get.snackbar(
                                'Error',
                                res.body['message'] ?? 'Failed to create timetable slot',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            }
                          } catch (e) {
                            Get.snackbar(
                              'Error',
                              'Failed to create timetable slot',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
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
      )),
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
            value: value,
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
                  child: Obx(() => Text(
                    timeValue.value.isEmpty ? hint : timeValue.value,
                    style: TextStyle(
                      fontSize: 16,
                      color: timeValue.value.isEmpty
                          ? AppColors.gray500
                          : AppColors.primaryColor,
                    ),
                  )),
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
}
