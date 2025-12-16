class ClassListResponse {
  final bool success;
  final int statusCode;
  final List<ClassData> data;
  final String timestamp;
  final String path;
  final String requestId;

  ClassListResponse({
    required this.success,
    required this.statusCode,
    required this.data,
    required this.timestamp,
    required this.path,
    required this.requestId,
  });

  factory ClassListResponse.fromJson(Map<String, dynamic> json) {
    return ClassListResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => ClassData.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      timestamp: json['timestamp'] ?? '',
      path: json['path'] ?? '',
      requestId: json['requestId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'statusCode': statusCode,
      'data': data.map((item) => item.toJson()).toList(),
      'timestamp': timestamp,
      'path': path,
      'requestId': requestId,
    };
  }
}

class ClassData {
  final String id;
  final String name;
  final String code;
  final String schoolId;
  final School school;
  final List<Section> sections;
  final List<Subject> subjects;

  ClassData({
    required this.id,
    required this.name,
    required this.code,
    required this.schoolId,
    required this.school,
    required this.sections,
    required this.subjects,
  });

  factory ClassData.fromJson(Map<String, dynamic> json) {
    return ClassData(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      schoolId: json['schoolId'] ?? '',
      school: School.fromJson(json['school'] as Map<String, dynamic>? ?? {}),
      sections:
          (json['sections'] as List<dynamic>?)
              ?.map((item) => Section.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      subjects:
          (json['subjects'] as List<dynamic>?)
              ?.map((item) => Subject.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'schoolId': schoolId,
      'school': school.toJson(),
      'sections': sections.map((item) => item.toJson()).toList(),
      'subjects': subjects.map((item) => item.toJson()).toList(),
    };
  }
}

class School {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String email;

  School({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
    };
  }
}

class Section {
  final String id;
  final String name;
  final String classId;

  Section({required this.id, required this.name, required this.classId});

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      classId: json['classId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'classId': classId};
  }
}

class Subject {
  final String id;
  final String name;
  final String code;
  final String classId;

  Subject({
    required this.id,
    required this.name,
    required this.code,
    required this.classId,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      classId: json['classId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'code': code, 'classId': classId};
  }
}
