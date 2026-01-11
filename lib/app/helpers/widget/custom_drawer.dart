import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/global.dart';
import 'package:student_management/app/helpers/rbac/rbac.dart';
import 'package:student_management/app/helpers/widget/profile_image.dart';
import 'package:student_management/app/modules/home/controllers/home_controller.dart';
import 'package:student_management/app/routes/app_pages.dart';

class CustomDrawerMenu extends StatelessWidget {
  CustomDrawerMenu({super.key});

  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final firstName = userData['username'] ?? '';
    final initial = (firstName.toString().isNotEmpty ? firstName[0] : '');
    return Drawer(
      backgroundColor: AppColors.secondaryColor,
      child: Column(
        children: [
          // Header Section with User Info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: BoxDecoration(color: AppColors.secondaryColor),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Avatar
                  profileImage(initial, controller.signedUrl),

                  const SizedBox(height: 12),
                  // User Name
                  Text(
                    getFseFullName(userData),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // User Email
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          userData['email'] ?? '',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.gray500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          userData['role'] ?? '',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.gray500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Divider between profile and menu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              color: AppColors.gray500.withOpacity(0.3),
              thickness: 1,
              height: 1,
            ),
          ),
          
          const SizedBox(height: 8),

          // Menu Items
          Expanded(
            child: Obx(
              () => ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Dashboard - All roles
                  _buildMenuItem(
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedMenu02,
                      color: controller.selectedMenu.value == 'Dashboard'
                          ? AppColors.primaryColor
                          : AppColors.black,
                    ),
                    title: 'Dashboard',
                    isSelected: controller.selectedMenu.value == 'Dashboard',
                    onTap: () {
                      controller.selectMenu('Dashboard');
                      Navigator.pop(context);
                      Get.toNamed(Routes.HOME);
                    },
                  ),
                  // My Children - Parent only
                  RoleWidget(
                    allowedRoles: [UserRole.PARENT],
                    child: _buildMenuItem(
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedUserGroup,
                        color: controller.selectedMenu.value == 'My Children'
                            ? AppColors.primaryColor
                            : AppColors.black,
                      ),
                      title: 'My Children',
                      isSelected: controller.selectedMenu.value == 'My Children',
                      onTap: () {
                        controller.selectMenu('My Children');
                        Navigator.pop(context);
                        Get.toNamed(Routes.STUDENT_LIST)?.then((_) {
                          controller.selectMenu('Dashboard');
                        });
                      },
                    ),
                  ),
                  // My Classes - Teacher only
                  RoleWidget(
                    allowedRoles: [UserRole.TEACHER],
                    child: _buildMenuItem(
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedBoardMath,
                        color: controller.selectedMenu.value == 'My Classes'
                            ? AppColors.primaryColor
                            : AppColors.black,
                      ),
                      title: 'My Classes',
                      isSelected: controller.selectedMenu.value == 'My Classes',
                      onTap: () {
                        controller.selectMenu('My Classes');
                        Navigator.pop(context);
                        Get.toNamed(Routes.CLASS_LIST)?.then((_) {
                          controller.selectMenu('Dashboard');
                        });
                      },
                    ),
                  ),
                  // Students - Admin, Teacher only
                  RoleWidget(
                    allowedRoles: [UserRole.SUPER_ADMIN, UserRole.ADMIN, UserRole.TEACHER],
                    child: _buildMenuItem(
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedStudent,
                        color: controller.selectedMenu.value == 'Students'
                            ? AppColors.primaryColor
                            : AppColors.black,
                      ),
                      title: 'Students',
                      isSelected: controller.selectedMenu.value == 'Students',
                      onTap: () {
                        controller.selectMenu('Students');
                        Navigator.pop(context);
                        Get.toNamed(Routes.STUDENT_LIST)?.then((_) {
                          controller.selectMenu('Dashboard');
                        });
                      },
                    ),
                  ),
                  // Parents - Admin, Teacher
                  RoleWidget(
                    allowedRoles: [UserRole.SUPER_ADMIN, UserRole.ADMIN, UserRole.TEACHER],
                    child: _buildMenuItem(
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedUserMultiple,
                        color: controller.selectedMenu.value == 'Parents'
                            ? AppColors.primaryColor
                            : AppColors.black,
                      ),
                      title: 'Parents',
                      isSelected: controller.selectedMenu.value == 'Parents',
                      onTap: () {
                        controller.selectMenu('Parents');
                        Navigator.pop(context);
                        Get.toNamed(Routes.PARENT_LIST)?.then((_) {
                          controller.selectMenu('Dashboard');
                        });
                      },
                    ),
                  ),
                  // Staffs/Teachers - Admin only
                  RoleWidget(
                    allowedRoles: [UserRole.SUPER_ADMIN, UserRole.ADMIN],
                    child: _buildMenuItem(
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedTeaching,
                        color: controller.selectedMenu.value == 'Staffs'
                            ? AppColors.primaryColor
                            : AppColors.black,
                      ),
                      title: 'Staffs',
                      isSelected: controller.selectedMenu.value == 'Staffs',
                      onTap: () {
                        controller.selectMenu('Staffs');
                        Navigator.pop(context);
                        Get.toNamed(Routes.TEACHER_LIST)?.then((_) {
                          controller.selectMenu('Dashboard');
                        });
                      },
                    ),
                  ),
                  // Subjects - Admin, Teacher
                  RoleWidget(
                    allowedRoles: [UserRole.SUPER_ADMIN, UserRole.ADMIN, UserRole.TEACHER],
                    child: _buildMenuItem(
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedPencil,
                        color: controller.selectedMenu.value == 'Subjects'
                            ? AppColors.primaryColor
                            : AppColors.black,
                      ),
                      title: 'Subjects',
                      isSelected: controller.selectedMenu.value == 'Subjects',
                      onTap: () {
                        controller.selectMenu('Subjects');
                        Navigator.pop(context);
                        Get.toNamed(Routes.SUBJECT_LIST)?.then((_) {
                          controller.selectMenu('Dashboard');
                        });
                      },
                    ),
                  ),
                  // Classes - Admin, Teacher
                  RoleWidget(
                    allowedRoles: [UserRole.SUPER_ADMIN, UserRole.ADMIN, UserRole.TEACHER],
                    child: _buildMenuItem(
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedBoardMath,
                        color: controller.selectedMenu.value == 'Classes'
                            ? AppColors.primaryColor
                            : AppColors.black,
                      ),
                      title: 'Classes',
                      isSelected: controller.selectedMenu.value == 'Classes',
                      onTap: () {
                        controller.selectMenu('Classes');
                        Navigator.pop(context);
                        Get.toNamed(Routes.CLASS_LIST)?.then((_) {
                          controller.selectMenu('Dashboard');
                        });
                      },
                    ),
                  ),
                  // Sections - Admin, Teacher
                  RoleWidget(
                    allowedRoles: [UserRole.SUPER_ADMIN, UserRole.ADMIN, UserRole.TEACHER],
                    child: _buildMenuItem(
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedCells,
                        color: controller.selectedMenu.value == 'Sections'
                            ? AppColors.primaryColor
                            : AppColors.black,
                      ),
                      title: 'Sections',
                      isSelected: controller.selectedMenu.value == 'Sections',
                      onTap: () {
                        controller.selectMenu('Sections');
                        Navigator.pop(context);
                        Get.toNamed(Routes.SECTION_LIST)?.then((_) {
                          controller.selectMenu('Dashboard');
                        });
                      },
                    ),
                  ),
                  // Fees - Admin, Student, Parent
                  RoleWidget(
                    allowedRoles: [UserRole.SUPER_ADMIN, UserRole.ADMIN, UserRole.STUDENT, UserRole.PARENT],
                    child: _buildMenuItem(
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedDollarSquare,
                        color: controller.selectedMenu.value == 'Fees'
                            ? AppColors.primaryColor
                            : AppColors.black,
                      ),
                      title: 'Fees',
                      isSelected: controller.selectedMenu.value == 'Fees',
                      onTap: () {
                        controller.selectMenu('Fees');
                        Navigator.pop(context);
                        Get.toNamed(Routes.FEES)?.then((_) {
                          controller.selectMenu('Dashboard');
                        });
                      },
                    ),
                  ),
                  // Timetable - All roles
                  _buildMenuItem(
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedDateTime,
                      color: controller.selectedMenu.value == 'Timetable'
                          ? AppColors.primaryColor
                          : AppColors.black,
                    ),
                    title: 'Timetable',
                    isSelected: controller.selectedMenu.value == 'Timetable',
                    onTap: () {
                      controller.selectMenu('Timetable');
                      Navigator.pop(context);
                      Get.toNamed(Routes.TIMETABLE)?.then((_) {
                        controller.selectMenu('Dashboard');
                      });
                    },
                  ),
                  // Attendance - Admin, Teacher
                  RoleWidget(
                    allowedRoles: [UserRole.SUPER_ADMIN, UserRole.ADMIN, UserRole.TEACHER],
                    child: _buildMenuItem(
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedCheckList,
                        color: controller.selectedMenu.value == 'Attendance'
                            ? AppColors.primaryColor
                            : AppColors.black,
                      ),
                      title: 'Attendance',
                      isSelected: controller.selectedMenu.value == 'Attendance',
                      onTap: () {
                        controller.selectMenu('Attendance');
                        Navigator.pop(context);
                        Get.toNamed(Routes.ATTENDANCE)?.then((_) {
                          controller.selectMenu('Dashboard');
                        });
                      },
                    ),
                  ),
                  // Settings - All roles
                  _buildMenuItem(
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedSettings02,
                      color: controller.selectedMenu.value == 'Settings'
                          ? AppColors.primaryColor
                          : AppColors.black,
                    ),
                    title: 'Settings',
                    isSelected: controller.selectedMenu.value == 'Settings',
                    onTap: () {
                      controller.selectMenu('Settings');
                      Navigator.pop(context);
                      Get.toNamed(Routes.PROFILE)?.then((_) {
                        controller.selectMenu('Dashboard');
                      });
                    },
                  ),
                  // Sign Out - All roles
                  _buildMenuItem(
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedLogout01,
                      color: AppColors.gray800,
                    ),
                    title: 'Sign Out',
                    isSelected: controller.selectedMenu.value == 'Sign Out',
                    onTap: () async {
                      await signOut();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required Widget icon,
    required String title,
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.green100 : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: icon,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? AppColors.primaryColor : AppColors.gray800,
          ),
        ),
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        onTap: onTap,
      ),
    );
  }
}
