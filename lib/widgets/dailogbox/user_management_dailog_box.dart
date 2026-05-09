import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_admin/utils/color_constant.dart';
import 'package:skinsync_admin/utils/custom_fonts.dart';

class UserManagementDialogBox extends StatelessWidget {
  final String transactionId;
  final String patientName;
  final String clinicName;
  final String serviceName;
  final String amount;
  final String? feedbackMessage;

  const UserManagementDialogBox({
    super.key,
    required this.transactionId,
    required this.patientName,
    required this.clinicName,
    required this.serviceName,
    required this.amount,
    this.feedbackMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      backgroundColor: Colors.white,
      child: Container(
        width: 600.w,
        padding: EdgeInsets.all(32.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("User Profile Details", style: CustomFonts.textMain24w700),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, size: 24.sp),
                  ),
                ],
              ),
              SizedBox(height: 32.h),
              Text("Personal Information", style: CustomFonts.textMain20w600),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(child: _infoBlock("First Name", "Emma")),
                  Expanded(child: _infoBlock("Last Name", "Johnson")),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(child: _infoBlock("Email", "emma.j@example.com")),
                  Expanded(child: _infoBlock("Mobile", "+1 (555) 123-4567")),
                ],
              ),
              SizedBox(height: 32.h),
              const Divider(),
              SizedBox(height: 32.h),
              Text("Skin Analysis & Goals", style: CustomFonts.textMain20w600),
              SizedBox(height: 20.h),
              _buildTagSection("Skin Goals", ["Anti-aging", "Hydration"]),
              SizedBox(height: 20.h),
              _buildTagSection("Primary Concerns", ["Fine lines", "Dryness", "Dark spots"]),
              SizedBox(height: 32.h),
              const Divider(),
              SizedBox(height: 32.h),
              Text("Bio & History", style: CustomFonts.textMain20w600),
              SizedBox(height: 16.h),
              _infoBlock("Bio", "Looking to improve skin texture and reduce signs of aging.", isFullWidth: true),
              SizedBox(height: 16.h),
              _infoBlock("Medical History", "No known allergies. Previous treatments include chemical peels.", isFullWidth: true),
              SizedBox(height: 40.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Close Profile"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoBlock(String label, String value, {bool isFullWidth = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: CustomFonts.textMuted13w500),
        SizedBox(height: 4.h),
        Text(value, style: CustomFonts.textMain16w400.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildTagSection(String label, List<String> tags) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: CustomFonts.textMuted13w500),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: tags.map((tag) => Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: CustomColors.brandCyan.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: CustomColors.brandCyan.withValues(alpha: 0.2)),
            ),
            child: Text(tag, style: CustomFonts.textMain14w600.copyWith(color: CustomColors.brandPrimary, fontSize: 12.sp)),
          )).toList(),
        ),
      ],
    );
  }
}
