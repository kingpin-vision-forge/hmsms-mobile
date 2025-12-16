import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget imagePreview(Widget child, {bool enabled = true}) {
  if (!enabled) {
    return child;
  }
  return GestureDetector(
      onTap: () {
        Get.generalDialog(
          pageBuilder: (context, animation, secondaryAnimation) {
            return ScaleTransition(
              scale: Tween<double>(
                begin: 0.0,
                end: 1.0,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              )),
              child: FadeTransition(
                opacity: Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                )),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Center(child: child),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          barrierDismissible: true,
          barrierLabel: '',
          barrierColor: Colors.black.withOpacity(0.70),
          transitionDuration: const Duration(milliseconds: 300),
        );
      },
      child: child);
}