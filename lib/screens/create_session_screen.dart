import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/responses/category_detail_response.dart';
import '../models/treatment_data_models.dart';
import '../utils/list_utils.dart';
import '../utils/theme.dart';
import '../view_models/category_view_model.dart';
import '../view_models/treatment_data_view_model.dart';
import '../view_models/treatment_view_model.dart';
import '../view_models/session_view_model.dart';
import '../widgets/custom_outlined_button.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/nested_area_selector.dart';
import '../widgets/session_creation_steps/treatment_creation_steps.dart';
import '../widgets/protocol_preview_widget.dart';
import '../widgets/live_session_preview_widget.dart';

class CreateSessionScreen extends ConsumerStatefulWidget {
  const CreateSessionScreen({super.key});

  static const String routeName = '/create-treatment-session';

  @override
  ConsumerState<CreateSessionScreen> createState() =>
      _CreateTreatmentScreenState();
}

class _CreateTreatmentScreenState extends ConsumerState<CreateSessionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref
          .read(sessionViewModelProvider.notifier)
          .fetchProductsByTreatmentCategory();
    });
  }

  int _getSessionOffsetStep(int sessionStep) {
    return sessionStep - 1;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(treatmentViewModelProvider);
    final viewModel = ref.read(treatmentViewModelProvider.notifier);
    final sessionViewModel = ref.read(sessionViewModelProvider.notifier);
    final dataState = ref.watch(treatmentDataViewModelProvider);
    final categoryState = ref.watch(categoryViewModelProvider);

    final bool isDesktop = context.screenWidth > 1200;
    final bool isTablet =
        context.screenWidth > 800 && context.screenWidth <= 1200;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.pop();
      },
      child: GradientScaffold(
        appBar: AppBar(
          flexibleSpace: AppDecorations.appBarGradient,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Session Detail Builder',
            style: context.fonts.black18w600,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: CustomColors.black),
            onPressed: () {
              context.pop();
            },
          ),
        ),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isDesktop || isTablet)
              _buildLeftSidebar(context, state, sessionViewModel),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  if (!isDesktop && !isTablet)
                    _buildMobileProgress(context, state),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: context.appEdgeInsets(
                        horizontal: 24,
                        vertical: 32,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: context.w(isDesktop ? 800 : 900),
                          ),
                          child: Column(
                            children: [
                              _buildStepHeader(context, state),
                              context.verticalSpace(32),
                              Container(
                                padding: context.appEdgeInsets(all: 32),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: context.appBorderRadius(
                                    all: 16,
                                  ),
                                  border: Border.all(
                                    color: CustomColors.border,
                                  ),
                                  boxShadow: AppShadows.card(context),
                                ),
                                child: _buildCurrentStepContent(
                                  context,
                                  state,
                                  viewModel,
                                  dataState,
                                  categoryState,
                                  ref,
                                ),
                              ),
                              context.verticalSpace(48),
                              _buildActionButtons(
                                context,
                                state,
                                sessionViewModel,
                                dataState,
                                categoryState,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isDesktop)
              const Expanded(
                flex: 2,
                child: LiveSessionPreviewWidget(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftSidebar(
    BuildContext context,
    TreatmentState state,
    SessionViewModel viewModel,
  ) {
    final sessionState = ref.watch(sessionViewModelProvider);
    final steps = [
      'Inventory Products',
      'Scheduling',
      'Pricing',
      'Protocols',
      'Pre-Treatment Instructions',
      'Post-Treatment Instructions',
      'Post Treatment Photos',
      'Phase Notifications',
      'Downtime Level',
      'Allowed Provider Roles',
      'Follow-Up Setup',
      'Patient Consent',
    ];

    final currentOffsetStep = _getSessionOffsetStep(sessionState.sessionStep);

    return Container(
      width: context.w(280),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: CustomColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: context.appEdgeInsets(all: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Progress', style: context.fonts.grey12w600),
                context.verticalSpace(12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${currentOffsetStep + 1} / ${steps.length}',
                      style: context.fonts.black14w700,
                    ),
                    Text(
                      '${((currentOffsetStep + 1) / steps.length * 100).toInt()}%',
                      style: context.fonts.purple14w700,
                    ),
                  ],
                ),
                context.verticalSpace(12),
                ClipRRect(
                  borderRadius: context.appBorderRadius(all: 10),
                  child: LinearProgressIndicator(
                    value: (currentOffsetStep + 1) / steps.length,
                    minHeight: context.h(8),
                    backgroundColor: CustomColors.whiteGrey,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      CustomColors.purple,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              padding: context.appEdgeInsets(vertical: 16),
              itemCount: steps.length,
              itemBuilder: (context, index) {
                final bool isActive = currentOffsetStep == index;
                final bool isCompleted = currentOffsetStep > index;

                return InkWell(
                  onTap: index < currentOffsetStep
                      ? () {
                          viewModel.setSessionStep(index + 1);
                        }
                      : null,
                  child: Container(
                    padding: context.appEdgeInsets(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? CustomColors.purple.withValues(alpha: 0.05)
                          : Colors.transparent,
                      border: Border(
                        right: BorderSide(
                          color: isActive
                              ? CustomColors.purple
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: context.w(24),
                          height: context.w(24),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCompleted
                                ? CustomColors.green
                                : (isActive
                                      ? CustomColors.purple
                                      : Colors.white),
                            border: Border.all(
                              color: isActive || isCompleted
                                  ? Colors.transparent
                                  : CustomColors.border,
                            ),
                          ),
                          child: Center(
                            child: isCompleted
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 14,
                                  )
                                : Text(
                                    '${index + 1}',
                                    style: isActive
                                        ? context.fonts.white10w700
                                        : context.fonts.grey10w700,
                                  ),
                          ),
                        ),
                        context.horizontalSpace(16),
                        Expanded(
                          child: Text(
                            steps[index],
                            style: isActive
                                ? context.fonts.purple14w600
                                : (isCompleted
                                      ? context.fonts.black14w400
                                      : context.fonts.grey14w400),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepHeader(BuildContext context, TreatmentState state) {
    final titles = [
      'Inventory Products',
      'Scheduling',
      'Pricing Setup',
      'Clinical Protocols',
      'Pre-Treatment Instructions',
      'Post-Treatment Instructions',
      'Post Treatment Photos',
      'Phase Notifications',
      'Downtime Level',
      'Allowed Provider Roles',
      'Follow-Up Configuration',
      'Patient Consent Form',
    ];
    final descriptions = [
      'Configure required products from inventory and area-wise consumption.',
      'Centralize appointment duration, preparation times, and booking permissions.',
      'Finalize treatment base price and sub-area pricing adjustments.',
      'Standardize procedures with checklists and required text fields.',
      'Detailed instructions and supporting media for patients before the procedure.',
      'Aftercare guidelines and recovery media for patients after the procedure.',
      'Configure how many post-treatment photos should be captured for this treatment.',
      'Automated reminders and follow-up engagement messages.',
      'Configure booking restriction window after treatment.',
      'Define which provider roles are authorized to perform this treatment.',
      'Manage rules and scheduling for post-procedure clinical check-ins.',
      'Upload and manage legal procedural consent documentation.',
    ];
    final icons = [
      Icons.inventory_2_outlined,
      Icons.schedule_outlined,
      Icons.payments_outlined,
      Icons.assignment_turned_in_outlined,
      Icons.login_rounded,
      Icons.logout_rounded,
      Icons.add_a_photo_outlined,
      Icons.notifications_active_outlined,
      Icons.hourglass_bottom_rounded,
      Icons.badge_outlined,
      Icons.replay_outlined,
      Icons.fact_check_outlined,
    ];

    final sessionState = ref.watch(sessionViewModelProvider);
    final int stepIndex = _getSessionOffsetStep(sessionState.sessionStep);
    if (stepIndex < 0 || stepIndex >= titles.length) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: context.appEdgeInsets(all: 12),
              decoration: BoxDecoration(
                color: CustomColors.purple.withValues(alpha: 0.1),
                borderRadius: context.appBorderRadius(all: 12),
              ),
              child: Icon(
                icons[stepIndex],
                color: CustomColors.purple,
                size: 24,
              ),
            ),
            context.horizontalSpace(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titles[stepIndex], style: context.fonts.black20w600),
                  Text(
                    descriptions[stepIndex],
                    style: context.fonts.grey14w400,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }



  List<TreatmentProtocolNoteItem> _getCategoryDefaultNotes(
    CategoryDetailDto? category,
  ) {
    if (category == null) return [];
    if ((category.name?.toLowerCase().contains('inject') ?? false) ||
        (category.name?.toLowerCase().contains('fill') ?? false)) {
      return [
        TreatmentProtocolNoteItem(
          title: 'Category Pre Care Instructions',
          description:
              'Avoid aspirin, ibuprofen, and alcohol 24 hours prior to injections to minimize bruising.',
          order: 1,
        ),
        TreatmentProtocolNoteItem(
          title: 'Category Post Care Instructions',
          description:
              'Do not massage, rub, or apply pressure to the injected areas for at least 4 hours.',
          order: 2,
        ),
      ];
    }
    return [
      TreatmentProtocolNoteItem(
        title: 'Category General Care Instructions',
        description:
            'Follow all general clinical skin sync instructions provided by your clinician.',
        order: 1,
      ),
    ];
  }

  Widget _buildCompleteTreatmentBlueprint(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
    TreatmentDataState dataState,
    CategoryDetailDto? selectedCategory,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildValidationIndicators(context, state, viewModel, selectedCategory),
        _buildBasicInfoSummary(context, state, viewModel, selectedCategory),
        _buildAreasSummary(context, state, dataState),
        _buildProductsSummary(context, state),
        _buildSchedulingSummary(context, state, viewModel),
        _buildPricingSummary(context, state, viewModel),
        _buildSessionsSummary(context, state, selectedCategory),
        _buildConsentSummary(context, state, selectedCategory),
        _buildPreTreatmentInstructionsSummary(context, state, viewModel),
        _buildNotificationsSummary(context, state, selectedCategory),
        _buildDowntimeSummary(context, state, selectedCategory),
        _buildProviderRolesSummary(context, state, selectedCategory),
        _buildInheritanceSummary(context, state),
      ],
    );
  }

  Widget _buildSchedulingSummary(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
  ) {
    final sessionState = ref.watch(sessionViewModelProvider);
    final sessionViewModel = ref.read(sessionViewModelProvider.notifier);
    final baseDuration =
        double.tryParse(sessionViewModel.treatmentDurationController.text) ??
        0.0;
    final productDuration = _calculateProductUsageDuration(state);
    final prepTime =
        double.tryParse(sessionViewModel.prepTimeController.text) ?? 0.0;
    final cleanupTime =
        double.tryParse(sessionViewModel.cleanupTimeController.text) ?? 0.0;
    final totalDuration =
        baseDuration + productDuration + prepTime + cleanupTime;

    return _blueprintSection(
      context,
      '4. Scheduling Configuration',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _blueprintRow(
            context,
            'Base Duration',
            '${baseDuration.toStringAsFixed(baseDuration % 1 == 0 ? 0 : 1)} Minutes',
          ),
          _blueprintRow(
            context,
            'Product Usage Duration',
            '${productDuration.toStringAsFixed(productDuration % 1 == 0 ? 0 : 1)} Minutes',
          ),
          _blueprintRow(
            context,
            'Preparation Time',
            '${prepTime.toStringAsFixed(prepTime % 1 == 0 ? 0 : 1)} Minutes',
          ),
          _blueprintRow(
            context,
            'Cleanup Time',
            '${cleanupTime.toStringAsFixed(cleanupTime % 1 == 0 ? 0 : 1)} Minutes',
          ),
          _blueprintRow(
            context,
            'Total Duration',
            '${totalDuration.toStringAsFixed(totalDuration % 1 == 0 ? 0 : 1)} Minutes',
          ),
          _blueprintRow(
            context,
            'Online Bookable',
            sessionState.onlineBookable ? 'Yes' : 'No',
          ),
          _blueprintRow(
            context,
            'Manual Approval Required',
            sessionState.manualApprovalRequired ? 'Yes' : 'No',
          ),
          _blueprintRow(
            context,
            'Allow Clinic Override',
            sessionState.allowClinicOverride ? 'Yes' : 'No',
          ),
          _blueprintRow(
            context,
            'Allow Provider Override',
            sessionState.allowProviderOverride ? 'Yes' : 'No',
          ),
          _blueprintRow(
            context,
            'Minimum Booking Notice',
            "${sessionViewModel.minimumBookingNoticeController.text.isEmpty ? '24' : sessionViewModel.minimumBookingNoticeController.text} Hours",
          ),
          _blueprintRow(
            context,
            'Maximum Days in Advance',
            "${sessionViewModel.maximumDaysInAdvanceController.text.isEmpty ? '90' : sessionViewModel.maximumDaysInAdvanceController.text} Days",
          ),
        ],
      ),
    );
  }

  Widget _blueprintSection(BuildContext context, String title, Widget child) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: context.appEdgeInsets(all: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: context.appBorderRadius(all: 12),
        border: Border.all(color: CustomColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.fonts.purple12w700),
          context.verticalSpace(12),
          child,
        ],
      ),
    );
  }

  Widget _blueprintRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: context.fonts.grey12w400),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: context.fonts.black12w600,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValidationIndicators(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
    CategoryDetailDto? selectedCategory,
  ) {
    final sessionState = ref.watch(sessionViewModelProvider);
    final sessionViewModel = ref.read(sessionViewModelProvider.notifier);
    final basicOk =
        viewModel.validateGlobalSku(
              viewModel.globalSkuController.text.trim(),
            ) ==
            null &&
        viewModel.categoryIdController.text.isNotEmpty;
    final schedOk =
        sessionViewModel.treatmentDurationController.text.isNotEmpty &&
        (int.tryParse(sessionViewModel.treatmentDurationController.text) ?? 0) >
            0;
    final areasOk = state.areas.any((a) => a.areaController.text.isNotEmpty);
    final sessionsOk = sessionState.totalSessions > 0;
    final followUpsOk = sessionState.sessions.any(
      (s) => s.followUps.isNotEmpty,
    );
    final consentOk =
        sessionState.consentType == 'category' ||
        sessionState.preTreatmentConsentForm != null ||
        sessionState.existingConsentForm != null;
    final notifOk =
        sessionState.preNotificationSource == 'category' ||
        sessionState.postNotificationSource == 'category' ||
        sessionState.preNotificationOffset != null ||
        sessionState.postNotificationOffset != null;
    final productsOk = sessionState.productUsageEntries.isNotEmpty;
    final pricingOk = sessionViewModel.basePriceController.text.isNotEmpty;
    final rolesOk =
        sessionState.providerRolesSource == 'category' ||
        sessionState.selectedRoles.isNotEmpty;

    return _blueprintSection(
      context,
      'Step Validation Status',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _validationRow(context, 'Basic Information', basicOk),
          _validationRow(context, 'Products', productsOk),
          _validationRow(context, 'Scheduling Configuration', schedOk),
          _validationRow(context, 'Pricing', pricingOk),
          _validationRow(context, 'Areas & Sub Areas', areasOk),
          _validationRow(context, 'Notifications', notifOk),
          rolesOk
              ? _validationRow(context, 'Provider Roles', true)
              : _validationRow(
                  context,
                  'Missing Provider Roles',
                  false,
                  warning: true,
                ),
          _validationRow(context, 'Sessions Setup', sessionsOk),
          _validationRow(context, 'Follow-Ups', followUpsOk),
          _validationRow(context, 'Consent Form', consentOk),
        ],
      ),
    );
  }

  Widget _validationRow(
    BuildContext context,
    String label,
    bool isOk, {
    bool warning = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(
            isOk
                ? Icons.check_circle_rounded
                : (warning
                      ? Icons.warning_amber_rounded
                      : Icons.cancel_rounded),
            size: 16,
            color: isOk
                ? CustomColors.green
                : (warning ? Colors.orange : CustomColors.red),
          ),
          context.horizontalSpace(8),
          Expanded(
            child: Text(
              label,
              style: isOk
                  ? context.fonts.black12w600
                  : (warning
                        ? context.fonts.black12w600.copyWith(
                            color: Colors.orange,
                          )
                        : context.fonts.grey12w400),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSummary(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
    CategoryDetailDto? selectedCategory,
  ) {
    return _blueprintSection(
      context,
      '1. Basic Information',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _blueprintRow(
            context,
            'Global SKU',
            viewModel.globalSkuController.text.isEmpty
                ? 'Not set'
                : viewModel.globalSkuController.text,
          ),
          _blueprintRow(
            context,
            'Treatment Name',
            viewModel.displayNameController.text.isEmpty
                ? 'Not set'
                : viewModel.displayNameController.text,
          ),
          _blueprintRow(
            context,
            'Description',
            viewModel.shortDescriptionController.text.isEmpty
                ? 'Not set'
                : viewModel.shortDescriptionController.text,
          ),
          _blueprintRow(
            context,
            'Category',
            viewModel.categoryNameController.text.isEmpty
                ? 'Not set'
                : viewModel.categoryNameController.text,
          ),
          _blueprintRow(context, 'Status', state.status.toUpperCase()),
          _blueprintRow(
            context,
            'AI Simulation',
            state.useInAiSimulator ? 'Compatible' : 'Incompatible',
          ),
          _blueprintRow(
            context,
            'Enable by Default',
            state.enableByDefault ? 'Yes' : 'No',
          ),
        ],
      ),
    );
  }

  Widget _buildAreasSummary(
    BuildContext context,
    TreatmentState state,
    TreatmentDataState dataState,
  ) {
    final activeAreas = state.areas
        .where((a) => a.areaController.text.isNotEmpty)
        .toList();

    return _blueprintSection(
      context,
      '2. Selected Areas & Sub-Areas Summary',
      activeAreas.isEmpty
          ? Text('No areas selected', style: context.fonts.grey12w400)
          : Wrap(
              spacing: 12,
              runSpacing: 12,
              children: activeAreas.map((areaEntry) {
                // Find corresponding AreaModel in dataState.areas
                final areaItem = dataState.areas.firstWhereOrNull(
                  (a) => a.name == areaEntry.areaController.text,
                );

                final List<PreviewItem> subItems = areaEntry.subAreas.map((s) {
                  // Find corresponding subarea SKU
                  final subAreaModel = areaItem?.subAreas.firstWhereOrNull(
                    (sa) => sa.name == s.name,
                  );

                  final List<PreviewItem> childItems = s.children.map((c) {
                    final childModel = subAreaModel?.subAreas.firstWhereOrNull(
                      (ca) => ca.name == c.name,
                    );
                    return PreviewItem(
                      label: '${c.name} (${childModel?.globalSku ?? 'N/A'})',
                      onRemove: () {},
                    );
                  }).toList();

                  return PreviewItem(
                    label: '${s.name} (${subAreaModel?.globalSku ?? 'N/A'})',
                    onRemove: () {},
                    children: childItems,
                  );
                }).toList();

                return SelectedSummaryCard(
                  title: areaItem?.name ?? 'N/A',
                  sku: areaItem?.globalSku ?? 'N/A',
                  icon: areaItem?.icon,
                  subLabel: 'Selected Sub-Areas:',
                  items: subItems,
                  onRemove: () {},
                  summary: true,
                );
              }).toList(),
            ),
    );
  }

  Widget _buildSessionsSummary(
    BuildContext context,
    TreatmentState state,
    CategoryDetailDto? selectedCategory,
  ) {
    final sessionState = ref.watch(sessionViewModelProvider);
    final isCategory = sessionState.sessionSource == 'category';

    return _blueprintSection(
      context,
      '6. Sessions Overview',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Sessions Source: ', style: context.fonts.black12w600),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isCategory
                      ? CustomColors.green.withValues(alpha: 0.1)
                      : CustomColors.purple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isCategory ? 'Category Default' : 'Custom',
                  style: isCategory
                      ? context.fonts.green10w700
                      : context.fonts.purple11w600,
                ),
              ),
            ],
          ),
          context.verticalSpace(10),
          if (sessionState.sessions.isEmpty)
            Text('No sessions defined', style: context.fonts.grey12w400)
          else
            ...sessionState.sessions.map((session) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Session ${session.sessionNumber} (Total Follow-Ups: ${session.followUps.length})',
                      style: context.fonts.black12w600,
                    ),
                    if (session.followUps != null &&
                        session.followUps.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 12, top: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: session.followUps.asMap().entries.map((
                            entry,
                          ) {
                            final idx = entry.key;
                            final fu = entry.value;
                            final durationText =
                                "${fu.durationValueController.text.isEmpty ? '0' : fu.durationValueController.text} ${fu.durationUnit}";
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '• Follow-Up ${idx + 1}',
                                    style: context.fonts.black12w600,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      "Type: ${fu.type.toUpperCase()} | Duration: $durationText | Image Req: ${fu.isImageRequired ? 'Yes' : 'No'}",
                                      style: context.fonts.grey11w400,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildConsentSummary(
    BuildContext context,
    TreatmentState state,
    CategoryDetailDto? selectedCategory,
  ) {
    final sessionState = ref.watch(sessionViewModelProvider);
    final isCategory = sessionState.consentType == 'category';
    String consentFileName = 'No PDF uploaded';
    if (isCategory) {
      consentFileName =
          selectedCategory?.consentFormName ?? 'Category Consent Form';
    } else {
      final dynamic preForm = sessionState.preTreatmentConsentForm;
      final dynamic exForm = sessionState.existingConsentForm;
      consentFileName =
          (preForm?.name as String?) ??
          (exForm?.name as String?) ??
          'No PDF uploaded';
    }

    return _blueprintSection(
      context,
      '7. Consent Form',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _blueprintRow(
            context,
            'Consent Form Source',
            isCategory ? 'Category Default' : 'Treatment Specific',
          ),
          _blueprintRow(context, 'Consent File', consentFileName),
        ],
      ),
    );
  }

  Widget _buildPreTreatmentInstructionsSummary(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
  ) {
    final sessionState = ref.watch(sessionViewModelProvider);
    final sessionViewModel = ref.read(sessionViewModelProvider.notifier);
    final hasInstructions =
        sessionViewModel.preTreatmentInstructionsController.text.isNotEmpty;
    final instructionsText = hasInstructions ? 'Configured' : 'None';

    final allPre = [...sessionState.existingPreAttachments];

    final pdfs = allPre.where((a) => a.type == 'pdf').length;
    final images = allPre.where((a) => a.type == 'image').length;
    final videos = allPre.where((a) => a.type == 'video').length;

    return _blueprintSection(
      context,
      '8. Pre-Treatment Instructions',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _blueprintRow(context, 'Instructions Text', instructionsText),
          _blueprintRow(context, 'PDFs Attached', '$pdfs'),
          _blueprintRow(context, 'Images Attached', '$images'),
          _blueprintRow(context, 'Videos Attached', '$videos'),
        ],
      ),
    );
  }

  Widget _buildNotificationsSummary(
    BuildContext context,
    TreatmentState state,
    CategoryDetailDto? selectedCategory,
  ) {
    final sessionState = ref.watch(sessionViewModelProvider);
    final isPreCategory = sessionState.preNotificationSource == 'category';
    final isPostCategory = sessionState.postNotificationSource == 'category';

    String preSummary = 'Not configured';
    if (isPreCategory) {
      preSummary = (selectedCategory?.preNotifications?.isNotEmpty ?? false)
          ? '${selectedCategory?.preNotifications?.length} Category Defaults'
          : 'Category Default';
    } else {
      preSummary =
          '${sessionState.preNotificationEntries.length} Custom Notifications';
    }

    String postSummary = 'Not configured';
    if (isPostCategory) {
      postSummary = (selectedCategory?.postNotifications?.isNotEmpty ?? false)
          ? '${selectedCategory?.postNotifications?.length} Category Defaults'
          : 'Category Default';
    } else {
      postSummary =
          '${sessionState.postNotificationEntries.length} Custom Notifications';
    }

    return _blueprintSection(
      context,
      '9. Patient Notifications',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _blueprintRow(
            context,
            'Pre-Notification Source',
            isPreCategory ? 'Category Default' : 'Custom',
          ),
          _blueprintRow(context, 'Pre-Notifications', preSummary),
          _blueprintRow(
            context,
            'Post-Notification Source',
            isPostCategory ? 'Category Default' : 'Custom',
          ),
          _blueprintRow(context, 'Post-Notifications', postSummary),
        ],
      ),
    );
  }

  Widget _buildDowntimeSummary(
    BuildContext context,
    TreatmentState state,
    CategoryDetailDto? selectedCategory,
  ) {
    final sessionState = ref.watch(sessionViewModelProvider);
    final level = sessionState.downtimeLevel;
    int days = 0;
    if (selectedCategory != null) {
      final presets = selectedCategory.downtimePresets;
      if (level == 'low') {
        days = presets?.low ?? 0;
      } else if (level == 'moderate') {
        days = presets?.moderate ?? 0;
      } else if (level == 'high') {
        days = presets?.high ?? 0;
      }
    } else {
      if (level == 'low') {
        days = 2;
      } else if (level == 'moderate') {
        days = 5;
      } else if (level == 'high') {
        days = 10;
      }
    }

    return _blueprintSection(
      context,
      '10. Downtime Configuration',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _blueprintRow(context, 'Downtime Level', level.toUpperCase()),
          _blueprintRow(context, 'Restriction Period', '$days Days'),
        ],
      ),
    );
  }

  Widget _buildProviderRolesSummary(
    BuildContext context,
    TreatmentState state,
    CategoryDetailDto? selectedCategory,
  ) {
    final sessionState = ref.watch(sessionViewModelProvider);
    final isCategory = sessionState.providerRolesSource == 'category';
    final List<String> roles = isCategory
        ? (selectedCategory?.defaultRoles
                  ?.map((r) => r.name[0] + r.name.substring(1).toLowerCase())
                  .toList() ??
              [])
        : sessionState.selectedRoles;

    return _blueprintSection(
      context,
      '11. Allowed Provider Roles',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _blueprintRow(
            context,
            'Provider Roles Source',
            isCategory ? 'Category Default' : 'Custom Overrides',
          ),
          _blueprintRow(
            context,
            'Allowed Roles',
            roles.isEmpty ? 'None allowed' : roles.join(', '),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsSummary(BuildContext context, TreatmentState state) {
    final sessionState = ref.watch(sessionViewModelProvider);
    return _blueprintSection(
      context,
      '3. Products Configuration',
      sessionState.productUsageEntries.isEmpty
          ? Text('No products configured', style: context.fonts.grey12w400)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: sessionState.productUsageEntries.map((entry) {
                final allSubAreas = state.areas
                    .expand((a) => a.subAreas)
                    .toList();

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '• ${entry.productName}',
                        style: context.fonts.black12w600,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12, top: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Usage Type: ${entry.usageType}',
                              style: context.fonts.grey11w400,
                            ),
                            Text(
                              'Deduction Timing: ${entry.deductionTiming}',
                              style: context.fonts.grey11w400,
                            ),
                            Text(
                              "Substitution Allowed: ${entry.allowSubstitution ? 'Yes' : 'No'}",
                              style: context.fonts.grey11w400,
                            ),
                            if (allSubAreas.isNotEmpty) ...[
                              context.verticalSpace(4),
                              Text(
                                'Sub-Area Consumption Overrides:',
                                style: context.fonts.black12w600,
                              ),
                              ...allSubAreas.map((subArea) {
                                final controllers = entry
                                    .getControllersForSubArea(
                                      subArea.name,
                                      subAreaId: subArea.id,
                                    );
                                final minText = controllers.minController.text;
                                final maxText = controllers.maxController.text;
                                return Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text(
                                    '- ${subArea.name}: Min $minText / Max $maxText ${entry.unit}',
                                    style: context.fonts.grey11w400,
                                  ),
                                );
                              }),
                            ],
                            if (entry.notesController.text.isNotEmpty)
                              Text(
                                'Notes: ${entry.notesController.text}',
                                style: context.fonts.grey11w400,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget _buildPricingSummary(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
  ) {
    final sessionState = ref.watch(sessionViewModelProvider);
    final sessionViewModel = ref.read(sessionViewModelProvider.notifier);
    final basePrice = sessionViewModel.basePriceController.text;

    final uniqueUnits = sessionState.productUsageEntries
        .map((e) => e.unit)
        .where((unit) => unit.trim().isNotEmpty)
        .toSet()
        .toList();

    final configuredUnits = uniqueUnits.where((u) {
      final ctrl = sessionViewModel.getControllerForUnit(u);
      return ctrl.text.isNotEmpty && ctrl.text != '0';
    }).toList();

    return _blueprintSection(
      context,
      '5. Pricing & Financial Rules',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _blueprintRow(
            context,
            'Base Price',
            basePrice.isEmpty ? '\$0' : '\$$basePrice',
          ),
          _blueprintRow(
            context,
            'Pricing Logic',
            configuredUnits.isEmpty
                ? 'Standard flat base pricing'
                : 'Dynamic Unit Pricing',
          ),
          if (configuredUnits.isNotEmpty) ...[
            context.verticalSpace(12),
            Text('Unit Pricing Overrides:', style: context.fonts.black12w600),
            ...configuredUnits.map((unit) {
              final ctrl = sessionViewModel.getControllerForUnit(unit);
              final formattedUnit = unit.isNotEmpty
                  ? (unit[0].toUpperCase() + unit.substring(1))
                  : unit;
              return Padding(
                padding: const EdgeInsets.only(left: 12, top: 4),
                child: Text(
                  '• Price Per $formattedUnit: \$${ctrl.text}',
                  style: context.fonts.grey11w400,
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildInheritanceSummary(BuildContext context, TreatmentState state) {
    final sessionState = ref.watch(sessionViewModelProvider);
    final List<String> inherited = [];
    final List<String> overrides = [];

    if (sessionState.sessionSource == 'category') {
      inherited.addAll(['Sessions', 'Follow-Ups']);
    } else {
      overrides.addAll(['Custom Sessions', 'Custom Follow-Ups']);
    }

    if (sessionState.consentType == 'category') {
      inherited.add('Consent Form');
    } else {
      overrides.add('Custom Consent Form');
    }

    if (sessionState.preNotificationSource == 'category' &&
        sessionState.postNotificationSource == 'category') {
      inherited.add('Notifications');
    } else {
      overrides.add('Custom Notifications');
    }

    if (sessionState.providerRolesSource == 'category') {
      inherited.add('Provider Roles');
    } else {
      overrides.add('Custom Provider Roles');
    }

    inherited.add('Downtime Configuration');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _blueprintSection(
          context,
          '12. Inherited From Category',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: inherited
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.arrow_downward_rounded,
                          size: 14,
                          color: CustomColors.green,
                        ),
                        context.horizontalSpace(8),
                        Text(item, style: context.fonts.grey12w400),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        _blueprintSection(
          context,
          '13. Treatment Overrides',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: overrides.isEmpty
                ? [
                    Text(
                      'No custom overrides defined',
                      style: context.fonts.grey12w400,
                    ),
                  ]
                : overrides
                      .map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.edit_road_rounded,
                                size: 14,
                                color: CustomColors.purple,
                              ),
                              context.horizontalSpace(8),
                              Text(item, style: context.fonts.black12w600),
                            ],
                          ),
                        ),
                      )
                      .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPatientJourneyPreview(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
    CategoryState categoryState,
  ) {
    final sessionState = ref.watch(sessionViewModelProvider);
    final sessionViewModel = ref.read(sessionViewModelProvider.notifier);

    final int totalFus = sessionState.sessions.fold(
      0,
      (sum, s) => sum + s.followUps.length,
    );

    return Container(
      padding: context.appEdgeInsets(all: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: context.appBorderRadius(all: 16),
        border: Border.all(color: CustomColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _previewRow(
            context,
            'Instructions',
            sessionViewModel.preTreatmentInstructionsController.text.isNotEmpty,
          ),
          _previewRow(
            context,
            'Aftercare',
            sessionViewModel
                .postTreatmentInstructionsController
                .text
                .isNotEmpty,
          ),
          _previewRow(
            context,
            'Notifications',
            sessionState.preNotificationOffset != null ||
                sessionState.postNotificationOffset != null,
          ),
          _previewRow(context, 'Sessions Defined', true),
          _previewText(context, '${sessionState.totalSessions} Sessions'),
          _previewRow(context, 'Follow-Ups Active', totalFus > 0),
          if (totalFus > 0) _previewText(context, '$totalFus Total Follow-Ups'),
        ],
      ),
    );
  }

  Widget _buildProtocolFormPreview(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
    TreatmentDataState dataState,
    CategoryState categoryState,
  ) {
    final sessionState = ref.watch(sessionViewModelProvider);
    final selectedProtocols = dataState.protocols
        .where((p) => sessionState.selectedProtocolIds.contains(p.id))
        .toList();
    final checkboxes = selectedProtocols
        .where((p) => p.type == ProtocolType.checkbox)
        .toList();
    final textFields = selectedProtocols
        .where((p) => p.type == ProtocolType.text)
        .toList();

    final CategoryDetailDto? selectedCategory = state.selectedCategoryDetail;

    List<TreatmentProtocolNoteItem> notesToShow = [];
    if (sessionState.standaloneNotes.isNotEmpty) {
      notesToShow = sessionState.standaloneNotes;
    } else if (selectedCategory != null) {
      notesToShow = _getCategoryDefaultNotes(selectedCategory);
    }

    final hasProtocols = selectedProtocols.isNotEmpty;
    final hasNotes = notesToShow.isNotEmpty;

    if (!hasProtocols && !hasNotes) {
      return Container(
        width: double.infinity,
        padding: context.appEdgeInsets(all: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: context.appBorderRadius(all: 12),
          border: Border.all(color: CustomColors.border),
        ),
        child: Center(
          child: Text(
            'No clinical protocols configured yet.',
            style: context.fonts.grey12w400,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: context.appEdgeInsets(all: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: context.appBorderRadius(all: 12),
        border: Border.all(color: CustomColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (checkboxes.isNotEmpty) ...[
            Text('CHECKLIST', style: context.fonts.grey10w700ls1),
            context.verticalSpace(12),
            ...checkboxes.map(
              (p) => Padding(
                padding: context.appEdgeInsets(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Container(
                        width: context.w(18),
                        height: context.w(18),
                        decoration: BoxDecoration(
                          borderRadius: context.appBorderRadius(all: 4),
                          border: Border.all(
                            color: CustomColors.border,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    context.horizontalSpace(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.title, style: context.fonts.black13w400),
                          Builder(
                            builder: (context) {
                              final pNote = sessionState.selectedProtocolNotes
                                  .firstWhere(
                                    (n) => n.protocolName == p.title,
                                    orElse: () => TreatmentProtocolNote(
                                      protocolName: p.title,
                                      notes: [],
                                    ),
                                  );
                              if (pNote.notes.isNotEmpty) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    context.verticalSpace(6),
                                    Text(
                                      'Notes:',
                                      style: context.fonts.black12w600,
                                    ),
                                    ...pNote.notes.map(
                                      (note) => Padding(
                                        padding: const EdgeInsets.only(
                                          left: 8.0,
                                          top: 4.0,
                                        ),
                                        child: Text(
                                          "• ${note.title != null && note.title!.isNotEmpty ? '${note.title}: ' : ''}${note.description}",
                                          style: context.fonts.grey11w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (checkboxes.isNotEmpty && textFields.isNotEmpty)
            context.verticalSpace(12),
          if (textFields.isNotEmpty) ...[
            Text('NOTES', style: context.fonts.grey10w700ls1),
            context.verticalSpace(12),
            ...textFields.map(
              (p) => Padding(
                padding: context.appEdgeInsets(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.title, style: context.fonts.black12w600),
                    context.verticalSpace(8),
                    Container(
                      height: context.h(40),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: CustomColors.whiteGrey,
                        borderRadius: context.appBorderRadius(all: 8),
                        border: Border.all(color: CustomColors.border),
                      ),
                    ),
                    Builder(
                      builder: (context) {
                        final pNote = sessionState.selectedProtocolNotes
                            .firstWhere(
                              (n) => n.protocolName == p.title,
                              orElse: () => TreatmentProtocolNote(
                                protocolName: p.title,
                                notes: [],
                              ),
                            );
                        if (pNote.notes.isNotEmpty) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              context.verticalSpace(8),
                              Text('Notes:', style: context.fonts.black12w600),
                              ...pNote.notes.map(
                                (note) => Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8.0,
                                    top: 4.0,
                                  ),
                                  child: Text(
                                    "• ${note.title != null && note.title!.isNotEmpty ? '${note.title}: ' : ''}${note.description}",
                                    style: context.fonts.grey11w400,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (hasNotes) ...[
            if (hasProtocols) ...[
              context.verticalSpace(24),
              const Divider(),
              context.verticalSpace(16),
            ],
            Text('NOTES / INSTRUCTIONS', style: context.fonts.grey10w700ls1),
            context.verticalSpace(12),
            ...notesToShow.map((note) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          size: 14,
                          color: CustomColors.purple,
                        ),
                        context.horizontalSpace(8),
                        if (note.title != null && note.title!.isNotEmpty)
                          Expanded(
                            child: Text(
                              note.title!,
                              style: context.fonts.black13w600,
                            ),
                          ),
                      ],
                    ),
                    context.verticalSpace(4),
                    Padding(
                      padding: const EdgeInsets.only(left: 22.0),
                      child: Text(
                        note.description,
                        style: context.fonts.grey12w400,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildPreviewCard(
    BuildContext context,
    TreatmentViewModel viewModel,
    TreatmentState state,
  ) {
    final sessionViewModel = ref.read(sessionViewModelProvider.notifier);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: context.appBorderRadius(all: 16),
        boxShadow: AppShadows.card(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: context.h(160),
            width: double.infinity,
            decoration: BoxDecoration(
              color: CustomColors.whiteGrey,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              image: state.treatmentImageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(state.treatmentImageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: state.treatmentImageUrl == null
                ? const Center(
                    child: Icon(
                      Icons.image_outlined,
                      color: CustomColors.grey,
                      size: 40,
                    ),
                  )
                : null,
          ),
          Padding(
            padding: context.appEdgeInsets(all: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        viewModel.displayNameController.text.isEmpty
                            ? 'New Treatment'
                            : viewModel.displayNameController.text,
                        style: context.fonts.black16w700,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      "\$${sessionViewModel.basePriceController.text.isEmpty ? "0" : sessionViewModel.basePriceController.text}",
                      style: context.fonts.purple16w700,
                    ),
                  ],
                ),
                context.verticalSpace(8),
                Text(
                  viewModel.shortDescriptionController.text.isEmpty
                      ? 'No description provided yet.'
                      : viewModel.shortDescriptionController.text,
                  style: context.fonts.grey12w400,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                context.verticalSpace(16),
                const Divider(),
                context.verticalSpace(16),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 16,
                      color: CustomColors.grey,
                    ),
                    context.horizontalSpace(8),
                    Text(
                      '${sessionViewModel.durationHoursController.text}h ${sessionViewModel.durationMinutesController.text}m',
                      style: context.fonts.black12w600,
                    ),
                    const Spacer(),
                    Container(
                      padding: context.appEdgeInsets(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: CustomColors.green.withValues(alpha: 0.1),
                        borderRadius: context.appBorderRadius(all: 20),
                      ),
                      child: Text('Active', style: context.fonts.green10w700),
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

  Widget _buildSummaryChips(
    BuildContext context,
    TreatmentViewModel viewModel,
    TreatmentState state,
    TreatmentDataState dataState,
  ) {
    final sessionState = ref.watch(sessionViewModelProvider);
    final checkboxCount = dataState.protocols
        .where(
          (p) =>
              p.type == ProtocolType.checkbox &&
              sessionState.selectedProtocolIds.contains(p.id),
        )
        .length;
    final textCount = dataState.protocols
        .where(
          (p) =>
              p.type == ProtocolType.text &&
              sessionState.selectedProtocolIds.contains(p.id),
        )
        .length;

    return Wrap(
      spacing: context.w(8),
      runSpacing: context.h(8),
      children: [
        if (viewModel.categoryPathController.text.isNotEmpty)
          _summaryChip(
            context,
            viewModel.categoryPathController.text,
            Icons.category_outlined,
          ),
        if (state.areas.any((a) => a.areaController.text.isNotEmpty))
          _summaryChip(
            context,
            '${state.areas.where((a) => a.areaController.text.isNotEmpty).length} Areas',
            Icons.location_on_outlined,
          ),
        if (checkboxCount > 0)
          _summaryChip(
            context,
            '$checkboxCount Checkboxes',
            Icons.check_box_outlined,
          ),
        if (textCount > 0)
          _summaryChip(
            context,
            '$textCount Text Protocols',
            Icons.text_snippet_outlined,
          ),
        if (sessionState.preTreatmentConsentForm != null ||
            sessionState.existingConsentForm != null)
          _summaryChip(context, 'Consent Required', Icons.fact_check_outlined),
        if (sessionState.isFollowUpRequired)
          _summaryChip(context, 'Follow-Up Required', Icons.replay_outlined),
        if (state.useInAiSimulator)
          _summaryChip(context, 'AI Compatible', Icons.auto_awesome_outlined),
        if (sessionState.requirePostTreatmentPhotos)
          _summaryChip(
            context,
            '${sessionState.requiredPostTreatmentPhotoCount} Photos Required',
            Icons.add_a_photo_outlined,
          ),
        _summaryChip(
          context,
          state.status.toUpperCase(),
          Icons.info_outline_rounded,
        ),
      ],
    );
  }

  Widget _summaryChip(BuildContext context, String label, IconData icon) {
    return Container(
      padding: context.appEdgeInsets(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: context.appBorderRadius(all: 8),
        border: Border.all(color: CustomColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: CustomColors.purple),
          context.horizontalSpace(8),
          Text(label, style: context.fonts.black12w400),
        ],
      ),
    );
  }

  Widget _previewRow(BuildContext context, String label, bool check) {
    return Padding(
      padding: context.appEdgeInsets(bottom: 8),
      child: Row(
        children: [
          Icon(
            check
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            size: 16,
            color: check ? CustomColors.green : CustomColors.grey,
          ),
          context.horizontalSpace(12),
          Expanded(
            child: Text(
              label,
              style: check
                  ? context.fonts.black13w600
                  : context.fonts.grey13w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _previewText(BuildContext context, String text) {
    return Padding(
      padding: context.appEdgeInsets(left: 28, bottom: 4),
      child: Text(text, style: context.fonts.grey12w400),
    );
  }

  Widget _buildMobileProgress(BuildContext context, TreatmentState state) {
    final sessionState = ref.watch(sessionViewModelProvider);
    const stepsCount = 12;
    final currentOffsetStep = _getSessionOffsetStep(sessionState.sessionStep);
    return Container(
      padding: context.appEdgeInsets(horizontal: 24, vertical: 16),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${currentOffsetStep + 1} of $stepsCount',
                style: context.fonts.black14w700,
              ),
              Text(
                '${((currentOffsetStep + 1) / stepsCount * 100).toInt()}%',
                style: context.fonts.purple14w700,
              ),
            ],
          ),
          context.verticalSpace(8),
          LinearProgressIndicator(
            value: (currentOffsetStep + 1) / stepsCount,
            minHeight: context.h(4),
            backgroundColor: CustomColors.whiteGrey,
            valueColor: const AlwaysStoppedAnimation<Color>(
              CustomColors.purple,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStepContent(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
    TreatmentDataState dataState,
    CategoryState categoryState,
    WidgetRef ref,
  ) {
    final sessionState = ref.watch(sessionViewModelProvider);
    switch (sessionState.sessionStep) {
      case 1:
        return const MaterialsStep();
      case 2:
        return const SchedulingStep();
      case 3:
        return const PricingStep();
      case 4:
        return const ProtocolsStep();
      case 5:
        return const PreInstructionsStep();
      case 6:
        return const PostInstructionsStep();
      case 7:
        return const PostPhotosStep();
      case 8:
        return const NotificationsStep();
      case 9:
        return const DowntimeStep();
      case 10:
        return const RolesStep();
      case 11:
        return const FollowUpStep();
      case 12:
        return const ConsentStep();
      default:
        return const SizedBox.shrink();
    }
  }

  double _getProductMinQuantity(
    ProductUsageEntry entry,
    List<SubAreaConfig> allSubAreas,
  ) {
    if (allSubAreas.isNotEmpty) {
      double sum = 0.0;
      for (final subArea in allSubAreas) {
        final controllers = entry.getControllersForSubArea(
          subArea.name,
          subAreaId: subArea.id,
        );
        sum += double.tryParse(controllers.minController.text) ?? 0.0;
      }
      return sum;
    } else {
      return double.tryParse(entry.minQuantityController.text) ?? 0.0;
    }
  }

  double _calculateProductUsageDuration(TreatmentState state) {
    final sessionState = ref.read(sessionViewModelProvider);
    final allSubAreas = state.areas.expand((a) => a.subAreas).toList();
    double total = 0.0;
    for (final entry in sessionState.productUsageEntries) {
      final minQty = _getProductMinQuantity(entry, allSubAreas);
      final perUnit =
          double.tryParse(entry.perUnitDurationController.text) ?? 0.0;
      total += minQty * perUnit;
    }
    return total;
  }

  Widget _buildActionButtons(
    BuildContext context,
    TreatmentState state,
    SessionViewModel viewModel,
    TreatmentDataState dataState,
    CategoryState categoryState,
  ) {
    final sessionState = ref.watch(sessionViewModelProvider);
    final sessionViewModel = ref.read(sessionViewModelProvider.notifier);
    final bool isLastStep = sessionState.sessionStep == 12;
    return Row(
      children: [
        if (sessionState.sessionStep > 1) ...[
          Expanded(
            child: CustomOutlinedButton(
              onTap: () {
                viewModel.setSessionStep(sessionState.sessionStep - 1);
              },
              label: 'Previous Step',
            ),
          ),
          context.horizontalSpace(16),
        ] else if (sessionState.sessionStep == 1) ...[
          Expanded(
            child: CustomOutlinedButton(
              onTap: () {
                context.pop();
              },
              label: 'Previous Step',
            ),
          ),
          context.horizontalSpace(16),
        ],
        Expanded(
          flex: 2,
          child: CustomPrimaryButton(
            onTap: () async {
              log('CURRENT STEP: ${sessionState.sessionStep}');
              bool success = false;

              if (sessionState.sessionStep == 1) { // Inventory Products
                if (!_validateProductQuantities(context, state)) return;
                final result = await viewModel.callProductUsage();
                success = (result == true);
              } 
              else if (sessionState.sessionStep == 2) { // Scheduling
                if (!_validateScheduling(context, viewModel)) return;
                final result = await viewModel.createSchedule(stepNumber: 3);
                success = (result == true);
              } 
              else if (sessionState.sessionStep == 3) { // Pricing Setup
                final result = await viewModel.callStepPricing(stepNumber: 4);
                success = (result == true);
              } 
              else if (sessionState.sessionStep == 4) { // Protocols
                final bytes = await ProtocolFormPreview.getPdfBytes(
                  state: state,
                  sessionState: sessionState,
                  dataState: dataState,
                  categoryState: categoryState,
                );
                final result = await viewModel.callProtocol(stepNumber: 5, bytes: bytes);
                success = (result == true);
              } 
              else if (sessionState.sessionStep == 5) { // Pre-Treatment Instructions
                final result = await viewModel.callPreTreatmentInstructions();
                success = (result == true);
              } 
              else if (sessionState.sessionStep == 6) { // Post-Treatment Instructions
                final result = await viewModel.callPostTreatmentInstructions();
                success = (result == true);
              } 
              else if (sessionState.sessionStep == 7) { // Post Treatment Photos
                if (!_validatePostPhotos(context, state)) return;
                final result = await viewModel.callPostTreatmentPhotos();
                success = (result == true);
              } 
              else if (sessionState.sessionStep == 8) { // Phase Notifications
                if (!_validatePhaseNotifications(context, state)) return;
                final result = await viewModel.callPhaseNotifications();
                success = (result == true);
              } 
              else if (sessionState.sessionStep == 9) { // Downtime Level
                final result = await viewModel.callDownTimeLevels();
                success = (result == true);
              } 
              else if (sessionState.sessionStep == 10) { // Allowed Provider Roles
                final result = await viewModel.callAllowedProviderRoles();
                success = (result == true);
              } 
              else if (sessionState.sessionStep == 11) { // Follow-Up Setup
                if (!_validateFollowUps(context, sessionState)) return;
                final result = await viewModel.callFollowUpConfig();
                success = (result == true);
              } 
              else if (sessionState.sessionStep == 12) { // Patient Consent (Last Step!)
                final result = await viewModel.callConsentFormSelection();
                if (result == true) {
                  final durationText =
                      '${sessionViewModel.treatmentDurationController.text} mins (Prep: ${sessionViewModel.prepTimeController.text}m, Clean: ${sessionViewModel.cleanupTimeController.text}m)';
                  final priceText = sessionState.isFixedPrice
                      ? '\$${sessionViewModel.fixedPriceController.text} (Fixed)'
                      : '\$${sessionViewModel.basePriceController.text}';

                  final protocols = sessionState.selectedProtocolIds.toList();
                  final preInstructions =
                      sessionViewModel.preTreatmentInstructionsController.text;
                  final postInstructions =
                      sessionViewModel.postTreatmentInstructionsController.text;

                  final preNotifs = sessionState.preNotificationEntries
                      .map(
                        (n) =>
                            '${n.timingValueController.text} ${n.timingUnit} before: ${n.titleController.text}',
                      )
                      .toList();
                  final postNotifs = sessionState.postNotificationEntries
                      .map(
                        (n) =>
                            '${n.timingValueController.text} ${n.timingUnit} after: ${n.titleController.text}',
                      )
                      .toList();

                  sessionViewModel.markActiveSessionAsDetailed(
                    durationText: durationText,
                    priceText: priceText,
                    protocols: protocols,
                    preInstructions: preInstructions,
                    postInstructions: postInstructions,
                    requirePhotosSnapshot:
                        sessionState.requirePostTreatmentPhotos,
                    photosCountSnapshot:
                        sessionState.requiredPostTreatmentPhotoCount,
                    preNotifs: preNotifs,
                    postNotifs: postNotifs,
                    downtimeLevel: sessionState.downtimeLevel,
                    selectedRoles: sessionState.selectedRoles,
                    consentSnapshot: sessionState.consentType == 'category'
                        ? (state.selectedCategoryDetail?.consentFormName ??
                              'Category Consent Form')
                        : (sessionState.preTreatmentConsentForm?.name ??
                              sessionState.existingConsentForm?.name ??
                              'Custom Consent'),
                    productUsageEntries: sessionState.productUsageEntries,
                  );
                  if (context.mounted) {
                    context.pop();
                  }
                }
              }

              if (success && sessionState.sessionStep < 12) {
                viewModel.setSessionStep(sessionState.sessionStep + 1);
              }
            },
            label: isLastStep ? 'Save Session Details' : 'Next Step',
          ),
        ),
      ],
    );
  }

  bool _validatePostPhotos(BuildContext context, TreatmentState state) {
    final sessionState = ref.read(sessionViewModelProvider);
    if (sessionState.requirePostTreatmentPhotos) {
      if (sessionState.requiredPostTreatmentPhotoCount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please specify the required number of photos.'),
            backgroundColor: CustomColors.red,
          ),
        );
        return false;
      }
    }
    return true;
  }

  bool _validateProductQuantities(BuildContext context, TreatmentState state) {
    final sessionState = ref.read(sessionViewModelProvider);
    final allSubAreas = state.areas.expand((a) => a.subAreas).toList();
    for (final entry in sessionState.productUsageEntries) {
      if (allSubAreas.isNotEmpty) {
        for (final subArea in allSubAreas) {
          final controllers = entry.getControllersForSubArea(
            subArea.name,
            subAreaId: subArea.id,
          );
          final minVal = double.tryParse(controllers.minController.text) ?? 0.0;
          final maxVal = double.tryParse(controllers.maxController.text) ?? 0.0;
          if (minVal < 1 || maxVal < 1) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Quantity for ${entry.productName} in ${subArea.name} must be greater than or equal to 1.',
                ),
                backgroundColor: CustomColors.red,
              ),
            );
            return false;
          }
          if (maxVal < minVal) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Maximum Quantity must be greater than or equal to Minimum Quantity for ${entry.productName} in ${subArea.name}.',
                ),
                backgroundColor: CustomColors.red,
              ),
            );
            return false;
          }
        }
      } else {
        final minVal = double.tryParse(entry.minQuantityController.text) ?? 0.0;
        final maxVal = double.tryParse(entry.maxQuantityController.text) ?? 0.0;
        if (minVal < 1 || maxVal < 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Quantity for ${entry.productName} must be greater than or equal to 1.',
              ),
              backgroundColor: CustomColors.red,
            ),
          );
          return false;
        }
        if (maxVal < minVal) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Maximum Quantity must be greater than or equal to Minimum Quantity for ${entry.productName}.',
              ),
              backgroundColor: CustomColors.red,
            ),
          );
          return false;
        }
      }
    }
    return true;
  }

  bool _validateScheduling(BuildContext context, SessionViewModel viewModel) {
    final sessionState = ref.read(sessionViewModelProvider);
    final sessionViewModel = ref.read(sessionViewModelProvider.notifier);
    if (sessionState.isFixedDuration) {
      if (sessionViewModel.fixedDurationController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid fixed duration'),
            backgroundColor: CustomColors.red,
          ),
        );
        return false;
      }
      final duration =
          int.tryParse(sessionViewModel.fixedDurationController.text) ?? 0;
      if (duration <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fixed duration must be greater than 0'),
            backgroundColor: CustomColors.red,
          ),
        );
        return false;
      }
      return true;
    }

    if (sessionViewModel.treatmentDurationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid treatment duration'),
          backgroundColor: CustomColors.red,
        ),
      );
      return false;
    }
    final duration =
        int.tryParse(sessionViewModel.treatmentDurationController.text) ?? 0;
    if (duration <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Treatment duration must be greater than 0'),
          backgroundColor: CustomColors.red,
        ),
      );
      return false;
    }
    return true;
  }

  bool _validatePhaseNotifications(BuildContext context, TreatmentState state) {
    final sessionState = ref.read(sessionViewModelProvider);
    log(
      'NOTIFICATION: ${sessionState.preNotificationEntries.length} ${sessionState.postNotificationEntries.length}',
    );
    for (final entry in [
      ...sessionState.postNotificationEntries,
      ...sessionState.preNotificationEntries,
    ]) {
      if (entry.type.isEmpty ||
          entry.titleController.text.isEmpty ||
          entry.timingUnit.isEmpty ||
          entry.timingValueController.text.isEmpty ||
          entry.messageController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Make sure each notification in both categories are valid!',
            ),
            backgroundColor: CustomColors.red,
          ),
        );
        return false;
      }
    }
    return true;
  }

  bool _validateFollowUps(BuildContext context, SessionState sessionState) {
    for (final session in sessionState.sessions) {
      final count = int.tryParse(session.totalFollowUpsController.text) ?? 0;
      if (count == 0) {
        continue; // 0 or empty follow-ups is completely valid
      }
      for (final followUp in session.followUps) {
        if (followUp.notesController.text.isEmpty ||
            followUp.intervalUnit.isEmpty ||
            followUp.intervalValueController.text.isEmpty ||
            followUp.durationValueController.text.isEmpty ||
            followUp.type.isEmpty ||
            followUp.durationUnit.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ensure that each follow up is valid!'),
              backgroundColor: CustomColors.red,
            ),
          );
          return false;
        }
      }
    }
    return true;
  }
}
