class TimetableResponse {
  final bool success;
  final List<TimetableSlot> data;

  TimetableResponse({required this.success, required this.data});

  factory TimetableResponse.fromJson(Map<String, dynamic> json) {
    return TimetableResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => TimetableSlot.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class TimetableSlot {
  final String id;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final int periodNumber;
  final TimetableClass? classInfo;
  final TimetableSection? section;
  final TimetableSubject? subject;
  final TimetableTeacher? teacher;

  TimetableSlot({
    required this.id,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.periodNumber,
    this.classInfo,
    this.section,
    this.subject,
    this.teacher,
  });

  factory TimetableSlot.fromJson(Map<String, dynamic> json) {
    return TimetableSlot(
      id: json['id'] ?? '',
      dayOfWeek: json['dayOfWeek'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      periodNumber: json['periodNumber'] ?? 0,
      classInfo: json['class'] != null
          ? TimetableClass.fromJson(json['class'])
          : null,
      section: json['section'] != null
          ? TimetableSection.fromJson(json['section'])
          : null,
      subject: json['subject'] != null
          ? TimetableSubject.fromJson(json['subject'])
          : null,
      teacher: json['teacher'] != null
          ? TimetableTeacher.fromJson(json['teacher'])
          : null,
    );
  }

  String get timeRange => '$startTime - $endTime';
}

class TimetableClass {
  final String id;
  final String name;
  final String? code;

  TimetableClass({required this.id, required this.name, this.code});

  factory TimetableClass.fromJson(Map<String, dynamic> json) {
    return TimetableClass(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'],
    );
  }
}

class TimetableSection {
  final String id;
  final String name;

  TimetableSection({required this.id, required this.name});

  factory TimetableSection.fromJson(Map<String, dynamic> json) {
    return TimetableSection(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class TimetableSubject {
  final String id;
  final String name;
  final String? code;

  TimetableSubject({required this.id, required this.name, this.code});

  factory TimetableSubject.fromJson(Map<String, dynamic> json) {
    return TimetableSubject(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'],
    );
  }
}

class TimetableTeacher {
  final String id;
  final TimetableUser? user;

  TimetableTeacher({required this.id, this.user});

  factory TimetableTeacher.fromJson(Map<String, dynamic> json) {
    return TimetableTeacher(
      id: json['id'] ?? '',
      user: json['user'] != null ? TimetableUser.fromJson(json['user']) : null,
    );
  }

  String get fullName {
    if (user == null) return '';
    return [user!.firstName, user!.middleName, user!.lastName]
        .where((n) => n != null && n.isNotEmpty)
        .join(' ');
  }
}

class TimetableUser {
  final String? firstName;
  final String? middleName;
  final String? lastName;

  TimetableUser({this.firstName, this.middleName, this.lastName});

  factory TimetableUser.fromJson(Map<String, dynamic> json) {
    return TimetableUser(
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
    );
  }
}
