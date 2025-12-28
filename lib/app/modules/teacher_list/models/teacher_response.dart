class TeacherListResponse {
  final List<Teacher> data;

  TeacherListResponse({required this.data});

  factory TeacherListResponse.fromJson(Map<String, dynamic> json) {
    return TeacherListResponse(
      data: json['data'] != null
          ? List<Teacher>.from(json['data'].map((e) => Teacher.fromJson(e)))
          : [],
    );
  }
}

class Teacher {
  final String? id;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? address;
  final String? userId;
  final String? employeeCode;
  final String? joinedDate;
  final String? schoolId;
  final String? schoolName;

  Teacher({
    this.id,
    this.firstName,
    this.middleName,
    this.lastName,
    this.email,
    this.phone,
    this.address,
    this.userId,
    this.employeeCode,
    this.joinedDate,
    this.schoolId,
    this.schoolName,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    // Handle nested user object if present
    final user = json['user'] as Map<String, dynamic>?;
    
    return Teacher(
      id: json['id'],
      firstName: user?['firstName'] ?? json['firstName'],
      middleName: user?['middleName'] ?? json['middleName'],
      lastName: user?['lastName'] ?? json['lastName'],
      email: user?['email'] ?? json['email'],
      phone: user?['phone'] ?? json['phone'],
      address: user?['address'] ?? json['address'],
      userId: json['userId'],
      employeeCode: json['employeeCode'],
      joinedDate: json['joinedDate'],
      schoolId: user?['schoolId'] ?? json['schoolId'],
      schoolName: json['school']?['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'address': address,
      'userId': userId,
      'employeeCode': employeeCode,
      'joinedDate': joinedDate,
      'schoolId': schoolId,
      'schoolName': schoolName,
    };
  }

  String get fullName {
    final parts = [firstName, middleName, lastName]
        .where((part) => part != null && part.isNotEmpty)
        .toList();
    return parts.join(' ');
  }
}
