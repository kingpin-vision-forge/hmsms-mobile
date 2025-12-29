import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/modules/notifications/controllers/notifications_controller.dart';
import 'package:student_management/app/routes/app_pages.dart';

class NotificationBadge extends StatelessWidget {
  const NotificationBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<NotificationsController>(
      init: NotificationsController(),
      builder: (controller) {
        final badgeCount = controller.totalBadgeCount;
        
        return GestureDetector(
          onTap: () {
            Get.toNamed(Routes.NOTIFICATIONS);
          },
          child: badges.Badge(
            showBadge: badgeCount > 0,
            position: badges.BadgePosition.topEnd(top: -4.0, end: 1.0),
            badgeAnimation: const badges.BadgeAnimation.slide(),
            badgeStyle: const badges.BadgeStyle(badgeColor: AppColors.red800),
            badgeContent: Text(
              '$badgeCount',
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedNotification01,
              color: AppColors.secondaryColor,
              size: 30,
            ),
          ),
        );
      },
    );
  }
}
