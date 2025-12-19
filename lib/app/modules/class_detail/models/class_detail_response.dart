import 'dart:convert';

class ClassDetailResponse {
  final ClassDetailData? data;

  ClassDetailResponse({this.data});

  factory ClassDetailResponse.fromJson(Map<String, dynamic> json) {
    return ClassDetailResponse(
      data: json['data'] != null
          ? ClassDetailData.fromJson(json['data'])
          : null,
    );
  }
}

class ClassDetailData {
  final String? id;
  final String? name;
  final String? code;
  final String? schoolId;
  final bool? isDeleted;
  final DateTime? deletedAt;
  final School? school;
  final List<Section> sections;
  final List<Subject> subjects;
  final List<Student> students;

  ClassDetailData({
    this.id,
    this.name,
    this.code,
    this.schoolId,
    this.isDeleted,
    this.deletedAt,
    this.school,
    this.sections = const [],
    this.subjects = const [],
    this.students = const [],
  });

  factory ClassDetailData.fromJson(Map<String, dynamic> json) {
    return ClassDetailData(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      schoolId: json['schoolId'],
      isDeleted: json['isDeleted'],
      deletedAt: json['deletedAt'] != null
          ? DateTime.tryParse(json['deletedAt'])
          : null,
      school: json['school'] != null ? School.fromJson(json['school']) : null,
      sections:
          (json['sections'] as List<dynamic>?)
              ?.map((e) => Section.fromJson(e))
              .toList() ??
          [],
      subjects:
          (json['subjects'] as List<dynamic>?)
              ?.map((e) => Subject.fromJson(e))
              .toList() ??
          [],
      students:
          (json['students'] as List<dynamic>?)
              ?.map((e) => Student.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class School {
  final String? id;
  final String? name;
  final String? address;
  final String? phone;
  final String? email;
  final bool? isDeleted;
  final DateTime? deletedAt;

  School({
    this.id,
    this.name,
    this.address,
    this.phone,
    this.email,
    this.isDeleted,
    this.deletedAt,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      isDeleted: json['isDeleted'],
      deletedAt: json['deletedAt'] != null
          ? DateTime.tryParse(json['deletedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'address': address,
    'phone': phone,
    'email': email,
    'isDeleted': isDeleted,
    'deletedAt': deletedAt?.toIso8601String(),
  };
}

class Section {
  final String? id;
  final String? name;
  final String? classId;
  final bool? isDeleted;
  final DateTime? deletedAt;

  Section({this.id, this.name, this.classId, this.isDeleted, this.deletedAt});

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['id'],
      name: json['name'],
      classId: json['classId'],
      isDeleted: json['isDeleted'],
      deletedAt: json['deletedAt'] != null
          ? DateTime.tryParse(json['deletedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'classId': classId,
    'isDeleted': isDeleted,
    'deletedAt': deletedAt?.toIso8601String(),
  };
}

class Subject {
  final String? id;
  final String? name;
  final String? code;
  final String? classId;
  final bool? isDeleted;
  final DateTime? deletedAt;

  Subject({
    this.id,
    this.name,
    this.code,
    this.classId,
    this.isDeleted,
    this.deletedAt,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      classId: json['classId'],
      isDeleted: json['isDeleted'],
      deletedAt: json['deletedAt'] != null
          ? DateTime.tryParse(json['deletedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'code': code,
    'classId': classId,
    'isDeleted': isDeleted,
    'deletedAt': deletedAt?.toIso8601String(),
  };
}

class Student {
  final String? id;
  final String? studentName;
  final String? studentFirstName;
  final String? studentMiddleName;
  final String? studentLastName;
  final String? studentEmail;
  final String? userId;
  final String? admissionNumber;
  final String? classId;
  final String? className;
  final String? sectionId;
  final String? sectionName;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? parentId;
  final String? parentName;
  final String? parentFirstName;
  final String? parentMiddleName;
  final String? parentLastName;
  final String? parentMobile;

  Student({
    this.id,
    this.studentName,
    this.studentFirstName,
    this.studentMiddleName,
    this.studentLastName,
    this.studentEmail,
    this.userId,
    this.admissionNumber,
    this.classId,
    this.className,
    this.sectionId,
    this.sectionName,
    this.dateOfBirth,
    this.gender,
    this.parentId,
    this.parentName,
    this.parentFirstName,
    this.parentMiddleName,
    this.parentLastName,
    this.parentMobile,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      studentName: json['student_name'],
      studentFirstName: json['student_firstName'],
      studentMiddleName: json['student_middleName'],
      studentLastName: json['student_lastName'],
      studentEmail: json['student_email'],
      userId: json['userId'],
      admissionNumber: json['admissionNumber'],
      classId: json['classId'],
      className: json['class_name'],
      sectionId: json['sectionId'],
      sectionName: json['section_name'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'])
          : null,
      gender: json['gender'],
      parentId: json['parentId'],
      parentName: json['parent_name'],
      parentFirstName: json['parent_firstName'],
      parentMiddleName: json['parent_middleName'],
      parentLastName: json['parent_lastName'],
      parentMobile: json['parent_mobile'],
    );
  }
}
