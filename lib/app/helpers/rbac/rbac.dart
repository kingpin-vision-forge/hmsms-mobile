/// RBAC (Role-Based Access Control) Module
/// 
/// This module provides role-based access control for the Flutter app.
/// 
/// Usage:
/// ```dart
/// import 'package:student_management/app/helpers/rbac/rbac.dart';
/// 
/// // Check permissions
/// if (rbacService.can(AppPermissions.createStudents)) {
///   // Show create button
/// }
/// 
/// // Use in widgets
/// PermissionWidget(
///   permission: AppPermissions.createStudents,
///   child: FloatingActionButton(...),
/// )
/// 
/// // Use in routes
/// GetPage(
///   name: Routes.CREATE_STUDENT,
///   page: () => CreateStudentView(),
///   middlewares: [RoleMiddleware(allowedRoles: [UserRole.ADMIN])],
/// )
/// ```

export 'roles.dart';
export 'permissions.dart';
export 'rbac_service.dart';
export 'role_middleware.dart';
export 'role_widgets.dart';
