import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:chopper/chopper.dart' as c;
import 'package:student_management/app/data/apis.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/global.dart';
import 'package:student_management/app/helpers/rbac/roles.dart';
import 'package:student_management/app/helpers/utilities/network_util.dart';
import 'package:student_management/app/modules/notifications/models/notification_response.dart';

class NotificationsController extends GetxController {
  final ApiService _apiService = ApiService.create();
  final GetStorage _storage = GetStorage();

  // Tab controller
  var selectedTabIndex = 0.obs;

  // Personal Notifications state
  var isLoadingNotifications = false.obs;
  var isLoadingMoreNotifications = false.obs;
  var notifications = <NotificationData>[].obs;
  var unreadCount = 0.obs;
  var hasMoreNotifications = true.obs;
  int _notificationPage = 1;

  // Announcements state
  var isLoadingAnnouncements = false.obs;
  var isLoadingMoreAnnouncements = false.obs;
  var announcements = <NotificationData>[].obs;
  var hasNewAnnouncements = false.obs;
  var hasMoreAnnouncements = true.obs;
  int _announcementPage = 1;

  static const int _limit = 20;
  static const String _lastViewedKey = 'lastAnnouncementViewedAt';

  Timer? _unreadCountTimer;

  // Reactive user role
  var currentUserRole = UserRole.STUDENT.obs;
  
  bool get isParent => currentUserRole.value == UserRole.PARENT;

  @override
  void onInit() {
    super.onInit();
    _initializeUserRole();
    fetchAll();
    _startUnreadCountPolling();
  }

  void _initializeUserRole() {
    if (userData != null && userData is Map) {
      final roleStr = (userData['role'] ?? '').toString().toUpperCase();
      currentUserRole.value = UserRole.values.firstWhere(
        (e) => e.name == roleStr,
        orElse: () => UserRole.STUDENT,
      );
    }
  }

  @override
  void onClose() {
    _unreadCountTimer?.cancel();
    super.onClose();
  }

  /// Start polling for unread count every 60 seconds
  void _startUnreadCountPolling() {
    if (isParent) {
      _unreadCountTimer = Timer.periodic(
        const Duration(seconds: 60),
        (_) => fetchUnreadCount(),
      );
    }
  }

  /// Fetch all data
  Future<void> fetchAll({bool refresh = false}) async {
    await Future.wait([
      fetchAnnouncements(refresh: refresh),
      if (isParent) fetchNotifications(refresh: refresh),
      if (isParent) fetchUnreadCount(),
    ]);
  }

  /// Fetch personal notifications (Parent only)
  Future<void> fetchNotifications({bool refresh = false}) async {
    if (!isParent) return;

    if (refresh) {
      _notificationPage = 1;
      hasMoreNotifications.value = true;
    }

    if (_notificationPage == 1) {
      isLoadingNotifications.value = true;
    } else {
      isLoadingMoreNotifications.value = true;
    }

    try {
      c.Response? res = await NetworkUtils.safeApiCall(
        () => _apiService.fetchNotifications(
          page: _notificationPage,
          limit: _limit,
        ),
      );

      if (res == null) return;
      if (res.isSuccessful && res.body != null && res.body['success'] == true) {
        final response = NotificationResponse.fromJson(res.body);

        if (refresh || _notificationPage == 1) {
          notifications.value = response.data;
        } else {
          notifications.addAll(response.data);
        }

        if (response.data.length < _limit ||
            _notificationPage >= response.meta.totalPages) {
          hasMoreNotifications.value = false;
        } else {
          _notificationPage++;
        }
      }
    } catch (e) {
      errorUtil.handleAppError(
        apiName: 'fetchNotifications',
        error: e,
        displayMessage: 'Failed to load notifications',
      );
    } finally {
      isLoadingNotifications.value = false;
      isLoadingMoreNotifications.value = false;
    }
  }

  /// Fetch announcements (All users)
  Future<void> fetchAnnouncements({bool refresh = false}) async {
    // Skip if schoolId is not set yet
    if (schoolId.isEmpty) {
      return;
    }
    
    if (refresh) {
      _announcementPage = 1;
      hasMoreAnnouncements.value = true;
    }

    if (_announcementPage == 1) {
      isLoadingAnnouncements.value = true;
    } else {
      isLoadingMoreAnnouncements.value = true;
    }

    try {
      c.Response? res = await NetworkUtils.safeApiCall(
        () => _apiService.fetchAnnouncements(
          schoolId: schoolId,
          page: _announcementPage,
          limit: _limit,
        ),
      );

      if (res == null) {
        return;
      }
      
      if (res.isSuccessful && res.body != null && res.body['success'] == true) {
        final response = AnnouncementResponse.fromJson(res.body);

        if (refresh || _announcementPage == 1) {
          announcements.value = response.data;
        } else {
          announcements.addAll(response.data);
        }

        if (response.data.length < _limit ||
            _announcementPage >= response.meta.totalPages) {
          hasMoreAnnouncements.value = false;
        } else {
          _announcementPage++;
        }

        // Check for new announcements
        _checkNewAnnouncements();
      } else {
        // Only show error toast if there was an actual error response
        if (res.body != null && res.body['message'] != null) {
          botToastError(res.body['message'].toString());
        }
      }
    } catch (e, stackTrace) {
      // Only show error toast for actual exceptions, not for empty data
      if (announcements.isEmpty) {
        errorUtil.handleAppError(
          apiName: 'fetchAnnouncements',
          error: e,
          displayMessage: 'Failed to load announcements',
        );
      }
    } finally {
      isLoadingAnnouncements.value = false;
      isLoadingMoreAnnouncements.value = false;
    }
  }

