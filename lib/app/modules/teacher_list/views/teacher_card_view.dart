import 'package:flutter/material.dart';
import 'package:student_management/app/helpers/constants.dart';

class TeacherCardView extends StatelessWidget {
  final String teacherName;
  final String teacherId;
  final String subject;
  final String status;

  const TeacherCardView({
    super.key,
    required this.teacherName,
    required this.teacherId,
    required this.subject,
    required this.status,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.red;
      case 'on leave':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.secondaryColor,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side: Circle avatar with teacher initials
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.greenChip,
              child: Text(
                teacherName.isNotEmpty ? teacherName[0].toUpperCase() : "?",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ),

            const SizedBox(width: 10),

            // Right side: Teacher details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    teacherName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "ID: $teacherId",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Subject: $subject",
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.gray100,
                    ),
                  ),
                ],
              ),
            ),

            // Status indicator
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _getStatusColor(status)),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(status),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
