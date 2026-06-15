import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/treatment_model.dart';
import '../utils/theme.dart';
import '../view_models/treatment_view_model.dart';
import '../widgets/app_badge.dart';
import '../widgets/borderd_container_widget.dart';
import '../widgets/gradient_scaffold.dart';
import 'edit_treatment_screen.dart';

class TreatmentDetailScreen extends ConsumerWidget {
  const TreatmentDetailScreen({super.key});
  static const String routeName = '/treatment-detail';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(treatmentViewModelProvider);
    final treatment = state.selectedTreatment;

    if (treatment == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Treatment not found')),
      );
    }

    return GradientScaffold(
      appBar: AppBar(
        flexibleSpace: AppDecorations.appBarGradient,
        title: Text(
          treatment.name ?? 'Treatment Profile',
          style: context.fonts.black18w600,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              ref
                  .read(treatmentViewModelProvider.notifier)
                  .selectTreatment(treatment);
              context.push(EditTreatmentScreen.routeName);
            },
          ),
          context.horizontalSpace(16),
        ],
      ),
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(horizontal: 28, vertical: 32),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.w(1000)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(context, treatment),
                context.verticalSpace(32),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildPrimaryInfo(context, treatment),
                    ),
                    context.horizontalSpace(24),
                    Expanded(child: _buildSecondaryStats(context, treatment)),
                  ],
                ),
                context.verticalSpace(32),
                _buildSessionsSection(context, treatment),
                context.verticalSpace(32),
                _buildInstructionsSection(context, treatment),
                context.verticalSpace(32),
                _buildNotificationsSection(context, treatment),
                context.verticalSpace(32),
                _buildConsentSection(context, treatment),
                context.verticalSpace(32),
                _buildDowntimeSection(context, treatment),
                context.verticalSpace(32),
                _buildRolesSection(context, treatment),
                context.verticalSpace(32),
                _buildAreasAndLogic(context, treatment),
                context.verticalSpace(32),
                _buildProtocolsSection(context, treatment),
                context.verticalSpace(32),
                _buildSchedulingSection(context, treatment),
                if (treatment.productUsages != null &&
                    treatment.productUsages!.isNotEmpty) ...[
                  context.verticalSpace(32),
                  _buildProductUsages(context, treatment),
                ],
                context.verticalSpace(32),
                _buildPricingSection(context, treatment),
                context.verticalSpace(32),
                _buildBusinessLogicSection(context, treatment),
                context.verticalSpace(48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, TreatmentModel treatment) {
    double productDuration = 0.0;
    if (treatment.productUsages != null) {
      for (final usage in treatment.productUsages!) {
        final double perUnit = usage.perUnitDuration ?? 0.0;
        double minQty = usage.minQuantity ?? 0.0;
        if (usage.subAreaConsumptions != null &&
            usage.subAreaConsumptions!.isNotEmpty) {
          minQty = usage.subAreaConsumptions!.fold(
            0.0,
            (sum, sub) => sum + (sub.minQuantity),
          );
        }
        productDuration += minQty * perUnit;
      }
    }
    final int baseMin =
        (treatment.baseDurationHours ?? 0) * 60 +
        (treatment.baseDurationMinutes ?? 0);
    final int prepTime = treatment.prepTime;
    final int cleanupTime = treatment.cleanupTime;
    final double totalDuration =
        baseMin + productDuration + prepTime + cleanupTime;

    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 32),
      child: Row(
        children: [
          Container(
            width: context.w(120),
            height: context.w(120),
            decoration: BoxDecoration(
              color: CustomColors.softGrey,
              borderRadius: context.appBorderRadius(all: 20),
              image: (treatment.image != null && treatment.image!.isNotEmpty)
                  ? DecorationImage(
                      image: NetworkImage(treatment.image!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: (treatment.image == null || treatment.image!.isEmpty)
                ? Icon(
                    Icons.image_outlined,
                    size: context.sp(48),
                    color: CustomColors.lightGrey,
                  )
                : null,
          ),
          context.horizontalSpace(32),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      treatment.name ?? 'N/A',
                      style: context.fonts.black26w700,
                    ),
                    context.horizontalSpace(16),
                    AppBadge(
                      label: (treatment.status).toUpperCase(),
                      variant: treatment.status == 'active'
                          ? AppBadgeVariant.success
                          : (treatment.status == 'draft'
                                ? AppBadgeVariant.warning
                                : AppBadgeVariant.neutral),
                    ),
                  ],
                ),
                context.verticalSpace(8),
                Text(
                  treatment.categoryPath ?? 'No Category Assigned',
                  style: context.fonts.purple14w600,
                ),
                context.verticalSpace(12),
                Row(
                  children: [
                    _headerMeta(
                      context,
                      Icons.tag_rounded,
                      "SKU: ${treatment.globalSku ?? 'N/A'}",
                    ),
                    context.horizontalSpace(24),
                    _headerMeta(
                      context,
                      Icons.timer_outlined,
                      '${totalDuration.toStringAsFixed(totalDuration % 1 == 0 ? 0 : 1)} Min Total',
                    ),
                    context.horizontalSpace(24),
                    _headerMeta(
                      context,
                      Icons.payments_outlined,
                      "Base \$${treatment.basePrice?.toStringAsFixed(2) ?? '0.00'}",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerMeta(BuildContext context, IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: context.sp(18), color: CustomColors.grey),
        context.horizontalSpace(8),
        Text(label, style: context.fonts.grey14w600),
      ],
    );
  }

  Widget _buildPrimaryInfo(BuildContext context, TreatmentModel treatment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoSection(
          context,
          'Patient-Facing Display Name & Description',
          "Display Name: ${treatment.patientDisplayName ?? 'N/A'}\n\n${treatment.shortDescription ?? 'No summary provided.'}",
        ),
        context.verticalSpace(24),
        _infoSection(
          context,
          'Clinical Protocol & Detailed Process',
          treatment.description ?? 'No detailed clinical information provided.',
        ),
      ],
    );
  }

  Widget _infoSection(BuildContext context, String title, String content) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.fonts.black14w700),
          context.verticalSpace(12),
          Text(content, style: context.fonts.grey14w400h16),
        ],
      ),
    );
  }

  Widget _buildSecondaryStats(BuildContext context, TreatmentModel treatment) {
    return Column(
      children: [
        _statCard(context, 'Network Usage', '84 Clinics', Icons.hub_outlined),
        context.verticalSpace(16),
        _statCard(
          context,
          'Avg. Actual Price',
          '\$342.00',
          Icons.analytics_outlined,
        ),
        context.verticalSpace(16),
        _statCard(
          context,
          'Patient Popularity',
          'Top 5',
          Icons.trending_up_rounded,
        ),
      ],
    );
  }

  Widget _statCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 20),
      child: Row(
        children: [
          Icon(icon, color: CustomColors.lightGrey, size: context.sp(20)),
          context.horizontalSpace(16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: context.fonts.grey12w400),
              Text(value, style: context.fonts.black16w600),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSessionsSection(BuildContext context, TreatmentModel treatment) {
    final totalSessions = treatment.sessions?.length ?? 0;
    final totalFollowUps =
        treatment.sessions?.fold(0, (sum, s) => sum + s.followUps.length) ?? 0;

    return CollapsibleSection(
      title:
          'Sessions & Follow-Ups Setup ($totalSessions Sessions, $totalFollowUps Follow-Ups)',
      icon: Icons.calendar_today_outlined,
      content: treatment.sessions == null || treatment.sessions!.isEmpty
          ? Text('No sessions configured.', style: context.fonts.grey14w400)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: treatment.sessions!.map((session) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Session ${session.sessionNumber}',
                        style: context.fonts.purple14w700,
                      ),
                      context.verticalSpace(10),
                      if (session.followUps.isEmpty)
                        Text(
                          'No follow-ups defined for this session.',
                          style: context.fonts.grey12w400,
                        )
                      else
                        ...session.followUps.asMap().entries.map((entry) {
                          final idx = entry.key + 1;
                          final fu = entry.value;
                          return Container(
                            margin: const EdgeInsets.only(
                              bottom: 8.0,
                              left: 16.0,
                            ),
                            padding: context.appEdgeInsets(all: 12),
                            decoration: BoxDecoration(
                              color: CustomColors.softGrey.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: context.appBorderRadius(all: 8),
                              border: Border.all(color: CustomColors.border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      fu.type == 'virtual'
                                          ? Icons.videocam_outlined
                                          : Icons.person_outline_rounded,
                                      size: 16,
                                      color: CustomColors.purple,
                                    ),
                                    context.horizontalSpace(8),
                                    Text(
                                      'Follow-Up $idx (${fu.type.toUpperCase()})',
                                      style: context.fonts.black13w600,
                                    ),
                                    const Spacer(),
                                    Text(
                                      "Timing: ${fu.intervalValue ?? 0} ${fu.intervalUnit ?? 'days'}",
                                      style: context.fonts.grey12w400,
                                    ),
                                  ],
                                ),
                                context.verticalSpace(6),
                                Text(
                                  'Duration: ${fu.durationValue ?? 0} ${fu.durationUnit}',
                                  style: context.fonts.black12w400,
                                ),
                                if (fu.isImageRequired) ...[
                                  context.verticalSpace(4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.camera_alt_outlined,
                                        size: 12,
                                        color: CustomColors.green,
                                      ),
                                      context.horizontalSpace(6),
                                      Text(
                                        'Patient image upload required',
                                        style: context.fonts.green14w600,
                                      ),
                                    ],
                                  ),
                                ],
                                if (fu.notes != null &&
                                    fu.notes!.isNotEmpty) ...[
                                  context.verticalSpace(6),
                                  Text(
                                    'Notes: ${fu.notes}',
                                    style: context.fonts.grey12w400.copyWith(
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        }),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget _buildInstructionsSection(
    BuildContext context,
    TreatmentModel treatment,
  ) {
    return CollapsibleSection(
      title: 'Pre-Treatment Instructions',
      icon: Icons.assignment_outlined,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Instruction Text:', style: context.fonts.black13w600),
          context.verticalSpace(6),
          Text(
            treatment.preTreatmentInstructions ??
                'No pre-treatment instructions specified.',
            style: context.fonts.grey14w400,
          ),
          if (treatment.preTreatmentAttachments != null &&
              treatment.preTreatmentAttachments!.isNotEmpty) ...[
            context.verticalSpace(16),
            Text('Instruction Attachments:', style: context.fonts.black13w600),
            context.verticalSpace(10),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: treatment.preTreatmentAttachments!.map((file) {
                IconData fileIcon = Icons.insert_drive_file_outlined;
                Color fileColor = CustomColors.grey;
                if (file.type == 'pdf') {
                  fileIcon = Icons.picture_as_pdf_rounded;
                  fileColor = Colors.red;
                } else if (file.type == 'image') {
                  fileIcon = Icons.image_outlined;
                  fileColor = Colors.blue;
                } else if (file.type == 'video') {
                  fileIcon = Icons.video_collection_rounded;
                  fileColor = Colors.purple;
                }
                return Container(
                  padding: context.appEdgeInsets(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: fileColor.withValues(alpha: 0.1),
                    borderRadius: context.appBorderRadius(all: 6),
                    border: Border.all(color: fileColor.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(fileIcon, color: fileColor, size: 16),
                      context.horizontalSpace(8),
                      Text(file.name, style: context.fonts.black12w600),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotificationsSection(
    BuildContext context,
    TreatmentModel treatment,
  ) {
    final preSource = treatment.preNotificationSource == 'category'
        ? 'Using Category Defaults'
        : 'Using Custom Configuration';
    final postSource = treatment.postNotificationSource == 'category'
        ? 'Using Category Defaults'
        : 'Using Custom Configuration';

    return CollapsibleSection(
      title: 'Treatment Notifications',
      icon: Icons.notifications_none_rounded,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Pre-Treatment Notifications: ',
                style: context.fonts.black13w600,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: treatment.preNotificationSource == 'category'
                      ? Colors.blue.withValues(alpha: 0.1)
                      : Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  preSource,
                  style: TextStyle(
                    color: treatment.preNotificationSource == 'category'
                        ? Colors.blue
                        : Colors.orange,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          context.verticalSpace(10),
          if (treatment.preNotifications.isEmpty)
            Text(
              'No pre-treatment notifications defined.',
              style: context.fonts.grey12w400,
            )
          else
            ...treatment.preNotifications
                .map(
                  (n) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "• ${n.title ?? 'Reminder'} (Timing: ${n.timing ?? 0} ${n.timingUnit ?? 'hours'} before)",
                          style: context.fonts.black13w600,
                        ),
                        Text(n.message ?? '', style: context.fonts.grey12w400),
                      ],
                    ),
                  ),
                )
                ,

          context.verticalSpace(20),
          const Divider(),
          context.verticalSpace(16),

          Row(
            children: [
              Text(
                'Post-Treatment Notifications: ',
                style: context.fonts.black13w600,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: treatment.postNotificationSource == 'category'
                      ? Colors.blue.withValues(alpha: 0.1)
                      : Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  postSource,
                  style: TextStyle(
                    color: treatment.postNotificationSource == 'category'
                        ? Colors.blue
                        : Colors.orange,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          context.verticalSpace(10),
          if (treatment.postNotifications.isEmpty)
            Text(
              'No post-treatment notifications defined.',
              style: context.fonts.grey12w400,
            )
          else
            ...treatment.postNotifications
                .map(
                  (n) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "• ${n.title ?? 'Aftercare'} (Timing: ${n.timing ?? 0} ${n.timingUnit ?? 'hours'} after)",
                          style: context.fonts.black13w600,
                        ),
                        Text(n.message ?? '', style: context.fonts.grey12w400),
                      ],
                    ),
                  ),
                )
                ,
        ],
      ),
    );
  }

  Widget _buildConsentSection(BuildContext context, TreatmentModel treatment) {
    final hasCustom = treatment.preTreatmentConsentForm != null;

    return CollapsibleSection(
      title: 'Patient Consent Forms',
      icon: Icons.gavel_rounded,
      content: Row(
        children: [
          const Icon(
            Icons.file_present_rounded,
            color: CustomColors.purple,
            size: 24,
          ),
          context.horizontalSpace(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasCustom
                      ? 'Using Custom Consent Form'
                      : 'Using Category Default Consent Form',
                  style: context.fonts.black14w600,
                ),
                context.verticalSpace(4),
                Text(
                  hasCustom
                      ? treatment.preTreatmentConsentForm!.name
                      : 'Standard clinic consent paperwork active.',
                  style: context.fonts.grey12w400,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDowntimeSection(BuildContext context, TreatmentModel treatment) {
    final level = treatment.downtimeLevel;
    int days = 0;
    if (level == 'Low') {
      days = 2;
    } else if (level == 'Moderate')
      days = 5;
    else if (level == 'High')
      days = 10;

    return CollapsibleSection(
      title: 'Treatment Downtime Level',
      icon: Icons.airline_seat_flat_angled_outlined,
      content: Row(
        children: [
          Icon(
            Icons.bedtime_outlined,
            color: level == 'None' ? Colors.green : Colors.orange,
            size: 24,
          ),
          context.horizontalSpace(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Downtime: $level', style: context.fonts.black14w600),
                if (level != 'None')
                  Text(
                    'Estimated healing time: $days Days',
                    style: context.fonts.grey12w400,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRolesSection(BuildContext context, TreatmentModel treatment) {
    final isCategory = treatment.providerRolesSource == 'category';

    return CollapsibleSection(
      title: 'Allowed Provider Roles',
      icon: Icons.people_outline_rounded,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Roles Source: ', style: context.fonts.black13w600),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isCategory
                      ? Colors.blue.withValues(alpha: 0.1)
                      : Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isCategory ? 'Category Defaults' : 'Custom Configuration',
                  style: TextStyle(
                    color: isCategory ? Colors.blue : Colors.orange,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          context.verticalSpace(12),
          if (treatment.allowedRoles.isEmpty)
            Text(
              'All staff roles authorized to perform this treatment.',
              style: context.fonts.grey14w400,
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: treatment.allowedRoles.map((role) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: CustomColors.palePurple,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(role, style: context.fonts.purple12w700),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildAreasAndLogic(BuildContext context, TreatmentModel treatment) {
    return CollapsibleSection(
      title: 'Target Areas & Sub-Area Logic',
      icon: Icons.location_on_outlined,
      content: treatment.sideAreas == null || treatment.sideAreas!.isEmpty
          ? const Text('No specific area logic defined.')
          : GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: 2.2,
              ),
              itemCount: treatment.sideAreas!.length,
              itemBuilder: (context, index) {
                final area = treatment.sideAreas![index];
                return _buildAreaCard(context, area);
              },
            ),
    );
  }

  Widget _buildAreaCard(BuildContext context, SideAreaModel area) {
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
                size: 18,
              ),
              context.horizontalSpace(8),
              Text(
                area.name ?? 'Unknown Area',
                style: context.fonts.black16w600,
              ),
            ],
          ),
          context.verticalSpace(16),
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (area.subAreas ?? []).map((sub) {
                // If it has children sub-areas, display them formatted beautifully too!
                String subName = sub.name ?? 'N/A';
                if (sub.children != null && sub.children!.isNotEmpty) {
                  final childNames = sub.children!
                      .map((c) => c.name)
                      .join(', ');
                  subName = '$subName -> [$childNames]';
                }
                return Container(
                  padding: context.appEdgeInsets(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: CustomColors.palePurple,
                    borderRadius: context.appBorderRadius(all: 6),
                  ),
                  child: Text(
                    subName,
                    style: context.fonts.purple11w600.copyWith(
                      fontSize: context.sp(10),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductUsages(BuildContext context, TreatmentModel treatment) {
    return CollapsibleSection(
      title: 'Required Inventory Products',
      icon: Icons.inventory_2_outlined,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...treatment.productUsages!.map(
            (usage) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: BorderdContainerWidget(
                padding: context.appEdgeInsets(all: 16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.inventory_2_outlined,
                      color: CustomColors.purple,
                    ),
                    context.horizontalSpace(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            usage.productName,
                            style: context.fonts.black14w600,
                          ),
                          context.verticalSpace(4),
                          Row(
                            children: [
                              _metaChip(context, usage.usageType, Colors.blue),
                              context.horizontalSpace(8),
                              _metaChip(
                                context,
                                usage.deductionTiming.replaceAll('_', ' '),
                                Colors.orange,
                              ),
                              if (usage.allowSubstitution) ...[
                                context.horizontalSpace(8),
                                _metaChip(
                                  context,
                                  'Substitutable',
                                  Colors.green,
                                ),
                              ],
                            ],
                          ),
                          context.verticalSpace(8),
                          Builder(
                            builder: (context) {
                              double minQty = usage.minQuantity ?? 1.0;
                              double maxQty = usage.maxQuantity ?? 1.0;
                              if (usage.subAreaConsumptions != null &&
                                  usage.subAreaConsumptions!.isNotEmpty) {
                                minQty = usage.subAreaConsumptions!.fold(
                                  0.0,
                                  (sum, sub) => sum + (sub.minQuantity),
                                );
                                maxQty = usage.subAreaConsumptions!.fold(
                                  0.0,
                                  (sum, sub) => sum + (sub.maxQuantity),
                                );
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Min Quantity: ${minQty.toStringAsFixed(minQty % 1 == 0 ? 0 : 1)} ${usage.unit}, Max Quantity: ${maxQty.toStringAsFixed(maxQty % 1 == 0 ? 0 : 1)} ${usage.unit}',
                                    style: context.fonts.grey12w400,
                                  ),
                                  if (usage.subAreaConsumptions != null &&
                                      usage
                                          .subAreaConsumptions!
                                          .isNotEmpty) ...[
                                    context.verticalSpace(4),
                                    Text(
                                      'Sub-Areas: ${usage.subAreaConsumptions!.map((sub) {
                                        return '${sub.subAreaName} (Min ${sub.minQuantity.toStringAsFixed(sub.minQuantity % 1 == 0 ? 0 : 1)} / Max ${sub.maxQuantity.toStringAsFixed(sub.maxQuantity % 1 == 0 ? 0 : 1)})';
                                      }).join(', ')}',
                                      style: context.fonts.grey11w400,
                                    ),
                                  ],
                                ],
                              );
                            },
                          ),
                          if (usage.notes != null &&
                              usage.notes!.isNotEmpty) ...[
                            context.verticalSpace(8),
                            Text(
                              'Notes: ${usage.notes}',
                              style: context.fonts.grey12w400.copyWith(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metaChip(BuildContext context, String label, Color color) {
    return Container(
      padding: context.appEdgeInsets(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: context.appBorderRadius(all: 4),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: context.sp(10),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPricingSection(BuildContext context, TreatmentModel treatment) {
    return CollapsibleSection(
      title: 'Treatment Pricing Information',
      icon: Icons.monetization_on_outlined,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _detailRow(
            context,
            'Base Treatment Price',
            "\$${treatment.basePrice?.toStringAsFixed(2) ?? '0.00'}",
          ),
          if (treatment.unitPrices != null &&
              treatment.unitPrices!.isNotEmpty) ...[
            context.verticalSpace(16),
            const Divider(),
            context.verticalSpace(12),
            Text('Unit Price Overrides:', style: context.fonts.black13w600),
            context.verticalSpace(8),
            ...treatment.unitPrices!.entries.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(e.key.toUpperCase(), style: context.fonts.black12w400),
                    Text(
                      '\$${e.value.toStringAsFixed(2)}',
                      style: context.fonts.black12w600,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _detailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: context.fonts.grey13w500),
          Text(value, style: context.fonts.black13w600),
        ],
      ),
    );
  }

  Widget _buildBusinessLogicSection(
    BuildContext context,
    TreatmentModel treatment,
  ) {
    return CollapsibleSection(
      title: 'Business Logic & Simulation Rules',
      icon: Icons.settings_suggest_outlined,
      content: Column(
        children: [
          _logicRow(
            context,
            Icons.biotech_outlined,
            'AI Face Simulation Compatible',
            treatment.useInAiSimulator
                ? 'Enabled (Compatible)'
                : 'Disabled (Incompatible)',
            treatment.useInAiSimulator,
          ),
          context.verticalSpace(12),
          _logicRow(
            context,
            Icons.add_business_outlined,
            'Enable by Default for New Clinics',
            treatment.enableByDefault ? 'Enabled (Yes)' : 'Disabled (No)',
            treatment.enableByDefault,
          ),
        ],
      ),
    );
  }

  Widget _logicRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    bool isOk,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: isOk ? CustomColors.purple : CustomColors.grey,
          size: 20,
        ),
        context.horizontalSpace(12),
        Expanded(child: Text(label, style: context.fonts.black13w600)),
        Text(
          value,
          style: isOk ? context.fonts.purple12w700 : context.fonts.grey14w400,
        ),
      ],
    );
  }

  Widget _buildSchedulingSection(
    BuildContext context,
    TreatmentModel treatment,
  ) {
    final int baseMin =
        (treatment.baseDurationHours ?? 0) * 60 +
        (treatment.baseDurationMinutes ?? 0);

    double productDuration = 0.0;
    final List<Widget> productDurationRows = [];

    if (treatment.productUsages != null) {
      for (final usage in treatment.productUsages!) {
        final double perUnit = usage.perUnitDuration ?? 0.0;
        double minQty = usage.minQuantity ?? 0.0;
        if (usage.subAreaConsumptions != null &&
            usage.subAreaConsumptions!.isNotEmpty) {
          minQty = usage.subAreaConsumptions!.fold(
            0.0,
            (sum, sub) => sum + (sub.minQuantity),
          );
        }

        final double usageDuration = minQty * perUnit;
        if (perUnit > 0) {
          productDuration += usageDuration;
          productDurationRows.add(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '• ${usage.productName}',
                    style: context.fonts.black13w500,
                  ),
                  Text(
                    '${perUnit.toStringAsFixed(perUnit % 1 == 0 ? 0 : 1)} Min per ${usage.unit} (Total: ${usageDuration.toStringAsFixed(usageDuration % 1 == 0 ? 0 : 1)} Min)',
                    style: context.fonts.grey13w500,
                  ),
                ],
              ),
            ),
          );
        }
      }
    }

    final int prepTime = treatment.prepTime;
    final int cleanupTime = treatment.cleanupTime;
    final double totalDuration =
        baseMin + productDuration + prepTime + cleanupTime;

    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.schedule_outlined,
                color: CustomColors.purple,
                size: 20,
              ),
              context.horizontalSpace(12),
              Text(
                'Scheduling & Duration Breakdown',
                style: context.fonts.black16w600,
              ),
            ],
          ),
          context.verticalSpace(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Base Duration', style: context.fonts.black14w500),
              Text('$baseMin Minutes', style: context.fonts.black14w700),
            ],
          ),
          if (productDurationRows.isNotEmpty) ...[
            context.verticalSpace(16),
            const Divider(),
            context.verticalSpace(12),
            Text('Product Usage Duration', style: context.fonts.purple12w700),
            context.verticalSpace(8),
            ...productDurationRows,
          ],
          context.verticalSpace(16),
          const Divider(),
          context.verticalSpace(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Preparation Time', style: context.fonts.black14w500),
              Text('$prepTime Minutes', style: context.fonts.black14w700),
            ],
          ),
          context.verticalSpace(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Cleanup Time', style: context.fonts.black14w500),
              Text('$cleanupTime Minutes', style: context.fonts.black14w700),
            ],
          ),
          context.verticalSpace(16),
          const Divider(),
          context.verticalSpace(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Calculated Total Duration',
                style: context.fonts.black14w700,
              ),
              Text(
                '${totalDuration.toStringAsFixed(totalDuration % 1 == 0 ? 0 : 1)} Minutes',
                style: context.fonts.purple16w700,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProtocolsSection(
    BuildContext context,
    TreatmentModel treatment,
  ) {
    final List<TreatmentProtocolNote> notes = treatment.protocolNotes ?? [];
    final List<TreatmentProtocolNoteItem> standalone =
        treatment.standaloneNotes ?? [];

    return Column(
      children: [
        CollapsibleSection(
          title: 'Clinical Protocols & Patient Guidance',
          icon: Icons.assignment_turned_in_outlined,
          content: notes.isEmpty
              ? Text(
                  'No clinical protocols configured for this treatment.',
                  style: context.fonts.grey14w400,
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: notes.map((pNote) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: BorderdContainerWidget(
                        padding: context.appEdgeInsets(all: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.assignment_turned_in_outlined,
                                  color: CustomColors.purple,
                                  size: 18,
                                ),
                                context.horizontalSpace(12),
                                Text(
                                  pNote.protocolName,
                                  style: context.fonts.black14w700,
                                ),
                              ],
                            ),
                            if (pNote.notes.isNotEmpty) ...[
                              context.verticalSpace(12),
                              const Divider(),
                              context.verticalSpace(12),
                              ...pNote.notes
                                  .map(
                                    (note) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 8.0,
                                        left: 4.0,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.arrow_right_rounded,
                                            color: CustomColors.purple,
                                            size: 18,
                                          ),
                                          context.horizontalSpace(8),
                                          Expanded(
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  if (note.title != null &&
                                                      note.title!.isNotEmpty)
                                                    TextSpan(
                                                      text: '${note.title}: ',
                                                      style: context
                                                          .fonts
                                                          .black13w600,
                                                    ),
                                                  TextSpan(
                                                    text: note.description,
                                                    style: context
                                                        .fonts
                                                        .grey13w500,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  ,
                            ],
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
        ),
        context.verticalSpace(32),
        CollapsibleSection(
          title: 'Notes / Instructions',
          icon: Icons.notes_rounded,
          content: standalone.isEmpty
              ? Text(
                  'No custom notes or instructions configured for this treatment.',
                  style: context.fonts.grey14w400,
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: standalone.map((note) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: BorderdContainerWidget(
                        padding: context.appEdgeInsets(all: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (note.title != null &&
                                note.title!.isNotEmpty) ...[
                              Row(
                                children: [
                                  const Icon(
                                    Icons.info_outline,
                                    color: CustomColors.purple,
                                    size: 18,
                                  ),
                                  context.horizontalSpace(12),
                                  Text(
                                    note.title!,
                                    style: context.fonts.black14w700,
                                  ),
                                ],
                              ),
                              context.verticalSpace(8),
                              const Divider(),
                              context.verticalSpace(8),
                            ],
                            Padding(
                              padding: EdgeInsets.only(
                                left:
                                    note.title != null && note.title!.isNotEmpty
                                    ? 30.0
                                    : 0.0,
                              ),
                              child: Text(
                                note.description,
                                style: context.fonts.grey14w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }
}

class CollapsibleSection extends StatefulWidget {
  final String title;
  final Widget content;
  final IconData icon;

  const CollapsibleSection({
    super.key,
    required this.title,
    required this.content,
    required this.icon,
  });

  @override
  State<CollapsibleSection> createState() => _CollapsibleSectionState();
}

class _CollapsibleSectionState extends State<CollapsibleSection> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(widget.icon, color: CustomColors.purple, size: 20),
                    context.horizontalSpace(12),
                    Text(widget.title, style: context.fonts.black16w700),
                  ],
                ),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: CustomColors.grey,
                ),
              ],
            ),
          ),
          if (_isExpanded) ...[
            context.verticalSpace(16),
            const Divider(),
            context.verticalSpace(16),
            widget.content,
          ],
        ],
      ),
    );
  }
}
