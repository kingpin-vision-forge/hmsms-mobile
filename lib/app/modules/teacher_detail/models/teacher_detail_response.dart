class TeacherDetailResponse {
  final bool success;
  final int statusCode;
  final TeacherData data;
  final String timestamp;
  final String path;
  final String requestId;

  TeacherDetailResponse({
    required this.success,
    required this.statusCode,
    required this.data,
    required this.timestamp,
    required this.path,
    required this.requestId,
  });

  factory TeacherDetailResponse.fromJson(Map<String, dynamic> json) {
    return TeacherDetailResponse(
      success: json['success'],
      statusCode: json['statusCode'],
      data: TeacherData.fromJson(json['data']),
      timestamp: json['timestamp'],
      path: json['path'],
      requestId: json['requestId'],
    );
  }
}
class TeacherData {
  final String id;
  final String userId;
  final String employeeCode;
  final DateTime joinedDate;
  final bool isDeleted;
  final DateTime? deletedAt;
  final TeacherUser user;

  TeacherData({
    required this.id,
    required this.userId,
    required this.employeeCode,
    required this.joinedDate,
    required this.isDeleted,
    this.deletedAt,
    required this.user,
  });

  factory TeacherData.fromJson(Map<String, dynamic> json) {
    return TeacherData(
      id: json['id'],
      userId: json['userId'],
      employeeCode: json['employeeCode'],
      joinedDate: DateTime.parse(json['joinedDate']),
      isDeleted: json['isDeleted'],
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'])
          : null,
      user: TeacherUser.fromJson(json['user']),
    );
  }
}
class TeacherUser {
  final String id;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String email;
  final String? phone;
  final String? address;
  final String role;

  TeacherUser({
    required this.id,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.email,
    this.phone,
    this.address,
    required this.role,
  });

  factory TeacherUser.fromJson(Map<String, dynamic> json) {
    return TeacherUser(
      id: json['id'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      role: json['role'],
    );
  }
}
