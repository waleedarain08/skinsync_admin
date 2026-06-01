import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../screens/sign_in_screen.dart';
import '../services/locator.dart';
import '../services/storage_service.dart';
import '../utils/theme.dart';
import '../utils/responsive.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.topBarHeight,
      decoration: const BoxDecoration(
        gradient: CustomColors.purpleWhiteStateBlueLightGradient,
        border: Border(bottom: BorderSide(color: CustomColors.border, width: 1)),
      ),
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Row(
        children: [
          Responsive.when(
            defaultValue: const SizedBox.shrink(),
            mobile: () => _MenuButton(context: context),
            tablet: () => _MenuButton(context: context), // Show hamburger on tablet too
          ),
          const Spacer(),
          const _TopBarAction(icon: Icons.notifications_none_rounded, tooltip: 'Notifications', hasBadge: true),
          SizedBox(width: AppSpacing.lg),
          const _TopBarAction(icon: Icons.help_outline_rounded, tooltip: 'Documentation'),
          SizedBox(width: AppSpacing.lg),
          const VerticalDivider(width: 1, indent: 20, endIndent: 20),
          SizedBox(width: AppSpacing.lg),
          _UserProfile(context: context),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, AppSpacing.topBarHeight);
}

class _MenuButton extends StatelessWidget {
  final BuildContext context;
  const _MenuButton({required this.context});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: AppSpacing.sm),
      child: IconButton(
        onPressed: () => Scaffold.of(context).openDrawer(),
        icon: Icon(Icons.menu_rounded, color: CustomColors.black, size: 26.sp),
        style: IconButton.styleFrom(
          backgroundColor: CustomColors.whiteGrey,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        ),
      ),
    );
  }
}

class _TopBarAction extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final bool hasBadge;

  const _TopBarAction({
    required this.icon,
    required this.tooltip,
    this.hasBadge = false,
  });

  @override
  State<_TopBarAction> createState() => _TopBarActionState();
}

class _TopBarActionState extends State<_TopBarAction> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(widget.icon, size: 24.sp),
              color: _hovered ? CustomColors.purple : CustomColors.grey,
              style: IconButton.styleFrom(
                backgroundColor: _hovered ? CustomColors.palePurple : Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            if (widget.hasBadge)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 7.w,
                  height: 7.w,
                  decoration: BoxDecoration(
                    color: CustomColors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: CustomColors.white, width: 1.5),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _UserProfile extends StatelessWidget {
  final BuildContext context;
  const _UserProfile({required this.context});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      offset: Offset(0, 48.h),
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: const BorderSide(color: CustomColors.border),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Alex MedSpa', style: CustomFonts.black12w600),
                Text('Super Admin', style: CustomFonts.grey10w400),
              ],
            ),
            SizedBox(width: AppSpacing.sm),
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: CustomColors.purple,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(Icons.person_rounded, size: 22.sp, color: CustomColors.white),
            ),
            SizedBox(width: 4.w),
            Icon(Icons.keyboard_arrow_down_rounded, size: 16.sp, color: CustomColors.lightGrey),
          ],
        ),
      ),
      itemBuilder: (context) => <PopupMenuEntry<void>>[
        PopupMenuItem<void>(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Alex MedSpa', style: CustomFonts.black14w600),
              Text('admin@skinsync.ai', style: CustomFonts.grey12w400),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<void>(
          onTap: () {},
          child: Row(
            children: [
              Icon(Icons.person_outline_rounded, size: 18.sp, color: CustomColors.grey),
              SizedBox(width: AppSpacing.md),
              const Text('Account Profile'),
            ],
          ),
        ),
        PopupMenuItem<void>(
          onTap: () async {
            final secureStorage = locator<SecureStorageService>();
            await secureStorage.clearToken();
            if (!context.mounted) return;
            context.goNamed(SignInScreen.routeName);
          },
          child: Row(
            children: [
              Icon(Icons.logout_rounded, color: CustomColors.red, size: 18.sp),
              SizedBox(width: AppSpacing.md),
              const Text('Logout', style: TextStyle(color: CustomColors.red, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}
