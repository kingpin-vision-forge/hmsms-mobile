import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:student_management/app/helpers/constants.dart';

class FeesCardView extends StatelessWidget {
  final Map<String, dynamic> data;
  final int index;

  const FeesCardView({super.key, required this.data, required this.index});

  @override
  Widget build(BuildContext context) {
    final Color statusColor = data['status'] == 'Paid'
        ? Colors.green
        : data['status'] == 'Pending'
        ? Colors.orange
        : Colors.red;

    return GestureDetector(
      onTap: () {
        // ✅ Navigate to Fees Detail View with the student ID
        Get.toNamed(
          '/fees-detail', // your route name
          arguments: {'studentId': data['id']}, // pass the student id
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        color: AppColors.secondaryColor,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Top Row: Avatar + Student Info + Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey.shade200,
                        radius: 22,
                        child: Text(
                          data['name']
                              .toString()
                              .split(' ')
                              .map((e) => e[0])
                              .take(2)
                              .join(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${data['id']} • ${data['grade']}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor, width: 1),
                    ),
                    child: Text(
                      data['status'],
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              Divider(color: Colors.grey.shade300, height: 10),

              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text(data['feeType']),
                    labelStyle: const TextStyle(fontSize: 12),
                    backgroundColor: Colors.grey.shade200,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                  ),
                  Text(
                    "\$${data['amount']}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Due: ${data['dueDate']}",
                    style: const TextStyle(fontSize: 13),
                  ),
                  if (data['status'] == 'Overdue')
                    const Text(
                      "Past due",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 6),
              data['status'] == 'Paid'
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Paid: ${data['paymentDate']}",
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "${data['paymentMethod']}\n${data['txnId']}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.gray100,
                          ),
                        ),
                      ],
                    )
                  : const Text(
                      "Not paid",
                      style: TextStyle(fontSize: 13, color: AppColors.black),
                    ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 300.ms, delay: (index * 150).ms),
    );
  }
}
