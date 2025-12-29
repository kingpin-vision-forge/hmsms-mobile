class ProfileResponse {
  final bool success;
  final int statusCode;
  final ProfileData data;

  ProfileResponse({
    required this.success,
    required this.statusCode,
    required this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      data: ProfileData.fromJson(json['data'] ?? {}),
    );
  }
}

class ProfileData {
  final String? id;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? address;
  final String? profilePicture;
  final String? role;
  final String? schoolId;
  // Parent-specific fields
  final String? whatsappNumber;
  final bool? whatsappOptIn;

  ProfileData({
    this.id,
    this.firstName,
    this.middleName,
    this.lastName,
    this.email,
    this.phone,
    this.address,
    this.profilePicture,
    this.role,
    this.schoolId,
    this.whatsappNumber,
    this.whatsappOptIn,
  });

  String get fullName {
    final parts = [firstName, middleName, lastName]
        .where((s) => s != null && s.isNotEmpty)
        .toList();
    return parts.join(' ');
  }

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['id'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      profilePicture: json['profilePicture'],
      role: json['role'],
      schoolId: json['schoolId'],
      whatsappNumber: json['whatsappNumber'],
      whatsappOptIn: json['whatsappOptIn'],
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
      'profilePicture': profilePicture,
      'role': role,
      'schoolId': schoolId,
      'whatsappNumber': whatsappNumber,
      'whatsappOptIn': whatsappOptIn,
    };
  }
}
