import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/widget/download_bottom.dart';
import 'package:student_management/app/helpers/widget/global_fab.dart';
import 'package:student_management/app/modules/teacher_list/controllers/teacher_list_controller.dart';
import 'package:student_management/app/modules/teacher_list/views/teacher_card_view.dart';

class TeacherListView extends GetView<TeacherListController> {
  const TeacherListView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.gray50,
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
                  elevation: 0, // remove extra shadow from AppBar itself
                  backgroundColor: Colors.transparent,
                  leadingWidth: double.infinity,
                  leading: SizedBox(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🔹 Top bar with back and search icons
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
                                    onPressed: () => Get.back(),
                                  ),
                                  Text(
                                        'Staffs',
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
                              duration: const Duration(
                                milliseconds: 200,
                              ), // Duration of the animation
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                    return SizeTransition(
                                      sizeFactor:
                                          animation, // Slide the text field smoothly
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
                                        key: const ValueKey(
                                          'searchField',
                                        ), // Unique key for AnimatedSwitcher
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
                                          // controller.onSearchChanged(query);
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
        body: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
          child: Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // download icon
                        Text(
                          '4 Items',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            height: 1.3,
                            color: AppColors.black,
                          ),
                        ),
                        IconButton(
                          icon: HugeIcon(
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

                    // filter dropdown
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.tune,
                            size: 28,
                            color: AppColors.black,
                          ),
                          onPressed: () {
                            _showSortBottomSheet(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                // teacher card
                Expanded(
                  child: Obx(() {
                    if (controller.teachers.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ListView.builder(
                      itemCount: controller.teachers.length,
                      itemBuilder: (context, index) {
                        final teacher = controller.teachers[index];
                        return Column(
                          children: [
                            TeacherCardView(
                              teacherName: teacher['name'],
                              teacherId: teacher['id'],
                              subject: teacher['subject'],
                              status: teacher['status'],
                            ),
                            SizedBox(height: 12),
                          ],
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),
        ),

        floatingActionButton: GlobalFAB(),
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
        final List<String> mainOptions = ['All', 'Departments', 'Status'];

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

              // 🔹 First-level options (Departments, Status)
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
                      print('Showing all items');
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
      case 'Departments':
        subOptions = ['Mathematics', 'English', 'Science', 'History'];
        break;
      case 'Status':
        subOptions = ['Active', 'On Leave', 'Inactive'];
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
