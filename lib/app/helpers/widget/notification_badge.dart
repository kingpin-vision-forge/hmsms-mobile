import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/routes/app_pages.dart';

class NotificationBadge extends StatelessWidget {
  const NotificationBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.NOTIFICATIONS);
      },
      child: badges.Badge(
        showBadge: true,
        position: badges.BadgePosition.topEnd(top: -4.0, end: 1.0),
        badgeAnimation: const badges.BadgeAnimation.slide(),
        badgeStyle: const badges.BadgeStyle(badgeColor: AppColors.red800),
        badgeContent: Text(
          '5',
          style: const TextStyle(color: Colors.white, fontSize: 10),
        ),
        child: HugeIcon(
          icon: HugeIcons.strokeRoundedNotification01,
          color: AppColors.secondaryColor,
          size: 30,
        ),
      ),
    );
  }
}
