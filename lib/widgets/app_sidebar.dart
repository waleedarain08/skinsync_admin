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
        width: 80.w,
        decoration: const BoxDecoration(
          color: CustomColors.sidebar,
          border: Border(right: BorderSide(color: CustomColors.borderLight, width: 1)),
        ),
        padding: EdgeInsets.symmetric(vertical: 24.h),
        iconTheme: IconThemeData(color: CustomColors.textSecondary, size: 20.sp),
        selectedIconTheme: IconThemeData(color: CustomColors.primary, size: 20.sp),
        hoverIconTheme: IconThemeData(color: CustomColors.primary, size: 20.sp),
        textStyle: CustomFonts.sidebarText,
        selectedTextStyle: CustomFonts.sidebarTextSelected,
        hoverTextStyle: CustomFonts.sidebarTextSelected,
        hoverColor: CustomColors.primary.withValues(alpha: 0.05),
        itemMargin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        selectedItemMargin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        itemPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        selectedItemPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        itemDecoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
        selectedItemDecoration: BoxDecoration(
          color: CustomColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: CustomColors.primary.withValues(alpha: 0.2), width: 1),
        ),
      );

  static SidebarXTheme get extendedTheme => collapsedTheme.copyWith(
        width: 280.w,
        itemTextPadding: EdgeInsets.only(left: 16.w),
        selectedItemTextPadding: EdgeInsets.only(left: 16.w),
      );

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: controller,
      theme: collapsedTheme,
      extendedTheme: extendedTheme,
      animationDuration: const Duration(milliseconds: 300),
      showToggleButton: true,
      headerDivider: const SizedBox.shrink(),
      footerDivider: Divider(color: CustomColors.sidebarBorder, height: 1.h, thickness: 1),
      separatorBuilder: (context, index) => _separatorBuilder(context, index, controller),
      headerBuilder: (context, extended) => _headerBuilder(context, extended),
      toggleButtonBuilder: (context, extended) => _toggleButtonBuilder(context, extended, controller),
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

  Widget _separatorBuilder(BuildContext context, int index, SidebarXController controller) {
    if (index == 0) return _SectionLabel(title: 'NETWORK', controller: controller);
    if (index == 3) return _SectionLabel(title: 'OPERATIONS', controller: controller);
    if (index == 6) return _SectionLabel(title: 'FINANCIALS', controller: controller);
    if (index == 8) return _SectionLabel(title: 'SYSTEM', controller: controller);
    return SizedBox(height: 2.h);
  }

  Widget _headerBuilder(BuildContext context, bool extended) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(
        vertical: 28.h,
        horizontal: extended ? 24.w : 12.w,
      ),
      child: Row(
        mainAxisAlignment: extended ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: [
          _LogoBadge(size: extended ? 42 : 30),
          if (extended) ...[
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'SkinSync',
                    style: CustomFonts.black18w600lsNeg04,
                  ),
                  Text(
                    'ADMIN PANEL',
                    style: CustomFonts.primary9w800ls1,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _toggleButtonBuilder(BuildContext context, bool extended, SidebarXController controller) {
    return InkWell(
      onTap: () => controller.toggleExtended(),
      hoverColor: CustomColors.primary.withValues(alpha: 0.05),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: Icon(
          extended ? Icons.arrow_back_ios_new_rounded : Icons.arrow_forward_ios_rounded,
          size: 18.sp,
          color: CustomColors.textSecondary.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}

class _LogoBadge extends StatelessWidget {
  final double size;
  const _LogoBadge({required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.w,
      height: size.w,
      child: Image.asset(PngAssets.splashLogo, fit: BoxFit.contain),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;
  final SidebarXController controller;
  const _SectionLabel({required this.title, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        if (!controller.extended) return SizedBox(height: 16.h);
        return Padding(
          padding: EdgeInsets.fromLTRB(28.w, 24.h, 16.w, 8.h),
          child: Text(
            title,
            style: CustomFonts.grey11w600ls12,
          ),
        );
      },
    );
  }
}
