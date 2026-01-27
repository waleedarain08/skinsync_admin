import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/assets.dart';
import '../utils/responsive.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 101.h,
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 101.h),
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.when(
          defaultValue: 100.w,
          desktop: () => 100.w,
          tablet: () => 30.w,
          mobile: () => 20.w,
        ),
        vertical: 24.h,
      ),
      child: Row(
        children: [
          Responsive.when(
            defaultValue: SizedBox.shrink(),
            mobile: () => _buildMobileActions(context),
            tablet: () => _buildMobileActions(context),
          ),
          Spacer(),
          Column(
            mainAxisAlignment: .center,
            children: [
              Text(
                'Admin Portal',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
              Text(
                'Super Administrator',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                  height: 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileActions(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Scaffold.of(context).openDrawer(),
          icon: Icon(Icons.menu),
        ),
        SizedBox(width: 10.w),
        Image.asset(PngAssets.splashLogo, width: 48.w, height: 48.w),
        Image.asset(PngAssets.logo),
      ],
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 101.h);
}
