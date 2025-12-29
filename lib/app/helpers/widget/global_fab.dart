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
}
