import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/widget/global_fab.dart';
import 'package:student_management/app/modules/create_class/controllers/create_class_controller.dart';

class CreateClassView extends GetView<CreateClassController> {
  const CreateClassView({super.key});
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
                    Get.back();
                  },
                ),
                Obx(
                  () => Text(
                        controller.isEditMode.value ? 'Edit Class' : 'New Class',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.left,
                      )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 800.ms)
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

                // class name
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
                      label: Text('Class Name'),
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
                //class code
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
                      label: Text('Class Code'),
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
                // // school id
                // Obx(
                //   () => TextFormField(
                //     controller: controller.schoolIdController,
                //     autovalidateMode: controller.hasInteractedWithSchoolId.value
                //         ? AutovalidateMode.onUserInteraction
                //         : AutovalidateMode.disabled,
                //     onTap: () {
                //       controller.hasInteractedWithSchoolId.value = true;
                //     },
                //     validator: (value) =>
                //         controller.validateSchoolId(value ?? ''),
                //     decoration: InputDecoration(
                //       label: Text('School ID'),
                //       labelStyle: TextStyle(
                //         fontSize: 14,
                //         color: AppColors.black,
                //         fontWeight: FontWeight.w600,
                //       ),
                //       border: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(15.0),
                //         borderSide: const BorderSide(color: AppColors.black),
                //       ),
                //       focusedBorder: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(15.0),
                //         borderSide: const BorderSide(color: AppColors.black),
                //       ),
                //       enabledBorder: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(15.0),
                //         borderSide: const BorderSide(color: AppColors.black),
                //       ),
                //     ),
                //   ),
                // ),

                // const SizedBox(height: 25),
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed:
                          controller.isFormValid.value &&
                              !controller.isLoading.value
                          ? () => controller.isEditMode.value
                                ? controller.updateClass()
                                : controller.createClass()
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
                                  ? 'Update Class'
                                  : 'Create Class',
                              style: const TextStyle(
                                color: AppColors.secondaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      floatingActionButton: GlobalFAB(),
    );
  }
}
