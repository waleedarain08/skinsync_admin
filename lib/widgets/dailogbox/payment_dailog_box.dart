import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'standard_dialog.dart';

class ReleasePaymentDialog extends StatelessWidget {
  final String transactionId;
  final String patientName;
  final String clinicName;
  final String serviceName;
  final String amount;
  final String? feedbackMessage;

  const ReleasePaymentDialog({
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
    return StandardDialog(
      title: "Release Payment",
      width: 550.w,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Please review the transaction details before releasing the funds to the clinic's wallet.",
            style: CustomFonts.grey14w400,
          ),
          SizedBox(height: 24.h),
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: CustomColors.whiteGrey,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                _buildDetailRow("Transaction ID", transactionId),
                _buildDetailRow("Patient", patientName),
                _buildDetailRow("Clinic", clinicName),
                _buildDetailRow("Service", serviceName),
                const Divider(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Amount", style: CustomFonts.black16w600),
                    Text(amount, style: CustomFonts.black20w600.copyWith(color: CustomColors.green)),
                  ],
                ),
              ],
            ),
          ),
          if (feedbackMessage != null) ...[
            SizedBox(height: 24.h),
            Text("Patient Feedback", style: CustomFonts.black16w600),
            SizedBox(height: 8.h),
            Text(
              feedbackMessage!,
              style: CustomFonts.black14w400.copyWith(fontStyle: FontStyle.italic),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        CustomPrimaryButton(
          onTap: () => Navigator.pop(context, true),
          label: "Confirm Release",
          width: 200.w,
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: CustomFonts.grey13w500),
          Text(value, style: CustomFonts.black14w600),
        ],
      ),
    );
  }
}
