import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/invite_clinic_model.dart';
import 'package:skinsync_admin/screens/add_new_clinic_screen.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/clinic_view_model.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/widgets/custom_outlined_button.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';

class InviteClinicDetailScreen extends ConsumerWidget {
  static const String routeName = '/invite-clinic-detail';
  const InviteClinicDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clinic = ref.watch(clinicViewModelProvider).selectedInviteClinic;

    if (clinic == null) {
      return GradientScaffold(body: Center(child: Text('No Clinic Data Found', style: context.fonts.black16w400)));
    }

    return GradientScaffold(
      appBar: AppBar(
        flexibleSpace: AppDecorations.appBarGradient,
        elevation: 0,
        centerTitle: true,
        title: Text('Prospect Clinic Detail', style: context.fonts.black18w600),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: CustomColors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(horizontal: 24, vertical: 32),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.w(1000)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderCard(context, clinic),
                context.verticalSpace(32),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: _buildMainContent(context, clinic)),
                    context.horizontalSpace(32),
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

  Widget _buildHeaderCard(BuildContext context, InviteClinicModel clinic) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 32),
      child: Row(
        children: [
          Container(
            width: context.w(120),
            height: context.w(120),
            decoration: BoxDecoration(
              color: CustomColors.whiteGrey,
              borderRadius: context.borderRadius(all: 20),
              image: (clinic.logo != null && clinic.logo!.isNotEmpty)
                  ? DecorationImage(image: NetworkImage(clinic.logo!), fit: BoxFit.cover)
                  : null,
            ),
            child: (clinic.logo == null || clinic.logo!.isEmpty)
                ? Icon(Icons.business_outlined, size: context.sp(48), color: CustomColors.black)
                : null,
          ),
          context.horizontalSpace(32),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(clinic.name, style: context.fonts.black26w700),
                    context.horizontalSpace(16),
                    _statusBadge(context, clinic.invitationStatus),
                  ],
                ),
                context.verticalSpace(8),
                Text(clinic.address, style: context.fonts.grey16w400),
                context.verticalSpace(16),
                Row(
                  children: [
                    _infoChip(context, Icons.calendar_today_outlined, 'Identified on: ${clinic.invitedDate}'),
                    context.horizontalSpace(12),
                    _infoChip(context, Icons.trending_up_rounded, '${clinic.interestedPatientsCount} Potential Patients'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, InviteClinicModel clinic) {
    return Column(
      children: [
        _infoSection(context, 'Contact Details', [
          _infoRow(context, Icons.email_outlined, 'Email Address', clinic.email),
          _infoRow(context, Icons.phone_outlined, 'Phone Number', clinic.phone),
          _infoRow(context, Icons.location_on_outlined, 'Full Address', clinic.address),
        ]),
        context.verticalSpace(24),
        _infoSection(context, 'Pipeline Metrics', [
          _infoRow(context, Icons.people_outline, 'Interested Patients', '${clinic.interestedPatientsCount} Patients'),
          _infoRow(context, Icons.event_note_rounded, 'Pending Appointments', '${clinic.pendingAppointmentsCount} In Queue'),
        ]),
        if (clinic.notes != null && clinic.notes!.isNotEmpty) ...[
          context.verticalSpace(24),
          _infoSection(context, 'Administrative Notes', [
            Text(clinic.notes!, style: context.fonts.grey14w400h16),
          ]),
        ],
      ],
    );
  }

  Widget _buildActionSidebar(BuildContext context, InviteClinicModel clinic) {
    return Column(
      children: [
        _infoSection(context, 'Invitation Control', [
          Text('Manage the outreach and onboarding workflow for this prospect.', 
            style: context.fonts.grey13w500h15),
          context.verticalSpace(28),
          _actionButton(
            context,
            'Invite Clinic Now', 
            Icons.mail_outline_rounded, 
            CustomColors.green, 
            CustomColors.black,
            () {},
          ),
          context.verticalSpace(12),
          _actionButton(
            context,
            'Resend Invitation', 
            Icons.refresh_rounded, 
            Colors.white, 
            CustomColors.green,
            () {},
            isOutlined: true,
          ),
          context.verticalSpace(12),
          _actionButton(
            context,
            'Start Onboarding', 
            Icons.rocket_launch_outlined, 
            CustomColors.green, 
            Colors.white,
            () {
              context.push(AddNewClinicScreen.routeName, extra: clinic);
            },
          ),
          Padding(
            padding: context.appEdgeInsets(vertical: 32),
            child: Divider(color: CustomColors.border.withValues(alpha: 0.6)),
          ),
          _actionButton(
            context,
            'Archive Prospect', 
            Icons.block_flipped, 
            Colors.white, 
            CustomColors.red,
            () {},
            isOutlined: true,
          ),
        ]),
      ],
    );
  }

  Widget _infoSection(BuildContext context, String title, List<Widget> children) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.fonts.black16w700),
          context.verticalSpace(24),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: context.appEdgeInsets(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: context.appEdgeInsets(all: 8),
            decoration: BoxDecoration(color: CustomColors.whiteGrey, borderRadius: context.borderRadius(all: 8)),
            child: Icon(icon, size: context.sp(18), color: CustomColors.grey),
          ),
          context.horizontalSpace(16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: context.fonts.grey13w500),
              Text(value, style: context.fonts.grey14w600),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton(BuildContext context, String label, IconData icon, Color bg, Color text, VoidCallback onTap, {bool isOutlined = false}) {
    if (isOutlined) {
      return CustomOutlinedButton(
        label: label,
        onTap: onTap,
        icon: icon,
        width: double.infinity,
        height: context.h(56),
        color: text,
      );
    }

    return CustomPrimaryButton(
      label: label,
      onTap: onTap,
      icon: icon,
      width: double.infinity,
      height: context.h(56),
    );
  }

  Widget _statusBadge(BuildContext context, String status) {
    Color color = CustomColors.grey;
    TextStyle textStyle = context.fonts.grey10w700;
    final String cleanStatus = status.toLowerCase();
    if (cleanStatus.contains('sent') || cleanStatus.contains('invited') || cleanStatus.contains('awaiting')) {
      color = CustomColors.green;
      textStyle = context.fonts.green10w700;
    } else if (cleanStatus.contains('interested') || cleanStatus.contains('pending')) {
      color = CustomColors.green;
      textStyle = context.fonts.green10w700;
    } else if (cleanStatus.contains('expired')) {
      color = CustomColors.red;
      textStyle = context.fonts.red10w700;
    }

    return Container(
      padding: context.appEdgeInsets(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: context.borderRadius(all: 20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        status.toUpperCase(),
        style: textStyle,
      ),
    );
  }

  Widget _infoChip(BuildContext context, IconData icon, String label) {
    return Container(
      padding: context.appEdgeInsets(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: CustomColors.whiteGrey,
        borderRadius: context.borderRadius(all: 8),
      ),
      child: Row(
        children: [
          Icon(icon, size: context.sp(14), color: CustomColors.grey),
          context.horizontalSpace(8),
          Text(label, style: context.fonts.grey13w500),
        ],
      ),
    );
  }
}
