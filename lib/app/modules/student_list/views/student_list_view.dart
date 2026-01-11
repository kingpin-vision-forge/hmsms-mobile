import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/widget/download_bottom.dart';
import 'package:student_management/app/helpers/widget/global_fab.dart';
import 'package:student_management/app/helpers/rbac/rbac.dart';
import 'package:student_management/app/modules/student_list/controllers/student_list_controller.dart';
import 'package:student_management/app/modules/student_list/views/student_card_view.dart';
import 'package:student_management/app/modules/teacher_list/views/teacher_card_view.dart';
import 'package:student_management/app/routes/app_pages.dart';
import 'package:student_management/app/helpers/widget/custom_drawer.dart';

class StudentListView extends GetView<StudentListController> {
  const StudentListView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.gray50,
        drawer: CustomDrawerMenu(),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            controller.isSearching.value ? 140 : 60,
          ),
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
            child: Obx(
              () => AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: AppBar(
                  toolbarHeight: controller.isSearching.value ? 140 : 60,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  leadingWidth: double.infinity,
                  leading: SizedBox(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top bar with menu and search icons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.chevron_left,
                                      size: 36,
                                      color: AppColors.secondaryColor,
                                    ),
                                    onPressed: () {
                                      Get.offAllNamed(Routes.HOME);
                                    },
                                  ),
                                  Text(
                                        'Students',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      )
                                      .animate()
                                      .fadeIn(delay: 50.ms, duration: 300.ms)
                                      .slideY(begin: 0.1, end: 0),
                                ],
                              ),
                              IconButton(
                                icon: const HugeIcon(
                                  icon: HugeIcons.strokeRoundedSearch02,
                                  size: 36,
                                  color: AppColors.secondaryColor,
                                ),
                                onPressed: () {
                                  if (controller.isSearching.value) {
                                    controller.stopSearch();
                                  } else {
                                    controller.startSearch();
                                  }
                                },
                              ),
                            ],
                          ),
                          // Animated search field
                          Obx(() {
                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                    return SizeTransition(
                                      sizeFactor: animation,
                                      axis: Axis.vertical,
                                      child: child,
                                    );
                                  },
                              child: controller.isSearching.value
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                        top: 10,
                                        right: 16,
                                        left: 16,
                                      ),
                                      child: TextField(
                                        key: const ValueKey('searchField'),
                                        autofocus: true,
                                        decoration: InputDecoration(
                                          hintText: 'Search',
                                          hintStyle: const TextStyle(
                                            color: AppColors.gray500,
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                          suffixIcon: IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () {
                                              controller.stopSearch();
                                            },
                                          ),
                                        ),
                                        onChanged: (query) {
                                          controller.searchQuery.value = query;
                                        },
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  foregroundColor: AppColors.secondaryColor,
                  automaticallyImplyLeading: false,
                ),
              ),
            ),
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.callBtn),
            );
          }

          if (controller.filteredStudentList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                        controller.searchQuery.value.isEmpty
                            ? 'No students available'
                            : 'No students found',
                        style: const TextStyle(fontSize: 20),
                      )
                      .animate()
                      .fadeIn(delay: 50.ms, duration: 300.ms)
                      .slideY(begin: 0.1, end: 0),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.filteredStudentList.length,
            itemBuilder: (context, index) {
              final student = controller.filteredStudentList[index];
              if (index == 0) {
                return Column(
                  children: [
                    // Items count and download button at the top
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${controller.filteredStudentList.length} Items',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            height: 1.3,
                            color: AppColors.black,
                          ),
                        ),
                        IconButton(
                          icon: const HugeIcon(
                            icon: HugeIcons.strokeRoundedDownload04,
                            size: 28,
                            color: AppColors.black,
                          ),
                          onPressed: () {
                            showDownloadBottomSheet(context);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildStudentCard(student, index),
                  ],
                );
              }
              return _buildStudentCard(student, index);
            },
          );
        }),
        floatingActionButton: RoleWidget(
          allowedRoles: [
            UserRole.SUPER_ADMIN,
            UserRole.ADMIN,
            UserRole.TEACHER,
          ],
          child: GlobalFAB(),
        ),
      ),
    );
  }

  Widget _buildStudentCard(student, int index) {
    return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryColor.withOpacity(0.8),
                AppColors.callBtn.withOpacity(0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.3),
                offset: const Offset(0, 4),
                blurRadius: 12,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                // Navigate to student details (implement as needed)
                Get.toNamed(
                  Routes.STUDENT_DETAIL,
                  arguments: {'student_id': student.id},
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with student name and icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    student.firstName ?? '',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.secondaryColor,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    student.lastName ?? '',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.secondaryColor
                                          .withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.secondaryColor.withOpacity(
                                    0.2,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  student.className ?? '',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.secondaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const HugeIcon(
                            icon: HugeIcons.strokeRoundedUser,
                            size: 32,
                            color: AppColors.secondaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Divider
                    Container(
                      height: 1,
                      color: AppColors.secondaryColor.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    // Student Info
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoItem(
                            icon: HugeIcons.strokeRoundedBookOpen01,
                            label: 'Admission No.',
                            value: student.admissionNumber ?? '-',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildInfoItem(
                            icon: HugeIcons.strokeRoundedSchool,
                            label: 'Section',
                            value: student.sectionName ?? '-',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoItem(
                            icon: HugeIcons.strokeRoundedUser,
                            label: 'Gender',
                            value: student.gender ?? '-',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildInfoItem(
                            icon: HugeIcons.strokeRoundedCalendar04,
                            label: 'DOB',
                            value: student.dateOfBirth ?? '-',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(delay: (100 * index).ms, duration: 250.ms)
        .slideX(begin: 0.2, end: 0);
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          HugeIcon(icon: icon, size: 20, color: AppColors.secondaryColor),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.secondaryColor.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: AppColors.gray50,
      builder: (BuildContext context) {
        final List<String> mainOptions = ['All', 'Grade', 'Section', 'Status'];

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter By',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              const Divider(color: AppColors.grayBorder, height: 1),

              // 🔹 First-level options (Grade, Section, Status)
              ...mainOptions.map(
                (option) => ListTile(
                  title: Text(
                    option,
                    style: const TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: option.toLowerCase() == 'all'
                      ? const SizedBox.shrink()
                      : const Icon(
                          Icons.chevron_right,
                          color: AppColors.gray500,
                        ),
                  onTap: () {
                    if (option.toLowerCase() == 'all') {
                      Navigator.pop(context);
                      // Handle "All" filter action directly if needed
                    } else {
                      Navigator.pop(context);
                      _showSubFilterBottomSheet(context, option);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSubFilterBottomSheet(BuildContext context, String category) {
    List<String> subOptions = [];

    // 🔹 Determine sub-options based on category
    switch (category) {
      case 'Grade':
        subOptions = ['Grade 1', 'Grade 2', 'Grade 3', 'Grade 4', 'Grade 5'];
        break;
      case 'Section':
        subOptions = ['Section A', 'Section B', 'Section C'];
        break;
      case 'Status':
        subOptions = ['Present', 'Absent', 'Inactive'];
        break;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: AppColors.gray50,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Header with back icon and title
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.chevron_left,
                      color: AppColors.primaryColor,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _showSortBottomSheet(context); // go back to main list
                    },
                  ),
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
              const Divider(color: AppColors.grayBorder, height: 1),

              // 🔹 Sub-options list
              ...subOptions.map(
                (subOption) => ListTile(
                  title: Text(
                    subOption,
                    style: const TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: handle selection (filter data, update UI, etc.)
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
