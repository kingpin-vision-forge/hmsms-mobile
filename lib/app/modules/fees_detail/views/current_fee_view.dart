import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/modules/fees_detail/controllers/fees_detail_controller.dart';

class CurrentFeeView extends StatelessWidget {
  final FeesDetailController controller = Get.find<FeesDetailController>();

  CurrentFeeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
          elevation: 1,
          color: AppColors.secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // <-- prevents infinite height
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Current Fee',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: controller
                            .getStatusColor(
                              controller.currentFee['status'] ?? '',
                            )
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: controller.getStatusColor(
                            controller.currentFee['status'] ?? '',
                          ),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        controller.currentFee['status'] ?? '',
                        style: TextStyle(
                          color: controller.getStatusColor(
                            controller.currentFee['status'] ?? '',
                          ),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      controller.currentFee['feeType'] ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '\$${controller.currentFee['amount']}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.callBtn,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Term: ${controller.currentFee['term']}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      'Due: ${controller.currentFee['dueDate']}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms, delay: 50.ms)
        .slideY(begin: 0.1, end: 0);
  }
}
