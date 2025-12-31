import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/modules/class_list/controllers/class_list_controller.dart';
import 'package:student_management/app/modules/class_list/models/class_list_response.dart';
import 'package:student_management/app/routes/app_pages.dart';
import 'package:student_management/app/helpers/widget/custom_drawer.dart';
import 'package:student_management/app/helpers/widget/global_fab.dart';

class ClassListView extends GetView<ClassListController> {
  const ClassListView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.gray50,
        drawer: CustomDrawerMenu(),
        floatingActionButton: GlobalFAB(),
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
                          // Top bar with menu and search icons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Builder(
                                    builder: (context) => IconButton(
                                      icon: const Icon(
                                        Icons.menu,
                                        size: 28,
                                        color: AppColors.secondaryColor,
                                      ),
                                      onPressed: () {
                                        Scaffold.of(context).openDrawer();
                                      },
                                    ),
                                  ),
                                  Text(
                                        'Classes',
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
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }

          if (controller.filteredClassList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  HugeIcon(
                        icon: HugeIcons.strokeRoundedAlert01,
                        size: 100,
                        color: AppColors.primaryColor,
                      )
                      .animate()
                      .fadeIn(delay: 50.ms, duration: 300.ms)
                      .slideY(begin: 0.1, end: 0),
                  const SizedBox(height: 20),
                  Text(
                        controller.searchQuery.value.isEmpty
                            ? 'No classes found'
                            : 'No classes found',
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
            itemCount: controller.filteredClassList.length,
            itemBuilder: (context, index) {
              final classData = controller.filteredClassList[index];
              return Column(
                children: [
                  // Items count and download button at the top
                  if (index == 0) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${controller.filteredClassList.length} Items',
                          style: const TextStyle(
                            fontSize: 16,
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
                            // showDownloadBottomSheet(context);
                            // TODO: Implement download functionality
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                  _buildClassCard(classData, index),
                ],
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildClassCard(ClassData classData, int index) {
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
                // Navigate to class details
                Get.offAllNamed(
                  Routes.CLASS_DETAIL,
                  arguments: {'class_id': classData.id},
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with class name and code
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                classData.name,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.secondaryColor,
                                ),
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
                                  'Code: ${classData.code}',
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
                            icon: HugeIcons.strokeRoundedBookOpen01,
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

                    // Info cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            icon: HugeIcons.strokeRoundedUserMultiple,
                            label: 'Sections',
                            value: '${classData.sections.length}',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildInfoCard(
                            icon: HugeIcons.strokeRoundedBook02,
                            label: 'Subjects',
                            value: '${classData.subjects.length}',
                          ),
                        ),
                      ],
                    ),

                    // Sections list if available
                    // if (classData.sections.isNotEmpty) ...[
                    //   const SizedBox(height: 12),
                    //   Wrap(
                    //     spacing: 6,
                    //     runSpacing: 6,
                    //     children: classData.sections.take(5).map((section) {
                    //       return Container(
                    //         padding: const EdgeInsets.symmetric(
                    //           horizontal: 10,
                    //           vertical: 6,
                    //         ),
                    //         decoration: BoxDecoration(
                    //           color: AppColors.secondaryColor.withOpacity(0.25),
                    //           borderRadius: BorderRadius.circular(8),
                    //           border: Border.all(
                    //             color: AppColors.secondaryColor.withOpacity(0.3),
                    //             width: 1,
                    //           ),
                    //         ),
                    //         child: Text(
                    //           section.name,
                    //           style: const TextStyle(
                    //             fontSize: 12,
                    //             fontWeight: FontWeight.w600,
                    //             color: AppColors.secondaryColor,
                    //           ),
                    //         ),
                    //       );
                    //     }).toList(),
                    //   ),
                    //   if (classData.sections.length > 5)
                    //     Padding(
                    //       padding: const EdgeInsets.only(top: 6),
                    //       child: Text(
                    //         '+${classData.sections.length - 5} more',
                    //         style: TextStyle(
                    //           fontSize: 11,
                    //           color: AppColors.secondaryColor.withOpacity(0.8),
                    //           fontStyle: FontStyle.italic,
                    //         ),
                    //       ),
                    //     ),
                    // ],
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

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          HugeIcon(icon: icon, size: 20, color: AppColors.secondaryColor),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.secondaryColor.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
