import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/global.dart';
import 'package:student_management/app/helpers/widget/custom_animated.dart';

class NoInternetDialog extends StatelessWidget {
  final bool isMainFlow;
  NoInternetDialog({super.key, this.isMainFlow = false});
  // Loading state for the dialog
  final isLoading = false.obs;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        // Show white screen
        isLoading.value = true;
        var result = await checkInternetConnection();
        // Hide white screen
        isLoading.value = false;
        if (result) {
          if (Get.isDialogOpen!) {
            Get.back(); // Close the dialog first
          }
          botToastSuccess(Constants.BOT_TOAST_MESSAGES['CONNECTION_RESTORED']!);
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 0,
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
              : Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child: const CustomAnimatedIcon(
                              icon: Icons.wifi_off,
                              color: AppColors.errorColor,
                              size: 48)),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                          child: Text(
                            Constants.BOT_TOAST_MESSAGES['NO_INTERNET']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                          child: Text(
                            Constants
                                .BOT_TOAST_MESSAGES['NO_INTERNET_DESCRIPTION']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.normalTextColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            splashFactory: InkSplash.splashFactory,
                            enableFeedback: true,
                            backgroundColor: AppColors.primaryColor,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            // Show white screen
                            isLoading.value = true;
                            var result = await checkInternetConnection();
                            // Hide white screen
                            isLoading.value = false;
                            if (result) {
                              if (Get.isDialogOpen!) {
                                Get.back(); // Close the dialog first
                              }
                              botToastSuccess(Constants
                                  .BOT_TOAST_MESSAGES['CONNECTION_RESTORED']!);
                            }
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  'Try Again',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: AppColors.secondaryColor,
                                    fontSize: 18, // Adjusted font size
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}