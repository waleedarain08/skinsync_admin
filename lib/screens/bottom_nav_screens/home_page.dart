import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/screens/bottom_nav_screens/push_notification_screen.dart';
import 'package:skinsync_admin/screens/dispute_screen.dart';
import 'package:skinsync_admin/screens/payment_screen.dart';
import 'package:skinsync_admin/utils/assets.dart';
import 'package:skinsync_admin/utils/color_constant.dart';
import 'package:skinsync_admin/widgets/custom_app_bar.dart';

import '../../utils/responsive.dart';
import 'clinic_management.dart';
import 'patient_management.dart';
import 'user_management.dart';

class HomePage extends StatelessWidget {
  static const String routeName = '/home-page';
  final Widget child;
  const HomePage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: CustomAppBar(),
      backgroundColor: CustomColors.dashboardBackgroundColor,
      drawer: Responsive.when(
        defaultValue: SizedBox.shrink(),
        mobile: () => _buildRail(),
        tablet: () => _buildRail(),
      ),
      body: Row(
        children: [
          Responsive.when(
            defaultValue: SizedBox.shrink(),
            desktop: () => _buildRail(),
          ),
          Expanded(
            child: Column(
              children: [
                CustomAppBar(),

                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRail() {
    return Builder(
      builder: (context) {
        return Container(
          width: 270.w,
          padding: EdgeInsets.symmetric(vertical: 38.h),
          margin: EdgeInsets.all(5.w),
          decoration: BoxDecoration(
            gradient: CustomColors.purpleBlueGradient,
            borderRadius: BorderRadiusGeometry.circular(10.r),
          ),
          child: Column(
            spacing: 10.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  PngAssets.splashLogo,
                  width: 48.w,
                  height: 48.w,
                ),
              ),
              Center(child: Image.asset(PngAssets.logo)),
              SizedBox(height: 30.h),
              _buildRailItem(
                context: context,
                title: 'User Management',
                icon: SvgAssets.user,
                routeName: UserManagement.routeName,
              ),
              _buildRailItem(
                context: context,
                title: 'Patient Management',
                icon: SvgAssets.patient,
                routeName: PatientManagement.routeName,
              ),
              _buildRailItem(
                context: context,
                title: 'Clinic Management',
                icon: SvgAssets.clinic,
                routeName: ClinicManagement.routeName,
              ),
              _buildRailItem(
                context: context,
                title: 'Dispute Management',
                icon: SvgAssets.disputeManagement,
                routeName: DisputeScreen.routeName,
              ),
              _buildRailItem(
                context: context,
                title: 'Payment Management',
                icon: SvgAssets.paymentManagement,
                routeName: PaymentScreen.routeName,
              ),
              _buildRailItem(
                context: context,
                title: 'Push Notifications',
                icon: SvgAssets.pushNotification,
                routeName: PushNotificationScreen.routeName,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRailItem({
    required BuildContext context,
    required String title,
    required String icon,
    required String routeName,
  }) {
    final uri = GoRouter.of(context).state.path;
    final isSelected = uri == routeName;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: ElevatedButton.icon(
        onPressed: () {
          context.go(routeName);
          if (Scaffold.of(context).hasDrawer) {
            Scaffold.of(context).closeDrawer();
          }
        },
        label: SizedBox(
          width: double.infinity,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: CustomColors.blackColor,
            ),
          ),
        ),
        icon: SvgPicture.asset(
          icon,
          width: 20.w,
          height: 20.w,
          color: isSelected ? CustomColors.blueColor : CustomColors.blackColor,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? CustomColors.whiteColor
              : Colors.transparent,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.all(15.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(15.r),
          ),
        ),
      ),
    );
  }
}
