import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/routes/app_pages.dart';

import '../controllers/class_detail_controller.dart';

class ClassDetailView extends GetView {
  ClassDetailView({super.key});

  final controller = Get.put(ClassDetailController());
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
                        Get.offAllNamed(Routes.SECTION_LIST);
                      },
                    ),
                    Text(
                          'Class Details',
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
                    controller.passEditClassArguments();
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

        if (controller.classDetailData.value == null) {
          return const Center(
            child: Text(
              'No data available',
              style: TextStyle(fontSize: 16, color: AppColors.black),
            ),
          );
        }

        final classData = controller.classDetailData.value!;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Class Information Card
                Card(
                  color: AppColors.secondaryColor,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Class Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        const Divider(),
                        const SizedBox(height: 8),
                        _buildInfoRow('Name', classData.name ?? 'N/A'),
                        const SizedBox(height: 8),
                        _buildInfoRow('Code', classData.code ?? 'N/A'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // School Information Card
                if (classData.school != null) ...[
                  Card(
                    color: AppColors.secondaryColor,
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'School Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const Divider(),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            'Name',
                            classData.school!.name ?? 'N/A',
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            'Address',
                            classData.school!.address ?? 'N/A',
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            'Phone',
                            classData.school!.phone ?? 'N/A',
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            'Email',
                            classData.school!.email ?? 'N/A',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Sections Card
                Card(
                  color: AppColors.secondaryColor,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Sections',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${classData.sections?.length ?? 0}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        if (classData.sections == null ||
                            classData.sections!.isEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text('No sections available'),
                          )
                        else
                          ...classData.sections!.map(
                            (section) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              // leading: CircleAvatar(
                              //   child: Text(
                              //     section.name?.substring(0, 1).toUpperCase() ?? 'S',
                              //   ),
                              // ),
                              title: Text('section ${section.name ?? 'N/A'}'),
                              titleTextStyle: TextStyle(
                                color: AppColors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Subjects Card
                Card(
                  color: AppColors.secondaryColor,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Subjects',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${classData.subjects?.length ?? 0}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        if (classData.subjects == null ||
                            classData.subjects!.isEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text('No subjects available'),
                          )
                        else
                          ...classData.subjects!.map(
                            (subject) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(subject.name ?? 'N/A'),
                              subtitle: Text('Code: ${subject.code ?? 'N/A'}'),
                              titleTextStyle: TextStyle(
                                color: AppColors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              subtitleTextStyle: TextStyle(
                                color: AppColors.black.withOpacity(0.6),
                                fontSize: 14,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Students Card
                Card(
                  color: AppColors.secondaryColor,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Students',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${classData.students?.length ?? 0}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        if (controller.classDetailData.value!.students.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text('No students available'),
                          )
                        else
                          ...classData.students!.map((student) {
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(student.studentName ?? 'N/A'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Admission No: ${student.admissionNumber ?? 'N/A'}',
                                  ),
                                  Text(
                                    'Class: ${student.className ?? 'N/A'} - Section: ${student.sectionName ?? 'N/A'}',
                                  ),
                                ],
                              ),
                              titleTextStyle: TextStyle(
                                color: AppColors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              subtitleTextStyle: TextStyle(
                                color: AppColors.black.withOpacity(0.6),
                                fontSize: 14,
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
      ],
    );
  }
}
