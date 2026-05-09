import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/appointment_management.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/dashboard_screen.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/product_management.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/push_notification_screen.dart';
import 'package:skinsync_admin/screens/dispute_screen.dart';
import 'package:skinsync_admin/screens/payment_screen.dart';
import 'package:skinsync_admin/screens/treatment_management_screen.dart';
import 'package:skinsync_admin/utils/assets.dart';
import 'package:skinsync_admin/utils/color_constant.dart';
import 'package:skinsync_admin/widgets/custom_app_bar.dart';

import '../../utils/responsive.dart';
import 'clinic_management.dart';
import 'patient_management.dart';
import 'setting_screen.dart';
import 'user_management.dart';

class HomePage extends StatelessWidget {
  static const String routeName = '/home-page';
  final Widget child;
  const HomePage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundLight,
      drawer: Responsive.when(
        defaultValue: const SizedBox.shrink(),
        mobile: () => _buildSidebar(context),
        tablet: () => _buildSidebar(context),
      ),
      body: Row(
        children: [
          Responsive.when(
            defaultValue: const SizedBox.shrink(),
            desktop: () => _buildSidebar(context),
          ),
          Expanded(
            child: Column(
              children: [
                const CustomAppBar(),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 280.w,
      decoration: const BoxDecoration(
        color: CustomColors.deepSlate,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(5, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSidebarHeader(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              children: [
                _buildSidebarItem(
                  context: context,
                  title: 'Dashboard',
                  icon: Icons.dashboard_rounded,
                  routeName: DashboardScreen.routeName,
                ),
                _buildSidebarSection("MANAGEMENT"),
                _buildSidebarItem(
                  context: context,
                  title: 'Clinics',
                  icon: Icons.business_rounded,
                  routeName: ClinicManagement.routeName,
                ),
                _buildSidebarItem(
                  context: context,
                  title: 'Appointments',
                  icon: Icons.calendar_today_rounded,
                  routeName: AppointmentManagement.routeName,
                ),
                _buildSidebarItem(
                  context: context,
                  title: 'Patients',
                  icon: Icons.people_alt_rounded,
                  routeName: PatientManagement.routeName,
                ),
                _buildSidebarItem(
                  context: context,
                  title: 'Treatments',
                  icon: Icons.medical_services_rounded,
                  routeName: TreatmentManagementScreen.routeName,
                ),
                _buildSidebarItem(
                  context: context,
                  title: 'Inventory',
                  icon: Icons.inventory_2_rounded,
                  routeName: ProductManagement.routeName,
                ),
                _buildSidebarSection("ADMINISTRATION"),
                _buildSidebarItem(
                  context: context,
                  title: 'Users',
                  icon: Icons.admin_panel_settings_rounded,
                  routeName: UserManagement.routeName,
                ),
                _buildSidebarItem(
                  context: context,
                  title: 'Payments',
                  icon: Icons.account_balance_wallet_rounded,
                  routeName: PaymentScreen.routeName,
                ),
                _buildSidebarItem(
                  context: context,
                  title: 'Disputes',
                  icon: Icons.gavel_rounded,
                  routeName: DisputeScreen.routeName,
                ),
                _buildSidebarItem(
                  context: context,
                  title: 'Notifications',
                  icon: Icons.notifications_active_rounded,
                  routeName: PushNotificationScreen.routeName,
                ),
                const Divider(color: Colors.white10),
                _buildSidebarItem(
                  context: context,
                  title: 'Settings',
                  icon: Icons.settings_rounded,
                  routeName: SettingScreen.routeName,
                ),
              ],
            ),
          ),
          _buildSidebarFooter(),
        ],
      ),
    );
  }

  Widget _buildSidebarHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 24.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              gradient: CustomColors.brandGradient,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: CustomColors.brandCyan.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Image.asset(PngAssets.splashLogo, width: 24.w, height: 24.w),
          ),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "SKINSYNC",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                "ADMIN PANEL",
                style: TextStyle(
                  color: CustomColors.brandCyan,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarSection(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w, top: 24.h, bottom: 8.h),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white24,
          fontSize: 11.sp,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSidebarItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required String routeName,
  }) {
    final bool isSelected = GoRouterState.of(context).matchedLocation == routeName;

    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: InkWell(
        onTap: () {
          context.go(routeName);
          if (Scaffold.of(context).hasDrawer) {
            Scaffold.of(context).closeDrawer();
          }
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white.withOpacity(0.08) : Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? CustomColors.brandCyan : Colors.white60,
                size: 20.sp,
              ),
              SizedBox(width: 16.w),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white60,
                  fontSize: 14.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
              if (isSelected) const Spacer(),
              if (isSelected)
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: CustomColors.brandCyan,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSidebarFooter() {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: CustomColors.brandPurple.withOpacity(0.2),
            child: const Icon(Icons.person_rounded, color: CustomColors.brandPurple),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Alex MedSpa",
                  style: TextStyle(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.w600),
                ),
                Text(
                  "Super Admin",
                  style: TextStyle(color: Colors.white38, fontSize: 11.sp),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.logout_rounded, color: Colors.white38, size: 18),
          ),
        ],
      ),
    );
  }
}
