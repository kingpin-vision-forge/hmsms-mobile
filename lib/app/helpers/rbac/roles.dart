/// User roles enum matching backend roles
enum UserRole {
  SUPER_ADMIN,
  ADMIN,
  TEACHER,
  STUDENT,
  PARENT,
}

/// Extension to convert string to UserRole
extension UserRoleExtension on String {
  UserRole toUserRole() {
    return UserRole.values.firstWhere(
      (e) => e.name == this,
      orElse: () => UserRole.STUDENT, // default fallback
    );
  }
}

/// Extension to get display name for UserRole
extension UserRoleDisplay on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.SUPER_ADMIN:
        return 'Super Admin';
      case UserRole.ADMIN:
        return 'Admin';
      case UserRole.TEACHER:
        return 'Teacher';
      case UserRole.STUDENT:
        return 'Student';
      case UserRole.PARENT:
        return 'Parent';
    }
  }
}
