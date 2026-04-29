import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../screens/sign_in_screen.dart';
import '../services/locator.dart';
import '../services/storage_service.dart';
import '../utils/assets.dart';
import '../utils/color_constant.dart';
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
          defaultValue: 20.w,
          // desktop: () => 20.w,
          // tablet: () => 30.w,
          // mobile: () => 20.w,
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
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
              Text(
                'Super Administrator',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 10.sp,
                  height: 0,
                ),
              ),
            ],
          ),
          PopupMenuButton(
            padding: EdgeInsets.zero,
            offset: Offset(0, 40.h),
            icon: Icon(
              Icons.arrow_drop_down_circle_outlined,
              size: 18.sp,
              color: CustomColors.blackColor,
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                height: 40.h,
                onTap: () async {
                  final _secureStorage = locator<SecureStorageService>();
                  await _secureStorage.clearToken();
                  if (!context.mounted) return;
                  context.goNamed(SignInScreen.routeName);
                },

                child: Row(
                  children: [
                    Icon(Icons.logout_rounded, color: Colors.red, size: 18.sp),
                    SizedBox(width: 8.w),
                    Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
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
