import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_admin/utils/custom_fonts.dart';

class UserManagementDailogBox extends StatelessWidget {
  final String transactionId;
  final String patientName;
  final String clinicName;
  final String serviceName;
  final String amount;
  final String? feedbackMessage;

  const UserManagementDailogBox({
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
        padding: EdgeInsets.all(20.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Release Payment to Clinic",
                    style: CustomFonts.black22w600,
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, size: 20.sp),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
          
              // Subtitle
              Text(
                "Confirm that you want to release this payment to the clinic's wallet.",
                style: CustomFonts.black16w400,
              ),
              SizedBox(height: 20.h),
              Text("Personal Information", style: CustomFonts.black18w600),
              SizedBox(height: 10.w),
              // Transaction Details
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(
                    "First Name",
                    "Last Name",
                    CustomFonts.black16w400,
                  ),
                  SizedBox(height: 10.h),
                  _buildDetailRow("Emma", "Johnson", CustomFonts.black16w500),
                  SizedBox(height: 20.h),
                  _buildDetailRow("Email", 'Mobile', CustomFonts.black16w400),
                  SizedBox(height: 10.h),
                  _buildDetailRow(
                    "Email",
                    "+1 (555) 123-4567",
                    CustomFonts.black16w500,
                  ),
                  SizedBox(height: 20.h),
                  _buildDetailRow("State", 'Skin Tone', CustomFonts.black16w400),
                  SizedBox(height: 10.h),
                  _buildDetailRow("State", "Fair", CustomFonts.black16w500),
                  SizedBox(height: 20.h),
                  Text("Skin Goals", style: CustomFonts.black18w600),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 20.w,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text("Anti-aging", style: CustomFonts.black14w400),
                      ),
                      SizedBox(width: 10.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 20.w,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text("Hydration", style: CustomFonts.black14w400),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Text("Primary Concerns", style: CustomFonts.black18w600),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 20.w,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text("Fine lines", style: CustomFonts.black14w400),
                      ),
                      SizedBox(width: 10.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 20.w,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text("Dryness", style: CustomFonts.black14w400),
                      ),
                      SizedBox(width: 10.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 20.w,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text("Dark spots", style: CustomFonts.black14w400),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Text("Bio", style: CustomFonts.black22w600),
                  SizedBox(height: 10.h),
                  Text(
                    "Looking to improve skin texture and reduce signs of aging.",
                    style: CustomFonts.black16w400,
                  ),
                  SizedBox(height: 20.h),
                  Text("Loyalty Points", style: CustomFonts.black22w600),
                  SizedBox(height: 10.h),
                  Text("1250 points", style: CustomFonts.black16w400),
                  SizedBox(height: 20.h),
                  Text("Medical History", style: CustomFonts.black22w600),
                  SizedBox(height: 10.h),
                  Text(
                    "No known allergies. Previous treatments include chemical peels.",
                    style: CustomFonts.black16w400,
                  ),
                  SizedBox(height: 20.h),
          
                  // Amount to Release
                ],
              ),
          
              // Feedback Message (if provided)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, TextStyle? style) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text(label, style: style ?? CustomFonts.black16w400)),

        Expanded(
          child: Text(
            value,
            style: style ?? CustomFonts.black16w400,
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }
}
