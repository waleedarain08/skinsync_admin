import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/appointment_management.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/clinic_management.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/dashboard_screen.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/patient_management.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/product_management.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/push_notification_screen.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/setting_screen.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/subscription_plans.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/user_management.dart';
import 'package:skinsync_admin/screens/dispute_screen.dart';
import 'package:skinsync_admin/screens/payment_screen.dart';
import 'package:skinsync_admin/screens/treatment_management_screen.dart';
import 'package:skinsync_admin/utils/assets.dart';
import 'package:skinsync_admin/utils/theme.dart';

abstract final class AppSidebarRoutes {
  static const routes = <String>[
    DashboardScreen.routeName,
    ClinicManagement.routeName,
    AppointmentManagement.routeName,
    PatientManagement.routeName,
    TreatmentManagementScreen.routeName,
    ProductManagement.routeName,
    SubscriptionPlansTab.routeName,
    UserManagement.routeName,
    PaymentScreen.routeName,
    DisputeScreen.routeName,
    PushNotificationScreen.routeName,
    SettingScreen.routeName,
  ];

  static int indexOf(String location) {
    final exact = routes.indexOf(location);
    if (exact >= 0) return exact;
    for (var i = 0; i < routes.length; i++) {
      if (location.startsWith(routes[i])) return i;
    }
    return -1;
  }
}

class AppSidebar extends StatelessWidget {
  const AppSidebar({
    super.key,
    required this.controller,
    required this.onItemTap,
  });

  final SidebarXController controller;
  final void Function(int index) onItemTap;

  static SidebarXTheme get collapsedTheme => SidebarXTheme(
        width: 72.w,
        decoration: const BoxDecoration(
          color: CustomColors.sidebar,
          border: Border(right: BorderSide(color: CustomColors.sidebarBorder, width: 1)),
        ),
        padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
        iconTheme: IconThemeData(color: CustomColors.textSecondary, size: 20.sp),
        selectedIconTheme: IconThemeData(color: Colors.white, size: 20.sp),
        hoverIconTheme: IconThemeData(color: CustomColors.primary, size: 20.sp),
        textStyle: CustomFonts.sidebarItem,
        selectedTextStyle: CustomFonts.sidebarItemActive,
        hoverTextStyle: CustomFonts.sidebarItemActive.copyWith(color: CustomColors.primary),
        hoverColor: CustomColors.hover,
        itemMargin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
        selectedItemMargin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
        itemPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        selectedItemPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        itemDecoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r)),
        selectedItemDecoration: BoxDecoration(
          color: CustomColors.primary,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: CustomColors.primary.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
      );

  static SidebarXTheme get extendedTheme => collapsedTheme.copyWith(
        width: 260.w,
        itemTextPadding: EdgeInsets.only(left: 12.w),
        selectedItemTextPadding: EdgeInsets.only(left: 12.w),
      );

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: controller,
      theme: collapsedTheme,
      extendedTheme: extendedTheme,
      animationDuration: const Duration(milliseconds: 250),
      showToggleButton: false,
      headerDivider: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: const Divider(color: CustomColors.sidebarBorder, height: 1),
      ),
      separatorBuilder: _separatorBuilder,
      headerBuilder: _headerBuilder,
      footerBuilder: _footerBuilder,
      items: _buildItems(),
    );
  }

  List<SidebarXItem> _buildItems() {
    return [
      SidebarXItem(icon: Icons.grid_view_rounded, label: 'Dashboard', onTap: () => onItemTap(0)),
      SidebarXItem(icon: Icons.business_rounded, label: 'Clinics', onTap: () => onItemTap(1)),
      SidebarXItem(icon: Icons.calendar_today_rounded, label: 'Appointments', onTap: () => onItemTap(2)),
      SidebarXItem(icon: Icons.people_alt_rounded, label: 'Patients', onTap: () => onItemTap(3)),
      SidebarXItem(icon: Icons.medical_services_rounded, label: 'Treatments', onTap: () => onItemTap(4)),
      SidebarXItem(icon: Icons.inventory_2_rounded, label: 'Inventory', onTap: () => onItemTap(5)),
      SidebarXItem(icon: Icons.card_membership_rounded, label: 'Subscriptions', onTap: () => onItemTap(6)),
      SidebarXItem(icon: Icons.admin_panel_settings_rounded, label: 'Users', onTap: () => onItemTap(7)),
      SidebarXItem(icon: Icons.account_balance_wallet_rounded, label: 'Payments', onTap: () => onItemTap(8)),
      SidebarXItem(icon: Icons.gavel_rounded, label: 'Disputes', onTap: () => onItemTap(9)),
      SidebarXItem(icon: Icons.notifications_active_rounded, label: 'Notifications', onTap: () => onItemTap(10)),
      SidebarXItem(icon: Icons.settings_rounded, label: 'Settings', onTap: () => onItemTap(11)),
    ];
  }

  Widget _separatorBuilder(BuildContext context, int index) {
    if (index == 0) return const _SectionLabel(title: 'NETWORK');
    if (index == 3) return const _SectionLabel(title: 'OPERATIONS');
    if (index == 6) return const _SectionLabel(title: 'FINANCIALS');
    if (index == 8) return const _SectionLabel(title: 'SYSTEM');
    return SizedBox(height: 2.h);
  }

  Widget _headerBuilder(BuildContext context, bool extended) {
    if (!extended) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: const _LogoBadge(size: 32),
      );
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 40.h, 24.w, 8.h),
      child: Row(
        children: [
          const _LogoBadge(size: 36),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SkinSync',
                  style: CustomFonts.h3.copyWith(
                    color: CustomColors.textPrimary,
                    letterSpacing: -0.5,
                    fontSize: 18.sp,
                  ),
                ),
                Text(
                  'MEDSPA SaaS',
                  style: CustomFonts.overline.copyWith(
                    color: CustomColors.secondary,
                    fontSize: 9.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _footerBuilder(BuildContext context, bool extended) {
    if (!extended) {
      return Padding(
        padding: EdgeInsets.only(bottom: 24.h),
        child: Icon(Icons.person_outline_rounded, color: CustomColors.textTertiary, size: 22.sp),
      );
    }
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: CustomColors.backgroundLight,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: CustomColors.sidebarBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              gradient: CustomColors.medicalGradient,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.person_rounded, color: CustomColors.surfaceWhite, size: 16.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Alex MedSpa',
                  style: CustomFonts.label.copyWith(fontSize: 12.sp),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Super Admin',
                  style: CustomFonts.caption.copyWith(fontSize: 10.sp),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoBadge extends StatelessWidget {
  final double size;
  const _LogoBadge({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.22),
      decoration: BoxDecoration(
        gradient: CustomColors.medicalGradient,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Image.asset(PngAssets.splashLogo, color: Colors.white),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;
  const _SectionLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 16.w, 10.h),
      child: Text(title, style: CustomFonts.sidebarSection),
    );
  }
}
