/// Notification types
enum NotificationType {
  FEE_REMINDER,
  ABSENCE_ALERT,
  HOLIDAY,
  EXAM,
  EVENT,
  GENERAL,
}

/// Main notification response with pagination
class NotificationResponse {
  final bool success;
  final List<NotificationData> data;
  final PaginationMeta meta;

  NotificationResponse({
    required this.success,
    required this.data,
    required this.meta,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => NotificationData.fromJson(item))
              .toList() ??
          [],
      meta: PaginationMeta.fromJson(json['meta'] ?? {}),
    );
  }
}

/// Pagination metadata
class PaginationMeta {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  PaginationMeta({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 20,
      totalPages: json['totalPages'] ?? 1,
    );
  }
}

/// Individual notification item
class NotificationData {
  final String id;
  final String type;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;
  final StudentInfo? student;

  NotificationData({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
    this.student,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      id: json['id'] ?? '',
      type: json['type'] ?? 'GENERAL',
      title: json['title'] ?? '',
      body: json['body'] ?? json['message'] ?? '',
      isRead: json['isRead'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      student:
          json['student'] != null ? StudentInfo.fromJson(json['student']) : null,
    );
  }

  bool get isPersonalNotification =>
      type == 'FEE_REMINDER' || type == 'ABSENCE_ALERT';

  bool get isAnnouncement =>
      type == 'HOLIDAY' || type == 'EXAM' || type == 'EVENT' || type == 'GENERAL';
}

/// Student info nested in notification
class StudentInfo {
  final String? id;
  final String? firstName;
  final String? lastName;

  StudentInfo({this.id, this.firstName, this.lastName});

  factory StudentInfo.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;
    return StudentInfo(
      id: user?['id'] ?? json['id'],
      firstName: user?['firstName'] ?? json['firstName'],
      lastName: user?['lastName'] ?? json['lastName'],
    );
  }

  String get fullName {
    return [firstName, lastName]
        .where((n) => n != null && n.isNotEmpty)
        .join(' ');
  }
}

/// Announcement response
class AnnouncementResponse {
  final bool success;
  final List<NotificationData> data;
  final PaginationMeta meta;

  AnnouncementResponse({
    required this.success,
    required this.data,
    required this.meta,
  });

  factory AnnouncementResponse.fromJson(Map<String, dynamic> json) {
    return AnnouncementResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => NotificationData.fromJson(item))
              .toList() ??
          [],
      meta: PaginationMeta.fromJson(json['meta'] ?? {}),
    );
  }
}

/// Unread count response
class UnreadCountResponse {
  final bool success;
  final int count;

  UnreadCountResponse({required this.success, required this.count});

  factory UnreadCountResponse.fromJson(Map<String, dynamic> json) {
    return UnreadCountResponse(
      success: json['success'] ?? false,
      count: json['data']?['count'] ?? json['count'] ?? 0,
    );
  }
}
