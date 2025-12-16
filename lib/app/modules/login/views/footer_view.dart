import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:student_management/app/helpers/constants.dart';

class FooterView extends GetView {
  const FooterView({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // OR divider
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: Container(height: 1, color: AppColors.grayBorder)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'OR',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(child: Container(height: 1, color: AppColors.grayBorder)),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Google
            SizedBox(
              width: 50,
              height: 50,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero, // remove extra padding
                  shape: const CircleBorder(), // make it circular
                  backgroundColor: AppColors.secondaryColor,
                  side: BorderSide(color: AppColors.grayBorder),
                ),
                child: const HugeIcon(
                  icon: HugeIcons.strokeRoundedGoogle,
                  size: 25,
                  color: AppColors.black,
                ),
              ),
            ),
            const SizedBox(width: 15),

            // Instagram
            SizedBox(
              width: 50,
              height: 50,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: const CircleBorder(),
                  backgroundColor: AppColors.secondaryColor,
                  side: BorderSide(color: AppColors.grayBorder),
                ),
                child: const HugeIcon(
                  icon: HugeIcons.strokeRoundedInstagram,
                  size: 25,
                  color: AppColors.black,
                ),
              ),
            ),
            const SizedBox(width: 15),

            // Facebook
            SizedBox(
              width: 50,
              height: 50,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: const CircleBorder(),
                  backgroundColor: AppColors.secondaryColor,
                  side: BorderSide(color: AppColors.grayBorder),
                ),
                child: const HugeIcon(
                  icon: HugeIcons.strokeRoundedFacebook02,
                  size: 25,
                  color: AppColors.black,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
