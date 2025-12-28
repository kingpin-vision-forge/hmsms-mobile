class SectionResponse {
  final List<SectionData> data;

  SectionResponse({
    required this.data,
  });

  factory SectionResponse.fromJson(Map<String, dynamic> json) {
    return SectionResponse(
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (item) => SectionData.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class SectionData {
  final String id;
  final String name;
  final String classId;
  final ClassInfo classInfo;

  SectionData({
    required this.id,
    required this.name,
    required this.classId,
    required this.classInfo,
  });

  factory SectionData.fromJson(Map<String, dynamic> json) {
    return SectionData(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      classId: json['classId'] ?? '',
      classInfo: ClassInfo.fromJson(
        json['class'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'classId': classId,
      'class': classInfo.toJson(),
    };
  }
}

class ClassInfo {
  final String id;
  final String name;
  final String code;
  final String schoolId;

  ClassInfo({
    required this.id,
    required this.name,
    required this.code,
    required this.schoolId,
  });

  factory ClassInfo.fromJson(Map<String, dynamic> json) {
    return ClassInfo(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      schoolId: json['schoolId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'code': code, 'schoolId': schoolId};
  }
}
