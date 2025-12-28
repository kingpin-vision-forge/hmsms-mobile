import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/global.dart';
import 'package:student_management/app/modules/login/controllers/login_controller.dart';
import 'package:student_management/app/modules/login/views/footer_view.dart';
import 'package:student_management/app/routes/app_pages.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.gray50, AppColors.callBtn],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 0.4 * (MediaQuery.of(context).size.height) / 10,
                    ),
                    Image.asset(
                      Constants.ASSETS['LOGIN_LOGO']!,
                      width: 200,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Column(
                        children: [
                          Animate(
                            child: Text(
                              'Welcome Back',
                              style: const TextStyle(
                                color: AppColors.black,
                                fontSize: 20,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Text(
                            'Sign in to your account to continue',

                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 14,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 15,
                        bottom: 100,
                      ),
                      child: Card(
                        color: Colors.white,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 20,
                            left: 20,
                            top: 15,
                            bottom: 15,
                          ),
                          child: Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "Login as",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Obx(
                                  () => Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () =>
                                                  controller
                                                          .selectedRole
                                                          .value =
                                                      "Admin",
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                    ),
                                                decoration: BoxDecoration(
                                                  gradient:
                                                      controller
                                                              .selectedRole
                                                              .value ==
                                                          "Admin"
                                                      ? const LinearGradient(
                                                          colors: [
                                                            AppColors.callBtn,
                                                            AppColors.callBtn,
                                                          ],
                                                          begin: Alignment
                                                              .centerLeft,
                                                          end: Alignment
                                                              .centerRight,
                                                        )
                                                      : null, // no gradient if not Admin
                                                  color:
                                                      controller
                                                              .selectedRole
                                                              .value ==
                                                          "Admin"
                                                      ? null
                                                      : AppColors.gray50,

                                                  borderRadius:
                                                      const BorderRadius.all(
                                                        Radius.circular(20),
                                                      ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "Admin",
                                                    style: TextStyle(
                                                      color:
                                                          controller
                                                                  .selectedRole
                                                                  .value ==
                                                              "Admin"
                                                          ? AppColors
                                                                .secondaryColor
                                                          : AppColors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          controller
                                                                  .selectedRole
                                                                  .value ==
                                                              "Admin"
                                                          ? FontWeight.w700
                                                          : FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () =>
                                                  controller
                                                          .selectedRole
                                                          .value =
                                                      "Teacher",
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                    ),
                                                decoration: BoxDecoration(
                                                  gradient:
                                                      controller
                                                              .selectedRole
                                                              .value ==
                                                          "Teacher"
                                                      ? const LinearGradient(
                                                          colors: [
                                                            AppColors.callBtn,
                                                            AppColors.callBtn,
                                                          ],
                                                          begin: Alignment
                                                              .centerLeft,
                                                          end: Alignment
                                                              .centerRight,
                                                        )
                                                      : null, // no gradient if not Admin
                                                  color:
                                                      controller
                                                              .selectedRole
                                                              .value ==
                                                          "Teacher"
                                                      ? null
                                                      : AppColors.gray50,

                                                  borderRadius:
                                                      const BorderRadius.all(
                                                        Radius.circular(20),
                                                      ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "Teacher",
                                                    style: TextStyle(
                                                      color:
                                                          controller
                                                                  .selectedRole
                                                                  .value ==
                                                              "Teacher"
                                                          ? AppColors
                                                                .secondaryColor
                                                          : AppColors.black,
                                                      fontWeight:
                                                          controller
                                                                  .selectedRole
                                                                  .value ==
                                                              "Teacher"
                                                          ? FontWeight.w700
                                                          : FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () =>
                                                  controller
                                                          .selectedRole
                                                          .value =
                                                      "Parent",
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                    ),
                                                decoration: BoxDecoration(
                                                  gradient:
                                                      controller
                                                              .selectedRole
                                                              .value ==
                                                          "Parent"
                                                      ? const LinearGradient(
                                                          colors: [
                                                            AppColors.callBtn,
                                                            AppColors.callBtn,
                                                          ],
                                                          begin: Alignment
                                                              .centerLeft,
                                                          end: Alignment
                                                              .centerRight,
                                                        )
                                                      : null, // no gradient if not Admin
                                                  color:
                                                      controller
                                                              .selectedRole
                                                              .value ==
                                                          "Parent"
                                                      ? null
                                                      : AppColors.gray50,

                                                  borderRadius:
                                                      const BorderRadius.all(
                                                        Radius.circular(20),
                                                      ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "Parent",
                                                    style: TextStyle(
                                                      color:
                                                          controller
                                                                  .selectedRole
                                                                  .value ==
                                                              "Parent"
                                                          ? AppColors
                                                                .secondaryColor
                                                          : AppColors.black,
                                                      fontWeight:
                                                          controller
                                                                  .selectedRole
                                                                  .value ==
                                                              "Parent"
                                                          ? FontWeight.w700
                                                          : FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5),

                                const Divider(
                                  color: AppColors.grayBorder,
                                  height: 1,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Email',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 10),

                                Obx(
                                  () => TextFormField(
                                    controller: controller.usernameController,
                                    autovalidateMode:
                                        controller
                                            .hasInteractedWithUsername
                                            .value
                                        ? AutovalidateMode.onUserInteraction
                                        : AutovalidateMode.disabled,
                                    onTap: () {
                                      controller
                                              .hasInteractedWithUsername
                                              .value =
                                          true;
                                    },
                                    validator: (value) =>
                                        validateUsername(value ?? ''),
                                    decoration: InputDecoration(
                                      // labelText: 'Email',
                                      hintText: 'Enter your email',
                                      hintStyle: const TextStyle(
                                        color: AppColors.placeholderTextColor,
                                        fontSize: 14,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          15.0,
                                        ),
                                        borderSide: const BorderSide(
                                          color: AppColors.black,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          15.0,
                                        ),
                                        borderSide: const BorderSide(
                                          color: AppColors.black,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          15.0,
                                        ),
                                        borderSide: const BorderSide(
                                          color: AppColors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Password',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Obx(
                                  () => TextFormField(
                                    controller: controller.passwordController,
                                    obscureText:
                                        controller.isPasswordHidden.value,
                                    autovalidateMode:
                                        controller
                                            .hasInteractedWithPassword
                                            .value
                                        ? AutovalidateMode.onUserInteraction
                                        : AutovalidateMode.disabled,
                                    onTap: () {
                                      controller
                                              .hasInteractedWithPassword
                                              .value =
                                          true;
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Password cannot be empty';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Enter your password',
                                      hintStyle: const TextStyle(
                                        color: AppColors.placeholderTextColor,
                                        fontSize: 14,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          15.0,
                                        ),
                                        borderSide: const BorderSide(
                                          color: AppColors.black,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          15.0,
                                        ),
                                        borderSide: const BorderSide(
                                          color: AppColors.black,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          15.0,
                                        ),
                                        borderSide: const BorderSide(
                                          color: AppColors.black,
                                        ),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          controller.isPasswordHidden.value
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                        ),
                                        onPressed:
                                            controller.togglePasswordVisibility,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),

                                //remember me and forgot password
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: Obx(
                                            () => Checkbox(
                                              value: controller
                                                  .isRememberMeChecked
                                                  .value,
                                              visualDensity:
                                                  VisualDensity.compact,
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              onChanged: (value) async {
                                                // Update the checkbox state
                                                controller
                                                        .isRememberMeChecked
                                                        .value =
                                                    value ?? false;
                                                // Store the preference in persistent storage
                                                await writeToStorage({
                                                  Constants
                                                          .STORAGE_KEYS['REMEMBER_ME']!:
                                                      controller
                                                          .isRememberMeChecked
                                                          .value,
                                                });
                                              },
                                              activeColor:
                                                  AppColors.primaryColor,
                                              checkColor:
                                                  AppColors.secondaryColor,
                                              side: const BorderSide(
                                                color: AppColors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width:
                                              5, // Adjust the width as needed
                                        ),
                                        const Text(
                                          'Remember me',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        // LauncherUtil.launchURL(
                                        //   Constants.LINKS['FORGOT_PASSWORD']!,
                                        // );
                                      },
                                      child: const Text(
                                        'Forgot password?',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // SizedBox(height: 20),
                                // // footer
                                // FooterView(),
                                // sign in button
                                const SizedBox(height: 10),
                                Obx(
                                  () => Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.callBtn,
                                          AppColors.callBtn,
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius: BorderRadius.circular(30),
                                      // Apply opacity to the entire container when terms not checked
                                      color: controller.isTermsChecked.value
                                          ? null
                                          : Colors.grey,
                                    ),
                                    child: ElevatedButton(
                                      onPressed: (!controller.isLoading.value)
                                          ? () {
                                              controller.signIn(formKey);
                                            }
                                          : null, // Button disabled when isTermsChecked is false or while loading
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors
                                            .transparent, // Make the button background transparent
                                        shadowColor: Colors
                                            .transparent, // Remove shadow to avoid overlap
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        minimumSize: const Size(
                                          double.infinity,
                                          50,
                                        ),
                                      ),
                                      child: controller.isLoading.value
                                          ? const CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ), // Loader color
                                            )
                                          : const Text(
                                              'Sign in',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: 10),
                                // Center(
                                //   child: RichText(
                                //     textAlign: TextAlign.start,
                                //     text: TextSpan(
                                //       style: const TextStyle(
                                //         fontSize: 12,
                                //         fontFamily: 'Montserrat',
                                //         color: AppColors.normalTextColor,
                                //       ),
                                //       children: [
                                //         const TextSpan(
                                //           text: 'Don\'t have an account? ',
                                //         ),
                                //         TextSpan(
                                //           text: 'Signup',
                                //           style: const TextStyle(
                                //             fontWeight: FontWeight.w700,
                                //             fontSize: 14,
                                //             color: AppColors.primaryColor,
                                //             decoration:
                                //                 TextDecoration.underline,
                                //           ),
                                //           recognizer: TapGestureRecognizer()
                                //             ..onTap = () {
                                //               // LauncherUtil.launchURL(
                                //               //   Constants
                                //               //       .LINKS['TERMS_CONDITION']!,
                                //               // );
                                //             },
                                //         ),
                                //       ],
                                //     ),
                                //     textScaler: MediaQuery.textScalerOf(context)
                                //         .clamp(
                                //           minScaleFactor: Constants
                                //               .CONFIG['TEXT_MIN_SCALE_FACTOR']!,
                                //           maxScaleFactor: Constants
                                //               .CONFIG['TEXT_MAX_SCALE_FACTOR']!,
                                //         ),
                                //   ),
                                // ),
                              
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ].animate(interval: 500.ms).fade(duration: 1000.ms),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Painter for Duo-Color Curved Background
class DuoColorBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // White/cream color (top section)
    final Paint topPaint = Paint()..color = AppColors.gray50;

    // Primary gradient color (bottom section)
    final Paint primaryPaint = Paint()
      ..shader =
          const LinearGradient(
            colors: [AppColors.callBtn, AppColors.callBtn],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(
            Rect.fromLTWH(
              0,
              size.height * 0.35,
              size.width,
              size.height * 0.65,
            ),
          );

    Path topPath = Path();
    topPath.lineTo(0, 0);
    topPath.lineTo(0, size.height * 0.4);

    // Create smooth curve
    topPath.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.68,
      size.width,
      size.height * 0.4,
    );

    topPath.lineTo(size.width, 0);
    topPath.close();

    canvas.drawPath(topPath, topPaint);

    // Draw the primary gradient section
    Path primaryPath = Path();
    primaryPath.moveTo(0, size.height * 0.5);

    // Match the curve from top path
    primaryPath.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.68,
      size.width,
      size.height * 0.5,
    );

    primaryPath.lineTo(size.width, size.height);
    primaryPath.lineTo(0, size.height);
    primaryPath.close();

    canvas.drawPath(primaryPath, primaryPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
