import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:skinsync_admin/main.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/appointment_management.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/clinic_management.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/dashboard_screen.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/explore_screen.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/forms_screen.dart';
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

/// Single source of truth for a sidebar entry. `routes`, the tappable
/// items, and the section-header separators are all derived from this
/// same (filtered) list, so nothing can drift out of sync with manual
/// index math again.
class _SidebarEntry {
  const _SidebarEntry({
    required this.routeName,
    required this.icon,
    required this.label,
    this.included = true,
    this.section,
  });

  final String routeName;
  final IconData icon;
  final String label;
  final bool included;
  final String? section;
}

final List<_SidebarEntry> _sidebarEntries = [
  const _SidebarEntry(
    routeName: DashboardScreen.routeName,
    icon: Icons.grid_view_rounded,
    label: 'Dashboard',
    section: 'NETWORK',
  ),
  const _SidebarEntry(
    routeName: ExploreScreen.routeName,
    icon: Icons.explore_outlined,
    label: 'Explore',
  ),
  const _SidebarEntry(
    routeName: ClinicManagement.routeName,
    icon: Icons.business_rounded,
    label: 'Clinics',
  ),
  const _SidebarEntry(
    routeName: AppointmentManagement.routeName,
    icon: Icons.calendar_today_rounded,
    label: 'Appointments',
  ),
  const _SidebarEntry(
    routeName: PatientManagementScreen.routeName,
    icon: Icons.people_alt_rounded,
    label: 'Patients',
    section: 'OPERATIONS',
  ),
  const _SidebarEntry(
    routeName: TreatmentManagementScreen.routeName,
    icon: Icons.medical_services_rounded,
    label: 'Treatments',
  ),
  const _SidebarEntry(
    routeName: ProductManagement.routeName,
    icon: Icons.inventory_2_rounded,
    label: 'Inventory',
  ),
  const _SidebarEntry(
    routeName: SubscriptionPlansTab.routeName,
    icon: Icons.card_membership_rounded,
    label: 'Subscriptions',
    section: 'FINANCIALS',
    // isDeploymentMode condition removed — always shown now.
  ),
  _SidebarEntry(
    routeName: UserManagement.routeName,
    icon: Icons.admin_panel_settings_rounded,
    label: 'Users',
    included: !isDeploymentMode,
  ),
   _SidebarEntry(
    routeName: PaymentScreen.routeName,
    icon: Icons.account_balance_wallet_rounded,
    label: 'Payments',
     included: !isDeploymentMode,
  ),
  _SidebarEntry(
    routeName: DisputeScreen.routeName,
    icon: Icons.gavel_rounded,
    label: 'Disputes',
    included: !isDeploymentMode,
  ),
  const _SidebarEntry(
    routeName: FormsScreen.routeName,
    icon: Icons.description_rounded,
    label: 'Forms',
  ),
  const _SidebarEntry(
    routeName: PushNotificationScreen.routeName,
    icon: Icons.notifications_active_rounded,
    label: 'Notifications',
    section: 'SYSTEM',
  ),
  const _SidebarEntry(
    routeName: SettingScreen.routeName,
    icon: Icons.settings_rounded,
    label: 'Settings',
  ),
];

/// Only the entries that should currently appear, in display order.
/// `routes`, `_buildItems`, and `_separatorBuilder` all read from this
/// same list so tap index <-> route <-> section stay in lockstep.
List<_SidebarEntry> get _visibleSidebarEntries =>
    _sidebarEntries.where((e) => e.included).toList();

abstract final class AppSidebarRoutes {
  static List<String> get routes =>
      _visibleSidebarEntries.map((e) => e.routeName).toList();

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
    final entries = _visibleSidebarEntries;
    return [
      for (var i = 0; i < entries.length; i++)
        SidebarXItem(
          icon: entries[i].icon,
          label: entries[i].label,
          onTap: () => onItemTap(i),
        ),
    ];
  }

    Widget _separatorBuilder(
    BuildContext context,
    int index,
    SidebarXController controller,
  ) {
    final entries = _visibleSidebarEntries;
    final nextIndex = index + 1;

    final section = nextIndex < entries.length ? entries[nextIndex].section : null;
    if (section != null) {
      return _SectionLabel(title: section, controller: controller);
    }
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
