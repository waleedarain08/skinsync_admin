import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:skinsync_admin/main.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/appointment_management.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/clinic_management.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/dashboard_screen.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/explore_screen.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/patient_management.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/product_management.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/push_notification_screen.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/setting_screen.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/subscription_plans.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/treatment_management_screen.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/user_management.dart';
import 'package:skinsync_admin/screens/dispute_screen.dart';
import 'package:skinsync_admin/screens/payment_screen.dart';
import 'package:skinsync_admin/utils/assets.dart';
import 'package:skinsync_admin/utils/theme.dart';

abstract final class AppSidebarRoutes {
  static List<String> get routes => [
    DashboardScreen.routeName,
    ExploreScreen.routeName,
    ClinicManagement.routeName,
    AppointmentManagement.routeName,
    PatientManagementScreen.routeName,
    TreatmentManagementScreen.routeName,
    ProductManagement.routeName,
    if (!isDeploymentMode) SubscriptionPlansTab.routeName,
    if (!isDeploymentMode) UserManagement.routeName,
    PaymentScreen.routeName,
    if (!isDeploymentMode) DisputeScreen.routeName,
    PushNotificationScreen.routeName,
    SettingScreen.routeName,
  ];

  static int indexOf(String location) {
    final list = routes;
    final exact = list.indexOf(location);
    if (exact >= 0) return exact;
    for (var i = 0; i < list.length; i++) {
      if (location.startsWith(list[i])) return i;
    }
    return -1;
  }
}

class AppSidebar extends StatelessWidget {
  const AppSidebar({
    super.key,
    required this.controller,
    required this.onItemTap,
    this.showToggleButton = true,
  });

