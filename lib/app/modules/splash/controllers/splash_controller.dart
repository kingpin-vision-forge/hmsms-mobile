import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/global.dart';
import 'package:student_management/app/helpers/widget/network_error.dart';
import 'package:student_management/app/modules/login/controllers/login_controller.dart';

class SplashController extends GetxController {
  LoginController controller = Get.put(LoginController());
  @override
  void onInit() {
    super.onInit();
  }

  Future<bool> _checkPermissions() async {
    final photosGranted = await Permission.camera.isGranted;
    final notificationsGranted = await Permission.notification.isGranted;

    return photosGranted && notificationsGranted;
  }

  Future<void> checkSession() async {
    try {
      // First check if all permissions are granted
      if (!(await readFromStorage(
            Constants.STORAGE_KEYS['PERMISSION_PAGE_SHOWN']!,
          ) ??
          false)) {
        // final hasAllPermissions = await _checkPermissions();
        // if (!hasAllPermissions) {
        //   Get.offAllNamed(Routes.CHECKPERMISSION);
        //   return;
        // }
      }

      var result = await checkInternetConnection();
      if (!result) {
        Get.to(
          NetworkErrorPage(
            title: Constants.BOT_TOAST_MESSAGES['NO_INTERNET']!,
            message: Constants.BOT_TOAST_MESSAGES['RECONNECT']!,
            isMainFlow: true,
          ),
        );
        return;
      }

      // Session check should rely on tokens, not only "Remember Me"
      final accessToken = await readFromStorage(
        Constants.STORAGE_KEYS['ACCESS_TOKEN']!,
      );
      final refreshToken = await readFromStorage(
        Constants.STORAGE_KEYS['REFRESH_TOKEN']!,
      );

      if (accessToken != null &&
          accessToken.toString().isNotEmpty &&
          refreshToken != null &&
          refreshToken.toString().isNotEmpty) {
        // Valid session exists
        await setUserData();
        Get.offAllNamed('/home');
        return;
      }

      // No valid session; don't erase storage on app restarts
      Get.offAllNamed('/login');
    } catch (e) {
      // Handle any errors during the splash/permission check process
      await eraseStorage();
      Get.offAllNamed('/login');
    }
  }
}
