import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/global.dart';
import 'package:student_management/app/helpers/widget/custom_animated.dart';
import 'package:student_management/app/modules/splash/controllers/splash_controller.dart';
import 'package:student_management/app/routes/app_pages.dart';
class NetworkErrorPage extends StatelessWidget {
  final String title;
  final String message;
  final bool isMainFlow;

  NetworkErrorPage({
    super.key,
    required this.title,
    required this.message,
    this.isMainFlow = false,
  });
  // Loading state for the dialog
  final isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          // Show white screen
          isLoading.value = true;
          var result = await checkInternetConnection();
          // Hide white screen
          isLoading.value = false;
          if (result) {
            if (isMainFlow) {
              if (Get.isRegistered<SplashController>()) {
                await Get.delete<SplashController>();
              }
              await Get.offAllNamed(Routes.SPLASH);
            } else {
              Get.back();
            }
            botToastSuccess(
                Constants.BOT_TOAST_MESSAGES['CONNECTION_RESTORED']!);
          }
        },
        child: SafeArea(
          child: Center(
            child: Obx(
              () => isLoading.value
                  ? Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: MediaQuery.of(context).size.height / 3,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CustomAnimatedIcon(
                            icon: Icons.wifi_off,
                            size: 74,
                            color: AppColors.black),
                        const SizedBox(height: 24),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                            child: Column(
                              children: [
                                Text(
                                  title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.normalTextColor),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  message,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: AppColors.normalTextColor),
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    splashFactory: InkSplash.splashFactory,
                                    enableFeedback: true,
                                    backgroundColor: AppColors.black,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 24),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.refresh, color: Colors.white),
                                      SizedBox(width: 8),
                                      Text("Retry",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  onPressed: () async {
                                    // Show white screen
                                    isLoading.value = true;
                                    var result =
                                        await checkInternetConnection();
                                    // Hide white screen
                                    isLoading.value = false;
                                    if (result) {
                                      if (isMainFlow) {
                                        if (Get.isRegistered<
                                            SplashController>()) {
                                          await Get.delete<SplashController>();
                                        }
                                        await Get.offAllNamed(Routes.SPLASH);
                                      } else {
                                        Get.back();
                                      }
                                      botToastSuccess(
                                          Constants.BOT_TOAST_MESSAGES[
                                              'CONNECTION_RESTORED']!);
                                    }
                                  },
                                ),
                              ],
                            )),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}