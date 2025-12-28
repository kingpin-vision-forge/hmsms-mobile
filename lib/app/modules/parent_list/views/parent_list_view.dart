import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/modules/parent_list/models/parent_response.dart';
import 'package:student_management/app/routes/app_pages.dart';

import '../controllers/parent_list_controller.dart';

class ParentListView extends GetView<ParentListController> {
  const ParentListView({super.key});
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
                                    onPressed: () {
                                      Get.offAllNamed(Routes.HOME);
                                    },
                                  ),
                                  Text(
                                        'Parents',
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
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.callBtn),
            );
          }

          if (controller.filteredParentList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                        controller.searchQuery.value.isEmpty
                            ? 'No parents available'
                            : 'No parents found for your search',
                        style: const TextStyle(fontSize: 20),
                      )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 800.ms)
                      .slideY(begin: 0.1, end: 0),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.filteredParentList.length,
            itemBuilder: (context, index) {
              final parentData = controller.filteredParentList[index];
              if (index == 0) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${controller.filteredParentList.length} Items',
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
                            // TODO: Implement export functionality
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildParentCard(parentData, index),
                  ],
                );
              }
              return _buildParentCard(parentData, index);
            },
          );
        }),
      ),
    );
  }

  Widget _buildParentCard(ParentModel parentData, int index) {
    final nameParts = [
      parentData.user.firstName.trim(),
      if ((parentData.user.middleName ?? '').trim().isNotEmpty)
        parentData.user.middleName!.trim(),
      parentData.user.lastName.trim(),
    ].where((part) => part.isNotEmpty).toList();

    final fullName = nameParts.join(' ');
    final primaryPhone =
        (parentData.phone.isNotEmpty ? parentData.phone : parentData.user.phone)
            .trim();
    final whatsappNumber = (parentData.whatsappNumber ?? '').trim();
    final address = parentData.address.trim();
    final studentNames = parentData.students
        .map(
          (s) => [
            s.user.firstName.trim(),
            s.user.lastName.trim(),
          ].where((part) => part.isNotEmpty).join(' '),
        )
        .where((name) => name.isNotEmpty)
        .toList();

    final studentsLabel = parentData.students.length == 1
        ? '1 student'
        : '${parentData.students.length} students';

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
                Get.offAllNamed(
                  Routes.PARENT_DETAIL,
                  arguments: {'parent_id': parentData.id},
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                    'Parent ',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.secondaryColor
                                          .withOpacity(0.8),
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      fullName.isNotEmpty
                                          ? fullName
                                          : 'Unnamed',
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.secondaryColor,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  if (primaryPhone.isNotEmpty)
                                    _buildTag(
                                      icon: Icons.phone_outlined,
                                      label: primaryPhone,
                                    ),
                                  if (parentData.user.email.isNotEmpty)
                                    _buildTag(
                                      icon: Icons.mail_outline,
                                      label: parentData.user.email,
                                    ),
                                  if (whatsappNumber.isNotEmpty)
                                    _buildTag(
                                      icon: Icons.messenger_outline,
                                      label: whatsappNumber,
                                    ),
                                  if (parentData.whatsappOptIn)
                                    _buildTag(
                                      icon: Icons.check_circle_outline,
                                      label: 'WhatsApp opt-in',
                                    ),
                                ],
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
                            icon: HugeIcons.strokeRoundedUserMultiple,
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

                    // Info rows
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoItem(
                            icon: HugeIcons.strokeRoundedUserMultiple,
                            label: 'Students',
                            value: studentsLabel,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildInfoItem(
                            icon: HugeIcons.strokeRoundedLocation04,
                            label: 'Address',
                            value: address.isNotEmpty
                                ? address
                                : 'Not provided',
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
        .fadeIn(delay: (100 * index).ms, duration: 600.ms)
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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.secondaryColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.secondaryColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
