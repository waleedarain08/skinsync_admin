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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.h),
              Text("Push Notifications", style: CustomFonts.black30w600),
              SizedBox(height: 10.h),
              Text(
                "Send push notifications to app users about updates, offers, and alerts",
                style: CustomFonts.grey18w400,
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
                          style: CustomFonts.black20w600,
                        ),
                      ],
                    ),
                    SizedBox(height: 40.h),
                    Text("Notification Title", style: CustomFonts.black16w600),
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
                    SizedBox(height: 34.5.h,),
                  ],
                ),
              ),
             SizedBox(height: 20.h,),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                        vertical: 15.h,
                        horizontal: 15.w,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: Color(0xFFFAF5FF),
                        border: Border.all(color: Color(0XFFE9D4FF)),
                      ),
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text("Best Practices for Push Notifications:",style: CustomFonts.black20w600,),
                          SizedBox(height: 5.h,),
                          Text(" • Keep titles short and actionable (under 50 characters)",style: CustomFonts.black16w400 ,),
                          SizedBox(height: 5.h,),
                          Text(" • Make messages clear and concise (under 200 characters)",style: CustomFonts.black16w400 ,),
                          SizedBox(height: 5.h,),
                          Text(" • Target the right audience to improve engagement",style: CustomFonts.black16w400 ,),
                           SizedBox(height: 5.h,),
                          Text(" • Avoid sending too many notifications to prevent user fatigue",style: CustomFonts.black16w400 ,),
                           SizedBox(height: 5.h,),
                          Text(" • Use notifications for important updates, offers, and alerts only",style: CustomFonts.black16w400 ,)
                    

                       
                        ],
                      ),
              ),
              SizedBox(height: 30.h,)
            ],
          ),
        ),
      ),
    );
  }
}
