class UserDetails {
  String? userId;
  String? userName;
  String? firstName;
  String? middleName;
  String? lastName;
  String? phone;
  String? email;
  String? role;
  String? schoolId;

  UserDetails({
    this.userId,
    this.userName,
    this.firstName,
    this.middleName,
    this.lastName,
    this.phone,
    this.email,
    this.role,
    this.schoolId,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      userId: json['id'],
      userName: json['username'] ?? '',
      firstName: json['firstName'] ?? '',
      middleName: json['middleName'] ?? '',
      lastName: json['lastName'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      schoolId: json['schoolId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': userId,
      'username': userName,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'phone': phone,
      'email': email,
      'role': role,
      'schoolId': schoolId,
    };
  }
}
