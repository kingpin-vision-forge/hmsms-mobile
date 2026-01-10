import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:student_management/app/helpers/constants.dart';
import '../controllers/create_teacher_controller.dart';

class CreateTeacherView extends GetView<CreateTeacherController> {
  const CreateTeacherView({super.key});

  static final _inputBorderRadius = BorderRadius.circular(8);

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
            elevation: 0,
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
                  onPressed: () => Get.back(),
                ),
                Obx(
                  () => Text(
                    controller.isEditMode.value ? 'Edit Staff' : 'New Staff',
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
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: 100,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First Name
              Obx(() => _buildInputField(
                hint: 'First Name',
                controller: controller.firstNameController,
                onChanged: controller.validateFirstName,
                errorText: controller.firstNameError.value,
              )),
              const SizedBox(height: 16),

              // Middle Name (optional)
              _buildInputField(
                hint: 'Middle Name (Optional)',
                controller: controller.middleNameController,
                onChanged: () {},
                errorText: null,
              ),
              const SizedBox(height: 16),

              // Last Name
              Obx(() => _buildInputField(
                hint: 'Last Name',
                controller: controller.lastNameController,
                onChanged: controller.validateLastName,
                errorText: controller.lastNameError.value,
              )),
              const SizedBox(height: 16),

              // Email
              Obx(() => _buildInputField(
                hint: 'Email',
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                onChanged: controller.validateEmail,
                errorText: controller.emailError.value,
              )),
              const SizedBox(height: 16),

              // Password - only show in create mode
              Obx(() {
                if (controller.isEditMode.value) {
                  return const SizedBox.shrink();
                }
                return Column(
                  children: [
                    Obx(() => _buildInputField(
                      hint: 'Password',
                      controller: controller.passwordController,
                      obscureText: true,
                      onChanged: controller.validatePassword,
                      errorText: controller.passwordError.value,
                    )),
                    const SizedBox(height: 16),
                  ],
                );
              }),

              // Phone
              Obx(() => _buildInputField(
                hint: 'Phone',
                controller: controller.phoneController,
                maxLength: 20,
                keyboardType: TextInputType.phone,
                onChanged: controller.validatePhone,
                errorText: controller.phoneError.value,
              )),
              const SizedBox(height: 16),

              // Address
              _buildInputField(
                hint: 'Address',
                controller: controller.addressController,
                onChanged: () {},
                errorText: null,
              ),
              const SizedBox(height: 16),

              // Employee Code
              Obx(() => _buildInputField(
                hint: 'Employee Code',
                controller: controller.employeeCodeController,
                onChanged: controller.validateEmployeeCode,
                errorText: controller.employeeCodeError.value,
              )),
              const SizedBox(height: 16),

              // Joined Date
              Obx(
                () => GestureDetector(
                  onTap: () => controller.selectJoinedDate(context),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: controller.joinedDateController,
                      decoration: InputDecoration(
                        labelText: 'Joined Date',
                        labelStyle: const TextStyle(
                          fontSize: 14,
                          color: AppColors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        filled: true,
                        fillColor: AppColors.secondaryColor,
                        suffixIcon: const Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: _inputBorderRadius,
                          borderSide: const BorderSide(color: AppColors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: _inputBorderRadius,
                          borderSide: const BorderSide(color: AppColors.black, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: _inputBorderRadius,
                          borderSide: const BorderSide(color: AppColors.black),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: _inputBorderRadius,
                          borderSide: const BorderSide(color: AppColors.errorColor),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        errorText: controller.joinedDateError.value,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: controller.isFormValid.value && !controller.isLoading.value
                        ? () => controller.isEditMode.value
                            ? controller.updateTeacher()
                            : controller.createTeacher()
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
                            controller.isEditMode.value ? 'Update Staff' : 'Create Staff',
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
    );
  }

  Widget _buildInputField({
    required String hint,
    required TextEditingController controller,
    required VoidCallback onChanged,
    required String? errorText,
    int? maxLength,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      maxLength: maxLength,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: (_) => onChanged(),
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: const TextStyle(
          fontSize: 14,
          color: AppColors.black,
          fontWeight: FontWeight.w600,
        ),
        filled: true,
        fillColor: AppColors.secondaryColor,
        border: OutlineInputBorder(
          borderRadius: _inputBorderRadius,
          borderSide: const BorderSide(color: AppColors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: _inputBorderRadius,
          borderSide: const BorderSide(color: AppColors.black, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: _inputBorderRadius,
          borderSide: const BorderSide(color: AppColors.black),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: _inputBorderRadius,
          borderSide: const BorderSide(color: AppColors.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: _inputBorderRadius,
          borderSide: const BorderSide(
            color: AppColors.errorColor,
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        counterText: '',
        errorText: errorText,
      ),
    );
  }
}
