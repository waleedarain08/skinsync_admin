import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_admin/utils/color_constant.dart';
import 'package:skinsync_admin/utils/custom_fonts.dart';

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
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      backgroundColor: Colors.white,
      child: Container(
        width: 500.w,
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Release Payment", style: CustomFonts.black22w600),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, size: 20.sp),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              "Please review the transaction details before releasing the funds to the clinic's wallet.",
              style: CustomFonts.grey18w400.copyWith(fontSize: 14.sp),
            ),
            SizedBox(height: 32.h),
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: CustomColors.softChampagne.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: CustomColors.greyColor),
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
                      Text(amount, style: CustomFonts.black22w600.copyWith(color: CustomColors.successGreen)),
                    ],
                  ),
                ],
              ),
            ),
            if (feedbackMessage != null) ...[
              SizedBox(height: 24.h),
              Text("Patient Feedback", style: CustomFonts.black14w600),
              SizedBox(height: 8.h),
              Text(
                feedbackMessage!,
                style: TextStyle(fontSize: 13.sp, color: CustomColors.textLight, fontStyle: FontStyle.italic),
              ),
            ],
            SizedBox(height: 40.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                    child: const Text("Cancel"),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.successGreen,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                    child: const Text("Confirm Release"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: CustomColors.textLight, fontSize: 13.sp)),
          Text(value, style: CustomFonts.black14w600),
        ],
      ),
    );
  }
}
