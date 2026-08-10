import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/founder_clinic_model.dart';
import 'package:skinsync_admin/screens/add_new_clinic_screen.dart';
import 'package:skinsync_admin/utils/date_time_utills.dart';
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
                (clinic.publicFacingClinicName ?? clinic.clinicName ?? 'F')[0].toUpperCase(),
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
                        clinic.publicFacingClinicName ?? clinic.clinicName ?? 'N/A',
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
                  clinic.primaryLocation ?? clinic.address ?? 'No Address Provided',
                  style: context.fonts.grey14w400,
                ),
                context.verticalSpace(4),
                Text(
                  'Requested on: ${formatDateTime(clinic.createdAt, includeTime: true, timeSeparator: ' | ')}',
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
        _infoSection(context, 'Clinic Information', [
          _infoRow(context, Icons.business_outlined, 'Clinic Legal Name', clinic.clinicLegalName ?? 'N/A'),
          _infoRow(context, Icons.storefront_outlined, 'Public Facing Name', clinic.publicFacingClinicName ?? 'N/A'),
          _infoRow(context, Icons.language_outlined, 'Website', clinic.website ?? 'N/A'),
          _infoRow(context, Icons.location_on_outlined, 'Primary Location', clinic.primaryLocation ?? 'N/A'),
          _infoRow(context, Icons.add_location_alt_outlined, 'Additional Locations', clinic.additionalLocations ?? 'N/A'),
          _infoRow(context, Icons.map_outlined, 'Primary Service Area', clinic.primaryServiceArea ?? 'N/A'),
        ]),
        context.verticalSpace(24),
        _infoSection(context, 'Contact Person', [
          _infoRow(context, Icons.person_outline, 'Primary Contact Name', clinic.primaryContactName ?? 'N/A'),
          _infoRow(context, Icons.email_outlined, 'Email Address', clinic.emailAddress ?? 'N/A'),
          _infoRow(context, Icons.phone_outlined, 'Phone Number', clinic.phoneNumber ?? 'N/A'),
        ]),
        context.verticalSpace(24),
        _infoSection(context, 'Representative & Authorization', [
          _infoRow(context, Icons.badge_outlined, 'Representative Name', clinic.representativeName ?? 'N/A'),
          _infoRow(context, Icons.title_outlined, 'Title', clinic.title ?? 'N/A'),
          _infoRow(context, Icons.draw_outlined, 'Electronic Signature', clinic.electronicSignature ?? 'N/A'),
          _infoRow(context, Icons.calendar_today_outlined, 'Signature Date', clinic.signatureDate ?? 'N/A'),
          _buildCheckRow(context, 'Authorized to submit request', clinic.authorizedToSubmit ?? false),
        ]),
      ],
    );
  }

  Widget _buildCheckRow(BuildContext context, String label, bool checked) {
    return Padding(
      padding: context.appEdgeInsets(bottom: 8),
      child: Row(
        children: [
          Icon(
            checked ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: checked ? CustomColors.green : CustomColors.red,
            size: 20,
          ),
          context.horizontalSpace(12),
          Text(label, style: context.fonts.black14w500),
        ],
      ),
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
    if (cleanStatus == 'pending' || cleanStatus == 'inactive') color = Colors.orange;

    return Container(
      padding: context.appEdgeInsets(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: context.borderRadius(all: 20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(status.toUpperCase(), style: context.fonts.grey10w700.copyWith(color: color)),
    );
  }
}
