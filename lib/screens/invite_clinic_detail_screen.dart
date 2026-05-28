import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/invite_clinic_model.dart';
import 'package:skinsync_admin/screens/add_new_clinic_screen.dart';
import 'package:skinsync_admin/view_models/clinic_view_model.dart';
import 'package:skinsync_admin/utils/color_constant.dart';
import 'package:skinsync_admin/utils/custom_fonts.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';

class InviteClinicDetailScreen extends ConsumerWidget {
  static const String routeName = '/invite-clinic-detail';
  const InviteClinicDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clinic = ref.watch(clinicViewModelProvider).selectedInviteClinic;

    if (clinic == null) {
      return Scaffold(body: Center(child: Text("No Clinic Data Found", style: CustomFonts.black16w400)));
    }

    return Scaffold(
      backgroundColor: CustomColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text("Prospect Clinic Detail", style: CustomFonts.black18w600),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: CustomColors.deepSlate),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 1000.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderCard(clinic),
                SizedBox(height: 32.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: _buildMainContent(clinic)),
                    SizedBox(width: 32.w),
                    Expanded(flex: 2, child: _buildActionSidebar(context, clinic)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(InviteClinicModel clinic) {
    return BorderdContainerWidget(
      padding: EdgeInsets.all(32.w),
      child: Row(
        children: [
          Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              color: CustomColors.backgroundLight,
              borderRadius: BorderRadius.circular(20.r),
              image: (clinic.logo != null && clinic.logo!.isNotEmpty)
                  ? DecorationImage(image: NetworkImage(clinic.logo!), fit: BoxFit.cover)
                  : null,
            ),
            child: (clinic.logo == null || clinic.logo!.isEmpty)
                ? Icon(Icons.business_outlined, size: 48.sp, color: CustomColors.deepSlate)
                : null,
          ),
          SizedBox(width: 32.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(clinic.name, style: CustomFonts.black26w700),
                    SizedBox(width: 16.w),
                    _statusBadge(clinic.invitationStatus),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(clinic.address, style: CustomFonts.grey16w400),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    _infoChip(Icons.calendar_today_outlined, "Identified on: ${clinic.invitedDate}"),
                    SizedBox(width: 12.w),
                    _infoChip(Icons.trending_up_rounded, "${clinic.interestedPatientsCount} Potential Patients"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(InviteClinicModel clinic) {
    return Column(
      children: [
        _infoSection("Contact Details", [
          _infoRow(Icons.email_outlined, "Email Address", clinic.email),
          _infoRow(Icons.phone_outlined, "Phone Number", clinic.phone),
          _infoRow(Icons.location_on_outlined, "Full Address", clinic.address),
        ]),
        SizedBox(height: 24.h),
        _infoSection("Pipeline Metrics", [
          _infoRow(Icons.people_outline, "Interested Patients", "${clinic.interestedPatientsCount} Patients"),
          _infoRow(Icons.event_note_rounded, "Pending Appointments", "${clinic.pendingAppointmentsCount} In Queue"),
        ]),
        if (clinic.notes != null && clinic.notes!.isNotEmpty) ...[
          SizedBox(height: 24.h),
          _infoSection("Administrative Notes", [
            Text(clinic.notes!, style: CustomFonts.grey14w400h16),
          ]),
        ],
      ],
    );
  }

  Widget _buildActionSidebar(BuildContext context, InviteClinicModel clinic) {
    return Column(
      children: [
        _infoSection("Invitation Control", [
          Text("Manage the outreach and onboarding workflow for this prospect.", 
            style: CustomFonts.grey13w500h15),
          SizedBox(height: 28.h),
          _actionButton(
            "Invite Clinic Now", 
            Icons.mail_outline_rounded, 
            CustomColors.brandCyan, 
            CustomColors.deepSlate,
            () {},
          ),
          SizedBox(height: 12.h),
          _actionButton(
            "Resend Invitation", 
            Icons.refresh_rounded, 
            Colors.white, 
            CustomColors.brandCyan,
            () {},
            isOutlined: true,
          ),
          SizedBox(height: 12.h),
          _actionButton(
            "Start Onboarding", 
            Icons.rocket_launch_outlined, 
            CustomColors.success, 
            Colors.white,
            () {
              context.push(AddNewClinicScreen.routeName, extra: clinic);
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 32.h),
            child: Divider(color: CustomColors.borderLight.withValues(alpha: 0.6)),
          ),
          _actionButton(
            "Archive Prospect", 
            Icons.block_flipped, 
            Colors.white, 
            CustomColors.error,
            () {},
            isOutlined: true,
          ),
        ]),
      ],
    );
  }

  Widget _infoSection(String title, List<Widget> children) {
    return BorderdContainerWidget(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: CustomFonts.black16w700),
          SizedBox(height: 24.h),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(color: CustomColors.backgroundLight, borderRadius: BorderRadius.circular(8.r)),
            child: Icon(icon, size: 18.sp, color: CustomColors.textSecondary),
          ),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: CustomFonts.grey13w500),
              Text(value, style: CustomFonts.grey14w600),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton(String label, IconData icon, Color bg, Color text, VoidCallback onTap, {bool isOutlined = false}) {
    final style = isOutlined
        ? OutlinedButton.styleFrom(
            foregroundColor: text,
            side: BorderSide(color: text.withValues(alpha: 0.5), width: 1.2),
            padding: EdgeInsets.symmetric(vertical: 20.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
            textStyle: CustomFonts.grey14w600ls03,
          ).copyWith(
            overlayColor: WidgetStateProperty.all(text.withValues(alpha: 0.05)),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: bg,
            foregroundColor: text,
            padding: EdgeInsets.symmetric(vertical: 20.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
            elevation: bg == CustomColors.brandCyan ? 4 : 0,
            shadowColor: bg.withValues(alpha: 0.4),
            textStyle: CustomFonts.grey14w700ls03,
          ).copyWith(
            overlayColor: WidgetStateProperty.all(text.withValues(alpha: 0.1)),
          );

    return SizedBox(
      width: double.infinity,
      child: isOutlined
          ? OutlinedButton.icon(
              onPressed: onTap,
              icon: Icon(icon, size: 20.sp),
              label: Text(label),
              style: style,
            )
          : ElevatedButton.icon(
              onPressed: onTap,
              icon: Icon(icon, size: 20.sp),
              label: Text(label),
              style: style,
            ),
    );
  }

  Widget _statusBadge(String status) {
    Color color = CustomColors.textSecondary;
    TextStyle textStyle = CustomFonts.grey10w700;
    String cleanStatus = status.toLowerCase();
    if (cleanStatus.contains('sent') || cleanStatus.contains('invited') || cleanStatus.contains('awaiting')) {
      color = CustomColors.brandCyan;
      textStyle = CustomFonts.cyan10w700;
    } else if (cleanStatus.contains('interested') || cleanStatus.contains('pending')) {
      color = CustomColors.success;
      textStyle = CustomFonts.success10w700;
    } else if (cleanStatus.contains('expired')) {
      color = CustomColors.error;
      textStyle = CustomFonts.error10w700;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        status.toUpperCase(),
        style: textStyle,
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: CustomColors.backgroundLight,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14.sp, color: CustomColors.textSecondary),
          SizedBox(width: 8.w),
          Text(label, style: CustomFonts.grey13w500),
        ],
      ),
    );
  }
}
