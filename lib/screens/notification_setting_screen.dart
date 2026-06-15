import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';

import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _appointmentNotifications = true;
  bool _paymentNotifications = true;
  bool _aiReportNotifications = true;
  bool _followUpReminders = true;

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
              SizedBox(height: 16.h),
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
          'Notification Settings',
          style: context.fonts.black18w600,
        ),
      ],
    );
  }

  Widget _buildCardContainer() {
    return Container(
      padding: EdgeInsets.all(20.w),

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
        spacing: 16.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Manage Notifications Title
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.w),
            child: Text(
              'Manage Notifications',
              style: context.fonts.black16w600,
            ),
          ),
          // Notification Options
          _buildNotificationOption(
            title: 'Appointment Notifications',
            subtitle: 'Get notified about new appointments',
            value: _appointmentNotifications,
            onChanged: (value) {
              setState(() {
                _appointmentNotifications = value;
              });
            },
          ),
          _buildNotificationOption(
            title: 'Payment Notifications',
            subtitle: 'Get notified about payments',
            value: _paymentNotifications,
            onChanged: (value) {
              setState(() {
                _paymentNotifications = value;
              });
            },
          ),
          _buildNotificationOption(
            title: 'AI Report Notifications',
            subtitle: 'Get notified when AI reports are ready',
            value: _aiReportNotifications,
            onChanged: (value) {
              setState(() {
                _aiReportNotifications = value;
              });
            },
          ),
          _buildNotificationOption(
            title: 'Follow-up Reminders',
            subtitle: 'Get reminders for patient follow-ups',
            value: _followUpReminders,
            onChanged: (value) {
              setState(() {
                _followUpReminders = value;
              });
            },
            showBottomPadding: true,
          ),
          _buildImportantNote(),
        ],
      ),
    );
  }

  Widget _buildNotificationOption({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    bool showBottomPadding = false,
  }) {
    return Container(
      padding: EdgeInsets.only(
        top: 16.h,
        left: 20.w,
        right: 20.w,
        bottom: showBottomPadding ? 20.h : 16.h,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Text Column
          Expanded(
            child: Column(
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
          ),
          // Toggle Switch
          Transform.scale(
            scale: 0.7,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeTrackColor: CustomColors.purple,
              activeThumbColor: CustomColors.white,
              inactiveThumbColor: CustomColors.white,
              inactiveTrackColor: CustomColors.border,
              trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportantNote() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: CustomColors.palePurple,
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
