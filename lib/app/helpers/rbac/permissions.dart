import 'roles.dart';

/// Permission constants for type-safe permission checking
class AppPermissions {
  // Dashboard
  static const String viewDashboard = 'view_dashboard';

  // Students
  static const String viewStudents = 'view_students';
  static const String createStudents = 'create_students';
  static const String editStudents = 'edit_students';
  static const String deleteStudents = 'delete_students';

  // Teachers
  static const String viewTeachers = 'view_teachers';
  static const String createTeachers = 'create_teachers';
  static const String editTeachers = 'edit_teachers';
  static const String deleteTeachers = 'delete_teachers';

  // Classes
  static const String viewClasses = 'view_classes';
  static const String createClasses = 'create_classes';
  static const String editClasses = 'edit_classes';
  static const String deleteClasses = 'delete_classes';

  // Sections
  static const String viewSections = 'view_sections';
  static const String createSections = 'create_sections';
  static const String editSections = 'edit_sections';
  static const String deleteSections = 'delete_sections';

  // Parents
  static const String viewParents = 'view_parents';
  static const String createParents = 'create_parents';
  static const String editParents = 'edit_parents';
  static const String deleteParents = 'delete_parents';

  // Subjects
  static const String viewSubjects = 'view_subjects';
  static const String createSubjects = 'create_subjects';
  static const String editSubjects = 'edit_subjects';
  static const String deleteSubjects = 'delete_subjects';

  // Fees
  static const String viewFees = 'view_fees';
  static const String manageFees = 'manage_fees';
  static const String viewMyFees = 'view_my_fees';
  static const String viewChildFees = 'view_child_fees';

  // Attendance
  static const String viewAttendance = 'view_attendance';
  static const String markAttendance = 'mark_attendance';
  static const String viewMyAttendance = 'view_my_attendance';
  static const String viewChildAttendance = 'view_child_attendance';

  // Notifications
  static const String viewNotifications = 'view_notifications';
  static const String sendNotifications = 'send_notifications';

  // Profile
  static const String viewMyProfile = 'view_my_profile';
  static const String editMyProfile = 'edit_my_profile';

  // Parent-specific
  static const String viewMyChildren = 'view_my_children';

  // Wildcard for super admin
  static const String all = '*';
}

/// Role-based permissions configuration
class RolePermissions {
  static const Map<UserRole, Set<String>> permissions = {
    // Super Admin has all permissions
    UserRole.SUPER_ADMIN: {AppPermissions.all},

    // Admin can manage everything except system settings
    UserRole.ADMIN: {
      AppPermissions.viewDashboard,
      // Students
      AppPermissions.viewStudents,
      AppPermissions.createStudents,
      AppPermissions.editStudents,
      AppPermissions.deleteStudents,
      // Teachers
      AppPermissions.viewTeachers,
      AppPermissions.createTeachers,
      AppPermissions.editTeachers,
      AppPermissions.deleteTeachers,
      // Classes
      AppPermissions.viewClasses,
      AppPermissions.createClasses,
      AppPermissions.editClasses,
      AppPermissions.deleteClasses,
      // Sections
      AppPermissions.viewSections,
      AppPermissions.createSections,
      AppPermissions.editSections,
      AppPermissions.deleteSections,
      // Parents
      AppPermissions.viewParents,
      AppPermissions.createParents,
      AppPermissions.editParents,
      AppPermissions.deleteParents,
      // Subjects
      AppPermissions.viewSubjects,
      AppPermissions.createSubjects,
      AppPermissions.editSubjects,
      AppPermissions.deleteSubjects,
      // Fees
      AppPermissions.viewFees,
      AppPermissions.manageFees,
      // Attendance
      AppPermissions.viewAttendance,
      AppPermissions.markAttendance,
      // Notifications
      AppPermissions.viewNotifications,
      AppPermissions.sendNotifications,
      // Profile
      AppPermissions.viewMyProfile,
      AppPermissions.editMyProfile,
    },

    // Teacher has limited management capabilities
    UserRole.TEACHER: {
      AppPermissions.viewDashboard,
      // View only for students
      AppPermissions.viewStudents,
      // Classes & Sections - view only
      AppPermissions.viewClasses,
      AppPermissions.viewSections,
      // Subjects
      AppPermissions.viewSubjects,
      // Attendance
      AppPermissions.viewAttendance,
      AppPermissions.markAttendance,
      // Notifications
      AppPermissions.viewNotifications,
      // Profile
      AppPermissions.viewMyProfile,
      AppPermissions.editMyProfile,
    },

    // Student has view-only access to their own data
    UserRole.STUDENT: {
      AppPermissions.viewDashboard,
      AppPermissions.viewMyProfile,
      AppPermissions.editMyProfile,
      AppPermissions.viewMyFees,
      AppPermissions.viewMyAttendance,
      AppPermissions.viewNotifications,
      AppPermissions.viewClasses,
      AppPermissions.viewSections,
      AppPermissions.viewSubjects,
    },

    // Parent can view their children's data
    UserRole.PARENT: {
      AppPermissions.viewDashboard,
      AppPermissions.viewMyProfile,
      AppPermissions.editMyProfile,
      AppPermissions.viewMyChildren,
      AppPermissions.viewChildFees,
      AppPermissions.viewChildAttendance,
      AppPermissions.viewNotifications,
    },
  };

  /// Check if a role has a specific permission
  static bool hasPermission(UserRole role, String permission) {
    final perms = permissions[role] ?? {};
    // Wildcard check for super admin
    if (perms.contains(AppPermissions.all)) return true;
    return perms.contains(permission);
  }

  /// Get all permissions for a role
  static Set<String> getPermissions(UserRole role) {
    return permissions[role] ?? {};
  }
}
