import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../controllers/create_parent_controller.dart';

class CreateParentView extends GetView<CreateParentController> {
  const CreateParentView({super.key});

  // Cache all static values
  static final _inputBorderRadius = BorderRadius.circular(8);
  static final _buttonBorderRadius = BorderRadius.circular(15);

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
                  () =>
                      Text(
                            controller.isEditMode.value
                                ? 'Edit Parent'
                                : 'New Parent',
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
              _buildInputField(
                hint: 'First Name',
                controller: controller.firstNameController,
                onChanged: controller.validateFirstName,
                errorTextGetter: () => controller.firstNameError.value,
              ),
              const SizedBox(height: 16),

              // Last Name
              _buildInputField(
                hint: 'Last Name',
                controller: controller.lastNameController,
                onChanged: controller.validateLastName,
                errorTextGetter: () => controller.lastNameError.value,
              ),
              const SizedBox(height: 16),

              // Email
              _buildInputField(
                hint: 'Email',
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                onChanged: controller.validateEmail,
                errorTextGetter: () => controller.emailError.value,
              ),
              const SizedBox(height: 16),

              // Password
              if (controller.isEditMode.value == false)
                _buildInputField(
                  hint: 'Password',
                  controller: controller.passwordController,
                  obscureText: true,
                  onChanged: controller.validatePassword,
                  errorTextGetter: () => controller.passwordError.value,
                ),
              if (controller.isEditMode.value == false)
                const SizedBox(height: 16),

              // Phone
              _buildInputField(
                hint: 'Phone',
                controller: controller.phoneController,
                maxLength: 20,
                keyboardType: TextInputType.phone,
                onChanged: controller.validatePhone,
                errorTextGetter: () => controller.phoneError.value,
              ),
              const SizedBox(height: 16),

              // Address
              _buildInputField(
                hint: 'Address',
                controller: controller.addressController,
                onChanged: controller.validateAddress,
                errorTextGetter: () => controller.addressError.value,
              ),
              const SizedBox(height: 16),

              // WhatsApp Opt-in
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'WhatsApp Opt-In',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                value: controller.isWhatsappOptIn.value,
                activeColor: AppColors.callBtn,
                onChanged: (val) {
                  controller.isWhatsappOptIn.value = val;
                  controller.validateWhatsappNumber();
                },
              ),
              const SizedBox(height: 8),

              // WhatsApp Number
              _buildInputField(
                hint: 'WhatsApp Number',
                controller: controller.whatsappNumberController,
                keyboardType: TextInputType.phone,
                onChanged: controller.validateWhatsappNumber,
                errorTextGetter: () => controller.whatsappNumberError.value,
              ),
              const SizedBox(height: 16),

              // Students Multi-select
              Obx(() {
                if (controller.isStudentLoading.value) {
                  return Container(
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.black),
                      borderRadius: _buttonBorderRadius,
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.callBtn,
                      ),
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MultiSelectDialogField(
                      items: controller.studentList
                          .map((s) => MultiSelectItem<String>(s.id, s.name))
                          .toList(),
                      title: const Text('Select Students'),
                      selectedColor: AppColors.callBtn,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.black),
                        borderRadius: _buttonBorderRadius,
                      ),
                      buttonIcon: const Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.black,
                      ),
                      buttonText: const Text(
                        'Select Students',
                        style: TextStyle(color: AppColors.black, fontSize: 16),
                      ),
                      onConfirm: (values) {
                        controller.selectStudent.value = values.cast<String>();
                        controller.validateStudentSelection();
                      },
                      initialValue: controller.selectStudent,
                    ),
                    if (controller.studentError.value != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          controller.studentError.value!,
                          style: const TextStyle(
                            color: AppColors.errorColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                );
              }),
              const SizedBox(height: 24),

              // Submit Button
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed:
                        controller.isFormValid.value &&
                            !controller.isLoading.value
                        ? () => controller.isEditMode.value
                              ? controller.updateParent()
                              : controller.createParent()
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
                                ? 'Update Parent'
                                : 'Create Parent',
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
    required String? Function() errorTextGetter,
    int? maxLength,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return Obx(
      () => TextField(
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
          errorText: errorTextGetter(),
        ),
      ),
    );
  }
}
