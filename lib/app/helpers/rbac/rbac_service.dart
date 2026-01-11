import 'package:get/get.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/utilities/secure_storage.dart';
import 'roles.dart';
import 'permissions.dart';

/// RBAC (Role-Based Access Control) Service
/// Manages user roles and permission checks throughout the app
class RbacService extends GetxService {
  final _currentRole = Rx<UserRole?>(null);
  final _isInitialized = false.obs;

  /// Current user's role
  UserRole? get currentRole => _currentRole.value;

  /// Whether the service has been initialized
  bool get isInitialized => _isInitialized.value;

  /// Initialize the RBAC service by loading user role from storage
  Future<RbacService> init() async {
    try {
      final storage = SecureStorage();
      final userData = await storage.read(Constants.STORAGE_KEYS['USER_DATA']!);

      if (userData != null && userData is Map && userData['role'] != null) {
        _currentRole.value = (userData['role'] as String).toUserRole();
      }
      _isInitialized.value = true;
    } catch (e) {
      _isInitialized.value = true;
    }
    return this;
  }

  /// Set the current user's role (called after login)
  void setRole(String role) {
    _currentRole.value = role.toUserRole();
  }

  /// Set role from UserRole enum
  void setRoleEnum(UserRole role) {
    _currentRole.value = role;
  }

  /// Clear the current role (called on logout)
  void clearRole() {
    _currentRole.value = null;
  }

  /// Check if current user has a specific permission
  bool can(String permission) {
    if (_currentRole.value == null) return false;
    return RolePermissions.hasPermission(_currentRole.value!, permission);
  }

  /// Check if current user has any of the given permissions
  bool canAny(List<String> permissions) {
    return permissions.any((permission) => can(permission));
  }

  /// Check if current user has all of the given permissions
  bool canAll(List<String> permissions) {
    return permissions.every((permission) => can(permission));
  }

  /// Check if current user is a specific role
  bool isRole(UserRole role) => _currentRole.value == role;

  /// Check if current user is any of the given roles
  bool isAnyRole(List<UserRole> roles) => roles.contains(_currentRole.value);

  /// Check if current user is an admin (SUPER_ADMIN or ADMIN)
  bool get isAdmin =>
      isAnyRole([UserRole.SUPER_ADMIN, UserRole.ADMIN]);

  /// Check if current user is a super admin
  bool get isSuperAdmin => isRole(UserRole.SUPER_ADMIN);

  /// Check if current user is a teacher
  bool get isTeacher => isRole(UserRole.TEACHER);

  /// Check if current user is a student
  bool get isStudent => isRole(UserRole.STUDENT);

  /// Check if current user is a parent
  bool get isParent => isRole(UserRole.PARENT);

  /// Get all permissions for current user
  Set<String> get currentPermissions {
    if (_currentRole.value == null) return {};
    return RolePermissions.getPermissions(_currentRole.value!);
  }
}
