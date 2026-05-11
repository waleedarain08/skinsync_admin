import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skinsync_admin/utils/assets.dart';
import 'package:skinsync_admin/utils/color_constant.dart';
import 'package:skinsync_admin/utils/custom_fonts.dart';

class PushNotificationScreen extends StatelessWidget {
  const PushNotificationScreen({super.key});
  static const String routeName = '/pushNotification-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundLight,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.h),
              Text("Push Notifications", style: CustomFonts.textMain32w700),
              SizedBox(height: 10.h),
              Text(
                "Send push notifications to app users about updates, offers, and alerts",
                style: CustomFonts.textMain14w400.copyWith(color: CustomColors.textMuted),
              ),
              SizedBox(height: 20.h),
              Divider(color: CustomColors.greyColor),
              SizedBox(height: 50.h),
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: CustomColors.greyColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.notifications_outlined,
                          size: 20.sp,
                          color: Colors.black,
                        ),
                        SizedBox(width: 20.w),
                        Text(
                          "Send New Notification",
                          style: CustomFonts.textMain20w600,
                        ),
                      ],
                    ),
                    SizedBox(height: 40.h),
                    Text("Notification Title", style: CustomFonts.textMain16w600),
                    SizedBox(height: 10.h),
                    TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: CustomColors.fillColor,
                        hintText: "e.g., New Feature Launch",
                        hintStyle: CustomFonts.grey16w400,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 15.h,
                          horizontal: 20.w,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(color: CustomColors.fillColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(color: CustomColors.fillColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(color: CustomColors.fillColor),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text("0/50 characters", style: CustomFonts.grey14w400),
                    SizedBox(height: 10.h),
                    Text("Message", style: CustomFonts.black16w600),
                    SizedBox(height: 10.h),
                    TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: CustomColors.fillColor,
                        hintText: "Enter your notification message...",
                        hintStyle: CustomFonts.grey16w400,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 15.h,
                          horizontal: 20.w,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(color: CustomColors.fillColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(color: CustomColors.fillColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(color: CustomColors.fillColor),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text("Target Audience", style: CustomFonts.black16w600),
                    SizedBox(height: 10.h),
                    TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: CustomColors.fillColor,
                        hintText: "All Users (1,247 users)",
                        hintStyle: CustomFonts.grey16w400,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 15.h,
                          horizontal: 20.w,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(color: CustomColors.fillColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(color: CustomColors.fillColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(color: CustomColors.fillColor),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 15.h,
                        horizontal: 20.w,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: Color(0xFFEFF6FF),
                        border: Border.all(color: Color(0XFFBEDBFF)),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            SvgAssets.pushNotification,
                            height: 30.w,
                            width: 30.w,
                          ),
                          SizedBox(width: 12.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Notification Preview",
                                style: CustomFonts.black20w600,
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                "Your notification preview will appear here",
                                style: CustomFonts.black16w400,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Divider(color: Colors.grey.shade300, height: 0),
                    SizedBox(height: 34.5.h),
                    Text.rich(
                      TextSpan(
                        text: "This notification will be sent to ",
                        style: CustomFonts.black16w500, // normal text
                        children: [
                          TextSpan(
                            text: "1247 users",
                            style: CustomFonts.black18w600, // BIG text
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 34.5.h),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: CustomColors.greyColor),
                ),
                child: Column(
                  children: [
                    Text(
                      "Notification History",
                      style: CustomFonts.textMain20w600,
                    ),
                    SizedBox(height: 20.h),
                    PushNotificationTable(),
                     SizedBox(height: 20.h),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: Color(0xFFFAF5FF),
                  border: Border.all(color: Color(0XFFE9D4FF)),
                ),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      "Best Practices for Push Notifications:",
                      style: CustomFonts.textMain20w600,
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      " • Keep titles short and actionable (under 50 characters)",
                      style: CustomFonts.black16w400,
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      " • Make messages clear and concise (under 200 characters)",
                      style: CustomFonts.black16w400,
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      " • Target the right audience to improve engagement",
                      style: CustomFonts.black16w400,
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      " • Avoid sending too many notifications to prevent user fatigue",
                      style: CustomFonts.black16w400,
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      " • Use notifications for important updates, offers, and alerts only",
                      style: CustomFonts.black16w400,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}

class PushNotificationTable extends StatelessWidget {
  const PushNotificationTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(
                  Colors.grey.shade100,
                ),
                headingRowHeight: 50.h,
                dataRowMinHeight: 60.h,
                dataRowMaxHeight: 60.h,
                columnSpacing: 40.w,
                border: TableBorder(
                  horizontalInside: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                  verticalInside: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                columns: [
                  DataColumn(
                    columnWidth: FixedColumnWidth(176.w),
                    label: Text('Title', style: CustomFonts.black16w600),
                  ),
                  DataColumn(
                    columnWidth: FixedColumnWidth(260.w),
                    label: Text('Message',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, 
                    style: CustomFonts.black16w600),
                  ),
                  DataColumn(
                    columnWidth: FixedColumnWidth(192.w),
                    label: Text('Audience', style: CustomFonts.black16w600),
                  ),
                  DataColumn(
                    columnWidth: FixedColumnWidth(130.w),
                    label: Text('Recipients', style: CustomFonts.black16w600),
                  ),
                  DataColumn(
                    columnWidth: FixedColumnWidth(102.w),
                    label: Text('Sent At', style: CustomFonts.black16w600),
                  ),
                  DataColumn(
                    columnWidth: FixedColumnWidth(130.w),
                    label: Text('Sent At', style: CustomFonts.black16w600),
                  ),
                  DataColumn(
                    columnWidth: FixedColumnWidth(114.w),
                    label: Text('Status', style: CustomFonts.black16w600),
                  ),
                ],
                rows: [
                  _buildDataRow(
                    'New Feature Launch',
                    'Check out our new AI-powered skin consultation feature!',
                    'Radiant Skin Clinic',
                    'All Users',
                    "1,247",
                    "Nov 1, 2025, 10:30 AM",
                    "Sent",
                  ),
                  _buildDataRow(
                    'New Feature Launch',
                    'Check out our new AI-powered skin consultation feature!',
                    'Radiant Skin Clinic',
                    'All Users',
                    "1,247",
                    "Nov 1, 2025, 10:30 AM",
                    "Sent",
                  ),
                  _buildDataRow(
                    'New Feature Launch',
                    'Check out our new AI-powered skin consultation feature!',
                    'Radiant Skin Clinic',
                    'All Users',
                    "1,247",
                    "Nov 1, 2025, 10:30 AM",
                    "Sent",
                  ),
                  _buildDataRow(
                    'New Feature Launch',
                    'Check out our new AI-powered skin consultation feature!',
                    'Radiant Skin Clinic',
                    'All Users',
                    "1,247",
                    "Nov 1, 2025, 10:30 AM",
                    "Sent",
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  DataRow _buildDataRow(
    String title,
    String message,
    String audience,
    String recipients,
    String sentAtTime,
    String sentAtDate,
    String status,
  ) {
    return DataRow(
      cells: [
        DataCell(Text(title, style: CustomFonts.black14w400)),
        DataCell(Text(message, style: CustomFonts.black14w400)),
        DataCell(Text(audience, style: CustomFonts.black14w400)),
        DataCell(Text(recipients, style: CustomFonts.black14w400)),
        DataCell(Text(sentAtTime, style: CustomFonts.black14w400)),
        DataCell(Text(sentAtDate, style: CustomFonts.black14w400)),
        DataCell(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: CustomColors.greenColor,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                  size: 10.sp,
                ),
                SizedBox(width: 10.w),
                Text(status, style: CustomFonts.white16w400),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
