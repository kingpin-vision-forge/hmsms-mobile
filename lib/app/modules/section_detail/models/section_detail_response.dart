class SectionDetailResponse {
  SectionData? data;

  SectionDetailResponse({this.data});

  SectionDetailResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? SectionData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class SectionData {
  String? id;
  String? name;
  String? classId;
  ClassInfo? classInfo;
  List<Student>? students;

  SectionData({
    this.id,
    this.name,
    this.classId,
    this.classInfo,
    this.students,
  });

  SectionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    classId = json['classId'];
    classInfo = json['class'] != null
        ? ClassInfo.fromJson(json['class'])
        : null;
    if (json['students'] != null) {
      students = <Student>[];
      json['students'].forEach((v) {
        students!.add(Student.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['classId'] = classId;
    if (classInfo != null) {
      data['class'] = classInfo!.toJson();
    }
    if (students != null) {
      data['students'] = students!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ClassInfo {
  String? id;
  String? name;
  String? code;
  String? schoolId;

  ClassInfo({this.id, this.name, this.code, this.schoolId});

  ClassInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    schoolId = json['schoolId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['schoolId'] = schoolId;
    return data;
  }
}

class Student {
  String? id;
  String? studentName;
  String? studentFirstName;
  String? studentMiddleName;
  String? studentLastName;
  String? studentEmail;
  String? userId;
  String? admissionNumber;
  String? classId;
  String? className;
  String? sectionId;
  String? sectionName;
  String? dateOfBirth;
  String? gender;
  String? parentId;
  String? parentName;
  String? parentFirstName;
  String? parentMiddleName;
  String? parentLastName;
  String? parentMobile;

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

  Student.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    studentName = json['student_name'];
    studentFirstName = json['student_firstName'];
    studentMiddleName = json['student_middleName'];
    studentLastName = json['student_lastName'];
    studentEmail = json['student_email'];
    userId = json['userId'];
    admissionNumber = json['admissionNumber'];
    classId = json['classId'];
    className = json['class_name'];
    sectionId = json['sectionId'];
    sectionName = json['section_name'];
    dateOfBirth = json['dateOfBirth'];
    gender = json['gender'];
    parentId = json['parentId'];
    parentName = json['parent_name'];
    parentFirstName = json['parent_firstName'];
    parentMiddleName = json['parent_middleName'];
    parentLastName = json['parent_lastName'];
    parentMobile = json['parent_mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['student_name'] = studentName;
    data['student_firstName'] = studentFirstName;
    data['student_middleName'] = studentMiddleName;
    data['student_lastName'] = studentLastName;
    data['student_email'] = studentEmail;
    data['userId'] = userId;
    data['admissionNumber'] = admissionNumber;
    data['classId'] = classId;
    data['class_name'] = className;
    data['sectionId'] = sectionId;
    data['section_name'] = sectionName;
    data['dateOfBirth'] = dateOfBirth;
    data['gender'] = gender;
    data['parentId'] = parentId;
    data['parent_name'] = parentName;
    data['parent_firstName'] = parentFirstName;
    data['parent_middleName'] = parentMiddleName;
    data['parent_lastName'] = parentLastName;
    data['parent_mobile'] = parentMobile;
    return data;
  }
}
