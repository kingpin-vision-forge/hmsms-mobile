import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/routes/app_pages.dart';

import '../controllers/subject_detail_controller.dart';

class SubjectDetailView extends GetView {
  SubjectDetailView({super.key});

  final SubjectDetailController controller = Get.put(SubjectDetailController());
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
                        Get.offAllNamed(Routes.SUBJECT_LIST);
                      },
                    ),
                    Text(
                          'Subject Details',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.left,
                        )
                        .animate()
                        .fadeIn(delay: 50.ms, duration: 300.ms)
                        .slideY(begin: 0.1, end: 0),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    controller.passEditSubjectArguments();
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

        final subjectDetail = controller.subjectDetailData.value?.data;
        if (subjectDetail == null) {
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
                  'No subject details available',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.black.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          );
        }

        final classInfo = subjectDetail.classInfo;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                                  0.15,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                HugeIcons.strokeRoundedBook03,
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
                                    subjectDetail.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.secondaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Code: ${subjectDetail.code}',
                                    style: TextStyle(
                                      fontSize: 14,
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
                              icon: Icons.class_,
                              label: 'Class',
                              value: classInfo.name.isNotEmpty
                                  ? classInfo.name
                                  : 'N/A',
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: AppColors.secondaryColor.withOpacity(0.3),
                            ),
                            _buildInfoItem(
                              icon: Icons.qr_code,
                              label: 'Class Code',
                              value: classInfo.code.isNotEmpty
                                  ? classInfo.code
                                  : 'N/A',
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 100.ms, duration: 250.ms)
                  .slideY(begin: 0.2, end: 0),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Subject Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      Icons.book_outlined,
                      'Subject Name',
                      subjectDetail.name.isNotEmpty
                          ? subjectDetail.name
                          : 'N/A',
                    ),
                    _buildDetailRow(
                      Icons.confirmation_number_outlined,
                      'Subject Code',
                      subjectDetail.code.isNotEmpty
                          ? subjectDetail.code
                          : 'N/A',
                    ),
                    _buildDetailRow(
                      Icons.school_outlined,
                      'Class',
                      classInfo.name.isNotEmpty ? classInfo.name : 'N/A',
                    ),
                    _buildDetailRow(
                      Icons.qr_code_2_outlined,
                      'Class Code',
                      classInfo.code.isNotEmpty ? classInfo.code : 'N/A',
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 50.ms, duration: 250.ms),
            ].animate(interval: 30.ms).fade(duration: 200.ms),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
