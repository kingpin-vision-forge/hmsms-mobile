class ParentDetailResponseModel {
  final bool success;
  final int statusCode;
  final ParentDetailModel data;
  final String timestamp;
  final String path;
  final String requestId;

  ParentDetailResponseModel({
    required this.success,
    required this.statusCode,
    required this.data,
    required this.timestamp,
    required this.path,
    required this.requestId,
  });

  factory ParentDetailResponseModel.fromJson(Map<String, dynamic> json) {
    return ParentDetailResponseModel(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      data: ParentDetailModel.fromJson(json['data'] ?? {}),
      timestamp: json['timestamp'] ?? '',
      path: json['path'] ?? '',
      requestId: json['requestId'] ?? '',
    );
  }
}

class ParentDetailModel {
  final String id;
  final String userId;
  final String phone;
  final String address;
  final String? whatsappNumber;
  final bool whatsappOptIn;
  final bool isDeleted;
  final String? deletedAt;
  final ParentUserModel user;
  final List<StudentDetailModel> students;

  ParentDetailModel({
    required this.id,
    required this.userId,
    required this.phone,
    required this.address,
    required this.whatsappNumber,
    required this.whatsappOptIn,
    required this.isDeleted,
    required this.deletedAt,
    required this.user,
    required this.students,
  });

  factory ParentDetailModel.fromJson(Map<String, dynamic> json) {
    return ParentDetailModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      whatsappNumber: json['whatsappNumber'],
      whatsappOptIn: json['whatsappOptIn'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      deletedAt: json['deletedAt'],
      user: ParentUserModel.fromJson(json['user'] ?? {}),
      students: (json['students'] as List<dynamic>? ?? [])
          .map((e) => StudentDetailModel.fromJson(e))
          .toList(),
    );
  }
}

class ParentUserModel {
  final String id;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String email;
  final String phone;
  final String? address;
  final String role;

  ParentUserModel({
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.role,
  });

  factory ParentUserModel.fromJson(Map<String, dynamic> json) {
    return ParentUserModel(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      middleName: json['middleName'],
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'],
      role: json['role'] ?? '',
    );
  }
}

class StudentDetailModel {
  final String id;
  final String userId;
  final String admissionNumber;
  final String classId;
  final String sectionId;
  final String dateOfBirth;
  final String gender;
  final bool isDeleted;
  final String? deletedAt;
  final String parentId;
  final StudentUserModel user;

  StudentDetailModel({
    required this.id,
    required this.userId,
    required this.admissionNumber,
    required this.classId,
    required this.sectionId,
    required this.dateOfBirth,
    required this.gender,
    required this.isDeleted,
    required this.deletedAt,
    required this.parentId,
    required this.user,
  });

  factory StudentDetailModel.fromJson(Map<String, dynamic> json) {
    return StudentDetailModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      admissionNumber: json['admissionNumber'] ?? '',
      classId: json['classId'] ?? '',
      sectionId: json['sectionId'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      gender: json['gender'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      deletedAt: json['deletedAt'],
      parentId: json['parentId'] ?? '',
      user: StudentUserModel.fromJson(json['user'] ?? {}),
    );
  }
}

class StudentUserModel {
  final String id;
  final String firstName;
  final String? middleName;
  final String lastName;

  StudentUserModel({
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
  });

  factory StudentUserModel.fromJson(Map<String, dynamic> json) {
    return StudentUserModel(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      middleName: json['middleName'],
      lastName: json['lastName'] ?? '',
    );
  }
}
