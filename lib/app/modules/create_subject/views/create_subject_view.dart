import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/widget/global_fab.dart';
import 'package:student_management/app/routes/app_pages.dart';

import '../controllers/create_subject_controller.dart';

class CreateSubjectView extends GetView<CreateSubjectController> {
  const CreateSubjectView({super.key});
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.chevron_left,
                    size: 36,
                    color: AppColors.secondaryColor,
                  ),
                  onPressed: () {
                    Get.offAllNamed(Routes.HOME);
                  },
                ),
                Obx(
                  () =>
                      Text(
                            controller.isEditMode.value
                                ? 'Edit Subject'
                                : 'New Subject',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.left,
                          )
                          .animate()
                          .fadeIn(delay: 50.ms, duration: 300.ms)
                          .slideY(begin: 0.1, end: 0),
                ),
              ],
            ),
            foregroundColor: AppColors.secondaryColor,
            automaticallyImplyLeading: false,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: 100,
          ),
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                const SizedBox(height: 5),

                // subject name
                Obx(
                  () => TextFormField(
                    controller: controller.nameController,
                    autovalidateMode: controller.hasInteractedWithName.value
                        ? AutovalidateMode.onUserInteraction
                        : AutovalidateMode.disabled,
                    onTap: () {
                      controller.hasInteractedWithName.value = true;
                    },
                    validator: (value) => controller.validateName(value ?? ''),
                    decoration: InputDecoration(
                      label: const Text('Subject Name'),
                      labelStyle: TextStyle(
                        fontSize: 14,
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(color: AppColors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(color: AppColors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(color: AppColors.black),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // subject code
                Obx(
                  () => TextFormField(
                    controller: controller.codeController,
                    autovalidateMode: controller.hasInteractedWithCode.value
                        ? AutovalidateMode.onUserInteraction
                        : AutovalidateMode.disabled,
                    onTap: () {
                      controller.hasInteractedWithCode.value = true;
                    },
                    validator: (value) => controller.validateCode(value ?? ''),
                    decoration: InputDecoration(
                      label: const Text('Subject Code'),
                      labelStyle: TextStyle(
                        fontSize: 14,
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(color: AppColors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(color: AppColors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(color: AppColors.black),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // dropdown to select class
                Obx(
                  () => controller.isClassLoading.value
                      ? Container(
                          width: MediaQuery.of(context).size.width - 40,
                          height: 60,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.black),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.callBtn,
                            ),
                          ),
                        )
                      : DropdownButtonFormField<String>(
                          value: controller.selectedClassId.value.isEmpty
                              ? null
                              : controller.selectedClassId.value,
                          decoration: InputDecoration(
                            labelText: 'Select Class',
                            labelStyle: const TextStyle(
                              fontSize: 14,
                              color: AppColors.black,
                              fontWeight: FontWeight.w600,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(
                                color: AppColors.black,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(
                                color: AppColors.black,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          dropdownColor: AppColors.secondaryColor,
                          items: controller.classList
                              .map(
                                (classItem) => DropdownMenuItem<String>(
                                  value: classItem.id,
                                  child: Text(classItem.name),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              controller.selectedClassId.value = value;
                              controller.checkFormValidity();
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a class';
                            }
                            return null;
                          },
                        ),
                ),

                const SizedBox(height: 20),
                // create/update subject button
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed:
                          controller.isFormValid.value &&
                              !controller.isLoading.value
                          ? () => controller.isEditMode.value
                                ? controller.updateSubject()
                                : controller.createSubject()
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.callBtn,
                        disabledBackgroundColor: AppColors.gray50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(
                              color: AppColors.black,
                            )
                          : Text(
                              controller.isEditMode.value
                                  ? 'Update Subject'
                                  : 'Create Subject',
                              style: const TextStyle(
                                color: AppColors.secondaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
              ].animate(interval: 30.ms).fade(duration: 200.ms),
            ),
          ),
        ),
      ),

      floatingActionButton: GlobalFAB(),
    );
  }
}
