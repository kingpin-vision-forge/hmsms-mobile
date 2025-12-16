import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/modules/fees_detail/controllers/fees_detail_controller.dart';

class FeesSummaryView extends StatelessWidget {
  final FeesDetailController controller = Get.find<FeesDetailController>();

  FeesSummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.secondaryColor,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // important to avoid infinite height
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fees Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryItem(
                  'Total Fees',
                  '\$${controller.feesSummary['totalFees']}',
                  Colors.blue,
                ),
                const SizedBox(width: 12),
                _buildSummaryItem(
                  'Paid',
                  '\$${controller.feesSummary['paidAmount']}',
                  Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryItem(
                  'Pending',
                  '\$${controller.feesSummary['pendingAmount']}',
                  Colors.orange,
                ),
                const SizedBox(width: 12),
                _buildSummaryItem(
                  'Overdue',
                  '\$${controller.feesSummary['overdueAmount']}',
                  Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
