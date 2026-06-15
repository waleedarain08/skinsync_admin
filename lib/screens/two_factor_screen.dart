import 'package:flutter/material.dart';
import 'package:skinsync_admin/utils/theme.dart';

import 'package:skinsync_admin/widgets/gradient_scaffold.dart';

class TwoFactorAuthScreen extends StatefulWidget {
  const TwoFactorAuthScreen({super.key});

  @override
  State<TwoFactorAuthScreen> createState() => _TwoFactorAuthScreenState();
}

class _TwoFactorAuthScreenState extends State<TwoFactorAuthScreen> {
  bool _isTwoFactorEnabled = false;
  String _selectedMethod = 'sms'; // 'sms' or 'email'

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
              SizedBox(height: 12.h),
              // Divider
              Divider(height: 1, thickness: 1, color: Colors.grey[200]),
              SizedBox(height: 12.h),
              // Main Card Container
              _buildCardContainer(),

              // Verification Method Section (shown when toggle is enabled)
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
          'Two-Factor Authentication',
          style: context.fonts.black18w600,
        ),
      ],
    );
  }

  Widget _buildCardContainer() {
    return Container(
      padding: EdgeInsets.all(24.w),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Business Information Row
          _buildBusinessInfoRow(),
          SizedBox(height: 30.h),
          // Two-Factor Authentication Toggle Row
          _buildTwoFactorToggleRow(),

          if (_isTwoFactorEnabled) ...[
            SizedBox(height: 24.h),
            _buildVerificationMethodSection(),
            SizedBox(height: 16.h),
            _buildImportantNote(),
          ],
        ],
      ),
    );
  }

  Widget _buildBusinessInfoRow() {
    return Row(
      children: [
        // Purple Circle Icon
        Container(
          width: 40.w,
          height: 40.w,
          decoration: const BoxDecoration(
            color: Color(0xFFEEEBFF),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              Icons.shield_outlined,
              size: 20.sp,
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
              'Business Information',
              style: context.fonts.black14w600,
            ),
            SizedBox(height: 4.h),
            Text(
              'Update clinic details and contact info',
              style: context.fonts.grey12w400,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTwoFactorToggleRow() {
    return Container(
      padding: EdgeInsets.all(16.w),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Text Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enable Two-Factor Authentication',
                style: context.fonts.black14w600,
              ),
              SizedBox(height: 4.h),
              Text(
                'Require a verification code when signing in',
                style: context.fonts.grey12w400,
              ),
            ],
          ),
          // Toggle Switch
          Switch(
            value: _isTwoFactorEnabled,
            onChanged: (value) {
              setState(() {
                _isTwoFactorEnabled = value;
              });
            },
            activeThumbColor: CustomColors.white,
            activeTrackColor: CustomColors.purple,
            inactiveThumbColor: CustomColors.white,
            inactiveTrackColor: CustomColors.border,
            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Verification Method',
          style: context.fonts.black16w600,
        ),
        SizedBox(height: 16.h),
        // SMS Verification Option
        _buildVerificationOption(
          icon: Icons.phone_android_outlined,
          title: 'SMS Verification',
          subtitle: 'Receive codes via text message',
          isSelected: _selectedMethod == 'sms',
          onTap: () {
            setState(() {
              _selectedMethod = 'sms';
            });
          },
        ),
        SizedBox(height: 12.h),
        // Email Verification Option
        _buildVerificationOption(
          icon: Icons.email_outlined,
          title: 'Email Verification',
          subtitle: 'Receive codes via email',
          isSelected: _selectedMethod == 'email',
          onTap: () {
            setState(() {
              _selectedMethod = 'email';
            });
          },
        ),
      ],
    );
  }

  Widget _buildVerificationOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD2CEF1) : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: isSelected
              ? Border.all(color: const Color(0xFF6B5DD3), width: 1)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.2)
                    : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 20.sp,
                  color: isSelected ? const Color(0xFF6B5DD3) : Colors.grey[600],
                ),
              ),
            ),
            SizedBox(width: 14.w),
            // Text Column
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.fonts.black14w600,
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: context.fonts.grey12w400,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImportantNote() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF4FF),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: RichText(
        text: TextSpan(
          style: context.fonts.black12w400h14,
          children: [
            TextSpan(
              text: 'Important: ',
              style: context.fonts.black12w600,
            ),
            TextSpan(
              text:
                  'You will need to enter a verification code sent to your phone every time you sign in.',
              style: context.fonts.grey12w400,
            ),
          ],
        ),
      ),
    );
  }
}
