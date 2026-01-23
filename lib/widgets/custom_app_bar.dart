import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_admin/utils/assets.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 101.h,
      constraints: BoxConstraints(minHeight: 101.h),
      padding: EdgeInsets.symmetric(horizontal: 100.w),
      child: Row(
        children: [
          Image.asset(PngAssets.splashLogo, width: 48.w, height: 48.w),
          Image.asset(PngAssets.logo, height: 20.h),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 101.h);
}
