import 'dart:io';
import 'package:student_management/app/data/apis.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/global.dart';
import 'package:student_management/app/helpers/utilities/network_util.dart';
import 'package:student_management/app/helpers/utilities/device_info_util.dart';
import 'package:student_management/app/helpers/rbac/rbac_service.dart';
import 'package:student_management/app/modules/login/models/sign_response.dart';
import 'package:student_management/app/modules/login/models/user_response.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chopper/chopper.dart' as c;
import 'package:student_management/app/routes/app_pages.dart';
import 'package:uuid/uuid.dart';

class LoginController extends GetxController with WidgetsBindingObserver {
  final ApiService _apiService = ApiService.create();
  // Use observables for username and sessionId
  var userName = ''.obs;
  var sessionId = ''.obs;
  var mfaCode = ''.obs;
  var mobileNumber = ''.obs;
  var verificationCode = ''.obs;
  var password = ''.obs;
  var device = '';
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final isButtonEnabled = false.obs;
  String fcmToken = '';
  var selectedRole = ''.obs;
  // Properties from LoginController
  var isPasswordHidden = true.obs;
  var isCheckboxChecked = false.obs;
  var isFormValid = false.obs;
  var isCheckboxEnabled = false.obs;
  var hasInteractedWithUsername = false.obs;
  var hasInteractedWithPassword = false.obs;
  final formKey = GlobalKey<FormState>();

  // Properties from Verify Controller
  final codeController = TextEditingController();
  final isCodeLoading = false.obs;
  final isCodeButtonEnabled = false.obs;
  final codeErrorMessage = ''.obs;
  final isResendSuccess = false.obs;
  final String generatedCode = '';
  var codeLength = 0.obs;
  var isResendButtonEnabled = true.obs;
  var timer = 0.obs;
  RxBool isKeyboardOpen = false.obs;
  var isRememberMeChecked = false.obs;
  var isTermsChecked = false.obs;
  var franchiseAvailable = false.obs;
  var useDetail = Rxn<UserDetails>();
  // final _firebaseMessaging = FirebaseMessaging.instance;
  // Resend Code Loader
  var isResendingCode = false.obs;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Add listener to username controller to validate input and update button state
    usernameController.addListener(() {
      isButtonEnabled.value = validateUsername(usernameController.text) == null;
      checkFormValidity(); // For Login functionality
    });

    // Add listener to password controller for form validation
    passwordController.addListener(checkFormValidity);

    // Add listener to checkbox for form validation updates
    isCheckboxChecked.listen((value) {
      checkFormValidity(); // For Login functionality
    });

    // Set up verification code length monitoring and button state management
    codeController.addListener(() {
      codeLength.value = codeController.text.length;
      isCodeButtonEnabled.value = codeController.text.length == 6;
    });

