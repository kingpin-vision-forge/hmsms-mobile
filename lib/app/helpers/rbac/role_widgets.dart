import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'roles.dart';
import 'rbac_service.dart';

/// Widget that shows/hides content based on user permission
class PermissionWidget extends StatelessWidget {
  /// The permission required to show the child widget
  final String permission;

  /// The widget to show if permission is granted
  final Widget child;

  /// Optional widget to show if permission is denied
  final Widget? fallback;

  const PermissionWidget({
    super.key,
    required this.permission,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    final rbac = Get.find<RbacService>();

    if (rbac.can(permission)) {
      return child;
    }
    return fallback ?? const SizedBox.shrink();
  }
}

/// Widget that shows/hides content based on any of the given permissions
class AnyPermissionWidget extends StatelessWidget {
  /// List of permissions - shows child if user has ANY of these
  final List<String> permissions;

  /// The widget to show if any permission is granted
  final Widget child;

  /// Optional widget to show if no permission is granted
  final Widget? fallback;

  const AnyPermissionWidget({
    super.key,
    required this.permissions,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    final rbac = Get.find<RbacService>();

    if (rbac.canAny(permissions)) {
      return child;
    }
    return fallback ?? const SizedBox.shrink();
  }
}

/// Widget that shows/hides content based on user role
class RoleWidget extends StatelessWidget {
  /// List of roles that can see this widget
  final List<UserRole> allowedRoles;

  /// The widget to show if user has an allowed role
  final Widget child;

  /// Optional widget to show if user doesn't have an allowed role
  final Widget? fallback;

  const RoleWidget({
    super.key,
    required this.allowedRoles,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    final rbac = Get.find<RbacService>();

    if (rbac.isAnyRole(allowedRoles)) {
      return child;
    }
    return fallback ?? const SizedBox.shrink();
  }
}

/// Widget that shows content only for admin users (SUPER_ADMIN or ADMIN)
class AdminOnlyWidget extends StatelessWidget {
  /// The widget to show for admin users
  final Widget child;

  /// Optional widget to show for non-admin users
  final Widget? fallback;

  const AdminOnlyWidget({
    super.key,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    final rbac = Get.find<RbacService>();

    if (rbac.isAdmin) {
      return child;
    }
    return fallback ?? const SizedBox.shrink();
  }
}

/// Builder widget for more complex role-based UI logic
class RoleBuilder extends StatelessWidget {
  /// Builder function that receives the current role
  final Widget Function(BuildContext context, UserRole? role) builder;

  const RoleBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final rbac = Get.find<RbacService>();
    return builder(context, rbac.currentRole);
  }
}

/// Reactive widget that rebuilds when role changes
class ObxRoleWidget extends StatelessWidget {
  /// List of roles that can see this widget
  final List<UserRole> allowedRoles;

  /// The widget to show if user has an allowed role
  final Widget child;

  /// Optional widget to show if user doesn't have an allowed role
  final Widget? fallback;

  const ObxRoleWidget({
    super.key,
    required this.allowedRoles,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    final rbac = Get.find<RbacService>();

    return Obx(() {
      if (rbac.isAnyRole(allowedRoles)) {
        return child;
      }
      return fallback ?? const SizedBox.shrink();
    });
  }
}
