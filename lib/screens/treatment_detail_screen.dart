import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/models/responses/treatment_detail_response.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';
import 'package:skinsync_admin/widgets/app_network_image.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';

class TreatmentDetailScreen extends ConsumerWidget {
  const TreatmentDetailScreen({super.key});
  static const String routeName = '/treatment-detail';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(treatmentViewModelProvider);
    final detail = state.selectedTreatmentDetail;

    if (state.loading) {
      return Scaffold(
        appBar: AppBar(
          flexibleSpace: AppDecorations.appBarGradient,
          title: const Text('Loading Details...'),
          centerTitle: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(color: CustomColors.purple),
        ),
      );
    }

    if (detail == null) {
      return Scaffold(
        appBar: AppBar(
          flexibleSpace: AppDecorations.appBarGradient,
          title: const Text('Treatment Details'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('No treatment details found (N/A)'),
        ),
      );
    }

    final status = detail.status ?? 'Draft';
    final statusColor = status.toLowerCase() == 'active'
        ? CustomColors.green
        : (status.toLowerCase() == 'draft' ? CustomColors.amber : CustomColors.red);

    return GradientScaffold(
      appBar: AppBar(
        flexibleSpace: AppDecorations.appBarGradient,
        title: Text(
          detail.patientDisplayName ?? 'Treatment Details',
          style: context.fonts.black18w600,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(horizontal: 24, vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.w(1100)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Hero Banner & Profile Card
                _buildHeroBannerCard(context, detail, status, statusColor),
                context.verticalSpace(24),

                // Main 2-Column Desktop Grid
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column (Description, Categories, Selected Areas)
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDescriptionCard(context, detail),
                          context.verticalSpace(24),
                          _buildCategoriesSection(context, detail),
                          context.verticalSpace(24),
                          _buildSelectedAreasSection(context, detail),
                          context.verticalSpace(24),
                          _buildSessionsListSection(context, detail),
                        ],
                      ),
                    ),
                    context.horizontalSpace(24),
                    // Right Column (Quick Stats / Business Logic)
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildBusinessLogicCard(context, detail),
                          context.verticalSpace(24),
                          _buildMetadataCard(context, detail),
                        ],
                      ),
                    ),
                  ],
                ),
                context.verticalSpace(48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroBannerCard(
    BuildContext context,
    TreatmentDetailDto detail,
    String status,
    Color statusColor,
  ) {
    return BorderdContainerWidget(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: context.appBorderRadius(all: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Image
            AppNetworkImage(
              imageUrl: detail.image ?? '',
              width: double.infinity,
              height: context.h(220),
              fit: BoxFit.cover,
              errorIcon: Icons.image_outlined,
              errorIconSize: 48,
            ),
            Padding(
              padding: context.appEdgeInsets(all: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Circular Icon
                  AppNetworkImage(
                    imageUrl: detail.icon ?? '',
                    width: 64,
                    height: 64,
                    borderRadius: BorderRadius.circular(32),
                    fit: BoxFit.cover,
                    errorIcon: Icons.spa_outlined,
                    errorIconSize: 28,
                  ),
                  context.horizontalSpace(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                detail.patientDisplayName ?? 'N/A',
                                style: context.fonts.black18w600.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: statusColor.withValues(alpha: 0.2),
                                ),
                              ),
                              child: Text(
                                status,
                                style: context.fonts.grey10w700ls1.copyWith(
                                  color: statusColor,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        context.verticalSpace(6),
                        Row(
                          children: [
                            const Icon(
                              Icons.tag_rounded,
                              size: 16,
                              color: CustomColors.grey,
                            ),
                            context.horizontalSpace(6),
                            Text(
                              'SKU: ${detail.globalSku ?? "N/A"}',
                              style: context.fonts.grey13w500,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionCard(BuildContext context, TreatmentDetailDto detail) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.description_outlined,
                color: CustomColors.purple,
                size: 20,
              ),
              context.horizontalSpace(10),
              Text('Description & Details', style: context.fonts.black16w700),
            ],
          ),
          context.verticalSpace(14),
          Text(
            detail.shortDescription ?? 'No short summary provided.',
            style: context.fonts.black14w700.copyWith(color: CustomColors.grey),
          ),
          context.verticalSpace(10),
          const Divider(),
          context.verticalSpace(10),
          Text(
            detail.description ?? 'No detailed description provided.',
            style: context.fonts.grey14w400h16.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection(
    BuildContext context,
    TreatmentDetailDto detail,
  ) {
    final categories = detail.selectedCategories ?? [];

    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.category_outlined,
                color: CustomColors.purple,
                size: 20,
              ),
              context.horizontalSpace(10),
              Text(
                'Assigned Category Path',
                style: context.fonts.black16w700,
              ),
            ],
          ),
          context.verticalSpace(16),
          if (categories.isEmpty)
            Text(
              'No laser categories assigned (N/A)',
              style: context.fonts.grey13w500,
            )
          else
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: categories.map((cat) {
                return Container(
                  padding: context.appEdgeInsets(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: CustomColors.palePurple.withValues(alpha: 0.05),
                    borderRadius: context.appBorderRadius(all: 8),
                    border: Border.all(
                      color: CustomColors.purple.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: CustomColors.purple,
                        size: 18,
                      ),
                      context.horizontalSpace(8),
                      Text(
                        cat.name ?? 'Category',
                        style: context.fonts.black13w600,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildSelectedAreasSection(
    BuildContext context,
    TreatmentDetailDto detail,
  ) {
    final areas = detail.selectedAreas ?? [];

    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: CustomColors.purple,
                size: 20,
              ),
              context.horizontalSpace(10),
              Text('Anatomical Target Areas', style: context.fonts.black16w700),
            ],
          ),
          context.verticalSpace(16),
          if (areas.isEmpty)
            Text(
              'No target body areas selected (N/A)',
              style: context.fonts.grey13w500,
            )
          else
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: areas.map((area) {
                return Container(
                  padding: context.appEdgeInsets(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: CustomColors.whiteGrey,
                    borderRadius: context.appBorderRadius(all: 8),
                    border: Border.all(color: CustomColors.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppNetworkImage(
                        imageUrl: area.icon ?? '',
                        width: 20,
                        height: 20,
                        fit: BoxFit.contain,
                        errorIcon: Icons.location_searching,
                        errorIconSize: 14,
                      ),
                      context.horizontalSpace(10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            area.name ?? 'Target Area',
                            style: context.fonts.black13w600,
                          ),
                          Text(
                            'SKU: ${area.globalSku ?? "—"}',
                            style: context.fonts.grey11w400,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildSessionsListSection(
    BuildContext context,
    TreatmentDetailDto detail,
  ) {
    final sessions = detail.sessions;

    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.event_note_outlined,
                color: CustomColors.purple,
                size: 20,
              ),
              context.horizontalSpace(10),
              Text(
                'Clinical Session Schedules',
                style: context.fonts.black16w700,
              ),
            ],
          ),
          context.verticalSpace(16),
          if (sessions.isEmpty)
            Text(
              'No active clinical sessions defined (N/A)',
              style: context.fonts.grey13w500,
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sessions.length,
              separatorBuilder: (_, __) => context.verticalSpace(16),
              itemBuilder: (context, index) {
                final session = sessions[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: context.appBorderRadius(all: 12),
                    border: Border.all(
                      color: CustomColors.purple.withValues(alpha: 0.15),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: CustomColors.purple.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: context.appBorderRadius(all: 12),
                    child: ExpansionTile(
                      shape: const RoundedRectangleBorder(side: BorderSide.none),
                      collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
                      backgroundColor: Colors.white,
                      collapsedBackgroundColor: Colors.white,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              session.title ?? 'Clinical Procedure Session',
                              style: context.fonts.black14w700,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: CustomColors.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              session.status ?? 'Active',
                              style: context.fonts.green14w600.copyWith(
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 6,
                          children: [
                            _sessionMetaChip(
                              context,
                              Icons.calendar_view_day,
                              'Session #${session.sessionNumber}',
                            ),
                            _sessionMetaChip(
                              context,
                              Icons.layers_outlined,
                              'Step ${session.currentStep ?? 12}',
                            ),
                            _sessionMetaChip(
                              context,
                              Icons.location_searching,
                              session.areaName ?? 'Target Area',
                            ),
                          ],
                        ),
                      ),
                      childrenPadding: context.appEdgeInsets(horizontal: 16, vertical: 16),
                      children: [
                        const Divider(),
                        context.verticalSpace(12),
                        
                        // 1. Timings & Pricing Policies Grid
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _buildSessionSubCard(
                                context,
                                title: 'Duration & Timeline',
                                icon: Icons.schedule,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildDetailText(context, 'Base Duration', '${session.baseDuration ?? 0} mins'),
                                    _buildDetailText(context, 'Prep Time', '${session.prepTime ?? 0} mins'),
                                    _buildDetailText(context, 'Cleanup Time', '${session.cleanupTime ?? 0} mins'),
                                    _buildDetailText(context, 'Total Calculated', '${session.calculatedTotalDuration ?? 0} mins'),
                                    if (session.isFixedDuration == true)
                                      _buildDetailText(context, 'Fixed Override', '${session.fixedDuration ?? 0} mins (Fixed)', isHighlight: true),
                                  ],
                                ),
                              ),
                            ),
                            context.horizontalSpace(16),
                            Expanded(
                              child: _buildSessionSubCard(
                                context,
                                title: 'Pricing & Billings',
                                icon: Icons.payments_outlined,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildDetailText(context, 'Base Price', '\$${session.basePrice ?? 0.0}'),
                                    _buildDetailText(context, 'Fixed Price Mode', session.isFixedPrice == true ? 'Yes' : 'No'),
                                    if (session.isFixedPrice == true)
                                      _buildDetailText(context, 'Fixed Price Override', '\$${session.fixedPrice ?? 0.0}', isHighlight: true),
                                    _buildDetailText(context, 'Clinic Overrides', session.allowClinicOverride == true ? 'Allowed' : 'Disabled'),
                                    _buildDetailText(context, 'Provider Overrides', session.allowProviderOverride == true ? 'Allowed' : 'Disabled'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        context.verticalSpace(16),

                        // 2. Product Usages & Consumption
                        _buildSessionSubCard(
                          context,
                          title: 'Required Product Consumables',
                          icon: Icons.biotech_outlined,
                          child: (session.productUsages == null || session.productUsages!.isEmpty)
                              ? Text('No products allocated for this session.', style: context.fonts.grey12w400)
                              : Column(
                                  children: session.productUsages!.map((prod) {
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: CustomColors.whiteGrey,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: CustomColors.border),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(prod.productName ?? 'Product Item', style: context.fonts.black13w600),
                                                Text('SKU: ${prod.productSku ?? "—"}', style: context.fonts.grey11w400),
                                                if (prod.notes != null && prod.notes!.isNotEmpty)
                                                  Text('Note: ${prod.notes}', style: context.fonts.grey11w400.copyWith(fontStyle: FontStyle.italic)),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text('Qty: ${prod.minQuantity ?? 0.0} - ${prod.maxQuantity ?? 0.0}', style: context.fonts.black12w600),
                                              Text(prod.allowSubstitution == true ? 'Substitutions OK' : 'No Substitution', style: context.fonts.grey11w400),
                                              Text('Deduct: ${prod.deductionTiming ?? "before"}', style: context.fonts.grey11w400),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                        ),
                        context.verticalSpace(16),

                        // 3. Clinical Instructions & Legal Documents
                        _buildSessionSubCard(
                          context,
                          title: 'Clinical Protocols & Directives',
                          icon: Icons.gavel_outlined,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (session.preTreatmentConsentForm != null)
                                _buildAttachmentLink(context, 'Pre-Treatment Consent Form', session.preTreatmentConsentForm!.name, session.preTreatmentConsentForm!.url),
                              if (session.clinicalProtocolPdf != null)
                                _buildAttachmentLink(context, 'Internal Clinical Protocol PDF', session.clinicalProtocolPdf!.name, session.clinicalProtocolPdf!.url),
                              context.verticalSpace(8),
                              _buildInstructionBlock(context, 'Pre-Care Directives', session.preTreatmentInstructions ?? 'None specified.'),
                              context.verticalSpace(8),
                              _buildInstructionBlock(context, 'Post-Care Directives', session.postTreatmentInstructions ?? 'None specified.'),
                            ],
                          ),
                        ),
                        context.verticalSpace(16),

                        // 4. Booking Policy & Notifications
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _buildSessionSubCard(
                                context,
                                title: 'Booking Policies',
                                icon: Icons.calendar_month_outlined,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildDetailText(context, 'Online Bookable', session.onlineBookable == true ? 'Yes' : 'No'),
                                    _buildDetailText(context, 'Manual Approval', session.manualApprovalRequired == true ? 'Required' : 'None'),
                                    _buildDetailText(context, 'Min Booking Notice', '${session.minimumBookingNotice ?? 24} hours'),
                                    _buildDetailText(context, 'Max Days Advance', '${session.maximumDaysInAdvance ?? 60} days'),
                                  ],
                                ),
                              ),
                            ),
                            context.horizontalSpace(16),
                            Expanded(
                              child: _buildSessionSubCard(
                                context,
                                title: 'Downtime & Safety Checks',
                                icon: Icons.health_and_safety_outlined,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildDetailText(context, 'Downtime Level', (session.downtimeLevel ?? 'Minimal').toUpperCase()),
                                    _buildDetailText(context, 'Downtime Days', '${session.downtimeDays ?? 0} days'),
                                    _buildDetailText(context, 'Post-Photos Mandatory', session.requirePostTreatmentPhotos == true ? 'Yes' : 'No'),
                                    if (session.allowedRoles != null && session.allowedRoles!.isNotEmpty)
                                      _buildDetailText(context, 'Allowed Roles', session.allowedRoles!.join(', ')),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        context.verticalSpace(16),

                        // 5. Follow-ups & Reminders Journeys
                        if ((session.preNotifications != null && session.preNotifications!.isNotEmpty) ||
                            (session.postNotifications != null && session.postNotifications!.isNotEmpty) ||
                            (session.followUps != null && session.followUps!.isNotEmpty))
                          _buildSessionSubCard(
                            context,
                            title: 'Safety Check-ins & Care Notifications',
                            icon: Icons.notifications_active_outlined,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (session.followUps != null && session.followUps!.isNotEmpty) ...[
                                  Text('Post-Session Follow-Up Checks:', style: context.fonts.black12w600),
                                  const SizedBox(height: 6),
                                  ...session.followUps!.map((f) {
                                    return Text(
                                      '• ${f.type?.toUpperCase()} Follow-up of ${f.durationValue} ${f.durationUnit} after ${f.intervalValue} ${f.intervalUnit}. (Image Required: ${f.isImageRequired == true ? "Yes" : "No"}). Notes: ${f.notes ?? "None"}',
                                      style: context.fonts.grey12w400,
                                    );
                                  }),
                                  const SizedBox(height: 12),
                                ],
                                if (session.preNotifications != null && session.preNotifications!.isNotEmpty) ...[
                                  Text('Automated Pre-Treatment Reminders:', style: context.fonts.black12w600),
                                  const SizedBox(height: 6),
                                  ...session.preNotifications!.map((n) {
                                    return Text(
                                      '• [${n.type?.toUpperCase()}] ${n.title}: "${n.message}" (${n.timing} ${n.timingUnit} before)',
                                      style: context.fonts.grey12w400,
                                    );
                                  }),
                                  const SizedBox(height: 12),
                                ],
                                if (session.postNotifications != null && session.postNotifications!.isNotEmpty) ...[
                                  Text('Automated Post-Treatment Care Tips:', style: context.fonts.black12w600),
                                  const SizedBox(height: 6),
                                  ...session.postNotifications!.map((n) {
                                    return Text(
                                      '• [${n.type?.toUpperCase()}] ${n.title}: "${n.message}" (${n.timing} ${n.timingUnit} after)',
                                      style: context.fonts.grey12w400,
                                    );
                                  }),
                                ],
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSessionSubCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CustomColors.whiteGrey.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: CustomColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: CustomColors.purple),
              const SizedBox(width: 8),
              Text(title, style: context.fonts.black13w600.copyWith(color: CustomColors.purple)),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _buildDetailText(BuildContext context, String key, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: RichText(
        text: TextSpan(
          text: '$key: ',
          style: context.fonts.grey12w400.copyWith(fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: value,
              style: context.fonts.black12w400.copyWith(
                color: isHighlight ? CustomColors.purple : CustomColors.black,
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionBlock(BuildContext context, String title, String body) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: CustomColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.fonts.black12w600),
          const SizedBox(height: 4),
          Text(body, style: context.fonts.grey11w400),
        ],
      ),
    );
  }

  Widget _buildAttachmentLink(BuildContext context, String label, String? name, String? url) {
    if (url == null || url.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(Icons.picture_as_pdf, size: 14, color: CustomColors.red),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: context.fonts.black12w600),
                Text(
                  name ?? 'Attached File.pdf',
                  style: context.fonts.grey11w400.copyWith(
                    color: CustomColors.purple,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sessionMetaChip(BuildContext context, IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: CustomColors.grey),
        context.horizontalSpace(4),
        Text(
          label,
          style: context.fonts.grey11w400.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }



  Widget _buildBusinessLogicCard(
    BuildContext context,
    TreatmentDetailDto detail,
  ) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.settings_suggest_outlined,
                color: CustomColors.purple,
                size: 20,
              ),
              context.horizontalSpace(10),
              Text(
                'Business Logic & Rules',
                style: context.fonts.black16w700,
              ),
            ],
          ),
          context.verticalSpace(16),
          _logicRow(
            context,
            Icons.add_business_outlined,
            'Enable by Default for New Clinics',
            detail.enableByDefault ?? false,
          ),
          context.verticalSpace(12),
          _logicRow(
            context,
            Icons.biotech_outlined,
            'AI Face Simulator Compatibility',
            detail.useInAiSimulator ?? false,
          ),
        ],
      ),
    );
  }

  Widget _logicRow(
    BuildContext context,
    IconData icon,
    String label,
    bool isEnabled,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: isEnabled ? CustomColors.purple : CustomColors.grey,
          size: 20,
        ),
        context.horizontalSpace(12),
        Expanded(
          child: Text(label, style: context.fonts.black13w600),
        ),
        Text(
          isEnabled ? 'Enabled' : 'Disabled',
          style: isEnabled
              ? context.fonts.purple12w700
              : context.fonts.grey13w500,
        ),
      ],
    );
  }

  Widget _buildMetadataCard(BuildContext context, TreatmentDetailDto detail) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: CustomColors.purple,
                size: 20,
              ),
              context.horizontalSpace(10),
              Text('Audit Information', style: context.fonts.black16w700),
            ],
          ),
          context.verticalSpace(16),
          _detailRow(
            context,
            'Created At',
            _formatTimestamp(detail.createdAt),
          ),
          context.verticalSpace(10),
          _detailRow(
            context,
            'Last Updated',
            _formatTimestamp(detail.updatedAt),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: context.fonts.grey13w500),
        Text(value, style: context.fonts.black13w600),
      ],
    );
  }

  String _formatTimestamp(DateTime? dt) {
    if (null == dt) return '—';
    try {
      final date = dt.toLocal();
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return '—';
    }
  }
}