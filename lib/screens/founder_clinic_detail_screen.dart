import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/founder_clinic_model.dart';
import 'package:skinsync_admin/screens/add_new_clinic_screen.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/clinic_view_model.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/widgets/custom_outlined_button.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';

class FounderClinicDetailScreen extends ConsumerWidget {
  static const String routeName = '/founder-clinic-detail';
  const FounderClinicDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clinic = ref.watch(clinicViewModelProvider).selectedFounderClinicDetail;

    if (clinic == null) {
      return GradientScaffold(
        body: Center(
          child: Text('No Founder Data Found', style: context.fonts.black16w400),
        ),
      );
    }

    return GradientScaffold(
      appBar: AppBar(
        flexibleSpace: AppDecorations.appBarGradient,
        elevation: 0,
        centerTitle: true,
        title: Text('Founder Clinic Detail', style: context.fonts.black18w600),
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
                    Expanded(
                      flex: 3,
                      child: _buildMainContent(context, clinic),
                    ),
                    context.horizontalSpace(32),
                    Expanded(
                      flex: 2,
                      child: _buildActionSidebar(context, ref, clinic),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, FounderClinicModel clinic) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Row(
        children: [
          Container(
            width: context.w(90),
            height: context.w(90),
            decoration: BoxDecoration(
              color: CustomColors.palePurple,
              borderRadius: context.borderRadius(all: 20),
            ),
            child: Center(
              child: Text(
                clinic.clinicName?[0].toUpperCase() ?? 'F',
                style: context.fonts.purple14w700.copyWith(fontSize: 32),
              ),
            ),
          ),
          context.horizontalSpace(24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        clinic.clinicName ?? 'N/A',
                        style: context.fonts.black20w600,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    context.horizontalSpace(12),
                    _statusBadge(context, clinic.status ?? 'Pending'),
                  ],
                ),
                context.verticalSpace(6),
                Text(
                  '${clinic.city ?? ""}, ${clinic.state ?? ""}',
                  style: context.fonts.grey14w400,
                ),
                context.verticalSpace(4),
                Text(
                  'Member since: ${_formatDate(clinic.createdAt)}',
                  style: context.fonts.grey12w400,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, FounderClinicModel clinic) {
    return Column(
      children: [
        _infoSection(context, 'General & Business Info', [
          _infoRow(context, Icons.business_outlined, 'Clinic Name', clinic.clinicName ?? 'N/A'),
          _infoRow(context, Icons.person_outline, 'Contact Person', clinic.contactName ?? 'N/A'),
          _infoRow(context, Icons.computer_outlined, 'Current EMR', clinic.currentEmr ?? 'N/A'),
          _infoRow(context, Icons.groups_outlined, 'No. of Providers', clinic.numberOfProviders ?? '0'),
          _infoRow(context, Icons.medical_services_outlined, 'Specialty', clinic.specialty ?? 'N/A'),
        ]),
        context.verticalSpace(24),
        _infoSection(context, 'Contact & Location', [
          _infoRow(context, Icons.email_outlined, 'Email Address', clinic.email ?? 'N/A'),
          _infoRow(context, Icons.phone_outlined, 'Phone Number', clinic.phone ?? 'N/A'),
          _infoRow(context, Icons.language_outlined, 'Website', clinic.website ?? 'N/A'),
          _infoRow(context, Icons.location_on_outlined, 'Address', '${clinic.address ?? "N/A"}, ${clinic.city ?? ""}, ${clinic.state ?? ""} ${clinic.zipCode ?? ""}'),
        ]),
        context.verticalSpace(24),
        _infoSection(context, 'Founder Statement', [
          _infoRow(context, Icons.camera_alt_outlined, 'Instagram', clinic.instagramHandle ?? 'N/A'),
          _infoRow(context, Icons.facebook_outlined, 'Facebook', clinic.facebookPage ?? 'N/A'),
          if (clinic.founderReason != null && clinic.founderReason!.isNotEmpty) ...[
            context.verticalSpace(12),
            Text('Why they want to join as Founder?', style: context.fonts.black14w600),
            context.verticalSpace(8),
            Container(
              width: double.infinity,
              padding: context.appEdgeInsets(all: 16),
              decoration: BoxDecoration(
                color: CustomColors.whiteGrey,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(clinic.founderReason!, style: context.fonts.grey14w400h16),
            ),
          ],
        ]),
      ],
    );
  }

  Widget _buildActionSidebar(BuildContext context, WidgetRef ref, FounderClinicModel clinic) {
    return Column(
      children: [
        _infoSection(context, 'Founder Onboarding', [
          Text(
            'Approve this clinic to become a founding partner and start their onboarding process.',
            style: context.fonts.grey13w500h15,
          ),
          context.verticalSpace(24),
          _actionButton(
            context,
            'Approve Founder',
            Icons.verified_outlined,
            CustomColors.green,
            Colors.white,
            () {
              // Logic to approve
            },
          ),
          context.verticalSpace(12),
          _actionButton(
            context,
            'Start Onboarding',
            Icons.rocket_launch_outlined,
            CustomColors.green,
            Colors.white,
            () {
              context.push(
                AddNewClinicScreen.routeName,
                extra: (clinic: clinic.toInviteClinicDetail(), onBoardClinic: true),
              );
            },
          ),
          context.verticalSpace(12),
          _actionButton(
            context,
            'Waitlist / Later',
            Icons.hourglass_empty_outlined,
            CustomColors.purple,
            CustomColors.purple,
            () {
              // Logic to waitlist
            },
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
            decoration: BoxDecoration(
              color: CustomColors.whiteGrey,
              borderRadius: context.borderRadius(all: 8),
            ),
            child: Icon(icon, size: context.sp(18), color: CustomColors.grey),
          ),
          context.horizontalSpace(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: context.fonts.grey13w500),
                Text(value, style: context.fonts.black14w600, maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(BuildContext context, String label, IconData icon, Color color, Color textColor, VoidCallback onTap, {bool isOutlined = false}) {
    if (isOutlined) {
      return CustomOutlinedButton(
        label: label,
        onTap: onTap,
        icon: icon,
        width: double.infinity,
        height: context.h(56),
        color: color,
        textColor: color,
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
    final String cleanStatus = status.toLowerCase();
    if (cleanStatus == 'approved') color = CustomColors.green;
    if (cleanStatus == 'rejected') color = CustomColors.red;
    if (cleanStatus == 'pending') color = Colors.orange;

    return Container(
      padding: context.appEdgeInsets(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: context.borderRadius(all: 20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(status.toUpperCase(), style: context.fonts.grey10w700.copyWith(color: color)),
    );
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}
