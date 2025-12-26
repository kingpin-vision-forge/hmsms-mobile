class SubjectDetailResponseModel {
  final bool success;
  final int statusCode;
  final SubjectDetailModel data;
  final String timestamp;
  final String path;
  final String requestId;

  SubjectDetailResponseModel({
    required this.success,
    required this.statusCode,
    required this.data,
    required this.timestamp,
    required this.path,
    required this.requestId,
  });

  factory SubjectDetailResponseModel.fromJson(Map<String, dynamic> json) {
    return SubjectDetailResponseModel(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      data: SubjectDetailModel.fromJson(json['data'] ?? {}),
      timestamp: json['timestamp'] ?? '',
      path: json['path'] ?? '',
      requestId: json['requestId'] ?? '',
    );
  }
}
class SubjectDetailModel {
  final String id;
  final String name;
  final String code;
  final String classId;
  final bool isDeleted;
  final String? deletedAt;
  final SubjectClassModel classInfo;

  SubjectDetailModel({
    required this.id,
    required this.name,
    required this.code,
    required this.classId,
    required this.isDeleted,
    required this.deletedAt,
    required this.classInfo,
  });

  factory SubjectDetailModel.fromJson(Map<String, dynamic> json) {
    return SubjectDetailModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      classId: json['classId'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      deletedAt: json['deletedAt'],
      classInfo: SubjectClassModel.fromJson(json['class'] ?? {}),
    );
  }
}
class SubjectClassModel {
  final String id;
  final String name;
  final String code;
  final String schoolId;
  final bool isDeleted;
  final String? deletedAt;

  SubjectClassModel({
    required this.id,
    required this.name,
    required this.code,
    required this.schoolId,
    required this.isDeleted,
    required this.deletedAt,
  });

  factory SubjectClassModel.fromJson(Map<String, dynamic> json) {
    return SubjectClassModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      schoolId: json['schoolId'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      deletedAt: json['deletedAt'],
    );
  }
}
