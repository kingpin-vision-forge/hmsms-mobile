class StudentDetailResponse {
  final StudentDetail? data;

  StudentDetailResponse({this.data});

  factory StudentDetailResponse.fromJson(Map<String, dynamic> json) {
    return StudentDetailResponse(
      data: json['data'] != null ? StudentDetail.fromJson(json['data']) : null,
    );
  }
}

class StudentDetail {
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

  final List<Attendance>? attendance;
  final List<dynamic>? feeInvoices;
  final List<dynamic>? examResults;

  StudentDetail({
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
    this.attendance,
    this.feeInvoices,
    this.examResults,
  });

  factory StudentDetail.fromJson(Map<String, dynamic> json) {
    return StudentDetail(
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
      attendance: json['attendance'] != null
          ? List<Attendance>.from(
              json['attendance'].map((e) => Attendance.fromJson(e)),
            )
          : [],
      feeInvoices: json['feeInvoices'] ?? [],
      examResults: json['examResults'] ?? [],
    );
  }
}

class Attendance {
  final String? id;
  final DateTime? date;
  final String? studentId;
  final String? status;
  final String? remarks;
  final String? recordedBy;
  final bool? isDeleted;
  final DateTime? deletedAt;

  Attendance({
    this.id,
    this.date,
    this.studentId,
    this.status,
    this.remarks,
    this.recordedBy,
    this.isDeleted,
    this.deletedAt,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      studentId: json['studentId'],
      status: json['status'],
      remarks: json['remarks'],
      recordedBy: json['recordedBy'],
      isDeleted: json['isDeleted'],
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'])
          : null,
    );
  }
}
