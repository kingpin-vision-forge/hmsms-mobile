import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/modules/fees_detail/controllers/fees_detail_controller.dart';

class StudentInfoView extends StatelessWidget {
  final FeesDetailController controller = Get.find<FeesDetailController>();

  StudentInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        mainAxisSize: MainAxisSize.min, // <-- fix infinite height
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.callBtn,
                radius: 30,
                child: Text(
                  controller.getStudentInitials(
                    controller.studentInfo['name'] ?? '',
                  ),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.studentInfo['name'] ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${controller.studentInfo['id']} • Roll: ${controller.studentInfo['rollNumber']}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade300),
          const SizedBox(height: 12),
          _buildInfoRow(
            Icons.school,
            'Class',
            '${controller.studentInfo['grade']} - ${controller.studentInfo['section']}',
          ),
          const SizedBox(height: 10),
          _buildInfoRow(
            Icons.phone,
            'Phone',
            controller.studentInfo['phone'] ?? '',
          ),
          const SizedBox(height: 10),
          _buildInfoRow(
            Icons.email,
            'Email',
            controller.studentInfo['email'] ?? '',
          ),
          const SizedBox(height: 10),
          _buildInfoRow(
            Icons.person,
            'Parent',
            '${controller.studentInfo['parentName']} • ${controller.studentInfo['parentPhone']}',
          ),
        ],
      ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.callBtn),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
