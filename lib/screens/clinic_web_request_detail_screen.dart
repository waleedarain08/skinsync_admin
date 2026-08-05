import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/clinic_web_request_model.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/clinic_view_model.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/widgets/custom_outlined_button.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';

class ClinicWebRequestDetailScreen extends ConsumerWidget {
  static const String routeName = '/clinic-web-request-detail';
  const ClinicWebRequestDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final request = ref.watch(clinicViewModelProvider).selectedWebRequestDetail;

    if (request == null) {
      return GradientScaffold(
        body: Center(
          child: Text('No Request Data Found', style: context.fonts.black16w400),
        ),
      );
    }

    return GradientScaffold(
      appBar: AppBar(
        flexibleSpace: AppDecorations.appBarGradient,
        elevation: 0,
        centerTitle: true,
        title: Text('Web Registration Request', style: context.fonts.black18w600),
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
                _buildHeaderCard(context, request),
                context.verticalSpace(32),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildMainContent(context, request),
                    ),
                    context.horizontalSpace(32),
                    Expanded(
                      flex: 2,
                      child: _buildActionSidebar(context, ref, request),
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

  Widget _buildHeaderCard(BuildContext context, ClinicWebRequestModel request) {
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
                request.clinicName?[0].toUpperCase() ?? 'W',
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
                        request.clinicName ?? 'N/A',
                        style: context.fonts.black20w600,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    context.horizontalSpace(12),
                    _statusBadge(context, request.status ?? 'Pending'),
                  ],
                ),
                context.verticalSpace(6),
                Text(
                  request.address ?? 'No Address Provided',
                  style: context.fonts.grey14w400,
                ),
                context.verticalSpace(4),
                Text(
                  'Requested on: ${_formatDate(request.createdAt)}',
                  style: context.fonts.grey12w400,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, ClinicWebRequestModel request) {
    return Column(
      children: [
        _infoSection(context, 'Clinic Information', [
          _infoRow(context, Icons.business_outlined, 'Clinic Name', request.clinicName ?? 'N/A'),
          _infoRow(context, Icons.person_outline, 'Owner Name', request.ownerName ?? 'N/A'),
          _infoRow(context, Icons.medical_services_outlined, 'Specialty', request.specialty ?? 'N/A'),
          _infoRow(context, Icons.history_outlined, 'Years in Business', request.yearsInBusiness ?? 'N/A'),
        ]),
        context.verticalSpace(24),
        _infoSection(context, 'Contact Details', [
          _infoRow(context, Icons.email_outlined, 'Email Address', request.email ?? 'N/A'),
          _infoRow(context, Icons.phone_outlined, 'Phone Number', request.phone ?? 'N/A'),
          _infoRow(context, Icons.language_outlined, 'Website', request.website ?? 'N/A'),
          _infoRow(context, Icons.location_on_outlined, 'Full Address', request.address ?? 'N/A'),
        ]),
        context.verticalSpace(24),
        _infoSection(context, 'Social Media & Message', [
          _infoRow(context, Icons.camera_alt_outlined, 'Instagram', request.instagramHandle ?? 'N/A'),
          _infoRow(context, Icons.facebook_outlined, 'Facebook', request.facebookPage ?? 'N/A'),
          if (request.message != null && request.message!.isNotEmpty) ...[
            context.verticalSpace(12),
            Text('Message from Clinic', style: context.fonts.black14w600),
            context.verticalSpace(8),
            Container(
              width: double.infinity,
              padding: context.appEdgeInsets(all: 16),
              decoration: BoxDecoration(
                color: CustomColors.whiteGrey,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(request.message!, style: context.fonts.grey14w400h16),
            ),
          ],
        ]),
      ],
    );
  }

  Widget _buildActionSidebar(BuildContext context, WidgetRef ref, ClinicWebRequestModel request) {
    return Column(
      children: [
        _infoSection(context, 'Request Actions', [
          Text(
            'Review this web registration request and decide whether to approve it for onboarding.',
            style: context.fonts.grey13w500h15,
          ),
          context.verticalSpace(24),
          _actionButton(
            context,
            'Approve & Send Invitation',
            Icons.check_circle_outline,
            CustomColors.green,
            Colors.white,
            () {
              // Logic to approve and invite
            },
          ),
          context.verticalSpace(12),
          _actionButton(
            context,
            'Reject Request',
            Icons.cancel_outlined,
            CustomColors.red,
            CustomColors.red,
            () {
              // Logic to reject
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
