import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/routes/app_pages.dart';

import '../controllers/student_detail_controller.dart';

class StudentDetailView extends GetView {
  StudentDetailView({super.key});

  final StudentDetailController controller = Get.put(StudentDetailController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.callBtn, AppColors.callBtn],
              begin: Alignment.centerLeft,
              end: Alignment.topRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.3),
                offset: const Offset(0, 3),
                blurRadius: 6,
              ),
            ],
          ),
          child: AppBar(
            toolbarHeight: 70,
            elevation: 0, // remove extra shadow from AppBar itself
            backgroundColor: Colors.transparent,
            leadingWidth: double.infinity,
            leading: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.chevron_left,
                        size: 36,
                        color: AppColors.secondaryColor,
                      ),
                      onPressed: () {
                        Get.offAllNamed(Routes.STUDENT_LIST);
                      },
                    ),
                    Text(
                          'Student Details',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.left,
                        )
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 800.ms)
                        .slideY(begin: 0.1, end: 0),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    // Add your edit action here
                    controller.passEditStudentArguments();
                  },
                  icon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedPencilEdit02,
                    color: AppColors.secondaryColor,
                    size: 28,
                  ),
                ),
              ],
            ),
            foregroundColor: AppColors.secondaryColor,
            automaticallyImplyLeading: false,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.black),
          );
        }

        if (controller.studentDetailData.value == null ||
            controller.studentDetailData.value!.data == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppColors.black.withOpacity(0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'No student details available',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.black.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          );
        }

        final studentData = controller.studentDetailData.value!.data!;
        final attendance = studentData.attendance ?? [];

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Student Info Card
              Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.callBtn, AppColors.callBtn],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.callBtn.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.secondaryColor.withOpacity(
                                  0.2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.person,
                                color: AppColors.secondaryColor,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${studentData.firstName ?? 'N/A'} ${studentData.middleName ?? ''} ${studentData.lastName ?? 'N/A'}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.secondaryColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    studentData.className ?? 'N/A',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.secondaryColor
                                          .withOpacity(0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(
                          color: AppColors.secondaryColor,
                          thickness: 0.5,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildInfoItem(
                              icon: Icons.badge_outlined,
                              label: 'Admission No',
                              value: studentData.admissionNumber ?? 'N/A',
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: AppColors.secondaryColor.withOpacity(0.3),
                            ),
                            _buildInfoItem(
                              icon: Icons.meeting_room_outlined,
                              label: 'Section',
                              value: studentData.sectionName ?? 'N/A',
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 100.ms, duration: 600.ms)
                  .slideY(begin: 0.2, end: 0),

              // Student Information Section
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: const Text(
                  'Student Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
              ).animate().fadeIn(delay: 200.ms, duration: 600.ms),

              // Student Details
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children:
                      [
                            _buildDetailRow(
                              Icons.email_outlined,
                              'Email',
                              studentData.email ?? 'N/A',
                            ),
                            _buildDetailRow(
                              Icons.phone_outlined,
                              'Phone',
                              studentData.phone ?? 'N/A',
                            ),
                            _buildDetailRow(
                              Icons.location_on_outlined,
                              'Address',
                              studentData.address ?? 'N/A',
                            ),
                            _buildDetailRow(
                              Icons.cake_outlined,
                              'Date of Birth',
                              studentData.dateOfBirth ?? 'N/A',
                            ),
                            _buildDetailRow(
                              Icons.person_outline,
                              'Gender',
                              studentData.gender ?? 'N/A',
                            ),
                          ]
                          .animate(interval: 50.ms)
                          .fadeIn(delay: 250.ms, duration: 500.ms),
                ),
              ),

              // Parent Information Section
              if (studentData.parentName != null &&
                  studentData.parentName!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                  child: const Text(
                    'Parent Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                ).animate().fadeIn(delay: 300.ms, duration: 600.ms),

              if (studentData.parentName != null &&
                  studentData.parentName!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children:
                        [
                              _buildDetailRow(
                                Icons.person_outline,
                                'Name',
                                studentData.parentName ?? 'N/A',
                              ),
                              _buildDetailRow(
                                Icons.phone_outlined,
                                'Mobile',
                                studentData.parentMobile ?? 'N/A',
                              ),
                            ]
                            .animate(interval: 50.ms)
                            .fadeIn(delay: 350.ms, duration: 500.ms),
                  ),
                ),

              // Attendance Section Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Attendance',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.callBtn.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${attendance.length} Records',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.callBtn,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 400.ms, duration: 600.ms),

              // Attendance Records
              if (attendance.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 64,
                          color: AppColors.black.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No attendance records available',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.black.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: attendance.length,
                  itemBuilder: (context, index) {
                    final record = attendance[index];
                    return _buildAttendanceCard(record, index);
                  },
                ),
            ].animate(interval: 100.ms).fade(duration: 500.ms),
          ),
        );
      }),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppColors.secondaryColor, size: 24),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.secondaryColor.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.secondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.callBtn),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.black.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard(dynamic record, int index) {
    final statusColor = record.status == 'Present'
        ? Colors.green
        : record.status == 'Absent'
        ? Colors.red
        : Colors.orange;

    return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.secondaryColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Status Indicator
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Icon(
                      record.status == 'Present'
                          ? Icons.check_circle
                          : record.status == 'Absent'
                          ? Icons.cancel
                          : Icons.help,
                      color: statusColor,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Attendance Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatDate(record.date),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        record.status ?? 'N/A',
                        style: TextStyle(
                          fontSize: 13,
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (record.remarks != null && record.remarks!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'Remarks: ${record.remarks}',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.black.withOpacity(0.6),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(delay: (400 + (index * 50)).ms, duration: 500.ms)
        .slideX(begin: 0.2, end: 0);
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }
}
