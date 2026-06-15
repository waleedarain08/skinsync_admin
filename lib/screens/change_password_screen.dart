import 'package:flutter/material.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';
import 'package:skinsync_admin/widgets/custom_outlined_button.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 250.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button
              _buildHeader(),
              SizedBox(height: 24.h),
              // Main Card Container
              _buildCardContainer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, size: 24.sp, color: Colors.black),
        ),
        SizedBox(width: 12.w),
        Text(
          'Password & Security',
          style: context.fonts.black18w600,
        ),
      ],
    );
  }

  Widget _buildCardContainer() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: CustomColors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Change Password Header
          _buildChangePasswordHeader(),
          SizedBox(height: 24.h),
          // Current Password Field
          BuildTextField(
            label: 'Current Password',
            controller: _currentPasswordController,
            obscureText: _obscureCurrentPassword,
            hintText: '••••••••',
            suffixIcon: IconButton(
              onPressed: () => setState(() => _obscureCurrentPassword = !_obscureCurrentPassword),
              icon: Icon(
                _obscureCurrentPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: Colors.grey[400],
                size: 20.sp,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          // New Password Field
          BuildTextField(
            label: 'New Password',
            controller: _newPasswordController,
            obscureText: _obscureNewPassword,
            hintText: '••••••••',
            suffixIcon: IconButton(
              onPressed: () => setState(() => _obscureNewPassword = !_obscureNewPassword),
              icon: Icon(
                _obscureNewPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: Colors.grey[400],
                size: 20.sp,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          // Confirm New Password Field
          BuildTextField(
            label: 'Confirm New Password',
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            hintText: '••••••••',
            suffixIcon: IconButton(
              onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
              icon: Icon(
                _obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: Colors.grey[400],
                size: 20.sp,
              ),
            ),
          ),
          SizedBox(height: 32.h),
          // Buttons Row
          _buildButtonsRow(),
        ],
      ),
    );
  }

  Widget _buildChangePasswordHeader() {
    return Row(
      children: [
        // Purple Circle Icon
        Container(
          width: 44.w,
          height: 44.w,
          decoration: const BoxDecoration(
            color: Color(0xFFEEEBFF),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              Icons.lock_outline_rounded,
              size: 22.sp,
              color: const Color(0xFF6B5DD3),
            ),
          ),
        ),
        SizedBox(width: 14.w),
        // Text Column
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Change Password',
              style: context.fonts.black16w600,
            ),
            SizedBox(height: 4.h),
            Text(
              'Keep your account secure with a strong password',
              style: context.fonts.grey12w400,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildButtonsRow() {
    return Row(
      children: [
        Expanded(
          child: CustomPrimaryButton(
            onTap: () {
              // Validate passwords
              if (_newPasswordController.text !=
                  _confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Passwords do not match!'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              // Handle update password
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password updated successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            label: 'Update Password',
          ),
        ),
        SizedBox(width: 16.w),
        // Cancel Button
        Expanded(
          child: CustomOutlinedButton(
            onTap: () {
              // Handle cancel
              Navigator.pop(context);
            },
            label: 'Cancel',
            color: Colors.grey[300],
            textColor: Colors.black,
          ),
        ),
      ],
    );
  }
}
