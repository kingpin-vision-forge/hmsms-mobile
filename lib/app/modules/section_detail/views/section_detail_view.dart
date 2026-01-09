import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/modules/section_detail/models/section_Detail_response.dart';
import 'package:student_management/app/routes/app_pages.dart';

import '../controllers/section_detail_controller.dart';

class SectionDetailView extends GetView {
  SectionDetailView({super.key});

  final SectionDetailController controller = Get.put(SectionDetailController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
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
            elevation: 0, // remove extra shadow from AppBar itself
            backgroundColor: Colors.transparent,
            leadingWidth: double.infinity,
            leading: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.chevron_left,
                        size: 36,
                        color: AppColors.secondaryColor,
                      ),
                      onPressed: () {
                        Get.offAllNamed(Routes.SECTION_LIST);
                      },
                    ),
                    Text(
                          'Section Details',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.left,
                        )
                        .animate()
                        .fadeIn(delay: 50.ms, duration: 300.ms)
                        .slideY(begin: 0.1, end: 0),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    // Add your edit action here
                    controller.passEditSectionArguments();
                  },
                  icon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedPencilEdit02,
                    color: AppColors.secondaryColor,
                    size: 28,
                  ),
                ),
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
            child: CircularProgressIndicator(color: AppColors.black),
          );
        }

        if (controller.sectionDetailData.value == null ||
            controller.sectionDetailData.value!.data == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppColors.black.withOpacity(0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'No section details available',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.black.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          );
        }

        final sectionData = controller.sectionDetailData.value!.data!;
        final classInfo = sectionData.classInfo;
        final students = sectionData.students ?? [];

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Info Card
              Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.callBtn, AppColors.callBtn],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.callBtn.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.secondaryColor.withOpacity(
                                  0.2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.class_,
                                color: AppColors.secondaryColor,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Section ${sectionData.name ?? 'N/A'}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.secondaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    classInfo?.name ?? 'N/A',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.secondaryColor
                                          .withOpacity(0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(
                          color: AppColors.secondaryColor,
                          thickness: 0.5,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildInfoItem(
                              icon: Icons.school,
                              label: 'Class Code',
                              value: classInfo?.code ?? 'N/A',
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: AppColors.secondaryColor.withOpacity(0.3),
                            ),
                            _buildInfoItem(
                              icon: Icons.people,
                              label: 'Total Students',
                              value: '${students.length}',
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 100.ms, duration: 250.ms)
                  .slideY(begin: 0.2, end: 0),

              // Students List Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Students',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.callBtn.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${students.length} Students',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.callBtn,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 50.ms, duration: 250.ms),

              // Students List
              if (students.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.person_off_outlined,
                          size: 64,
                          color: AppColors.black.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No students in this section',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.black.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return _buildStudentCard(student, index);
                  },
                ),
            ].animate(interval: 30.ms).fade(duration: 200.ms),
          ),
        );
      }),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppColors.secondaryColor, size: 24),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.secondaryColor.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.secondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStudentCard(Student student, int index) {
    return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.secondaryColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                // Navigate to student detail or show more info
                _showStudentDetails(student);
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Avatar
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.callBtn.withOpacity(0.8),
                            AppColors.callBtn,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Center(
                        child: Text(
                          _getInitials(student.studentName ?? 'N/A'),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondaryColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Student Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            student.studentName ?? 'N/A',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.badge_outlined,
                                size: 14,
                                color: AppColors.black.withOpacity(0.6),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                student.admissionNumber ?? 'N/A',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.black.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                student.gender == 'MALE'
                                    ? Icons.male
                                    : Icons.female,
                                size: 14,
                                color: AppColors.black.withOpacity(0.6),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                student.gender ?? 'N/A',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.black.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Chevron Icon
                    Icon(
                      Icons.chevron_right,
                      color: AppColors.black.withOpacity(0.3),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(delay: (300 + (index * 50)).ms, duration: 200.ms)
        .slideX(begin: 0.2, end: 0);
  }

  String _getInitials(String name) {
    List<String> names = name.trim().split(' ');
    if (names.isEmpty) return 'N/A';
    if (names.length == 1) return names[0][0].toUpperCase();
    return '${names[0][0]}${names[names.length - 1][0]}'.toUpperCase();
  }

  void _showStudentDetails(Student student) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: AppColors.secondaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Header
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.callBtn, AppColors.callBtn],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Center(
                      child: Text(
                        _getInitials(student.studentName ?? 'N/A'),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student.studentName ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          student.admissionNumber ?? 'N/A',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.black.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              // Student Details
              const Text(
                'Student Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailRow(
                Icons.email_outlined,
                'Email',
                student.studentEmail ?? 'N/A',
              ),
              _buildDetailRow(
                Icons.cake_outlined,
                'Date of Birth',
                student.dateOfBirth ?? 'N/A',
              ),
              _buildDetailRow(
                Icons.person_outline,
                'Gender',
                student.gender ?? 'N/A',
              ),
              _buildDetailRow(
                Icons.class_outlined,
                'Class',
                student.className ?? 'N/A',
              ),
              _buildDetailRow(
                Icons.meeting_room_outlined,
                'Section',
                student.sectionName ?? 'N/A',
              ),
              const SizedBox(height: 24),
              // Parent Details
              const Text(
                'Parent Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailRow(
                Icons.person_outline,
                'Name',
                student.parentName ?? 'N/A',
              ),
              _buildDetailRow(
                Icons.phone_outlined,
                'Mobile',
                student.parentMobile ?? 'N/A',
              ),
              const SizedBox(height: 24),
              // Close Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.callBtn,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.callBtn),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.black.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
