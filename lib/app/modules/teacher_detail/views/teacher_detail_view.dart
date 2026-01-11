import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/widget/global_fab.dart';
import 'package:student_management/app/modules/teacher_detail/controllers/teacher_detail_controller.dart';

class TeacherDetailView extends GetView {
  TeacherDetailView({super.key});

  final TeacherDetailController controller = Get.put(TeacherDetailController());

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
            elevation: 0,
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
                        Get.back();
                      },
                    ),
                    Text(
                          'Teacher Details',
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
                    controller.passEditTeacherArguments();
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

        if (controller.teacher.value == null) {
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
                  'No teacher details available',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.black.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          );
        }

        final teacherData = controller.teacher.value!.data;
        final teacherUser = teacherData.user;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Teacher Info Card
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
                                Icons.person,
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
                                    '${teacherUser.firstName} ${teacherUser.middleName ?? ''} ${teacherUser.lastName}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.secondaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    teacherUser.role,
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
                        // Contact Info
                        Column(
                          children: [
                            _buildContactInfoRow(
                              icon: Icons.email_outlined,
                              label: 'Email',
                              value: teacherUser.email,
                            ),
                            const SizedBox(height: 12),
                            _buildContactInfoRow(
                              icon: Icons.phone_outlined,
                              label: 'Phone',
                              value: teacherUser.phone ?? 'N/A',
                            ),
                            const SizedBox(height: 12),
                            _buildContactInfoRow(
                              icon: Icons.location_on_outlined,
                              label: 'Address',
                              value: teacherUser.address ?? 'N/A',
                            ),
                            const SizedBox(height: 12),
                            _buildContactInfoRow(
                              icon: Icons.badge_outlined,
                              label: 'Employee Code',
                              value: teacherData.employeeCode,
                            ),
                            const SizedBox(height: 12),
                            _buildContactInfoRow(
                              icon: Icons.calendar_today_outlined,
                              label: 'Joined Date',
                              value: _formatDate(
                                teacherData.joinedDate.toString(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 100.ms, duration: 250.ms)
                  .slideY(begin: 0.2, end: 0),

              // Additional Info Section
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Text(
                  'Additional Information',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
              ).animate().fadeIn(delay: 50.ms, duration: 250.ms),

              // Additional Details Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.callBtn.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.callBtn.withOpacity(0.2)),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(
                      'Account Status',
                      teacherData.isDeleted ? 'Deleted' : 'Active',
                      teacherData.isDeleted ? Colors.red : Colors.green,
                    ),
                    if (teacherData.deletedAt != null) ...[
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        'Deleted At',
                        _formatDate(teacherData.deletedAt.toString()),
                        AppColors.callBtn,
                      ),
                    ],
                  ],
                ),
              ).animate().fadeIn(delay: 150.ms, duration: 250.ms),

              const SizedBox(height: 32),
            ].animate(interval: 30.ms).fade(duration: 200.ms),
          ),
        );
      }),

      floatingActionButton: GlobalFAB(),
    );
  }

  Widget _buildContactInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppColors.secondaryColor, size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.secondaryColor.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.secondaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.black.withOpacity(0.7),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateString) {
    try {
      if (dateString.isEmpty) return 'N/A';
      final date = DateTime.parse(dateString);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }
}
