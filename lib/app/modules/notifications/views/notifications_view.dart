import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/modules/notifications/controllers/notifications_controller.dart';
import 'package:student_management/app/modules/notifications/models/notification_response.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
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
          child: SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
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
                            'Notifications',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.secondaryColor,
                            ),
                          )
                              .animate()
                              .fadeIn(delay: 50.ms, duration: 300.ms)
                              .slideY(begin: 0.05, end: 0),
                        ],
                      ),
                      // Mark all as read - only for parents on notifications tab
                      Obx(() {
                        if (controller.isParent &&
                            controller.selectedTabIndex.value == 0 &&
                            controller.notifications.isNotEmpty) {
                          return IconButton(
                            icon: const HugeIcon(
                              icon: HugeIcons.strokeRoundedCheckmarkCircle02,
                              size: 28,
                              color: AppColors.secondaryColor,
                            ),
                            onPressed: () => controller.markAllAsRead(),
                            tooltip: 'Mark all as read',
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                    ],
                  ),
                ),
                // Tab Bar
                _buildTabBar(),
              ],
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.selectedTabIndex.value == 0) {
          return _buildNotificationsTab();
        } else {
          return _buildAnnouncementsTab();
        }
      }),
    );
  }

  Widget _buildTabBar() {
    return Obx(() => Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.secondaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              // Notifications Tab
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.changeTab(0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: controller.selectedTabIndex.value == 0
                          ? AppColors.secondaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Notifications',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: controller.selectedTabIndex.value == 0
                                ? AppColors.callBtn
                                : AppColors.secondaryColor,
                          ),
                        ),
                        if (controller.isParent && controller.unreadCount.value > 0)
                          Container(
                            margin: const EdgeInsets.only(left: 6),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${controller.unreadCount.value}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              // Announcements Tab
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.changeTab(1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: controller.selectedTabIndex.value == 1
                          ? AppColors.secondaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Announcements',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: controller.selectedTabIndex.value == 1
                                ? AppColors.callBtn
                                : AppColors.secondaryColor,
                          ),
                        ),
                        if (controller.hasNewAnnouncements.value)
                          Container(
                            margin: const EdgeInsets.only(left: 6),
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildNotificationsTab() {
    return Obx(() {
      if (!controller.isParent) {
        return _buildNoAccessState();
      }

      if (controller.isLoadingNotifications.value) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.callBtn),
        );
      }

      if (controller.notifications.isEmpty) {
        return _buildEmptyState('No notifications yet');
      }

      return RefreshIndicator(
        onRefresh: controller.refresh,
        color: AppColors.callBtn,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.notifications.length +
              (controller.hasMoreNotifications.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == controller.notifications.length) {
              controller.loadMoreNotifications();
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.callBtn),
                ),
              );
            }
            return _buildNotificationCard(
              controller.notifications[index],
              index,
              isPersonal: true,
            );
          },
        ),
      );
    });
  }

  Widget _buildAnnouncementsTab() {
    return Obx(() {
      if (controller.isLoadingAnnouncements.value) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.callBtn),
        );
      }

      if (controller.announcements.isEmpty) {
        return _buildEmptyState('No announcements yet');
      }

      return RefreshIndicator(
        onRefresh: controller.refresh,
        color: AppColors.callBtn,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.announcements.length +
              (controller.hasMoreAnnouncements.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == controller.announcements.length) {
              controller.loadMoreAnnouncements();
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.callBtn),
                ),
              );
            }
            return _buildNotificationCard(
              controller.announcements[index],
              index,
              isPersonal: false,
            );
          },
        ),
      );
    });
  }

  Widget _buildNoAccessState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HugeIcon(
            icon: HugeIcons.strokeRoundedNotification03,
            size: 80,
            color: AppColors.gray500,
          ),
          const SizedBox(height: 16),
          Text(
            'Personal notifications are for parents only',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.gray500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Check the Announcements tab for school updates',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.gray500.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HugeIcon(
            icon: HugeIcons.strokeRoundedNotification03,
            size: 100,
            color: AppColors.gray500,
          )
              .animate()
              .fadeIn(delay: 50.ms, duration: 300.ms)
              .slideY(begin: 0.05, end: 0),
          const SizedBox(height: 20),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: AppColors.gray500,
              fontWeight: FontWeight.w500,
            ),
          )
              .animate()
              .fadeIn(delay: 100.ms, duration: 300.ms)
              .slideY(begin: 0.05, end: 0),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(
    NotificationData notification,
    int index, {
    required bool isPersonal,
  }) {
    final isUnread = isPersonal && !notification.isRead;

    return GestureDetector(
      onTap: () {
        if (isPersonal && isUnread) {
          controller.markAsRead(notification.id);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isUnread
              ? AppColors.callBtn.withOpacity(0.1)
              : AppColors.secondaryColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUnread
                ? AppColors.callBtn.withOpacity(0.3)
                : AppColors.grayBorder,
            width: isUnread ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.05),
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _getTypeColor(notification.type).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: HugeIcon(
                  icon: _getNotificationIcon(notification.type),
                  size: 24,
                  color: _getTypeColor(notification.type),
                ),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Type badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color:
                                _getTypeColor(notification.type).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _getTypeLabel(notification.type),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: _getTypeColor(notification.type),
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (isUnread)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.callBtn,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      notification.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: isUnread ? FontWeight.w700 : FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.body,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.gray500,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (notification.student != null) ...[
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedUser,
                            size: 12,
                            color: AppColors.gray500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            notification.student!.fullName,
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.gray500,
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        Text(
                          _formatDate(notification.createdAt),
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.gray500.withOpacity(0.7),
                          ),
                        ),
                      ],
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
          .slideX(begin: 0.05, end: 0),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type.toUpperCase()) {
      case 'FEE_REMINDER':
        return HugeIcons.strokeRoundedMoney01;
      case 'ABSENCE_ALERT':
        return HugeIcons.strokeRoundedAlert02;
      case 'HOLIDAY':
        return HugeIcons.strokeRoundedCalendar03;
      case 'EXAM':
        return HugeIcons.strokeRoundedBook02;
      case 'EVENT':
        return HugeIcons.strokeRoundedCalendarCheckIn01;
      case 'GENERAL':
        return HugeIcons.strokeRoundedMegaphone01;
      default:
        return HugeIcons.strokeRoundedNotification03;
    }
  }

  Color _getTypeColor(String type) {
    switch (type.toUpperCase()) {
      case 'FEE_REMINDER':
        return Colors.orange;
      case 'ABSENCE_ALERT':
        return Colors.red;
      case 'HOLIDAY':
        return Colors.green;
      case 'EXAM':
        return Colors.purple;
      case 'EVENT':
        return Colors.blue;
      case 'GENERAL':
        return AppColors.callBtn;
      default:
        return AppColors.gray500;
    }
  }

  String _getTypeLabel(String type) {
    switch (type.toUpperCase()) {
      case 'FEE_REMINDER':
        return 'Fee';
      case 'ABSENCE_ALERT':
        return 'Absence';
      case 'HOLIDAY':
        return 'Holiday';
      case 'EXAM':
        return 'Exam';
      case 'EVENT':
        return 'Event';
      case 'GENERAL':
        return 'General';
      default:
        return type;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }
}
