import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chopper/chopper.dart' as c;
import 'package:student_management/app/data/apis.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/global.dart';
import 'package:student_management/app/helpers/utilities/network_util.dart';
import 'package:student_management/app/helpers/rbac/roles.dart';
import 'package:student_management/app/modules/profile/models/profile_response.dart';

class ProfileController extends GetxController {
  final ApiService _apiService = ApiService.create();
  
  var isLoading = false.obs;
  var isUpdating = false.obs;
  var profile = Rxn<ProfileData>();

  // Form controllers
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final whatsappNumberController = TextEditingController();
  var isWhatsappOptIn = false.obs;

  // Get current user role
  UserRole get currentUserRole {
    if (userData == null || userData is! Map) {
      return UserRole.STUDENT;
    }
    final roleStr = (userData['role'] ?? '').toString().toUpperCase();
    return UserRole.values.firstWhere(
      (e) => e.name == roleStr,
      orElse: () => UserRole.STUDENT,
    );
  }

  bool get isParent => currentUserRole == UserRole.PARENT;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  void _populateFormFields() {
    final p = profile.value;
    if (p == null) return;
    
    phoneController.text = p.phone ?? '';
    addressController.text = p.address ?? '';
    whatsappNumberController.text = p.whatsappNumber ?? '';
    isWhatsappOptIn.value = p.whatsappOptIn ?? false;
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      
      c.Response? res = await NetworkUtils.safeApiCall(
        () => _apiService.fetchProfile(),
      );

      if (res == null) return;
      if (res.isSuccessful) {
        if (res.body != null &&
            res.body['data'] != null &&
            res.body['success'] == true) {
          profile.value = ProfileData.fromJson(res.body['data']);
          _populateFormFields();
        } else {
          serverError(res, () => fetchProfile());
        }
      }
    } catch (e) {
      errorUtil.handleAppError(
        apiName: 'fetchProfile',
        error: e,
        displayMessage: 'Failed to fetch profile',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    try {
      isUpdating.value = true;

      Map<String, dynamic> payload = {
        'phone': phoneController.text.trim(),
        'address': addressController.text.trim(),
      };

      // Add parent-specific fields
      if (isParent) {
        payload['whatsappNumber'] = whatsappNumberController.text.trim();
        payload['whatsappOptIn'] = isWhatsappOptIn.value;
      }

      c.Response? res = await NetworkUtils.safeApiCall(
        () => _apiService.updateProfile(payload),
      );

      if (res == null) return;
      if (res.isSuccessful) {
        if (res.body != null && res.body['success'] == true) {
          await fetchProfile();
          botToastSuccess('Profile updated successfully');
        } else {
          serverError(res, () => updateProfile());
        }
      }
    } catch (e) {
      errorUtil.handleAppError(
        apiName: 'updateProfile',
        error: e,
        displayMessage: 'Failed to update profile',
      );
    } finally {
      isUpdating.value = false;
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    addressController.dispose();
    whatsappNumberController.dispose();
    super.onClose();
  }
}
