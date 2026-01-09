import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/widget/global_fab.dart';
import 'package:student_management/app/helpers/rbac/rbac.dart';
import 'package:student_management/app/routes/app_pages.dart';
import 'package:student_management/app/modules/teacher_detail/controllers/teacher_detail_controller.dart';

class TeacherDetailView extends GetView<TeacherDetailController> {
  const TeacherDetailView({super.key});
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
              end: Alignment.centerRight,
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
                      'Staff Details',
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
            foregroundColor: AppColors.secondaryColor,
            automaticallyImplyLeading: false,
            actions: [
              RoleWidget(
                allowedRoles: [UserRole.SUPER_ADMIN, UserRole.ADMIN],
                child: IconButton(
                  icon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedEdit02,
                    size: 24,
                    color: AppColors.secondaryColor,
                  ),
                  onPressed: () {
                    if (controller.teacher.value != null) {
                      Get.toNamed(
                        Routes.CREATE_TEACHER,
                        arguments: {
                          'isEdit': true,
                          'teacherId': controller.teacherId,
                          'firstName': controller.teacher.value?.firstName,
                          'middleName': controller.teacher.value?.middleName,
                          'lastName': controller.teacher.value?.lastName,
                          'email': controller.teacher.value?.email,
                          'phone': controller.teacher.value?.phone,
                          'address': controller.teacher.value?.address,
                          'employeeCode': controller.teacher.value?.employeeCode,
                          'joinedDate': controller.teacher.value?.joinedDate,
                        },
                      );
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.callBtn),
          );
        }

        final teacher = controller.teacher.value;
        if (teacher == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HugeIcon(
                  icon: HugeIcons.strokeRoundedUserQuestion01,
                  size: 80,
                  color: AppColors.gray500,
                ),
                const SizedBox(height: 16),
                Text(
                  'Teacher not found',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.gray500,
                  ),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header Card
              _buildProfileCard(teacher),
              const SizedBox(height: 20),

              // Contact Information
              _buildSectionHeader('Contact Information'),
              const SizedBox(height: 12),
              _buildDetailCard([
                _buildDetailRow(
                  icon: HugeIcons.strokeRoundedMail01,
                  label: 'Email',
                  value: teacher.email ?? 'N/A',
                ),
                _buildDetailRow(
                  icon: HugeIcons.strokeRoundedCall,
                  label: 'Phone',
                  value: teacher.phone ?? 'N/A',
                ),
                _buildDetailRow(
                  icon: HugeIcons.strokeRoundedLocation01,
                  label: 'Address',
                  value: teacher.address ?? 'N/A',
                ),
              ]),
              const SizedBox(height: 20),

              // Employment Details
              _buildSectionHeader('Employment Details'),
              const SizedBox(height: 12),
              _buildDetailCard([
                _buildDetailRow(
                  icon: HugeIcons.strokeRoundedIdea01,
                  label: 'Employee Code',
                  value: teacher.employeeCode ?? 'N/A',
                ),
                _buildDetailRow(
                  icon: HugeIcons.strokeRoundedCalendar03,
                  label: 'Joined Date',
                  value: _formatDate(teacher.joinedDate),
                ),
              ]),
              const SizedBox(height: 30),
            ].animate(interval: 50.ms).fade(duration: 200.ms),
          ),
        );
      }),
      floatingActionButton: RoleWidget(
        allowedRoles: [UserRole.SUPER_ADMIN, UserRole.ADMIN],
        child: GlobalFAB(),
      ),
    );
  }

  Widget _buildProfileCard(dynamic teacher) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.callBtn.withOpacity(0.1), AppColors.callBtn.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.callBtn.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.callBtn,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                _getInitials(teacher.fullName),
                style: const TextStyle(
                  color: AppColors.secondaryColor,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Name
          Text(
            teacher.fullName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          // Employee Code Badge
          if (teacher.employeeCode != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.callBtn.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                teacher.employeeCode!,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.callBtn,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryColor,
      ),
    );
  }

  Widget _buildDetailCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grayBorder),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HugeIcon(
            icon: icon,
            size: 20,
            color: AppColors.callBtn,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.gray500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return '?';
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }
}
