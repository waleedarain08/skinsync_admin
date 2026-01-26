import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/screens/dispute_screen.dart';
import 'package:skinsync_admin/screens/payment_screen.dart';
import 'package:skinsync_admin/utils/assets.dart';
import 'package:skinsync_admin/utils/color_constant.dart';

import '../../widgets/custom_app_bar.dart';
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
      appBar: CustomAppBar(),
      body: Row(
        children: [
          _buildDrawer(context),
          Expanded(child: Center(child: child)),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Container(
      width: 314.w,
      padding: EdgeInsets.symmetric(vertical: 38.h),
      decoration: BoxDecoration(gradient: CustomColors.purpleBlueGradient),
      child: Column(
        spacing: 10.h,
        children: [
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
        ],
      ),
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
    return SizedBox(
      width: 200.w,
      child: ElevatedButton.icon(
        onPressed: () {
          context.go(routeName);
        },
        label: Text(
          title,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            color: CustomColors.blackColor,
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
