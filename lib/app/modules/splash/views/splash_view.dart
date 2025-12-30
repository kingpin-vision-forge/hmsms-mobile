import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/modules/splash/controllers/splash_controller.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    SplashController controller = Get.put(SplashController());

    // Reduced delay for faster navigation
    Future.delayed(const Duration(seconds: 1), () async {
      await controller.checkSession();
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Spacer(),
              Image.asset(
                Constants.ASSETS['LOGIN_LOGO']!,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 24),
              const Spacer(),
              // Bottom Text
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Text(
                  'Mangalore Educational Trust © 2025',
                  style: TextStyle(
                    color: AppColors.gray800,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