    // Register widget binding observer for keyboard visibility tracking
    WidgetsBinding.instance.addObserver(this);
  }

  signIn(GlobalKey<FormState> formKey) async {
    // Check for empty required fields
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      botToastError(Constants.BOT_TOAST_MESSAGES['REQ_FIELDS']!);
      return;
    }

    // Determine device platform and set appropriate token
    // if (Platform.isIOS) {
    //   device = 'iOS';
    //   // Get Apple Push Notification Service token
    //   await _firebaseMessaging.getAPNSToken();
    // } else if (Platform.isAndroid) {
    //   device = 'Android';
    // } else {
    //   // Clear tokens for unsupported platforms
    //   fcmToken = '';
    //   device = '';
    // }

    // Get Firebase Cloud Messaging token
    // fcmToken = (await FirebaseMessaging.instance.getToken())!;
    // await writeToStorage({Constants.STORAGE_KEYS['FCM_TOKEN']!: fcmToken});
    // Validate form state before proceeding
    if (formKey.currentState?.validate() ?? false) {
      // Generate UUID for device tracking
      var uuid = Uuid();
      String deviceUUID = uuid.v4();
      
      // Collect device information for audit logging
      final deviceInfo = await DeviceInfoUtil.getDeviceInfo();
      
      // Prepare login credentials payload with audit metadata
      Map<String, dynamic> payload = {
        'identifier': usernameController.text,
        'password': passwordController.text,
        'deviceId': deviceUUID,
        'deviceName': deviceInfo['deviceName'],
        'userAgent': deviceInfo['userAgent'],
        'ipAddress': deviceInfo['ipAddress'],
      };
      try {
        // Set loading state to indicate API call in progress
        isLoading.value = true;
        // Attempt login with provided credentials
        c.Response? res = await NetworkUtils.safeApiCall(
          () => _apiService.login(payload),
        );

        if (res == null) return;
        if (res.isSuccessful) {
          // Validate response body structure and success status
          if (res.body != null &&
              res.body['data'] != null &&
              res.body['success'] == true) {
            final response = SignInResponse.fromJson(res.body);
            final accessToken = response.data?.accessToken ?? '';
            final refreshToken = response.data?.refreshToken ?? '';
            // final expiresIn = response.data?.expiresIn ??
            //     Constants.CONFIG['DEFAULT_ACCESS_TOKEN_EXPIRY']!;
            useDetail.value = response.data?.user;
            final rememberMe = isRememberMeChecked.value;
            // storeTokenExpiry(expiresIn);

            await writeToStorage({
              Constants.STORAGE_KEYS['ACCESS_TOKEN']!: accessToken,
              Constants.STORAGE_KEYS['REFRESH_TOKEN']!: refreshToken,
              Constants.STORAGE_KEYS['REMEMBER_ME']!: rememberMe,
              Constants.STORAGE_KEYS['USERNAME']!: usernameController.text,
              Constants.STORAGE_KEYS['DEVICE_ID']!: deviceUUID,
              Constants.STORAGE_KEYS['USER_DATA']!: useDetail.value?.toJson(),
            });
            await setUserData();
            
            // Set the user role in RBAC service
            final rbacService = Get.find<RbacService>();
            if (useDetail.value?.role != null) {
              rbacService.setRole(useDetail.value!.role!);
            }
            
            // Register device for push notifications
            await _registerDeviceForPush();
            
            // Show success message and navigate to main app
            botToastSuccess(Constants.BOT_TOAST_MESSAGES['SUCCESS_SIGN_IN']!);
            clear();
            isRememberMeChecked.value = false;
            isTermsChecked.value = false;
            Get.offAllNamed(Routes.HOME);
          }
        } else {
          // Handle API error responses
          serverError(res, () => signIn(formKey));
        }
      } catch (e) {
        // Handle unexpected errors

        errorUtil.handleAppError(
          apiName: 'signIn',
          error: e,
          displayMessage: Constants.BOT_TOAST_MESSAGES['FAILED_SIGN_IN']!,
        );
      } finally {
        // Reset loading state
        isLoading.value = false;
      }
    }
  }

  /* 
   * Toggles the visibility of the password field.
   * Switches between showing and hiding the password text.
   */
  togglePasswordVisibility() {
    // Toggle password visibility state
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  /* 
   * Validates the login form and updates form state.
   * 
   * This method:
   * - Checks username and password validity
   * - Updates checkbox state based on field validity
   * - Updates overall form validity state
   * - Manages the enabled state of the remember me checkbox
   */
  checkFormValidity() {
    // Validate username using trim to remove whitespace
    bool isUsernameValid =
        validateUsername(usernameController.text.trim()) == null;

    // Check if password is not empty after trimming
    bool isPasswordValid = passwordController.text.trim().isNotEmpty;

    // Get current state of remember me checkbox
    bool isRememberMeValid = isCheckboxChecked.value;

    // Reset checkbox if either username or password is invalid
    if (!isUsernameValid || !isPasswordValid) {
      isCheckboxChecked.value = false;
    }

    // Update checkbox enabled state based on field validity
    isCheckboxEnabled.value = isUsernameValid && isPasswordValid;

    // Update overall form validity state
    isFormValid.value = isUsernameValid && isPasswordValid && isRememberMeValid;
  }

  /* 
   * Clears all form controllers and input fields.
   * 
   * This method resets:
   * - Code controller
   * - Username controller
   * - Password controller
   */
  clear() {
    // Clear all text input controllers
    codeController.clear();
    usernameController.clear();
    passwordController.clear();
    isRememberMeChecked.value = false;
    isTermsChecked.value = false;
  }

  @override
  void onClose() {
    // Remove widget binding observer to prevent memory leaks
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  /// Registers device for push notifications
  Future<void> _registerDeviceForPush() async {
    try {
      // Get FCM token
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken == null || fcmToken.isEmpty) return;

      // Store FCM token
      await writeToStorage({
        Constants.STORAGE_KEYS['FCM_TOKEN']!: fcmToken,
      });

      // Determine platform
      String platform = 'android';
      if (Platform.isIOS) {
        platform = 'ios';
      }

      // Register device with backend
      await NetworkUtils.safeApiCall(
        () => _apiService.registerDevice({
          'token': fcmToken,
          'platform': platform,
        }),
      );
    } catch (e) {
      // Silently fail - don't block login for push notification registration
      debugPrint('Failed to register device for push: $e');
    }
  }
}
