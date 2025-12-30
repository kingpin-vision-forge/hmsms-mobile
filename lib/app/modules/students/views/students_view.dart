import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/widget/global_fab.dart';
import 'package:student_management/app/helpers/rbac/rbac.dart';
import 'package:student_management/app/modules/students/controllers/students_controller.dart';

class StudentsView extends GetView<StudentsController> {
  const StudentsView({super.key});

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
                  onPressed: () {
                    Get.back();
                  },
                ),
                Text(
                      controller.isEdit.value ? 'Edit Student' : 'New Student',
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
            foregroundColor: AppColors.secondaryColor,
            automaticallyImplyLeading: false,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Student Name Fields
              _buildInputField(
                label: 'First Name',
                hint: 'First Name',
                controller: controller.firstNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter first name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildInputField(
                label: 'Middle Name (optional)',
                hint: 'Middle Name (optional)',
                controller: controller.middleNameController,
                validator: (value) {
                  return null; // Optional field
                },
              ),
              const SizedBox(height: 16),
              _buildInputField(
                label: 'Last Name',
                hint: 'Last Name',
                controller: controller.lastNameController,
                validator: (value) {
                  return null;
                },
              ),
              const SizedBox(height: 16),

              //email
              _buildInputField(
                label: 'Email',
                hint: 'Email',
                controller: controller.emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  // Email format validation
                  final emailRegex = RegExp(
                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                  );
                  if (!emailRegex.hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Password (hidden in edit mode)
              Obx(
                () => controller.isEdit.value
                    ? const SizedBox.shrink()
                    : Column(
                        children: [
                          _buildInputField(
                            label: 'Password',
                            hint: 'Password',
                            controller: controller.passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              final alphanumericRegex = RegExp(
                                r'^(?=.*[a-zA-Z])(?=.*[0-9])',
                              );
                              if (!alphanumericRegex.hasMatch(value)) {
                                return 'Password must contain both letters and numbers';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
              ),

              // Admission Number Field (disabled in edit mode)
              Obx(
                () => _buildInputField(
                  label: 'Admission Number',
                  hint: 'Admission Number',
                  controller: controller.admissionNumberController,
                  enabled: !controller.isEdit.value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter admission number';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),

              //address
              _buildInputField(
                label: 'Address',
                hint: 'Address',
                controller: controller.addressController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              //phone
              _buildInputField(
                label: 'Phone',
                hint: 'Phone',
                controller: controller.phoneController,
                maxLength: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone';
                  }
                  // Phone validation: only numbers, exactly 10 digits
                  final phoneRegex = RegExp(r'^[0-9]{10}$');
                  if (!phoneRegex.hasMatch(value)) {
                    return 'Phone must be exactly 10 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Class Dropdown
              Obx(
                () => _buildDropdownField(
                  label: 'Class',
                  hint: 'Select class',
                  value:
                      controller.classList.any(
                        (c) => c.id == controller.selectedClassId.value,
                      )
                      ? controller.selectedClassId.value
                      : null,
                  items: controller.classList
                      .map(
                        (c) =>
                            DropdownMenuItem(value: c.id, child: Text(c.name)),
                      )
                      .toList(),
                  onChanged: (value) {
                    controller.selectedClassId.value = value ?? '';
                    controller.fetchSection();
                    controller.checkFormValidity();
                  },
                  isLoading: controller.isClassLoading.value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a class';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Section Dropdown
              Obx(
                () => _buildDropdownField(
                  label: 'Section',
                  hint: 'Select section',
                  value:
                      controller.sectionList.any(
                        (s) => s.id == controller.selectedSectionId.value,
                      )
                      ? controller.selectedSectionId.value
                      : null,
                  items: controller.sectionList
                      .map(
                        (s) =>
                            DropdownMenuItem(value: s.id, child: Text(s.name)),
                      )
                      .toList(),
                  onChanged: (value) {
                    controller.selectedSectionId.value = value ?? '';
                    controller.checkFormValidity();
                  },
                  isLoading: controller.isClassLoading.value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a section';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Date of Birth Field
              Obx(
                () => _buildDateField(
                  label: 'Select date of birth',
                  value: controller.dateOfBirth.value,
                  onChanged: (date) {
                    controller.dateOfBirth.value = date;
                    controller.checkFormValidity();
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select date of birth';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              // parent dropdown
              Obx(
                () => _buildDropdownField(
                  label: 'Parent',
                  hint: 'Select parent',
                  value: controller.selectedParentId.isEmpty
                      ? null
                      : controller.selectedParentId.value,
                  items: controller.parentList
                      .map(
                        (c) =>
                            DropdownMenuItem(value: c.id, child: Text(c.name)),
                      )
                      .toList(),
                  onChanged: (value) {
                    controller.selectedParentId.value = value ?? '';
                    controller.fetchParent();
                    controller.checkFormValidity();
                  },
                  isLoading: controller.isParentLoading.value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a parent';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Gender Dropdown
              Obx(
                () => _buildDropdownField(
                  label: 'Gender',
                  hint: 'Select gender',
                  value: controller.selectedGender.isEmpty
                      ? null
                      : controller.selectedGender.value,
                  items: const [
                    DropdownMenuItem(value: 'MALE', child: Text('Male')),
                    DropdownMenuItem(value: 'FEMALE', child: Text('Female')),
                    DropdownMenuItem(value: 'OTHER', child: Text('Other')),
                  ],
                  onChanged: (value) {
                    controller.selectedGender.value = value ?? '';
                    controller.checkFormValidity();
                  },
                  isLoading: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select gender';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 28),

              // Submit Button
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            if (controller.isEdit.value) {
                              controller.updateStudent();
                            } else {
                              controller.createStudent();
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.callBtn,
                      disabledBackgroundColor: AppColors.gray50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.secondaryColor,
                              ),
                            ),
                          )
                        : Text(
                            controller.isEdit.value
                                ? 'Update Student'
                                : 'Create Student',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondaryColor,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ].animate(interval: 30.ms).fade(duration: 200.ms),
          ),
        ),
      ),
      floatingActionButton: RoleWidget(
        allowedRoles: [UserRole.SUPER_ADMIN, UserRole.ADMIN, UserRole.TEACHER],
        child: GlobalFAB(),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required String? Function(String?)? validator,
    int? maxLength,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   label,
        //   style: const TextStyle(
        //     fontSize: 14,
        //     fontWeight: FontWeight.w600,
        //     color: AppColors.mainTextColor,
        //   ),
        // ),
        // const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          maxLength: maxLength,
          enabled: enabled,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            // hintText: hint,
            label: Text(hint),
            labelStyle: TextStyle(
              fontSize: 14,
              color: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
            filled: true,
            fillColor: AppColors.secondaryColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.black),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.black),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.black),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.errorColor),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            counterText: '',
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required Function(String?)? onChanged,
    required bool isLoading,
    required String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   label,
        //   style: const TextStyle(
        //     fontSize: 14,
        //     fontWeight: FontWeight.w600,
        //     color: AppColors.mainTextColor,
        //   ),
        // ),
        // const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          dropdownColor: AppColors.secondaryColor,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            label: Text(hint),
            labelStyle: TextStyle(
              fontSize: 14,
              color: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
            filled: true,
            fillColor: AppColors.secondaryColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.black),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.black),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.black),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.errorColor),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
          items: isLoading ? [] : items,
          onChanged: isLoading ? null : onChanged,
          validator: validator,
          isExpanded: true,
          icon: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.black,
                  ),
                )
              : const Icon(Icons.arrow_drop_down),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? value,
    required Function(DateTime?)? onChanged,
    required String? Function(DateTime?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   label,
        //   style: const TextStyle(
        //     fontSize: 14,
        //     fontWeight: FontWeight.w600,
        //     color: AppColors.mainTextColor,
        //   ),
        // ),
        // const SizedBox(height: 8),
        FormField<DateTime>(
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (FormFieldState<DateTime> field) {
            return GestureDetector(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: Get.context!,
                  initialDate: value ?? DateTime.now(),
                  firstDate: DateTime(1990),
                  lastDate: DateTime.now(),
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        primaryColor: AppColors.callBtn,
                        colorScheme: const ColorScheme.light(
                          primary: AppColors.callBtn,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  onChanged?.call(picked);
                  field.didChange(picked);
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: TextStyle(
                    fontSize: 14,
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  filled: true,
                  fillColor: AppColors.secondaryColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.black),
                  ),
                  suffixIcon: const Icon(
                    Icons.calendar_today,
                    color: AppColors.black,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  errorText: field.errorText,
                ),
                isEmpty: value == null,
                child: Text(
                  value != null
                      ? '${value.day}/${value.month}/${value.year}'
                      : '',
                  style: TextStyle(color: AppColors.black),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