  /// Fetch unread count (Parent only)
  Future<void> fetchUnreadCount() async {
    if (!isParent) return;

    try {
      c.Response? res = await NetworkUtils.safeApiCall(
        () => _apiService.getUnreadCount(),
      );

      if (res == null) return;
      if (res.isSuccessful && res.body != null && res.body['success'] == true) {
        final response = UnreadCountResponse.fromJson(res.body);
        unreadCount.value = response.count;
      }
    } catch (e) {
      // Silently fail for unread count
    }
  }

  /// Check if there are new announcements since last view
  void _checkNewAnnouncements() {
    final lastViewedStr = _storage.read<String>(_lastViewedKey);
    if (lastViewedStr == null) {
      hasNewAnnouncements.value = announcements.isNotEmpty;
      return;
    }

    try {
      final lastViewed = DateTime.parse(lastViewedStr);
      hasNewAnnouncements.value = announcements.any(
        (a) => a.createdAt.isAfter(lastViewed),
      );
    } catch (e) {
      hasNewAnnouncements.value = announcements.isNotEmpty;
    }
  }

  /// Mark announcements as viewed (updates local timestamp)
  void markAnnouncementsViewed() {
    _storage.write(_lastViewedKey, DateTime.now().toIso8601String());
    hasNewAnnouncements.value = false;
  }

  /// Mark single notification as read (Parent only)
  Future<void> markAsRead(String notificationId) async {
    if (!isParent) return;

    try {
      c.Response? res = await NetworkUtils.safeApiCall(
        () => _apiService.markNotificationAsRead(notificationId),
      );

      if (res == null) return;
      if (res.isSuccessful && res.body != null && res.body['success'] == true) {
        // Update local state
        final index = notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          final notification = notifications[index];
          notifications[index] = NotificationData(
            id: notification.id,
            type: notification.type,
            title: notification.title,
            body: notification.body,
            isRead: true,
            createdAt: notification.createdAt,
            student: notification.student,
          );
        }
        if (unreadCount.value > 0) {
          unreadCount.value--;
        }
      }
    } catch (e) {
      errorUtil.handleAppError(
        apiName: 'markAsRead',
        error: e,
        displayMessage: 'Failed to mark notification as read',
      );
    }
  }

  /// Mark all notifications as read (Parent only)
  Future<void> markAllAsRead() async {
    if (!isParent) return;

    try {
      c.Response? res = await NetworkUtils.safeApiCall(
        () => _apiService.markAllNotificationsAsRead(),
      );

      if (res == null) return;
      if (res.isSuccessful && res.body != null && res.body['success'] == true) {
        // Update local state - mark all as read
        notifications.value = notifications
            .map((n) => NotificationData(
                  id: n.id,
                  type: n.type,
                  title: n.title,
                  body: n.body,
                  isRead: true,
                  createdAt: n.createdAt,
                  student: n.student,
                ))
            .toList();
        unreadCount.value = 0;
        botToastSuccess('All notifications marked as read');
      }
    } catch (e) {
      errorUtil.handleAppError(
        apiName: 'markAllAsRead',
        error: e,
        displayMessage: 'Failed to mark all as read',
      );
    }
  }

  /// Load more notifications
  void loadMoreNotifications() {
    if (!isLoadingMoreNotifications.value && hasMoreNotifications.value) {
      fetchNotifications();
    }
  }

  /// Load more announcements
  void loadMoreAnnouncements() {
    if (!isLoadingMoreAnnouncements.value && hasMoreAnnouncements.value) {
      fetchAnnouncements();
    }
  }

  /// Refresh all data
  Future<void> refresh() async {
    await fetchAll(refresh: true);
  }

  /// Change tab
  void changeTab(int index) {
    selectedTabIndex.value = index;
    if (index == 1) {
      // Announcements tab
      markAnnouncementsViewed();
    }
  }

  /// Total badge count (unread notifications + new announcements indicator)
  int get totalBadgeCount {
    int count = 0;
    if (isParent) count += unreadCount.value;
    if (hasNewAnnouncements.value) count += 1; // Just indicator
    return count;
  }
}
