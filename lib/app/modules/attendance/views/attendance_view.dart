import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/widget/custom_drawer.dart';
import 'package:student_management/app/helpers/widget/global_fab.dart';
import 'package:student_management/app/modules/attendance/controllers/attendance_controller.dart';

class AttendanceView extends GetView<AttendanceController> {
  const AttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      drawer: CustomDrawerMenu(),
      floatingActionButton: GlobalFAB(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.callBtn, AppColors.callBtn],
              begin: Alignment.centerLeft,
              end: Alignment.topRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.3),
                offset: const Offset(0, 3),
                blurRadius: 6,
              ),
            ],
          ),
          child: AppBar(
            toolbarHeight: 70,
            elevation: 0,
            backgroundColor: Colors.transparent,
            leadingWidth: double.infinity,
            leading: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(
                      Icons.menu,
                      size: 28,
                      color: AppColors.secondaryColor,
                    ),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                Text(
                  'Mark Attendance',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 800.ms)
                    .slideY(begin: 0.1, end: 0),
              ],
            ),
            foregroundColor: AppColors.secondaryColor,
            automaticallyImplyLeading: false,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.callBtn),
          );
        }

        return Column(
          children: [
            // Filters Section
            _buildFiltersSection(context),
            // Students List
            Expanded(
              child: _buildStudentsList(),
            ),
            // Submit Button
            if (controller.students.isNotEmpty) _buildSubmitButton(),
          ],
        );
      }),
    );
  }

  Widget _buildFiltersSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          // Date Picker
          GestureDetector(
            onTap: () => controller.pickDate(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.grayBorder),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedCalendar03,
                    color: AppColors.callBtn,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Obx(() {
                    final date = controller.selectedDate.value;
                    return Text(
                      '${date.day}/${date.month}/${date.year}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }),
                  const Spacer(),
                  const Icon(Icons.arrow_drop_down, color: AppColors.gray500),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Class & Section Row
          Row(
            children: [
              // Class Dropdown
              Expanded(
                child: _buildDropdown(
                  label: 'Class',
                  value: controller.selectedClassId.value.isEmpty
                      ? null
                      : controller.selectedClassId.value,
                  items: controller.classes
                      .map((c) => DropdownMenuItem<String>(
                            value: c['id'] as String,
                            child: Text(c['name'] as String),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) controller.selectClass(value);
                  },
                  hint: 'Select Class',
                ),
              ),
              const SizedBox(width: 12),
              // Section Dropdown
              Expanded(
                child: _buildDropdown(
                  label: 'Section',
                  value: controller.selectedSectionId.value.isEmpty
                      ? null
                      : controller.selectedSectionId.value,
                  items: controller.sections
                      .map((s) => DropdownMenuItem<String>(
                            value: s['id'] as String,
                            child: Text(s['name'] as String),
                          ))
                      .toList(),
                  onChanged: (value) {
                    controller.selectSection(value ?? '');
                  },
                  hint: 'All Sections',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Quick Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: controller.markAllPresent,
                  icon: const Icon(Icons.check_circle_outline,
                      color: Colors.green, size: 18),
                  label: const Text('Mark All Present',
                      style: TextStyle(color: Colors.green, fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.green),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: controller.markAllAbsent,
                  icon: const Icon(Icons.cancel_outlined,
                      color: Colors.red, size: 18),
                  label: const Text('Mark All Absent',
                      style: TextStyle(color: Colors.red, fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
    required String hint,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grayBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        hint: Text(hint, style: TextStyle(color: AppColors.gray500)),
        items: items,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildStudentsList() {
    if (controller.selectedClassId.value.isEmpty) {
      return _buildEmptyState(
        icon: HugeIcons.strokeRoundedBoardMath,
        title: 'Select a Class',
        subtitle: 'Choose a class to load students',
      );
    }

    if (controller.isLoadingStudents.value) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.callBtn),
      );
    }

    if (controller.students.isEmpty) {
      return _buildEmptyState(
        icon: HugeIcons.strokeRoundedUserMultiple,
        title: 'No Students Found',
        subtitle: 'No students in the selected class/section',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.students.length,
      itemBuilder: (context, index) => _buildStudentCard(index),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HugeIcon(icon: icon, size: 64, color: AppColors.gray500),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.gray500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.gray500.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(int index) {
    final student = controller.students[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grayBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          // Student Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.studentName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                if (student.admissionNumber != null)
                  Text(
                    student.admissionNumber!,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.gray500,
                    ),
                  ),
              ],
            ),
          ),
          // Status Toggles
          Row(
            children: [
              _buildStatusButton(index, 'PRESENT', Colors.green, Icons.check),
              const SizedBox(width: 8),
              _buildStatusButton(index, 'LATE', Colors.orange, Icons.access_time),
              const SizedBox(width: 8),
              _buildStatusButton(index, 'ABSENT', Colors.red, Icons.close),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: (30 * index).ms, duration: 300.ms)
        .slideX(begin: 0.05, end: 0);
  }

  Widget _buildStatusButton(
      int index, String status, Color color, IconData icon) {
    final isSelected = controller.students[index].status == status;
    return GestureDetector(
      onTap: () => controller.updateStudentStatus(index, status),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isSelected ? Colors.white : color,
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1),
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed:
                controller.isSubmitting.value ? null : controller.submitAttendance,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.callBtn,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: controller.isSubmitting.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.secondaryColor,
                    ),
                  )
                : const Text(
                    'Submit Attendance',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondaryColor,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
