class StudentListResponse {
  final List<Student> data;

  StudentListResponse({required this.data});

  factory StudentListResponse.fromJson(Map<String, dynamic> json) {
    return StudentListResponse(
      data: json['data'] != null
          ? List<Student>.from(json['data'].map((e) => Student.fromJson(e)))
          : [],
    );
  }
}

class Student {
  final String? id;
  final String? studentName;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? address;

  final String? userId;
  final String? admissionNumber;

  final String? classId;
  final String? className;
  final String? sectionId;
  final String? sectionName;

  final String? dateOfBirth;
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
    this.firstName,
    this.middleName,
    this.lastName,
    this.email,
    this.phone,
    this.address,
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
      firstName: json['student_firstName'],
      middleName: json['student_middleName'],
      lastName: json['student_lastName'],
      email: json['student_email'],
      phone: json['student_phone'],
      address: json['student_address'],
      userId: json['userId'],
      admissionNumber: json['admissionNumber'],
      classId: json['classId'],
      className: json['class_name'],
      sectionId: json['sectionId'],
      sectionName: json['section_name'],
      dateOfBirth: json['dateOfBirth'],
      gender: json['gender'],
      parentId: json['parentId'],
      parentName: json['parent_name'],
      parentFirstName: json['parent_firstName'],
      parentMiddleName: json['parent_middleName'],
      parentLastName: json['parent_lastName'],
      parentMobile: json['parent_mobile'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_name': studentName,
      'student_firstName': firstName,
      'student_middleName': middleName,
      'student_lastName': lastName,
      'student_email': email,
      'student_phone': phone,
      'student_address': address,
      'userId': userId,
      'admissionNumber': admissionNumber,
      'classId': classId,
      'class_name': className,
      'sectionId': sectionId,
      'section_name': sectionName,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'parentId': parentId,
      'parent_name': parentName,
      'parent_firstName': parentFirstName,
      'parent_middleName': parentMiddleName,
      'parent_lastName': parentLastName,
      'parent_mobile': parentMobile,
    };
  }
}
