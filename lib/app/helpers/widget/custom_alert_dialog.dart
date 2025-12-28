import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_management/app/helpers/constants.dart';

class CustomAlertDialog extends GetView {
  final String title;
  final IconData icon;
  final String content;
  final String cta;
  final VoidCallback onBack;

  const CustomAlertDialog({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
    required this.cta,
    required this.onBack,
  });

  Widget renderIcon(IconData iconPath) {
    return Icon(
      iconPath,
      size: 60,
      color: AppColors.black,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        backgroundColor: AppColors.secondaryColor,
        contentPadding: EdgeInsets.zero,
        content: Padding(
          padding: const EdgeInsets.fromLTRB(8, 25, 8, 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              renderIcon(icon),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.normalTextColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                content,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.normalTextColor,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.black, // Background color
                padding:
                    const EdgeInsets.symmetric(vertical: 16), // Vertical padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Border radius
                ),
              ),
              onPressed: () {
                onBack();
              },
              child: Text(
                cta,
                style: const TextStyle(
                  color: AppColors.secondaryColor, // Text color
                  fontSize: 20, // Text size
                  height: 1.3, // Text height
                  fontWeight: FontWeight.w700, // Font weight
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}