import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_management/app/helpers/constants.dart';

class StudentCardView extends StatelessWidget {
  final String studentName;
  final String studentId;
  final String grade;
  final String section;
  final String rollNumber;
  final String attendance;
  final String status;

  const StudentCardView({
    super.key,
    required this.studentName,
    required this.studentId,
    required this.status,
    required this.grade,
    required this.section,
    required this.attendance,
    required this.rollNumber,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'absent':
        return Colors.orange;
      case 'present':
        return Colors.green;
      case 'inactive':
        return Colors.red;
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
            // 🔹 Left side: Circle avatar with student initials
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.greenChip,
              child: Text(
                studentName.isNotEmpty ? studentName[0].toUpperCase() : "?",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ),

            const SizedBox(width: 12),

            // 🔹 Middle: Student details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Student name
                  Text(
                    studentName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Student ID and Roll No
                  Row(
                    children: [
                      Text(
                        "ID: $studentId",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Roll: $rollNumber",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Grade and Section
                  Row(
                    children: [
                      Text(
                        "Grade: $grade",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Section: $section",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Attendance
                  Text(
                    "Attendance: $attendance",
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ),

            // 🔹 Right side: Status indicator
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
