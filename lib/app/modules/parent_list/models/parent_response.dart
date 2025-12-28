class ParentResponseModel {
  final bool success;
  final int statusCode;
  final List<ParentModel> data;
  final String timestamp;
  final String path;
  final String requestId;

  ParentResponseModel({
    required this.success,
    required this.statusCode,
    required this.data,
    required this.timestamp,
    required this.path,
    required this.requestId,
  });

  factory ParentResponseModel.fromJson(Map<String, dynamic> json) {
    return ParentResponseModel(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => ParentModel.fromJson(e))
          .toList(),
      timestamp: json['timestamp'] ?? '',
      path: json['path'] ?? '',
      requestId: json['requestId'] ?? '',
    );
  }
}

class ParentModel {
  final String id;
  final String userId;
  final String phone;
  final String address;
  final String? whatsappNumber;
  final bool whatsappOptIn;
  final bool isDeleted;
  final String? deletedAt;
  final ParentUser user;
  final List<StudentModel> students;

  ParentModel({
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

  factory ParentModel.fromJson(Map<String, dynamic> json) {
    return ParentModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      whatsappNumber: json['whatsappNumber'],
      whatsappOptIn: json['whatsappOptIn'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      deletedAt: json['deletedAt'],
      user: ParentUser.fromJson(json['user'] ?? {}),
      students: (json['students'] as List<dynamic>? ?? [])
          .map((e) => StudentModel.fromJson(e))
          .toList(),
    );
  }
}

class ParentUser {
  final String id;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String email;
  final String phone;
  final String? address;
  final String role;

  ParentUser({
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.role,
  });

  factory ParentUser.fromJson(Map<String, dynamic> json) {
    return ParentUser(
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

class StudentModel {
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
  final StudentUser user;

  StudentModel({
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

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
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
      user: StudentUser.fromJson(json['user'] ?? {}),
    );
  }
}

class StudentUser {
  final String id;
  final String firstName;
  final String? middleName;
  final String lastName;

  StudentUser({
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
  });

  factory StudentUser.fromJson(Map<String, dynamic> json) {
    return StudentUser(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      middleName: json['middleName'],
      lastName: json['lastName'] ?? '',
    );
  }
}
