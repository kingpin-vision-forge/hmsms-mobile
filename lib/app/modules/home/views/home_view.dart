import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/global.dart';
import 'package:student_management/app/helpers/widget/custom_drawer.dart';
import 'package:student_management/app/helpers/widget/global_fab.dart';
import 'package:student_management/app/helpers/widget/notification_badge.dart';
import 'package:student_management/app/helpers/widget/profile_image.dart';
import 'package:student_management/app/modules/bottom_navbar/views/bottom_navbar_view.dart';
import 'package:student_management/app/modules/home/views/statistic_view.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView {
  HomeView({super.key});
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final firstName = userData['username'] ?? '';
    final initial = (firstName.toString().isNotEmpty ? firstName[0] : '');
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.gray50,
        drawer: CustomDrawerMenu(),
        body: Stack(
          children: [
            // Blue curved background
            ClipPath(
              clipper: BlueHeaderClipper(),
              child: Container(
                height: 160,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.callBtn, AppColors.callBtn],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ),

            // AppBar contents over the blue clip
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Builder(
                          builder: (context) => IconButton(
                            icon: HugeIcon(
                              icon: HugeIcons.strokeRoundedMenu02,
                              color: AppColors.secondaryColor,
                              size: 30,
                            ),
                            onPressed: () => Scaffold.of(context).openDrawer(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Row(
                            children: [
                              Wrap(children: [NotificationBadge()]),
                              // const SizedBox(width: 12),
                              // User Avatar
                              // profileImage(initial, controller.signedUrl),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Welcome, Annie',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondaryColor,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ].animate(interval: 500.ms).fade(duration: 1000.ms),
                ),
              ),
            ),

            // Main content below curved header
            Padding(
              padding: const EdgeInsets.only(top: 140),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: DashboardStatistics()
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 800.ms)
                    .slideY(begin: 0.1, end: 0),
              ),
            ),
          ],
        ),
        floatingActionButton: GlobalFAB(),
      ),
    );
  }
}

// 🎨 Custom Clipper for blue curve
class BlueHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 50,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
