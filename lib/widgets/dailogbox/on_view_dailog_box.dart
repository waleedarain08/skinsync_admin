import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_admin/utils/color_constant.dart';
import 'package:skinsync_admin/utils/custom_fonts.dart';
import 'standard_dialog.dart';

class DisputeDetailsDialog extends StatelessWidget {
  const DisputeDetailsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return StandardDialog(
      title: 'Dispute Details',
      width: 650.w,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(backgroundColor: CustomColors.red),
          child: const Text("Escalate"),
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(backgroundColor: CustomColors.green),
          child: const Text("Resolve Dispute"),
        ),
      ],
    );
  }

  Widget _detailItem(String label, String value, {bool isBoldValue = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: CustomFonts.grey11w400.copyWith(letterSpacing: 0.5)),
        SizedBox(height: 4.h),
        Text(
          value,
          style: isBoldValue ? CustomFonts.black16w600 : CustomFonts.black14w400,
        ),
      ],
    );
  }
}
