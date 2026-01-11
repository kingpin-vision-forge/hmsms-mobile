import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/widget/custom_drawer.dart';
import 'package:student_management/app/helpers/widget/global_fab.dart';
import 'package:student_management/app/modules/timetable/controllers/timetable_controller.dart';
import 'package:student_management/app/modules/timetable/models/timetable_response.dart';
import 'package:student_management/app/routes/app_pages.dart';

class TimetableView extends GetView<TimetableController> {
  const TimetableView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      drawer: CustomDrawerMenu(),
      floatingActionButton: GlobalFAB(),
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
              mainAxisAlignment: MainAxisAlignment.start,
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
                      'Timetable',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 50.ms, duration: 300.ms)
                    .slideY(begin: 0.05, end: 0),
              ],
            ),
            foregroundColor: AppColors.secondaryColor,
            automaticallyImplyLeading: false,
          ),
        ),
      ),
      body: Column(
        children: [
          // Day selector tabs
          _buildDaySelector(),
          // Timetable list
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.callBtn),
                );
              }

              final slots = controller.slotsForSelectedDay;

              if (slots.isEmpty) {
                return _buildEmptyState();
              }

              return RefreshIndicator(
                onRefresh: controller.refresh,
                color: AppColors.callBtn,
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                  itemCount: slots.length,
                  itemBuilder: (context, index) =>
                      _buildSlotCard(slots[index], index),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySelector() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            TimetableController.dayLabels.length,
            (index) => _buildDayTab(index),
          ),
        ),
      ),
    );
  }

  Widget _buildDayTab(int index) {
    final isSelected = controller.selectedDayIndex.value == index;
    return GestureDetector(
      onTap: () => controller.selectDay(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.callBtn : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          TimetableController.dayLabels[index],
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? AppColors.secondaryColor : AppColors.gray500,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HugeIcon(
                icon: HugeIcons.strokeRoundedCalendar03,
                size: 80,
                color: AppColors.gray500,
              )
              .animate()
              .fadeIn(delay: 50.ms, duration: 300.ms)
              .slideY(begin: 0.05, end: 0),
          const SizedBox(height: 16),
          Text(
                'No classes scheduled',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.gray500,
                  fontWeight: FontWeight.w500,
                ),
              )
              .animate()
              .fadeIn(delay: 100.ms, duration: 300.ms)
              .slideY(begin: 0.05, end: 0),
          const SizedBox(height: 8),
          Text(
                'Enjoy your free day!',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.gray500.withOpacity(0.7),
                ),
              )
              .animate()
              .fadeIn(delay: 150.ms, duration: 300.ms)
              .slideY(begin: 0.05, end: 0),
        ],
      ),
    );
  }

  Widget _buildSlotCard(TimetableSlot slot, int index) {
    return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.secondaryColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.grayBorder),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.05),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                // Period number indicator
                Container(
                  width: 50,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: AppColors.callBtn.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${slot.periodNumber}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.callBtn,
                        ),
                      ),
                      const Text(
                        'Period',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.gray500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Subject name
                        Text(
                          slot.subject?.name ?? 'Unknown Subject',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Time
                        Row(
                          children: [
                            HugeIcon(
                              icon: HugeIcons.strokeRoundedClock01,
                              size: 14,
                              color: AppColors.gray500,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              slot.timeRange,
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.gray500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Teacher
                        if (slot.teacher != null)
                          Row(
                            children: [
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedUser,
                                size: 14,
                                color: AppColors.gray500,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  slot.teacher!.fullName,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.gray500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                // Class/Section on the right
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: AppColors.callBtn.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        slot.classInfo?.name ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.callBtn,
                        ),
                      ),
                      if (slot.section != null)
                        Text(
                          slot.section!.name,
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.gray500,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(delay: (25 * index).ms, duration: 200.ms)
        .slideX(begin: 0.05, end: 0);
  }
}
