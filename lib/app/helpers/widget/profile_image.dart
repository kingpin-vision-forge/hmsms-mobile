import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/widget/image_preview.dart';

Widget profileImage(String initial, RxString signedUrl) {
  return Obx(
    () => Container(
      width: 50,
      height: 50,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.antiAlias,
      child: signedUrl.value.isNotEmpty
          ? imagePreview(
              enabled: true,
              Obx(
                () => Image.network(
                  signedUrl.value,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.black,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.red,
                      child: Text(
                        initial.isNotEmpty ? initial : '?',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          : CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.redColorDonut,
              child: Text(
                initial.isNotEmpty ? initial : '?',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
    ),
  );
}