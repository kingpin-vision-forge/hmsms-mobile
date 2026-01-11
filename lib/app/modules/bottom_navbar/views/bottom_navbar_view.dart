import 'dart:io';

import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/modules/home/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:student_management/app/modules/menu/views/menu_view.dart';
import 'package:student_management/app/modules/students/views/students_view.dart';
import 'package:student_management/app/modules/teacher_list/views/teacher_list_view.dart';
import '../controllers/bottom_navbar_controller.dart';

class BottomNavbarView extends StatelessWidget {
  final PageController pageController; // Declare without initialization
  BottomNavbarView({super.key}) : pageController = PageController();
  @override
  Widget build(BuildContext context) {
    final BottomNavbarController controller = Get.put(BottomNavbarController());
    final initialIndex = int.tryParse(Get.parameters['index'] ?? '0') ?? 0;
    // Set the initial index if it's different from the current one
    if (controller.selectedIndex.value != initialIndex) {
      controller.setInitialIndex(initialIndex);
    }
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        showCustomDialog(context);
      },
      child: Obx(() {
        return Scaffold(
          body: IndexedStack(
            index: controller.selectedIndex.value,
            children: [
              HomeView(),
              Obx(
                () => controller.selectedIndex.value == 1
                    ? StudentsView()
                    : const SizedBox.shrink(),
              ),
              Obx(
                () => controller.selectedIndex.value == 2
                    ? TeacherListView()
                    : const SizedBox.shrink(),
              ),
              MenuView(),
            ],
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.secondaryColor,
                border: Border(
                  top: BorderSide(
                    color: Colors.grey, // Border color
                    width: 1, // Border thickness
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildNavItem(
                    controller,
                    index: 0,
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedMenu02,
                      color: AppColors.black,
                    ),
                    label: 'Dashboard',
                  ),
                  buildNavItem(
                    controller,
                    index: 1,
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedStudent,
                      color: AppColors.black,
                    ),
                    label: 'Students',
                  ),
                  buildNavItem(
                    controller,
                    index: 2,
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedTeaching,
                      color: AppColors.black,
                    ),
                    label: 'Teachers',
                  ),

                  buildNavItem(
                    controller,
                    index: 4,
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedSettings01,
                      color: AppColors.black,
                    ),
                    label: 'Menu',
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget buildNavItem(
    BottomNavbarController controller, {
    required int index,
    required Widget icon,
    required String label,
  }) {
    final bool isSelected = controller.selectedIndex.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.onItemTapped(index),
        child: Container(
          padding: EdgeInsets.only(bottom: Platform.isIOS ? 25 : 15, top: 10),
          decoration: BoxDecoration(color: Colors.transparent),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(child: icon),
              // const SizedBox(height: 4),
              // Flexible(
              //   child: Text(
              //     label,
              //     overflow: TextOverflow.ellipsis,
              //     style: TextStyle(
              //       fontSize: isSelected ? Constants.radiusLg : Constants.radiusXmd,
              //       color: isSelected
              //           ? AppColors.redColorDonut
              //           : AppColors.grayColor,
              //       fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void showCustomDialog(context) {
    Get.dialog(
      barrierDismissible: false,
      PopScope(
        onPopInvokedWithResult: (didPop, result) {
          if (result == true) {
            SystemNavigator.pop(); // Exit the app
          }
        },
        child: AlertDialog(
          insetPadding: const EdgeInsets.symmetric(
            vertical: 24,
            horizontal: 20,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Constants.radiusLg),
          ),
          backgroundColor: AppColors.secondaryColor,
          title: const Text('Exit', style: TextStyle(color: AppColors.gray800)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                textScaler: MediaQuery.textScalerOf(context).clamp(
                  minScaleFactor: Constants.CONFIG['TEXT_MIN_SCALE_FACTOR']!,
                  maxScaleFactor: Constants.CONFIG['TEXT_MAX_SCALE_FACTOR']!,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Inter',
                    color: AppColors.normalTextColor,
                  ),
                  children: [TextSpan(text: 'Are you sure you want to exit?')],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Close the dialog
                        Navigator.pop(context, false);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        side: const BorderSide(
                          color: AppColors.normalTextColor,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            Constants.radiusSm,
                          ),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.normalTextColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: AppColors.redColorDonut,
                          ),
                          borderRadius: BorderRadius.circular(
                            Constants.radiusSm,
                          ),
                        ),
                        backgroundColor: AppColors.redColorDonut,
                      ),
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: const Text(
                        'Exit',
                        style: TextStyle(
                          color: AppColors.secondaryColor,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
