import 'package:flutter/material.dart';
import 'package:student_management/app/helpers/constants.dart';

Future<void> showDownloadBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: AppColors.gray50,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Download As',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 10),
            const Divider(color: AppColors.grayBorder, height: 1),

            // 🔹 Excel Option
            ListTile(
              leading: const Icon(
                Icons.table_chart,
                color: AppColors.primaryColor,
              ),
              title: const Text(
                'Excel',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Add Excel download logic here
              },
            ),

            // 🔹 PDF Option
            ListTile(
              leading: const Icon(
                Icons.picture_as_pdf,
                color: AppColors.primaryColor,
              ),
              title: const Text(
                'PDF',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Add PDF download logic here
              },
            ),
          ],
        ),
      );
    },
  );
}
