class AttendanceResponse {
  final bool success;
  final List<AttendanceRecord> data;

  AttendanceResponse({required this.success, required this.data});

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => AttendanceRecord.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class AttendanceRecord {
  final String id;
  final String date;
  final String? time; // Time when marked (HH:mm format)
  final String status;
  final String? remarks;
  final AttendanceStudent? student;
  final String? recordedBy;

  AttendanceRecord({
    required this.id,
    required this.date,
    this.time,
    required this.status,
    this.remarks,
    this.student,
    this.recordedBy,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'] ?? '',
      date: json['date'] ?? '',
      time: json['time'],
      status: json['status'] ?? 'ABSENT',
      remarks: json['remarks'],
      student: json['student'] != null
          ? AttendanceStudent.fromJson(json['student'])
          : null,
      recordedBy: json['recordedBy'],
    );
  }
}

class AttendanceStudent {
  final String id;
  final String? admissionNumber;
  final AttendanceUser? user;

  AttendanceStudent({
    required this.id,
    this.admissionNumber,
    this.user,
  });

  factory AttendanceStudent.fromJson(Map<String, dynamic> json) {
    return AttendanceStudent(
      id: json['id'] ?? '',
      admissionNumber: json['admissionNumber'],
      user: json['user'] != null
          ? AttendanceUser.fromJson(json['user'])
          : null,
    );
  }

  String get fullName {
    if (user == null) return '';
    return [user!.firstName, user!.middleName, user!.lastName]
        .where((n) => n != null && n.isNotEmpty)
        .join(' ');
  }
}

class AttendanceUser {
  final String? firstName;
  final String? middleName;
  final String? lastName;

  AttendanceUser({this.firstName, this.middleName, this.lastName});

  factory AttendanceUser.fromJson(Map<String, dynamic> json) {
    return AttendanceUser(
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
    );
  }
}

/// Model for marking attendance (local state)
class StudentAttendanceEntry {
  final String studentId;
  final String studentName;
  final String? admissionNumber;
  String status; // PRESENT, ABSENT, LATE
  String? remarks;

  StudentAttendanceEntry({
    required this.studentId,
    required this.studentName,
    this.admissionNumber,
    this.status = 'PRESENT',
    this.remarks,
  });
}
