import 'package:flutter/material.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'standard_dialog.dart';

class DisputeDetailsDialog extends StatelessWidget {
  const DisputeDetailsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return StandardDialog(
      title: 'Dispute Details',
      width: context.w(650),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _detailItem(context, 'Dispute ID', '#DSP-2025-001')),
              Expanded(child: _detailItem(context, 'Date Filed', 'Oct 28, 2023')),
            ],
          ),
          context.verticalSpace(24),
          Row(
            children: [
              Expanded(child: _detailItem(context, 'Patient', 'Emma Johnson')),
              Expanded(child: _detailItem(context, 'Clinic', 'Radiant Skin NY')),
            ],
          ),
          context.verticalSpace(32),
          const Divider(),
          context.verticalSpace(24),
          _detailItem(context, 'Subject/Reason', 'Service Quality Mismatch', isBoldValue: true),
          context.verticalSpace(16),
          _detailItem(
            context,
            'Detailed Description',
            'The treatment was rushed and did not meet the promised duration. The patient claims the results were not as discussed during consultation.',
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        CustomPrimaryButton(
          onTap: () {},
          label: 'Escalate',
          width: context.w(120),
        ),
        CustomPrimaryButton(
          onTap: () {},
          label: 'Resolve Dispute',
          width: context.w(160),
        ),
      ],
    );
  }

  Widget _detailItem(BuildContext context, String label, String value, {bool isBoldValue = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.fonts.grey11w400),
        context.verticalSpace(4),
        Text(
          value,
          style: isBoldValue ? context.fonts.black16w600 : context.fonts.black14w400,
        ),
      ],
    );
  }
}
