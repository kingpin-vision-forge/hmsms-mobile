class SubjectListResponseModel {
  final bool success;
  final int statusCode;
  final List<SubjectModel> data;
  final String timestamp;
  final String path;
  final String requestId;

  SubjectListResponseModel({
    required this.success,
    required this.statusCode,
    required this.data,
    required this.timestamp,
    required this.path,
    required this.requestId,
  });

  factory SubjectListResponseModel.fromJson(Map<String, dynamic> json) {
    return SubjectListResponseModel(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => SubjectModel.fromJson(e))
          .toList(),
      timestamp: json['timestamp'] ?? '',
      path: json['path'] ?? '',
      requestId: json['requestId'] ?? '',
    );
  }
}
class SubjectModel {
  final String id;
  final String name;
  final String code;
  final String classId;
  final bool isDeleted;
  final String? deletedAt;
  final ClassModel classInfo;

  SubjectModel({
    required this.id,
    required this.name,
    required this.code,
    required this.classId,
    required this.isDeleted,
    required this.deletedAt,
    required this.classInfo,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      classId: json['classId'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      deletedAt: json['deletedAt'],
      classInfo: ClassModel.fromJson(json['class'] ?? {}),
    );
  }
}
class ClassModel {
  final String id;
  final String name;
  final String code;
  final String schoolId;
  final bool isDeleted;
  final String? deletedAt;

  ClassModel({
    required this.id,
    required this.name,
    required this.code,
    required this.schoolId,
    required this.isDeleted,
    required this.deletedAt,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      schoolId: json['schoolId'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      deletedAt: json['deletedAt'],
    );
  }
}
