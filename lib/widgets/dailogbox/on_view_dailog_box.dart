import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_admin/utils/color_constant.dart';
import 'package:skinsync_admin/utils/custom_fonts.dart';

class DisputeDetailsDialog extends StatelessWidget {
  const DisputeDetailsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Container(
        width: 600.w,
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Dispute Details', style: CustomFonts.black22w600),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
              ],
            ),
            SizedBox(height: 32.h),
            Row(
              children: [
                Expanded(child: _detailItem('Dispute ID', '#DSP-2025-001')),
                Expanded(child: _detailItem('Date Filed', 'Oct 28, 2023')),
              ],
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(child: _detailItem('Patient', 'Emma Johnson')),
                Expanded(child: _detailItem('Clinic', 'Radiant Skin NY')),
              ],
            ),
            SizedBox(height: 32.h),
            const Divider(),
            SizedBox(height: 24.h),
            _detailItem('Subject/Reason', 'Service Quality Mismatch', isBoldValue: true),
            SizedBox(height: 16.h),
            _detailItem(
              'Detailed Description',
              'The treatment was rushed and did not meet the promised duration. The patient claims the results were not as discussed during consultation.',
            ),
            SizedBox(height: 40.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h)),
                  child: const Text("Close"),
                ),
                SizedBox(width: 16.w),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.errorRed,
                    padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                  ),
                  child: const Text("Escalate Dispute"),
                ),
                SizedBox(width: 12.w),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.successGreen,
                    padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                  ),
                  child: const Text("Resolve Dispute"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailItem(String label, String value, {bool isBoldValue = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: CustomColors.textLight, fontSize: 12.sp, fontWeight: FontWeight.bold)),
        SizedBox(height: 4.h),
        Text(
          value,
          style: isBoldValue ? CustomFonts.black16w600 : CustomFonts.black14w400,
        ),
      ],
    );
  }
}
