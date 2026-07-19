import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/responses/invite_clinic_detail_response.dart';
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
    final clinic = ref
        .watch(clinicViewModelProvider)
        .selectedInviteClinicDetail;

    if (clinic == null) {
      return GradientScaffold(
        body: Center(
          child: Text('No Clinic Data Found', style: context.fonts.black16w400),
        ),
      );
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

  Widget _buildHeaderCard(BuildContext context, InviteClinicDetailData clinic) {
    return BorderdContainerWidget(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Image
          Container(
            height: context.h(180),
            width: double.infinity,
            decoration: BoxDecoration(
              color: CustomColors.whiteGrey,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
              image: (clinic.banner != null && clinic.banner!.isNotEmpty)
                  ? DecorationImage(
                      image: NetworkImage(clinic.banner!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: (clinic.banner == null || clinic.banner!.isEmpty)
                ? Center(
                    child: Icon(
                      Icons.image_outlined,
                      size: context.sp(48),
                      color: CustomColors.grey.withOpacity(0.5),
                    ),
                  )
                : null,
          ),
          Padding(
            padding: context.appEdgeInsets(all: 24),
            child: Row(
              children: [
                Container(
                  width: context.w(90),
                  height: context.w(90),
                  decoration: BoxDecoration(
                    color: CustomColors.whiteGrey,
                    borderRadius: context.borderRadius(all: 20),
                    image: (clinic.logo != null && clinic.logo!.isNotEmpty)
                        ? DecorationImage(
                            image: NetworkImage(clinic.logo!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: (clinic.logo == null || clinic.logo!.isEmpty)
                      ? Icon(
                          Icons.business_outlined,
                          size: context.sp(36),
                          color: CustomColors.black,
                        )
                      : null,
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
                              clinic.name ?? 'N/A',
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
                        clinic.address ?? 'N/A',
                        style: context.fonts.grey14w400,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(
    BuildContext context,
    InviteClinicDetailData clinic,
  ) {
    return Column(
      children: [
        _infoSection(context, 'Contact & General Info', [
          _infoRow(
            context,
            Icons.email_outlined,
            'Email Address',
            clinic.email ?? 'N/A',
          ),
          _infoRow(
            context,
            Icons.phone_outlined,
            'Phone Number',
            clinic.phone ?? 'N/A',
          ),
          _infoRow(
            context,
            Icons.location_on_outlined,
            'Full Address',
            clinic.address ?? 'N/A',
          ),
          _infoRow(
            context,
            Icons.language_outlined,
            'Website',
            clinic.website ?? 'N/A',
          ),
          if (clinic.description != null && clinic.description!.isNotEmpty) ...[
            context.verticalSpace(12),
            Text('About Clinic', style: context.fonts.black14w600),
            context.verticalSpace(8),
            Text(clinic.description!, style: context.fonts.grey14w400h16),
          ],
        ]),
        context.verticalSpace(24),
        _infoSection(context, 'Treatments Registered', [
          if (clinic.treatments == null || clinic.treatments!.isEmpty)
            _buildTreatmentsEmptyState(context)
          else
            Column(
              children: clinic.treatments!
                  .map((t) => _buildTreatmentRow(context, t))
                  .toList(),
            ),
        ]),
      ],
    );
  }

  Widget _buildTreatmentsEmptyState(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.h(24)),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.medical_services_outlined,
              size: context.sp(40),
              color: CustomColors.grey,
            ),
            context.verticalSpace(12),
            Text(
              'No treatments registered currently',
              style: context.fonts.grey14w500,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTreatmentRow(BuildContext context, dynamic treatment) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.h(8)),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            color: CustomColors.green,
            size: context.sp(20),
          ),
          context.horizontalSpace(12),
          Text(treatment.toString(), style: context.fonts.black14w500),
        ],
      ),
    );
  }

  Widget _buildActionSidebar(
    BuildContext context,
    WidgetRef ref,
    InviteClinicDetailData clinic,
  ) {
    return Column(
      children: [
        _infoSection(context, 'Invitation Control', [
          Text(
            'Manage the outreach and onboarding workflow for this prospect.',
            style: context.fonts.grey13w500h15,
          ),
          context.verticalSpace(24),
          _actionButton(
            context,
            'Invite Clinic Now',
            Icons.mail_outline_rounded,
            CustomColors.green,
            CustomColors.black,
            () async {
              if (clinic.clinicId == null) return;
              final success = await ref
                  .read(clinicViewModelProvider.notifier)
                  .sendInvitation(clinic.clinicId!);
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Invitation sent successfully!'),
                  ),
                );
              }
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
                extra: (clinic: clinic, onBoardClinic: true),
              );
            },
          ),
        ]),
        context.verticalSpace(24),
        _infoSection(context, 'Availability Hours', [
          if (clinic.availability == null || clinic.availability!.isEmpty)
            Text(
              'No working hours registered.',
              style: context.fonts.grey14w400,
            )
          else
            ...clinic.availability!.map(
              (a) => _buildAvailabilityCard(context, a),
            ),
        ]),
      ],
    );
  }

  Widget _buildAvailabilityCard(
    BuildContext context,
    InviteClinicAvailability availability,
  ) {
    final String daysStr = availability.days?.join(', ') ?? 'N/A';
    return Container(
      margin: EdgeInsets.only(bottom: context.h(12)),
      padding: EdgeInsets.all(context.w(12)),
      decoration: BoxDecoration(
        color: CustomColors.whiteGrey,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Working Hours', style: context.fonts.black13w600),
              Text(
                '${availability.openTime ?? "09:00"} - ${availability.closeTime ?? "17:00"}',
                style: context.fonts.purple13w600,
              ),
            ],
          ),
          context.verticalSpace(8),
          Text(
            daysStr,
            style: context.fonts.grey12w400,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _infoSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
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

  Widget _infoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
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
                Text(
                  value,
                  style: context.fonts.grey14w600,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color bg,
    Color text,
    VoidCallback onTap, {
    bool isOutlined = false,
  }) {
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
    if (cleanStatus.contains('sent') ||
        cleanStatus.contains('invited') ||
        cleanStatus.contains('awaiting') ||
        cleanStatus.contains('active')) {
      color = CustomColors.green;
      textStyle = context.fonts.green10w700;
    } else if (cleanStatus.contains('interested') ||
        cleanStatus.contains('pending')) {
      color = CustomColors.green;
      textStyle = context.fonts.green10w700;
    } else if (cleanStatus.contains('expired')) {
      color = CustomColors.red;
      textStyle = context.fonts.red10w700;
    }

    return Container(
      padding: context.appEdgeInsets(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: context.borderRadius(all: 20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(status.toUpperCase(), style: textStyle),
    );
  }
}
