import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../screens/sign_in_screen.dart';
import '../services/locator.dart';
import '../services/storage_service.dart';
import '../utils/color_constant.dart';
import '../utils/responsive.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: CustomColors.textMuted.withOpacity(0.1), width: 1)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: [
          Responsive.when(
            defaultValue: const SizedBox.shrink(),
            mobile: () => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(Icons.menu_rounded),
            ),
            tablet: () => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(Icons.menu_rounded),
            ),
          ),
          const Spacer(),
          _buildActionButton(Icons.search_rounded),
          SizedBox(width: 16.w),
          _buildActionButton(Icons.notifications_none_rounded, hasBadge: true),
          SizedBox(width: 24.w),
          _buildUserProfile(context),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, {bool hasBadge = false}) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: CustomColors.surfaceGhost,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, color: CustomColors.textMuted, size: 22.sp),
        ),
        if (hasBadge)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: CustomColors.brandPrimary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildUserProfile(BuildContext context) {
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Alex MedSpa', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: CustomColors.textMain)),
            Text('Super Admin', style: TextStyle(fontSize: 11.sp, color: CustomColors.textMuted, fontWeight: FontWeight.w500)),
          ],
        ),
        SizedBox(width: 12.w),
        PopupMenuButton(
          offset: Offset(0, 50.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          child: CircleAvatar(
            radius: 20.r,
            backgroundColor: CustomColors.brandCyan.withOpacity(0.1),
            child: Icon(Icons.person_rounded, size: 20.sp, color: CustomColors.brandPrimary),
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              onTap: () async {
                final secureStorage = locator<SecureStorageService>();
                await secureStorage.clearToken();
                if (!context.mounted) return;
                context.goNamed(SignInScreen.routeName);
              },
              child: Row(
                children: [
                  const Icon(Icons.logout_rounded, color: CustomColors.error, size: 18),
                  SizedBox(width: 12.w),
                  const Text('Logout', style: TextStyle(color: CustomColors.error, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 80.h);
}
