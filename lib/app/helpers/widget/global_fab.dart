import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:student_management/app/helpers/constants.dart';
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
}