  final SidebarXController controller;
  final void Function(int index) onItemTap;
  final bool showToggleButton;

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: controller,
      theme: _buildTheme(context),
      extendedTheme: _buildExtendedTheme(context),
      animationDuration: const Duration(milliseconds: 300),
      showToggleButton: showToggleButton,
      toggleButtonBuilder: _buildToggleButton,
      headerDivider: const SizedBox.shrink(),
      footerDivider: Divider(
        color: CustomColors.border,
        height: context.h(1),
        thickness: 1,
      ),
      separatorBuilder: (context, index) =>
          _separatorBuilder(context, index, controller),
      headerBuilder: _headerBuilder,
      items: _buildItems(),
    );
  }

  SidebarXTheme _buildTheme(BuildContext context) {
    return SidebarXTheme(
      width: context.w(80),
      decoration: const BoxDecoration(
        color: CustomColors.white,
        border: Border(right: BorderSide(color: CustomColors.border, width: 1)),
      ),
      padding: context.appEdgeInsets(vertical: 24),
      iconTheme: IconThemeData(color: CustomColors.grey, size: context.sp(20)),
      selectedIconTheme: IconThemeData(
        color: CustomColors.purple,
        size: context.sp(20),
      ),
      hoverIconTheme: IconThemeData(
        color: CustomColors.purple,
        size: context.sp(20),
      ),
      textStyle: context.fonts.grey14w600,
      selectedTextStyle: context.fonts.purple14w600,
      hoverTextStyle: context.fonts.purple14w600,
      hoverColor: CustomColors.lightPurple,
      itemMargin: context.appEdgeInsets(horizontal: 12, vertical: 4),
      selectedItemMargin: context.appEdgeInsets(horizontal: 12, vertical: 4),
      itemPadding: context.appEdgeInsets(horizontal: 12, vertical: 12),
      selectedItemPadding: context.appEdgeInsets(horizontal: 12, vertical: 12),
      itemDecoration: BoxDecoration(
        borderRadius: context.borderRadius(all: 12),
      ),
      selectedItemDecoration: BoxDecoration(
        color: CustomColors.lightPurple,
        borderRadius: context.borderRadius(all: 12),
        border: Border.all(
          color: CustomColors.purple.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
    );
  }

  SidebarXTheme _buildExtendedTheme(BuildContext context) {
    return _buildTheme(context).copyWith(
      width: context.w(280),
      itemTextPadding: context.appEdgeInsets(left: 16),
      selectedItemTextPadding: context.appEdgeInsets(left: 16),
    );
  }

  List<SidebarXItem> _buildItems() {
    SidebarXItem item(int index, IconData icon, String label) =>
        SidebarXItem(icon: icon, label: label, onTap: () => onItemTap(index));

    return [
      item(0, Icons.grid_view_rounded, 'Dashboard'),
      item(1, Icons.explore_outlined, 'Explore'),
      item(2, Icons.business_rounded, 'Clinics'),
      item(3, Icons.calendar_today_rounded, 'Appointments'),
      item(4, Icons.people_alt_rounded, 'Patients'),
      item(5, Icons.medical_services_rounded, 'Treatments'),
      item(6, Icons.inventory_2_rounded, 'Inventory'),
      item(7, Icons.card_membership_rounded, 'Subscriptions'),
      if (!isDeploymentMode)
        item(8, Icons.admin_panel_settings_rounded, 'Users'),
      item(
        !isDeploymentMode ? 9 : 7,
        Icons.account_balance_wallet_rounded,
        'Payments',
      ),
      if (!isDeploymentMode) item(10, Icons.gavel_rounded, 'Disputes'),
      item(
        !isDeploymentMode ? 11 : 8,
        Icons.notifications_active_rounded,
        'Notifications',
      ),
      item(!isDeploymentMode ? 12 : 9, Icons.settings_rounded, 'Settings'),
    ];
  }

  Widget _separatorBuilder(
    BuildContext context,
    int index,
    SidebarXController controller,
  ) {
    final financialsIndex = !isDeploymentMode ? 7 : -1;
    final systemIndex = !isDeploymentMode ? 9 : 7;
    if (index == 0)
      return _SectionLabel(title: 'NETWORK', controller: controller);
    if (index == 4)
      return _SectionLabel(title: 'OPERATIONS', controller: controller);
    if (index == financialsIndex)
      return _SectionLabel(title: 'FINANCIALS', controller: controller);
    if (index == systemIndex)
      return _SectionLabel(title: 'SYSTEM', controller: controller);
    return context.verticalSpace(2);
  }

  Widget _headerBuilder(BuildContext context, bool extended) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: context.appEdgeInsets(
        vertical: 28,
        horizontal: extended ? 24 : 12,
      ),
      child: Row(
        mainAxisAlignment: extended
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        children: [
          SizedBox(
            width: context.w(extended ? 42 : 30),
            height: context.w(extended ? 42 : 30),
            child: Image.asset(PngAssets.splashLogo, fit: BoxFit.contain),
          ),
          if (extended) ...[
            context.horizontalSpace(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('SkinSync', style: context.fonts.black18w600lsNeg04),
                  Text('ADMIN PANEL', style: context.fonts.purple9w800ls1),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildToggleButton(BuildContext context, bool extended) {
    return InkWell(
      onTap: controller.toggleExtended,
      hoverColor: CustomColors.purple.withValues(alpha: 0.05),
      child: Container(
        width: double.infinity,
        padding: context.appEdgeInsets(vertical: 16),
        child: Icon(
          extended
              ? Icons.arrow_back_ios_new_rounded
              : Icons.arrow_forward_ios_rounded,
          size: context.sp(16),
          color: CustomColors.grey.withValues(alpha: 0.7),
        ),
      ),
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
        if (!controller.extended) {
          return Padding(
            padding: context.appEdgeInsets(vertical: 8),
            child: Divider(
              color: CustomColors.border,
              indent: context.w(20),
              endIndent: context.w(20),
            ),
          );
        }
        return Padding(
          padding: context.appEdgeInsets(
            left: 28,
            top: 24,
            right: 16,
            bottom: 8,
          ),
          child: Text(title, style: context.fonts.grey11w600ls12),
        );
      },
    );
  }
}
