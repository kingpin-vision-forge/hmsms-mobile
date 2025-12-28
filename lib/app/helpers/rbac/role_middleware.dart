import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_management/app/routes/app_pages.dart';
import 'roles.dart';
import 'rbac_service.dart';

/// Middleware to protect routes based on user roles
class RoleMiddleware extends GetMiddleware {
  final List<UserRole> allowedRoles;
  final String? redirectRoute;

  RoleMiddleware({
    required this.allowedRoles,
    this.redirectRoute,
  });

  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final rbac = Get.find<RbacService>();

    // If user is not logged in or role is not set, redirect to login
    if (rbac.currentRole == null) {
      return const RouteSettings(name: Routes.LOGIN);
    }

    // If user doesn't have the required role, redirect
    if (!rbac.isAnyRole(allowedRoles)) {
      return RouteSettings(name: redirectRoute ?? Routes.HOME);
    }

    // Allow navigation
    return null;
  }
}

/// Middleware to protect routes based on permissions
class PermissionMiddleware extends GetMiddleware {
  final List<String> requiredPermissions;
  final bool requireAll;
  final String? redirectRoute;

  PermissionMiddleware({
    required this.requiredPermissions,
    this.requireAll = false,
    this.redirectRoute,
  });

  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final rbac = Get.find<RbacService>();

    // If user is not logged in, redirect to login
    if (rbac.currentRole == null) {
      return const RouteSettings(name: Routes.LOGIN);
    }

    // Check permissions
    final hasPermission = requireAll
        ? rbac.canAll(requiredPermissions)
        : rbac.canAny(requiredPermissions);

    if (!hasPermission) {
      return RouteSettings(name: redirectRoute ?? Routes.HOME);
    }

    // Allow navigation
    return null;
  }
}

/// Middleware that blocks students and parents from admin routes
class AdminOnlyMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final rbac = Get.find<RbacService>();

    if (!rbac.isAdmin) {
      return const RouteSettings(name: Routes.HOME);
    }

    return null;
  }
}
