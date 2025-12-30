import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:student_management/app/helpers/constants.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

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
                Text(
                  'Settings',
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
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.callBtn),
          );
        }

        final profile = controller.profile.value;
        if (profile == null) {
          return const Center(
            child: Text('Failed to load profile'),
          );
        }

        return SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryColor.withOpacity(0.8),
                        AppColors.callBtn.withOpacity(0.9),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      // Avatar
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            profile.firstName?.isNotEmpty == true
                                ? profile.firstName![0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondaryColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Name
                      Text(
                        profile.fullName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Email
                      Text(
                        profile.email ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.secondaryColor.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Role badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          profile.role ?? '',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 250.ms).slideY(begin: 0.1, end: 0),

                const SizedBox(height: 24),

                // Personal Information Section (Read-only)
                const Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 16),

                // First Name
                _buildReadOnlyField(
                  label: 'First Name',
                  value: profile.firstName ?? '',
                  icon: HugeIcons.strokeRoundedUser,
                ),
                const SizedBox(height: 12),

                // Middle Name
                _buildReadOnlyField(
                  label: 'Middle Name',
                  value: profile.middleName ?? '',
                  icon: HugeIcons.strokeRoundedUser,
                ),
                const SizedBox(height: 12),

                // Last Name
                _buildReadOnlyField(
                  label: 'Last Name',
                  value: profile.lastName ?? '',
                  icon: HugeIcons.strokeRoundedUser,
                ),
                const SizedBox(height: 12),

                // Email
                _buildReadOnlyField(
                  label: 'Email',
                  value: profile.email ?? '',
                  icon: HugeIcons.strokeRoundedMail01,
                ),
                const SizedBox(height: 24),

                // Editable Fields Section
                const Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 16),

                // Phone
                _buildInputField(
                  hint: 'Phone',
                  controller: controller.phoneController,
                  keyboardType: TextInputType.phone,
                  icon: HugeIcons.strokeRoundedCall,
                ),
                const SizedBox(height: 16),

                // Address
                _buildInputField(
                  hint: 'Address',
                  controller: controller.addressController,
                  icon: HugeIcons.strokeRoundedLocation01,
                  maxLines: 2,
                ),
                const SizedBox(height: 16),

                // WhatsApp fields (Parent only)
                if (controller.isParent) ...[
                  // WhatsApp Number
                  _buildInputField(
                    hint: 'WhatsApp Number',
                    controller: controller.whatsappNumberController,
                    keyboardType: TextInputType.phone,
                    icon: HugeIcons.strokeRoundedMessage01,
                  ),
                  const SizedBox(height: 12),
                  // WhatsApp Opt-in
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.grayBorder),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        'WhatsApp Notifications',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: const Text(
                        'Receive updates via WhatsApp',
                        style: TextStyle(fontSize: 12),
                      ),
                      value: controller.isWhatsappOptIn.value,
                      activeColor: AppColors.callBtn,
                      onChanged: (val) {
                        controller.isWhatsappOptIn.value = val;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                const SizedBox(height: 24),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: controller.isUpdating.value
                        ? null
                        : () => controller.updateProfile(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.callBtn,
                      disabledBackgroundColor: AppColors.gray50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: controller.isUpdating.value
                        ? const CircularProgressIndicator(
                            color: AppColors.black,
                          )
                        : const Text(
                            'Save Changes',
                            style: TextStyle(
                              color: AppColors.secondaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildInputField({
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: const TextStyle(
          fontSize: 14,
          color: AppColors.black,
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: HugeIcon(
          icon: icon,
          size: 20,
          color: AppColors.gray500,
        ),
        filled: true,
        fillColor: AppColors.secondaryColor,
        border: OutlineInputBorder(
          borderRadius: _inputBorderRadius,
          borderSide: const BorderSide(color: AppColors.grayBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: _inputBorderRadius,
          borderSide: const BorderSide(color: AppColors.callBtn, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: _inputBorderRadius,
          borderSide: const BorderSide(color: AppColors.grayBorder),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: _inputBorderRadius,
        border: Border.all(color: AppColors.grayBorder),
      ),
      child: Row(
        children: [
          HugeIcon(
            icon: icon,
            size: 20,
            color: AppColors.gray500,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.gray500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value.isNotEmpty ? value : '-',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
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
