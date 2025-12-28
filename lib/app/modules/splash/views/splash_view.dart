import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/modules/splash/controllers/splash_controller.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    SplashController controller = Get.put(SplashController());

    // Delay navigation
    Future.delayed(const Duration(seconds: 4), () async {
      await controller.checkSession();
    });

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.callBtn,
              AppColors.gray50, // Your app's primary color
              // Custom blue
            ],
            begin: Alignment.bottomCenter, // Start from bottom
            end: Alignment.topCenter, // Go to top
          ),
        ),
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

              // Animated Text
              // DefaultTextStyle(
              //   style: const TextStyle(
              //     fontSize: 18,
              //     fontWeight: FontWeight.w700,
              //     color: Colors.white,
              //   ),
              //   child: AnimatedTextKit(
              //     animatedTexts: [
              //       TypewriterAnimatedText(
              //         'make your work life easier',
              //         speed: Duration(milliseconds: 100),
              //       ),
              //     ],
              //     totalRepeatCount: 1,
              //     pause: Duration(milliseconds: 1000),
              //     displayFullTextOnTap: true,
              //     stopPauseOnTap: true,
              //   ),
              // ),

              const Spacer(),
              // Bottom Text
              const Padding(
                padding: EdgeInsets.only(bottom: 24.0),
                child: Text(
                  'Mangalore Educational Trust © 2025',
                  style: TextStyle(
                    color: Colors.white,
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
