import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hugeicons/hugeicons.dart';

class Error503Screen extends StatelessWidget {
  final Function retryCallback;

  const Error503Screen({Key? key, required this.retryCallback})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        toolbarHeight: 70,
        leadingWidth: double.infinity,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.chevron_left,
                  color: AppColors.black,
                  size: 36,
                ),
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          ),
        ),
        foregroundColor: AppColors.secondaryColor,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.secondaryColor,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: AppColors.red200,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: HugeIcon(
                    icon: HugeIcons.strokeRoundedAlertCircle,
                    size: 35,
                    color: AppColors.redColorDonut),
              ),
              const SizedBox(height: 24),
              Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Column(
                    children: [
                      const Text(
                        "Oops, something went wrong",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.normalTextColor),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "The application has encountered an unexpected issue and needs to close. We apologize for the inconvenience.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, color: AppColors.normalTextColor),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: isRetry.value
                            ? null
                            : () async {
                                Get.back();
                                isRetry.value = true;
                                await retryCallback();
                                isRetry.value = false;
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.redColorDonut,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24),
                        ),
                        child: Obx(() {
                          if (isRetry.value) {
                            return const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            );
                          }
                          return const Row(
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
                          );
                        }),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}