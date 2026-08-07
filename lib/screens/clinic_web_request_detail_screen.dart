import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/clinic_web_request_model.dart';
import 'package:skinsync_admin/models/requests/send_notes_request.dart';
import 'package:skinsync_admin/screens/add_new_clinic_screen.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/clinic_view_model.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';
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
        title: Text('Registration Request Detail', style: context.fonts.black18w600),
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
                (request.clinicOrPracticeName ?? request.clinicName ?? 'W')[0].toUpperCase(),
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
                        request.clinicOrPracticeName ?? request.clinicName ?? 'N/A',
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
                  request.primaryClinicAddress ?? request.clinicLocation ?? 'No Address Provided',
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
          _infoRow(context, Icons.business_outlined, 'Clinic/Practice Name', request.clinicOrPracticeName ?? 'N/A'),
          _infoRow(context, Icons.category_outlined, 'Clinic Type', request.clinicType ?? 'N/A'),
          _infoRow(context, Icons.language_outlined, 'Clinic Website', request.clinicWebsite ?? 'N/A'),
          _infoRow(context, Icons.location_on_outlined, 'Primary Address', request.primaryClinicAddress ?? 'N/A'),
          _infoRow(context, Icons.pin_drop_outlined, 'Number of Locations', request.numberOfLocations ?? 'N/A'),
        ]),
        context.verticalSpace(24),
        _infoSection(context, 'Contact Person', [
          _infoRow(context, Icons.person_outline, 'First & Last Name', request.firstAndLastName ?? 'N/A'),
          _infoRow(context, Icons.badge_outlined, 'Professional Title', request.professionalTitle ?? 'N/A'),
          _infoRow(context, Icons.email_outlined, 'Business Email', request.businessEmailAddress ?? 'N/A'),
          _infoRow(context, Icons.phone_outlined, 'Phone Number', request.phoneNumber ?? 'N/A'),
        ]),
        context.verticalSpace(24),
        _infoSection(context, 'Business Volume & Tools', [
          _infoRow(context, Icons.groups_outlined, 'Approx. Providers', request.approximateNumberOfProviders ?? 'N/A'),
          _infoRow(context, Icons.person_add_alt_1_outlined, 'Monthly Patient Volume', request.approximateMonthlyPatientVolume ?? 'N/A'),
          _infoRow(context, Icons.computer_outlined, 'Current Software', request.currentSchedulingEhrCrmOrPracticeManagementSoftware ?? 'N/A'),
        ]),
        context.verticalSpace(24),
        _infoSection(context, 'Additional Details', [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('SkinSync AI Capabilities Interested In:', style: context.fonts.black14w600),
              context.verticalSpace(12),
              if (request.skinsyncAiCapabilities != null && request.skinsyncAiCapabilities!.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: request.skinsyncAiCapabilities!.map((cap) => Container(
                    padding: context.appEdgeInsets(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: CustomColors.palePurple,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(cap, style: context.fonts.purple13w600),
                  )).toList(),
                )
              else
                Text('None selected', style: context.fonts.grey14w400),
            ],
          ),
          context.verticalSpace(20),
          _infoRow(context, Icons.campaign_outlined, 'How did you hear about us?', request.howDidYouHearAboutSkinsyncAi ?? 'N/A'),
          context.verticalSpace(12),
          _buildCheckRow(context, 'Authorized to create account', request.authorizedToCreateAccount ?? false),
          _buildCheckRow(context, 'Agreed to Terms & Privacy Policy', request.agreeToTermsOfServiceAndPrivacyPolicy ?? false),
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

  Widget _buildActionSidebar(BuildContext context, WidgetRef ref, ClinicWebRequestModel request) {
    return Column(
      children: [
        _infoSection(context, 'Feedback & Notes', [
          Text(
            'Send follow-up notes or internal feedback regarding this registration request directly to the clinic\'s provided email address.',
            style: context.fonts.grey13w500h15,
          ),
          context.verticalSpace(24),
          _actionButton(
            context,
            'Send Notes',
            Icons.email_outlined,
            CustomColors.purple,
            Colors.white,
            () => _showSendNotesDialog(context, ref, request),
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
                extra: (clinic: request.toInviteClinicDetail(), onBoardClinic: true),
              );
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

  void _showSendNotesDialog(BuildContext context, WidgetRef ref, ClinicWebRequestModel request) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Send Notes to ${request.clinicOrPracticeName ?? request.clinicName}', style: context.fonts.black18w600),
              context.verticalSpace(4),
              Text('Recipient: ${request.businessEmailAddress ?? request.ownerEmail}', style: context.fonts.grey12w400),
            ],
          ),
          content: SizedBox(
            width: context.w(400),
            child: BuildTextField(
              label: 'Notes',
              controller: controller,
              hintText: 'Type your feedback or notes here...',
              maxLines: 5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: context.fonts.grey14w600),
            ),
              CustomPrimaryButton(
                onTap: () async {
                  final notes = controller.text.trim();
                  if (notes.isEmpty) return;

                  final email = request.businessEmailAddress ?? request.ownerEmail;
                  if (email == null || email.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Recipient email not found!')),
                    );
                    return;
                  }

                  final req = SendNotesRequest(email: email, notes: notes);
                  final success = await ref
                      .read(clinicViewModelProvider.notifier)
                      .sendWebRequestNotes(request.id!, req);
                  if (success && context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notes sent successfully!')),
                    );
                  }
                },
                label: 'Send Email',
                width: 120.w,
              ),
          ],
        );
      },
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
