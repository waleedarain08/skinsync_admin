import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_admin/utils/color_constant.dart';
import 'package:skinsync_admin/utils/custom_fonts.dart';
import 'standard_dialog.dart';

class UserManagementDialogBox extends StatelessWidget {
  const UserManagementDialogBox({super.key});

  @override
  Widget build(BuildContext context) {
    return StandardDialog(
      title: "User Profile Details",
      width: 700.w,
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Personal Information"),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(child: _infoBlock("First Name", "Emma")),
                SizedBox(width: 24.w),
                Expanded(child: _infoBlock("Last Name", "Johnson")),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(child: _infoBlock("Email", "emma.j@example.com")),
                SizedBox(width: 24.w),
                Expanded(child: _infoBlock("Mobile", "+1 (555) 123-4567")),
              ],
            ),
            SizedBox(height: 32.h),
            _buildSectionTitle("Skin Analysis & Goals"),
            SizedBox(height: 20.h),
            _buildTagSection("Skin Goals", ["Anti-aging", "Hydration"]),
            SizedBox(height: 20.h),
            _buildTagSection("Primary Concerns", ["Fine lines", "Dryness", "Dark spots"]),
            SizedBox(height: 32.h),
            _buildSectionTitle("Bio & History"),
            SizedBox(height: 16.h),
            _infoBlock("Bio", "Looking to improve skin texture and reduce signs of aging."),
            SizedBox(height: 16.h),
            _infoBlock("Medical History", "No known allergies. Previous treatments include chemical peels."),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close Profile"),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: CustomFonts.black16w600.copyWith(color: CustomColors.purple)),
        const Divider(),
      ],
    );
  }

  Widget _infoBlock(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: CustomFonts.grey13w500),
        SizedBox(height: 4.h),
        Text(value, style: CustomFonts.black16w600),
      ],
    );
  }

  Widget _buildTagSection(String label, List<String> tags) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: CustomFonts.grey13w500),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: tags.map((tag) => Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: CustomColors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: CustomColors.green.withValues(alpha: 0.2)),
            ),
            child: Text(tag, style: CustomFonts.black14w600.copyWith(color: CustomColors.purple, fontSize: 11.sp)),
          )).toList(),
        ),
      ],
    );
  }
}
