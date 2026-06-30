import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skinsync_admin/models/responses/area_list_response.dart';
import 'package:skinsync_admin/widgets/protocol_preview_widget.dart';

import '../models/notification_entry.dart';
import '../models/notification_model.dart';
import '../models/responses/category_detail_response.dart';
import '../models/responses/treatment_products_response.dart';
import '../models/treatment_data_models.dart';
import '../utils/list_utils.dart';
import '../utils/theme.dart';
import '../utils/validators.dart';
import '../view_models/area_view_model.dart';
import '../view_models/category_view_model.dart';
import '../view_models/product_view_model.dart';
import '../view_models/treatment_data_view_model.dart';
import '../view_models/treatment_view_model.dart';
import '../widgets/app_search_field.dart';
import '../widgets/borderd_container_widget.dart';
import '../widgets/build_textfield.dart';
import '../widgets/custom_dropdown_widget.dart';
import '../widgets/custom_outlined_button.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/dailogbox/standard_dialog.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/app_network_image.dart';
import '../widgets/icon_image_container.dart';
import '../widgets/nested_category_selector.dart';
import 'product_detail_screen.dart';

class CreateTreatmentScreen extends ConsumerStatefulWidget {
  const CreateTreatmentScreen({super.key});

  static const String routeName = '/create-treatment';

  @override
  ConsumerState<CreateTreatmentScreen> createState() =>
      _CreateTreatmentScreenState();
}

class _CreateTreatmentScreenState extends ConsumerState<CreateTreatmentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(categoryViewModelProvider.notifier).fetchCategories();
      ref.read(productViewModelProvider.notifier).fetchProducts();
      await ref.read(areaViewModelProvider.notifier).fetchAreas();
      final fetchedAreas = ref.read(areaViewModelProvider).areas;
      ref
          .read(treatmentDataViewModelProvider.notifier)
          .setAreasFromBackend(fetchedAreas);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(treatmentViewModelProvider);
    final viewModel = ref.read(treatmentViewModelProvider.notifier);
    final dataState = ref.watch(treatmentDataViewModelProvider);
    final categoryState = ref.watch(categoryViewModelProvider);

    final bool isDesktop = context.screenWidth > 1200;
    final bool isTablet =
        context.screenWidth > 800 && context.screenWidth <= 1200;

    return GradientScaffold(
      appBar: AppBar(
        flexibleSpace: AppDecorations.appBarGradient,
        elevation: 0,
        centerTitle: true,
        title: Text('Treatment Builder', style: context.fonts.black18w600),
        leading: IconButton(
          icon: const Icon(Icons.close, color: CustomColors.black),
          onPressed: () {
            viewModel.resetForm();
            context.pop();
          },
        ),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDesktop || isTablet)
            _buildLeftSidebar(context, state, viewModel),
          Expanded(
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
                                borderRadius: context.appBorderRadius(all: 16),
                                border: Border.all(color: CustomColors.border),
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
                              viewModel,
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
            _buildRightSidebar(
              context,
              state,
              viewModel,
              dataState,
              categoryState,
            ),
        ],
      ),
    );
  }

  Widget _buildLeftSidebar(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
  ) {
    final steps = [
      'Categories',
      'Basic Information',
      'Treatment Areas',
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
      'Sessions Setup',
      'Follow-Up Setup',
      'Patient Consent',
      'Business Logic',
    ];

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
                      '${state.currentStep + 1} / ${steps.length}',
                      style: context.fonts.black14w700,
                    ),
                    Text(
                      '${((state.currentStep + 1) / steps.length * 100).toInt()}%',
                      style: context.fonts.purple14w700,
                    ),
                  ],
                ),
                context.verticalSpace(12),
                ClipRRect(
                  borderRadius: context.appBorderRadius(all: 10),
                  child: LinearProgressIndicator(
                    value: (state.currentStep + 1) / steps.length,
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
                final bool isActive = state.currentStep == index;
                final bool isCompleted = state.currentStep > index;

                return InkWell(
                  onTap: index < state.currentStep
                      ? () => viewModel.setStep(index)
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
      'Categorization',
      'Basic Information',
      'Body Areas',
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
      'Sessions Setup',
      'Follow-Up Configuration',
      'Patient Consent Form',
      'Business Logic',
    ];
    final descriptions = [
      'Organize treatments to help patients and staff find them easily.',
      'Core identification details including status.',
      'Define mandatory sub-areas.',
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
      'Manage total sessions and procedural frequency.',
      'Manage rules and scheduling for post-procedure clinical check-ins.',
      'Upload and manage legal procedural consent documentation.',
      'Manage system-wide treatment behaviors and onboarding settings.',
    ];
    final icons = [
      Icons.category_outlined,
      Icons.description_outlined,
      Icons.accessibility_new_outlined,
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
      Icons.event_repeat_rounded,
      Icons.replay_outlined,
      Icons.fact_check_outlined,
      Icons.settings_suggest_outlined,
    ];

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
                icons[state.currentStep],
                color: CustomColors.purple,
                size: 24,
              ),
            ),
            context.horizontalSpace(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titles[state.currentStep],
                    style: context.fonts.black20w600,
                  ),
                  Text(
                    descriptions[state.currentStep],
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

  Widget _buildRightSidebar(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
    TreatmentDataState dataState,
    CategoryState categoryState,
  ) {
    final CategoryDetailDto? selectedCategory = state.selectedCategoryDetail;

    return Container(
      width: context.w(350),
      decoration: BoxDecoration(
        color: CustomColors.whiteGrey.withValues(alpha: 0.5),
        border: const Border(left: BorderSide(color: CustomColors.border)),
      ),
      child: SingleChildScrollView(
        padding: context.appEdgeInsets(all: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Live Preview', style: context.fonts.black16w600),
            context.verticalSpace(20),
            _buildPreviewCard(context, viewModel, state),

            context.verticalSpace(32),
            Text(
              'Treatment Blueprint Summary',
              style: context.fonts.black16w600,
            ),
            context.verticalSpace(16),
            _buildCompleteTreatmentBlueprint(
              context,
              state,
              viewModel,
              dataState,
              selectedCategory,
            ),

            context.verticalSpace(32),
            Text(
              'Clinical Protocol Form Preview',
              style: context.fonts.black16w600,
            ),
            context.verticalSpace(16),
            _buildProtocolFormPreview(
              context,
              state,
              viewModel,
              dataState,
              categoryState,
            ),
            context.verticalSpace(32),
            Text('Patient Journey Preview', style: context.fonts.black16w600),
            context.verticalSpace(20),
            _buildPatientJourneyPreview(
              context,
              state,
              viewModel,
              categoryState,
            ),
            context.verticalSpace(32),
            Text('Configuration Summary', style: context.fonts.black16w600),
            context.verticalSpace(16),
            _buildSummaryChips(context, viewModel, state, dataState),
          ],
        ),
      ),
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
    final baseDuration =
        double.tryParse(viewModel.treatmentDurationController.text) ?? 0.0;
    final productDuration = _calculateProductUsageDuration(state);
    final prepTime = double.tryParse(viewModel.prepTimeController.text) ?? 0.0;
    final cleanupTime =
        double.tryParse(viewModel.cleanupTimeController.text) ?? 0.0;
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
            state.onlineBookable ? 'Yes' : 'No',
          ),
          _blueprintRow(
            context,
            'Manual Approval Required',
            state.manualApprovalRequired ? 'Yes' : 'No',
          ),
          _blueprintRow(
            context,
            'Allow Clinic Override',
            state.allowClinicOverride ? 'Yes' : 'No',
          ),
          _blueprintRow(
            context,
            'Allow Provider Override',
            state.allowProviderOverride ? 'Yes' : 'No',
          ),
          _blueprintRow(
            context,
            'Minimum Booking Notice',
            "${viewModel.minimumBookingNoticeController.text.isEmpty ? '24' : viewModel.minimumBookingNoticeController.text} Hours",
          ),
          _blueprintRow(
            context,
            'Maximum Days in Advance',
            "${viewModel.maximumDaysInAdvanceController.text.isEmpty ? '90' : viewModel.maximumDaysInAdvanceController.text} Days",
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
    final basicOk =
        viewModel.validateGlobalSku(
              viewModel.globalSkuController.text.trim(),
            ) ==
            null &&
        viewModel.categoryIdController.text.isNotEmpty;
    final schedOk =
        viewModel.treatmentDurationController.text.isNotEmpty &&
        (int.tryParse(viewModel.treatmentDurationController.text) ?? 0) > 0;
    final areasOk = state.areas.any((a) => a.areaController.text.isNotEmpty);
    final sessionsOk = state.totalSessions > 0;
    final followUpsOk = state.sessions.any((s) => s.followUps.isNotEmpty);
    final consentOk =
        state.consentType == 'category' ||
        state.preTreatmentConsentForm != null ||
        state.existingConsentForm != null;
    final notifOk =
        state.preNotificationSource == 'category' ||
        state.postNotificationSource == 'category' ||
        state.preNotificationOffset != null ||
        state.postNotificationOffset != null;
    final productsOk = state.productUsageEntries.isNotEmpty;
    final pricingOk = viewModel.basePriceController.text.isNotEmpty;
    final rolesOk =
        state.providerRolesSource == 'category' ||
        state.selectedRoles.isNotEmpty;

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

                final List<String> subNames = areaEntry.subAreas.map((s) {
                  // Find corresponding subarea SKU
                  final subItem = areaItem?.subAreas.firstWhereOrNull(
                    (sa) => sa.name == s.name,
                  );
                  return '${s.name} (${subItem?.globalSku ?? 'N/A'})';
                }).toList();

                return _SelectedSummaryCard(
                  title: areaItem?.name ?? 'N/A',
                  sku: areaItem?.globalSku ?? 'N/A',
                  icon: areaItem?.icon,
                  subLabel: 'Selected Sub-Areas:',
                  items: subNames,
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
    final isCategory = state.sessionSource == 'category';

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
          if (state.sessions.isEmpty)
            Text('No sessions defined', style: context.fonts.grey12w400)
          else
            ...state.sessions.map((session) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Session ${session.sessionNumber} (Total Follow-Ups: ${session.followUps.length})',
                      style: context.fonts.black12w600,
                    ),
                    if (session.followUps.isNotEmpty)
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
    final isCategory = state.consentType == 'category';
    String consentFileName = 'No PDF uploaded';
    if (isCategory) {
      consentFileName =
          selectedCategory?.consentFormName ?? 'Category Consent Form';
    } else {
      consentFileName =
          state.preTreatmentConsentForm?.name ??
          state.existingConsentForm?.name ??
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

  String _getPlatformFileTypeSummary(PlatformFile file) {
    final ext = file.extension?.toLowerCase();
    if (ext == 'pdf') return 'pdf';
    if (['jpg', 'jpeg', 'png', 'webp'].contains(ext)) return 'image';
    if (['mp4', 'mov', 'avi', 'mkv'].contains(ext)) return 'video';
    return 'other';
  }

  Widget _buildPreTreatmentInstructionsSummary(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
  ) {
    final hasInstructions =
        viewModel.preTreatmentInstructionsController.text.isNotEmpty;
    final instructionsText = hasInstructions ? 'Configured' : 'None';

    final allPre = [...state.existingPreAttachments];

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
    final isPreCategory = state.preNotificationSource == 'category';
    final isPostCategory = state.postNotificationSource == 'category';

    String preSummary = 'Not configured';
    if (isPreCategory) {
      preSummary = (selectedCategory?.preNotifications?.isNotEmpty ?? false)
          ? '${selectedCategory?.preNotifications?.length} Category Defaults'
          : 'Category Default';
    } else {
      preSummary =
          '${state.preNotificationEntries.length} Custom Notifications';
    }

    String postSummary = 'Not configured';
    if (isPostCategory) {
      postSummary = (selectedCategory?.postNotifications?.isNotEmpty ?? false)
          ? '${selectedCategory?.postNotifications?.length} Category Defaults'
          : 'Category Default';
    } else {
      postSummary =
          '${state.postNotificationEntries.length} Custom Notifications';
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
    final level = state.downtimeLevel;
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
    final isCategory = state.providerRolesSource == 'category';
    final List<String> roles = isCategory
        ? (selectedCategory?.defaultRoles
                  ?.map((r) => r.name[0] + r.name.substring(1).toLowerCase())
                  .toList() ??
              [])
        : state.selectedRoles;

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
    return _blueprintSection(
      context,
      '3. Products Configuration',
      state.productUsageEntries.isEmpty
          ? Text('No products configured', style: context.fonts.grey12w400)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: state.productUsageEntries.map((entry) {
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
    final basePrice = viewModel.basePriceController.text;

    final uniqueUnits = state.productUsageEntries
        .map((e) => e.unit)
        .where((unit) => unit.trim().isNotEmpty)
        .toSet()
        .toList();

    final configuredUnits = uniqueUnits.where((u) {
      final ctrl = viewModel.getControllerForUnit(u);
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
              final ctrl = viewModel.getControllerForUnit(unit);
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
    final List<String> inherited = [];
    final List<String> overrides = [];

    if (state.sessionSource == 'category') {
      inherited.addAll(['Sessions', 'Follow-Ups']);
    } else {
      overrides.addAll(['Custom Sessions', 'Custom Follow-Ups']);
    }

    if (state.consentType == 'category') {
      inherited.add('Consent Form');
    } else {
      overrides.add('Custom Consent Form');
    }

    if (state.preNotificationSource == 'category' &&
        state.postNotificationSource == 'category') {
      inherited.add('Notifications');
    } else {
      overrides.add('Custom Notifications');
    }

    if (state.providerRolesSource == 'category') {
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
    final CategoryDetailDto? selectedCategory = state.selectedCategoryDetail;

    int totalFus = 0;
    if (state.sessionSource == 'custom') {
      totalFus = state.sessions.fold(0, (sum, s) => sum + s.followUps.length);
    } else if (selectedCategory != null) {
      if (selectedCategory.defaultSessions?.isNotEmpty ?? false) {
        totalFus = selectedCategory.defaultSessions!.fold(
          0,
          (sum, s) => sum + s.followUps.length,
        );
      }
    }

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
            viewModel.preTreatmentInstructionsController.text.isNotEmpty,
          ),
          _previewRow(
            context,
            'Aftercare',
            viewModel.postTreatmentInstructionsController.text.isNotEmpty,
          ),
          _previewRow(
            context,
            'Notifications',
            state.preNotificationOffset != null ||
                state.postNotificationOffset != null,
          ),
          _previewRow(context, 'Sessions Defined', true),
          _previewText(context, '${state.totalSessions} Sessions'),
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
    final selectedProtocols = dataState.protocols
        .where((p) => state.selectedProtocolIds.contains(p.id))
        .toList();
    final checkboxes = selectedProtocols
        .where((p) => p.type == ProtocolType.checkbox)
        .toList();
    final textFields = selectedProtocols
        .where((p) => p.type == ProtocolType.text)
        .toList();

    final CategoryDetailDto? selectedCategory = state.selectedCategoryDetail;

    List<TreatmentProtocolNoteItem> notesToShow = [];
    if (state.standaloneNotes.isNotEmpty) {
      notesToShow = state.standaloneNotes;
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
                              final pNote = state.selectedProtocolNotes
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
                        final pNote = state.selectedProtocolNotes.firstWhere(
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
                      "\$${viewModel.basePriceController.text.isEmpty ? "0" : viewModel.basePriceController.text}",
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
                      '${viewModel.durationHoursController.text}h ${viewModel.durationMinutesController.text}m',
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
    final checkboxCount = dataState.protocols
        .where(
          (p) =>
              p.type == ProtocolType.checkbox &&
              state.selectedProtocolIds.contains(p.id),
        )
        .length;
    final textCount = dataState.protocols
        .where(
          (p) =>
              p.type == ProtocolType.text &&
              state.selectedProtocolIds.contains(p.id),
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
        if (state.preTreatmentConsentForm != null ||
            state.existingConsentForm != null)
          _summaryChip(context, 'Consent Required', Icons.fact_check_outlined),
        if (state.isFollowUpRequired)
          _summaryChip(context, 'Follow-Up Required', Icons.replay_outlined),
        if (state.useInAiSimulator)
          _summaryChip(context, 'AI Compatible', Icons.auto_awesome_outlined),
        if (state.requirePostTreatmentPhotos)
          _summaryChip(
            context,
            '${state.requiredPostTreatmentPhotoCount} Photos Required',
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
    return Container(
      padding: context.appEdgeInsets(horizontal: 24, vertical: 16),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${state.currentStep + 1} of 17',
                style: context.fonts.black14w700,
              ),
              Text(
                '${((state.currentStep + 1) / 17 * 100).toInt()}%',
                style: context.fonts.purple14w700,
              ),
            ],
          ),
          context.verticalSpace(8),
          LinearProgressIndicator(
            value: (state.currentStep + 1) / 17,
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
    switch (state.currentStep) {
      case 0:
        return _buildStepCategory(context, state, viewModel, categoryState);
      case 1:
        return _buildStepDetails(context, state, viewModel);
      case 2:
        return _buildStepAreas(context, state, viewModel, dataState, ref);
      case 3:
        return _buildStepMaterials(context, state, viewModel, dataState, ref);
      case 4:
        return _buildStepScheduling(context, state, viewModel);
      case 5:
        return _buildStepPricing(context, state, viewModel);
      case 6:
        return _buildStepProtocolsStep(
          context,
          state,
          viewModel,
          dataState,
          ref,
        );
      case 7:
        return _buildStepPreInstructions(context, state, viewModel);
      case 8:
        return _buildStepPostInstructions(context, state, viewModel);
      case 9:
        return _buildPostTreatmentPhotosStep(context, state, viewModel);
      case 10:
        return _buildStepNotifications(
          context,
          state,
          viewModel,
          categoryState,
        );
      case 11:
        return _buildStepDowntime(context, state, viewModel, categoryState);
      case 12:
        return _buildStepRoles(context, state, viewModel, categoryState);
      case 13:
        return _buildStepSessions(context, state, viewModel, categoryState);
      case 14:
        return _buildStepFollowUp(context, state, viewModel, dataState);
      case 15:
        return _buildStepConsent(context, state, viewModel, ref);
      case 16:
        return _buildStepLogic(context, state, viewModel);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStepPricing(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
  ) {
    final uniqueUnits = state.productUsageEntries
        .map((e) => e.unit)
        .where((unit) => unit.trim().isNotEmpty)
        .toSet()
        .toList();

    String formatUnitLabel(String unit) {
      if (unit.isEmpty) return '';
      return unit[0].toUpperCase() + unit.substring(1);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Base Pricing'),
        context.verticalSpace(24),
        BuildTextField(
          label: 'Treatment Base Price (\$)',
          controller: viewModel.basePriceController,
          hintText: '100',
          keyboardType: TextInputType.number,
          validator: Validators.empty,
        ),
        if (uniqueUnits.isNotEmpty) ...[
          context.verticalSpace(40),
          _sectionTitle(context, 'Unit-Based Pricing Overrides'),
          context.verticalSpace(8),
          Text(
            'Define dynamic pricing overrides for each unit of measure from the selected inventory products.',
            style: context.fonts.grey14w400,
          ),
          context.verticalSpace(24),
          Container(
            padding: context.appEdgeInsets(all: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: context.appBorderRadius(all: 12),
              border: Border.all(color: CustomColors.border),
            ),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: uniqueUnits.map((unit) {
                final formattedUnit = formatUnitLabel(unit);
                return SizedBox(
                  width: context.w(180),
                  child: BuildTextField(
                    label: 'Price Per $formattedUnit (\$)',
                    controller: viewModel.getControllerForUnit(unit),
                    hintText: '0',
                    keyboardType: TextInputType.number,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStepPreInstructions(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BuildTextField(
          label: 'Pre-Treatment Instructions',
          controller: viewModel.preTreatmentInstructionsController,
          hintText: 'Instructions for the patient before their procedure...',
          maxLines: 8,
        ),
        context.verticalSpace(32),
        _buildUploadedAttachmentsField(
          context,
          state.existingPreAttachments,
          () => viewModel.pickAttachments(true),
          (idx) => viewModel.removeExistingAttachment(true, idx),
        ),
      ],
    );
  }

  Widget _buildStepPostInstructions(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BuildTextField(
          label: 'Post-Treatment Instructions',
          controller: viewModel.postTreatmentInstructionsController,
          hintText: 'Aftercare and recovery guidelines...',
          maxLines: 8,
        ),

        context.verticalSpace(32),

        _buildUploadedAttachmentsField(
          context,
          state.existingPostAttachments,
          () => viewModel.pickAttachments(false),
          (idx) => viewModel.removeExistingAttachment(false, idx),
        ),
      ],
    );
  }

  Widget _buildStepNotifications(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
    CategoryState categoryState,
  ) {
    final CategoryDetailDto? selectedCategory = state.selectedCategoryDetail;

    return StatefulBuilder(
      builder: (context, setState) {
        Widget buildCategoryDefaultPreviews(
          List<NotificationModel> notifications, {
          required bool isPre,
        }) {
          if (notifications.isEmpty) {
            return Container(
              padding: context.appEdgeInsets(all: 16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: CustomColors.whiteGrey,
                borderRadius: context.appBorderRadius(all: 12),
                border: Border.all(color: CustomColors.border),
              ),
              child: Text(
                'No default notifications defined in this category.',
                style: context.fonts.grey14w400,
              ),
            );
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: notifications.length,
            separatorBuilder: (_, _) => context.verticalSpace(12),
            itemBuilder: (context, idx) {
              final config = notifications[idx];
              final typeStr = typeValues.reverse[config.type] ?? 'reminder';
              final typeText =
                  ' [${typeStr[0].toUpperCase()}${typeStr.substring(1)}]';
              final timingUnitStr =
                  unitValues.reverse[config.timingUnit] ?? 'hours';
              return _buildNotificationPreview(
                context,
                title: "${config.title} $typeText (Read-only)",
                message: config.message,
                timing:
                    "${config.timing} $timingUnitStr ${isPre ? 'Before' : 'After'}",
              );
            },
          );
        }

        Widget buildCustomNotificationBuilder(
          List<NotificationEntry> entries,
          bool isPre,
        ) {
          final types = isPre
              ? ['reminder', 'warning', 'instruction']
              : ['recovery', 'care', 'follow-up reminder'];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isPre
                        ? 'Custom Pre Notifications'
                        : 'Custom Post Notifications',
                    style: context.fonts.black14w600,
                  ),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        if (isPre) {
                          viewModel.addPreNotificationEntry();
                        } else {
                          viewModel.addPostNotificationEntry();
                        }
                      });
                    },
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: CustomColors.purple,
                    ),
                    label: const Text('Add Notification'),
                  ),
                ],
              ),
              context.verticalSpace(12),
              if (entries.isEmpty)
                Container(
                  width: double.infinity,
                  padding: context.appEdgeInsets(all: 16),
                  decoration: BoxDecoration(
                    color: CustomColors.whiteGrey,
                    borderRadius: context.appBorderRadius(all: 12),
                    border: Border.all(color: CustomColors.border),
                  ),
                  child: Text(
                    "No custom notifications added. Tap 'Add Notification' to create one.",
                    style: context.fonts.grey13w500,
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: entries.length,
                  separatorBuilder: (_, _) => context.verticalSpace(16),
                  itemBuilder: (context, idx) {
                    final entry = entries[idx];
                    return Container(
                      padding: context.appEdgeInsets(all: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: context.appBorderRadius(all: 12),
                        border: Border.all(color: CustomColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Notification #${idx + 1}',
                                style: context.fonts.purple14w700,
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: CustomColors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (isPre) {
                                      viewModel.removePreNotificationEntry(idx);
                                    } else {
                                      viewModel.removePostNotificationEntry(
                                        idx,
                                      );
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                          context.verticalSpace(12),
                          BuildTextField(
                            label: 'Title',
                            controller: entry.titleController,
                            hintText: 'e.g. Avoid alcohol',
                          ),
                          context.verticalSpace(12),
                          BuildTextField(
                            label: 'Message Content',
                            controller: entry.messageController,
                            hintText: 'Enter notification message...',
                            maxLines: 2,
                          ),
                          context.verticalSpace(12),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: BuildTextField(
                                  label: 'Timing Value',
                                  controller: entry.timingValueController,
                                  hintText: 'e.g. 24',
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              context.horizontalSpace(12),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Timing Unit',
                                      style: context.fonts.black14w600,
                                    ),
                                    context.verticalSpace(8),
                                    DropdownButtonHideUnderline(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: CustomColors.border,
                                          ),
                                        ),
                                        child: DropdownButton<String>(
                                          value: entry.timingUnit,
                                          isExpanded: true,
                                          items: const [
                                            DropdownMenuItem(
                                              value: 'minutes',
                                              child: Text('Minutes'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'hours',
                                              child: Text('Hours'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'days',
                                              child: Text('Days'),
                                            ),
                                          ],
                                          onChanged: (v) {
                                            if (v != null) {
                                              setState(() {
                                                entry.timingUnit = v;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          context.verticalSpace(12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Type (Optional)',
                                style: context.fonts.black14w600,
                              ),
                              context.verticalSpace(8),
                              DropdownButtonHideUnderline(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: CustomColors.border,
                                    ),
                                  ),
                                  child: DropdownButton<String>(
                                    value: entry.type,
                                    isExpanded: true,
                                    items: types
                                        .map(
                                          (t) => DropdownMenuItem(
                                            value: t,
                                            child: Text(
                                              t[0].toUpperCase() +
                                                  t.substring(1),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (v) {
                                      if (v != null) {
                                        setState(() {
                                          entry.type = v;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          );
        }

        return Column(
          children: [
            _expandableSection(
              context,
              title: 'Pre-Treatment Notifications',
              icon: Icons.notifications_none_rounded,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Notification Source', style: context.fonts.black14w600),
                  context.verticalSpace(12),
                  Row(
                    children: [
                      _radioOption(
                        context,
                        'Use Category Default',
                        state.preNotificationSource == 'category',
                        () {
                          setState(() {
                            viewModel.setPreNotificationSource(
                              'category',
                              category: selectedCategory,
                            );
                          });
                        },
                      ),
                      context.horizontalSpace(32),
                      _radioOption(
                        context,
                        'Create Custom',
                        state.preNotificationSource == 'custom',
                        () {
                          setState(() {
                            viewModel.setPreNotificationSource('custom');
                          });
                        },
                      ),
                    ],
                  ),
                  context.verticalSpace(24),
                  if (state.preNotificationSource == 'category') ...[
                    buildCategoryDefaultPreviews(
                      selectedCategory?.preNotifications ?? [],
                      isPre: true,
                    ),
                  ] else ...[
                    buildCustomNotificationBuilder(
                      state.preNotificationEntries,
                      true,
                    ),
                  ],
                ],
              ),
            ),
            context.verticalSpace(24),
            _expandableSection(
              context,
              title: 'Post-Treatment Notifications',
              icon: Icons.notifications_active_outlined,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Notification Source', style: context.fonts.black14w600),
                  context.verticalSpace(12),
                  Row(
                    children: [
                      _radioOption(
                        context,
                        'Use Category Default',
                        state.postNotificationSource == 'category',
                        () {
                          setState(() {
                            viewModel.setPostNotificationSource(
                              'category',
                              category: selectedCategory,
                            );
                          });
                        },
                      ),
                      context.horizontalSpace(32),
                      _radioOption(
                        context,
                        'Create Custom',
                        state.postNotificationSource == 'custom',
                        () {
                          setState(() {
                            viewModel.setPostNotificationSource('custom');
                          });
                        },
                      ),
                    ],
                  ),
                  context.verticalSpace(24),
                  if (state.postNotificationSource == 'category') ...[
                    buildCategoryDefaultPreviews(
                      selectedCategory?.postNotifications ?? [],
                      isPre: false,
                    ),
                  ] else ...[
                    buildCustomNotificationBuilder(
                      state.postNotificationEntries,
                      false,
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNotificationPreview(
    BuildContext context, {
    required String title,
    required String message,
    required String timing,
  }) {
    return Container(
      padding: context.appEdgeInsets(all: 16),
      decoration: BoxDecoration(
        color: CustomColors.whiteGrey,
        borderRadius: context.appBorderRadius(all: 12),
        border: Border.all(color: CustomColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: context.fonts.grey10w700ls1),
              Container(
                padding: context.appEdgeInsets(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: CustomColors.purple.withValues(alpha: 0.1),
                  borderRadius: context.appBorderRadius(all: 4),
                ),
                child: Text(timing, style: context.fonts.purple12w700),
              ),
            ],
          ),
          context.verticalSpace(12),
          Text(message, style: context.fonts.black14w400),
        ],
      ),
    );
  }

  Widget _buildStepDowntime(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
    CategoryState categoryState,
  ) {
    final CategoryDetailDto? selectedCategory = state.selectedCategoryDetail;
    final presets = selectedCategory?.downtimePresets;
    final lowDays = presets?.low ?? 2;
    final moderateDays = presets?.moderate ?? 5;
    final highDays = presets?.high ?? 10;
    final noneDays = presets?.none ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Downtime Level Configuration'),
        context.verticalSpace(8),
        Text(
          'Define how long a patient cannot book other services in the treatment area after this procedure.',
          style: context.fonts.grey14w400,
        ),
        context.verticalSpace(32),

        _downtimeOption(
          context,
          'None',
          '${noneDays} Days',
          'No booking restrictions.',
          state.downtimeLevel == 'None',
          () => viewModel.setDowntimeLevel('None'),
        ),
        context.verticalSpace(16),
        _downtimeOption(
          context,
          'Low',
          '${lowDays} Days',
          'Short recovery window.',
          state.downtimeLevel == 'Low',
          () => viewModel.setDowntimeLevel('Low'),
        ),
        context.verticalSpace(16),
        _downtimeOption(
          context,
          'Moderate',
          '${moderateDays} Days',
          'Standard clinical recovery.',
          state.downtimeLevel == 'Moderate',
          () => viewModel.setDowntimeLevel('Moderate'),
        ),
        context.verticalSpace(16),
        _downtimeOption(
          context,
          'High',
          '${highDays} Days',
          'Extended recovery required.',
          state.downtimeLevel == 'High',
          () => viewModel.setDowntimeLevel('High'),
        ),
      ],
    );
  }

  Widget _downtimeOption(
    BuildContext context,
    String title,
    String duration,
    String desc,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: context.appBorderRadius(all: 12),
      child: Container(
        padding: context.appEdgeInsets(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? CustomColors.purple.withValues(alpha: 0.05)
              : Colors.white,
          borderRadius: context.appBorderRadius(all: 12),
          border: Border.all(
            color: isSelected ? CustomColors.purple : CustomColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: context.w(48),
              height: context.w(48),
              decoration: BoxDecoration(
                color: isSelected
                    ? CustomColors.purple
                    : CustomColors.whiteGrey,
                borderRadius: context.appBorderRadius(all: 10),
              ),
              child: Icon(
                Icons.timer_outlined,
                color: isSelected ? Colors.white : CustomColors.grey,
                size: 24,
              ),
            ),
            context.horizontalSpace(20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.fonts.black16w600),
                  Text(desc, style: context.fonts.grey12w400),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(duration, style: context.fonts.purple14w700),
                if (isSelected) context.verticalSpace(4),
                if (isSelected)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: CustomColors.purple,
                    size: 20,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepRoles(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
    CategoryState categoryState,
  ) {
    final CategoryDetailDto? selectedCategory = state.selectedCategoryDetail;
    final List<String> availableRoles = [
      'Injector',
      'Aesthetician',
      'MD',
      'Nurse',
      'Specialist',
    ];
    final List<String> categoryRoles =
        selectedCategory?.defaultRoles
            ?.map((r) => defaultRoleValues.reverse[r] ?? '')
            .toList() ??
        [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Allowed Provider Roles'),
        context.verticalSpace(8),
        Text(
          'Define which provider roles are authorized to perform this treatment.',
          style: context.fonts.grey14w400,
        ),
        context.verticalSpace(32),

        Row(
          children: [
            _radioOption(
              context,
              'Use Category Defaults',
              state.providerRolesSource == 'category',
              () {
                viewModel.setProviderRolesSource('category');
                viewModel.setRoles(categoryRoles);
              },
            ),
            context.horizontalSpace(32),
            _radioOption(
              context,
              'Define Custom Roles',
              state.providerRolesSource == 'custom',
              () => viewModel.setProviderRolesSource('custom'),
            ),
          ],
        ),

        context.verticalSpace(40),

        if (state.providerRolesSource == 'category') ...[
          Text(
            'Category Roles (Read-only)',
            style: context.fonts.grey10w700ls1,
          ),
          context.verticalSpace(16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: categoryRoles.isEmpty
                ? [
                    Text(
                      'No roles defined in category.',
                      style: context.fonts.grey14w400,
                    ),
                  ]
                : categoryRoles
                      .map((role) => _roleChip(context, role, true, null))
                      .toList(),
          ),
        ] else ...[
          Text('Select Authorized Roles', style: context.fonts.black16w600),
          context.verticalSpace(16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: availableRoles.map((role) {
              final isSelected = state.selectedRoles.contains(role);
              return _roleChip(
                context,
                role,
                isSelected,
                () => viewModel.toggleRole(role),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _roleChip(
    BuildContext context,
    String role,
    bool isSelected,
    VoidCallback? onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: context.appBorderRadius(all: 30),
      child: Container(
        padding: context.appEdgeInsets(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? CustomColors.purple : Colors.white,
          borderRadius: context.appBorderRadius(all: 30),
          border: Border.all(
            color: isSelected ? CustomColors.purple : CustomColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected
                  ? Icons.check_circle_rounded
                  : Icons.add_circle_outline_rounded,
              color: isSelected ? Colors.white : CustomColors.grey,
              size: 18,
            ),
            context.horizontalSpace(8),
            Text(
              role,
              style: isSelected
                  ? context.fonts.white14w600
                  : context.fonts.black14w400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepSessions(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
    CategoryState categoryState,
  ) {
    final CategoryDetailDto? selectedCategory = state.selectedCategoryDetail;
    final int categorySessions = selectedCategory?.totalSessions ?? 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Sessions Configuration'),
        context.verticalSpace(8),
        Text(
          'Define the total number of clinical sessions for this treatment journey.',
          style: context.fonts.grey14w400,
        ),
        context.verticalSpace(32),

        Row(
          children: [
            _radioOption(
              context,
              'Use Category Sessions ($categorySessions)',
              state.sessionSource == 'category',
              () {
                viewModel.setSessionSource(
                  'category',
                  category: selectedCategory,
                );
              },
            ),
            context.horizontalSpace(32),
            _radioOption(
              context,
              'Custom Session Count',
              state.sessionSource == 'custom',
              () => viewModel.setSessionSource('custom'),
            ),
          ],
        ),

        if (state.sessionSource == 'custom') ...[
          context.verticalSpace(32),
          BuildTextField(
            label: 'Total Sessions',
            controller: TextEditingController(
              text: state.totalSessions.toString(),
            ),
            hintText: 'e.g. 3',
            keyboardType: TextInputType.number,
            onChanged: (val) => viewModel.setTotalSessions(val ?? '1'),
          ),
        ],

        context.verticalSpace(40),
        Text('Journey Preview', style: context.fonts.black16w600),
        context.verticalSpace(16),
        Container(
          width: double.infinity,
          padding: context.appEdgeInsets(all: 20),
          decoration: BoxDecoration(
            color: CustomColors.whiteGrey,
            borderRadius: context.appBorderRadius(all: 12),
            border: Border.all(color: CustomColors.border),
          ),
          child: Column(
            children: List.generate(state.totalSessions, (index) {
              return Padding(
                padding: context.appEdgeInsets(
                  bottom: index == state.totalSessions - 1 ? 0 : 12,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: context.appEdgeInsets(all: 8),
                      decoration: const BoxDecoration(
                        color: CustomColors.purple,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${index + 1}',
                        style: context.fonts.white10w700,
                      ),
                    ),
                    context.horizontalSpace(16),
                    Text(
                      'Session ${index + 1}',
                      style: context.fonts.black14w600,
                    ),
                    const Spacer(),
                    Text(
                      'Follow-ups required',
                      style: context.fonts.grey12w400,
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildStepFollowUp(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
    TreatmentDataState dataState,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Configure Follow-Ups per Session',
          style: context.fonts.black18w600,
        ),
        context.verticalSpace(8),
        Text(
          'Each session in the journey can have its own dedicated clinical check-ins.',
          style: context.fonts.grey14w400,
        ),
        context.verticalSpace(32),

        ...state.sessions.asMap().entries.map((sessionEntry) {
          final int sIdx = sessionEntry.key;
          final session = sessionEntry.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: context.appEdgeInsets(all: 20),
                decoration: BoxDecoration(
                  color: CustomColors.purple.withValues(alpha: 0.05),
                  borderRadius: context.appBorderRadius(all: 12),
                  border: Border.all(
                    color: CustomColors.purple.withValues(alpha: 0.1),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.event_note_rounded,
                      color: CustomColors.purple,
                    ),
                    context.horizontalSpace(12),
                    Text(
                      'SESSION ${session.sessionNumber}',
                      style: context.fonts.purple14w700,
                    ),
                    const Spacer(),
                    SizedBox(
                      width: context.w(150),
                      child: BuildTextField(
                        label: 'Follow-Ups',
                        controller: session.totalFollowUpsController,
                        hintText: '0',
                        keyboardType: TextInputType.number,
                        onChanged: (val) => viewModel
                            .updateSessionFollowUpCount(sIdx, val ?? '0'),
                      ),
                    ),
                  ],
                ),
              ),
              if (session.followUps.isNotEmpty) ...[
                context.verticalSpace(20),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: session.followUps.length,
                  separatorBuilder: (_, _) => context.verticalSpace(16),
                  itemBuilder: (context, fuIdx) {
                    return _buildFollowUpEntryCardV2(
                      context,
                      sIdx,
                      fuIdx,
                      session.followUps[fuIdx],
                      viewModel,
                    );
                  },
                ),
              ],
              context.verticalSpace(32),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildFollowUpEntryCardV2(
    BuildContext context,
    int sIdx,
    int fuIdx,
    FollowUpEntry entry,
    TreatmentViewModel viewModel,
  ) {
    return Container(
      padding: context.appEdgeInsets(all: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: context.appBorderRadius(all: 16),
        border: Border.all(color: CustomColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: context.appEdgeInsets(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: CustomColors.purple.withValues(alpha: 0.1),
                  borderRadius: context.appBorderRadius(all: 20),
                ),
                child: Text(
                  'S${sIdx + 1} - Follow-Up ${fuIdx + 1}',
                  style: context.fonts.purple12w700,
                ),
              ),
            ],
          ),
          context.verticalSpace(20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomDropdown<String>(
                  label: 'Appointment Type',
                  hintText: 'Select type',
                  value: entry.type,
                  items: const [
                    DropdownMenuItem(value: 'virtual', child: Text('Virtual')),
                    DropdownMenuItem(
                      value: 'in_person',
                      child: Text('In-Person'),
                    ),
                  ],
                  onChanged: (val) => viewModel.updateSessionFollowUpEntry(
                    sIdx,
                    fuIdx,
                    type: val,
                  ),
                ),
              ),
              context.horizontalSpace(24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Duration', style: context.fonts.black14w600),
                    context.verticalSpace(10),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: entry.durationValueController,
                            keyboardType: TextInputType.number,
                            decoration: AppDecorations.input(
                              context,
                              hint: '30',
                            ),
                            onChanged: (v) => viewModel
                                .updateSessionFollowUpEntry(sIdx, fuIdx),
                          ),
                        ),
                        context.horizontalSpace(12),
                        Expanded(
                          flex: 3,
                          child: DropdownButtonHideUnderline(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: CustomColors.border),
                              ),
                              child: DropdownButton<String>(
                                value: entry.durationUnit,
                                isExpanded: true,
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: CustomColors.grey,
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'minutes',
                                    child: Text('Minutes'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'hours',
                                    child: Text('Hours'),
                                  ),
                                ],
                                onChanged: (val) =>
                                    viewModel.updateSessionFollowUpEntry(
                                      sIdx,
                                      fuIdx,
                                      durationUnit: val,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          context.verticalSpace(20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Scheduling Interval',
                      style: context.fonts.black14w600,
                    ),
                    context.verticalSpace(10),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: entry.intervalValueController,
                            keyboardType: TextInputType.number,
                            decoration: AppDecorations.input(
                              context,
                              hint: '1',
                            ),
                            onChanged: (v) => viewModel
                                .updateSessionFollowUpEntry(sIdx, fuIdx),
                          ),
                        ),
                        context.horizontalSpace(12),
                        Expanded(
                          flex: 3,
                          child: DropdownButtonHideUnderline(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: CustomColors.border),
                              ),
                              child: DropdownButton<String>(
                                value: entry.intervalUnit,
                                isExpanded: true,
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: CustomColors.grey,
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'days',
                                    child: Text('Days After'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'weeks',
                                    child: Text('Weeks After'),
                                  ),
                                ],
                                onChanged: (val) =>
                                    viewModel.updateSessionFollowUpEntry(
                                      sIdx,
                                      fuIdx,
                                      intervalUnit: val,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              context.horizontalSpace(24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Requirements', style: context.fonts.black14w600),
                    context.verticalSpace(10),
                    Container(
                      padding: context.appEdgeInsets(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: context.appBorderRadius(all: 8),
                        border: Border.all(color: CustomColors.border),
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            value: entry.isImageRequired,
                            activeColor: CustomColors.purple,
                            onChanged: (val) =>
                                viewModel.updateSessionFollowUpEntry(
                                  sIdx,
                                  fuIdx,
                                  isImageRequired: val ?? false,
                                ),
                          ),
                          Text(
                            'Image Required',
                            style: context.fonts.black14w600,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          context.verticalSpace(20),
          BuildTextField(
            label: 'Clinical Notes',
            controller: entry.notesController,
            hintText: 'Specific instructions for this follow-up...',
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _radioOption(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: context.appBorderRadius(all: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<bool>(
            value: true,
            groupValue: isSelected,
            onChanged: (_) => onTap(),
            activeColor: CustomColors.purple,
          ),
          Text(label, style: context.fonts.black14w600),
        ],
      ),
    );
  }

  Widget _buildStepConsent(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
    WidgetRef ref,
  ) {
    final CategoryDetailDto? selectedCategory = state.selectedCategoryDetail;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Consent Form Selection', style: context.fonts.black18w600),
        context.verticalSpace(24),
        Row(
          children: [
            _radioOption(
              context,
              'Use Category Default',
              state.consentType == 'category',
              () => viewModel.setConsentType('category'),
            ),
            context.horizontalSpace(32),
            _radioOption(
              context,
              'Upload Custom Form',
              state.consentType == 'custom',
              () => viewModel.setConsentType('custom'),
            ),
          ],
        ),
        context.verticalSpace(32),
        if (state.consentType == 'category') ...[
          Container(
            padding: context.appEdgeInsets(all: 20),
            decoration: BoxDecoration(
              color: CustomColors.whiteGrey,
              borderRadius: context.appBorderRadius(all: 12),
              border: Border.all(color: CustomColors.border),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: CustomColors.purple,
                ),
                context.horizontalSpace(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Default Category Form',
                        style: context.fonts.black14w600,
                      ),
                      context.verticalSpace(4),
                      Text(
                        selectedCategory?.consentFormName ??
                            'No default form found for this category.',
                        style: context.fonts.grey12w400,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          _buildConsentFormSection(
            context,
            state.preTreatmentConsentForm,
            () => viewModel.pickConsentForm(),
            () => viewModel.removeConsentForm(),
          ),
        ],
        context.verticalSpace(24),
        Text(
          'Patients must digitally sign the selected consent form before the procedure begins.',
          style: context.fonts.grey14w400,
        ),
      ],
    );
  }

  // CategoryItem? _findCategoryInTree(List<CategoryItem> items, String id) {
  //   for (var item in items) {
  //     if (item.id == id) return item;
  //     if (item.children.isNotEmpty) {
  //       final found = _findCategoryInTree(item.children, id);
  //       if (found != null) return found;
  //     }
  //   }
  //   return null;
  // }

  // Widget _buildOffsetDropdown(
  //   BuildContext context, {
  //   required String label,
  //   required int? value,
  //   required Map<int, String> options,
  //   required void Function(int?) onChanged,
  // }) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(label, style: context.fonts.black14w600),
  //       context.verticalSpace(10),
  //       Container(
  //         padding: context.appEdgeInsets(horizontal: 16),
  //         decoration: BoxDecoration(
  //           color: CustomColors.whiteGrey,
  //           borderRadius: context.appBorderRadius(all: 12),
  //         ),
  //         child: DropdownButtonHideUnderline(
  //           child: DropdownButton<int>(
  //             value: value,
  //             hint: Text('Select timing', style: context.fonts.grey14w400),
  //             isExpanded: true,
  //             dropdownColor: Colors.white,
  //             borderRadius: context.appBorderRadius(all: 12),
  //             items: options.entries
  //                 .map(
  //                   (e) => DropdownMenuItem<int>(
  //                     value: e.key,
  //                     child: Text(e.value, style: context.fonts.black14w400),
  //                   ),
  //                 )
  //                 .toList(),
  //             onChanged: onChanged,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildStepProtocolsStep(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
    TreatmentDataState dataState,
    WidgetRef ref,
  ) {
    final selectedProtocols = dataState.protocols
        .where((p) => state.selectedProtocolIds.contains(p.id))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildJourneyProtocols(
          context,
          dataState,
          ref,
          state.selectedProtocolIds,
          (id) {
            final pItem = dataState.protocols.firstWhere((p) => p.id == id);
            viewModel.toggleProtocolSelection(
              id,
              protocolName: pItem.title,
              masterProtocols: dataState.protocols,
            );
          },
        ),
        if (selectedProtocols.isNotEmpty) ...[
          context.verticalSpace(32),
          _sectionTitle(context, 'Protocol Notes & Instructions'),
          context.verticalSpace(8),
          Text(
            'Add custom step-by-step notes and clinical guidelines for each selected protocol.',
            style: context.fonts.grey14w400,
          ),
          context.verticalSpace(16),
          ...selectedProtocols.map((protocol) {
            final noteEntry = state.selectedProtocolNotes.firstWhere(
              (n) => n.protocolName == protocol.title,
              orElse: () => TreatmentProtocolNote(
                protocolName: protocol.title,
                notes: [],
              ),
            );
            return ProtocolNotesCard(
              key: ValueKey('note_${protocol.id}_${noteEntry.notes.length}'),
              protocol: protocol,
              initialNotes: noteEntry.notes,
              onNotesChanged: (updatedNotes) {
                viewModel.updateProtocolNotes(protocol.title, updatedNotes);
              },
            );
          }),
        ],
        context.verticalSpace(40),
        _buildStandaloneNotesSection(context, state, viewModel),
      ],
    );
  }

  Widget _buildStandaloneNotesSection(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
  ) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _sectionTitle(context, 'Notes / Instructions'),
              IconButton(
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: CustomColors.purple,
                  size: 24,
                ),
                onPressed: () => _showStandaloneNoteEditDialog(
                  context,
                  null,
                  null,
                  viewModel,
                  state.standaloneNotes,
                ),
              ),
            ],
          ),
          if (state.standaloneNotes.isEmpty) ...[
            context.verticalSpace(16),
            Text(
              'No notes or custom instructions configured yet.',
              style: context.fonts.grey14w400,
            ),
          ] else ...[
            context.verticalSpace(16),
            const Divider(),
            context.verticalSpace(16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.standaloneNotes.length,
              separatorBuilder: (context, index) => const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Divider(),
              ),
              itemBuilder: (context, index) {
                final note = state.standaloneNotes[index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (note.title != null && note.title!.isNotEmpty) ...[
                            Text(note.title!, style: context.fonts.black14w700),
                            context.verticalSpace(4),
                          ],
                          Text(
                            note.description,
                            style: context.fonts.grey14w400,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_upward, size: 16),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: index > 0
                              ? () {
                                  final updated =
                                      List<TreatmentProtocolNoteItem>.from(
                                        state.standaloneNotes,
                                      );
                                  final temp = updated[index];
                                  updated[index] = updated[index - 1];
                                  updated[index - 1] = temp;
                                  viewModel.updateStandaloneNotes(updated);
                                }
                              : null,
                        ),
                        context.horizontalSpace(8),
                        IconButton(
                          icon: const Icon(Icons.arrow_downward, size: 16),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: index < state.standaloneNotes.length - 1
                              ? () {
                                  final updated =
                                      List<TreatmentProtocolNoteItem>.from(
                                        state.standaloneNotes,
                                      );
                                  final temp = updated[index];
                                  updated[index] = updated[index + 1];
                                  updated[index + 1] = temp;
                                  viewModel.updateStandaloneNotes(updated);
                                }
                              : null,
                        ),
                        context.horizontalSpace(12),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => _showStandaloneNoteEditDialog(
                            context,
                            index,
                            note,
                            viewModel,
                            state.standaloneNotes,
                          ),
                        ),
                        context.horizontalSpace(12),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: CustomColors.red,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            final updated =
                                List<TreatmentProtocolNoteItem>.from(
                                  state.standaloneNotes,
                                );
                            updated.removeAt(index);
                            viewModel.updateStandaloneNotes(updated);
                          },
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  void _showStandaloneNoteEditDialog(
    BuildContext context,
    int? editIndex,
    TreatmentProtocolNoteItem? existingNote,
    TreatmentViewModel viewModel,
    List<TreatmentProtocolNoteItem> currentNotes,
  ) {
    final titleController = TextEditingController(text: existingNote?.title);
    final descController = TextEditingController(
      text: existingNote?.description,
    );

    showDialog(
      context: context,
      builder: (context) => StandardDialog(
        title: editIndex == null
            ? 'Add Note / Instruction'
            : 'Edit Note / Instruction',
        width: context.w(450),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            BuildTextField(
              label: 'Title (Optional)',
              controller: titleController,
              hintText: 'e.g. Pre Care Instructions',
            ),
            context.verticalSpace(16),
            BuildTextField(
              label: 'Note / Description',
              controller: descController,
              hintText: 'e.g. Avoid retinol 3 days before treatment',
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          CustomPrimaryButton(
            onTap: () {
              if (descController.text.trim().isNotEmpty) {
                final updated = List<TreatmentProtocolNoteItem>.from(
                  currentNotes,
                );
                final newNote = TreatmentProtocolNoteItem(
                  title: titleController.text.trim().isEmpty
                      ? null
                      : titleController.text.trim(),
                  description: descController.text.trim(),
                  order: editIndex == null
                      ? currentNotes.length + 1
                      : existingNote!.order,
                );

                if (editIndex == null) {
                  updated.add(newNote);
                } else {
                  updated[editIndex] = newNote;
                }

                viewModel.updateStandaloneNotes(updated);
                Navigator.pop(context);
              }
            },
            label: 'Save',
            width: context.w(120),
          ),
        ],
      ),
    );
  }

  Widget _expandableSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget content,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: context.appBorderRadius(all: 12),
        border: Border.all(color: CustomColors.border),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          leading: Container(
            padding: context.appEdgeInsets(all: 8),
            decoration: BoxDecoration(
              color: CustomColors.purple.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: CustomColors.purple, size: 18),
          ),
          title: Text(title, style: context.fonts.black16w600),
          children: [
            const Divider(height: 1),
            Padding(padding: context.appEdgeInsets(all: 24), child: content),
          ],
        ),
      ),
    );
  }

  // Widget _buildJourneySection(
  //   BuildContext context, {
  //   required String title,
  //   required TextEditingController instructionController,
  //   required String instructionLabel,
  //   required TextEditingController notificationTitleController,
  //   required TextEditingController notificationDescController,
  //   required int? selectedOffset,
  //   required Map<int, String> offsetOptions,
  //   required String offsetLabel,
  //   required void Function(int?) onOffsetChanged,
  //   required List<PlatformFile> attachments,
  //   required VoidCallback onPickAttachments,
  //   required void Function(int) onRemoveAttachment,
  //   bool isPreTreatment = false,
  //   bool isPostTreatment = false,
  //   TreatmentDataState? dataState,
  //   WidgetRef? ref,
  //   List<String>? selectedProtocolIds,
  //   void Function(String)? onProtocolToggle,
  //   PlatformFile? consentForm,
  //   VoidCallback? onPickConsent,
  //   VoidCallback? onRemoveConsent,
  //   bool isFollowUpRequired = false,
  //   void Function(bool?)? onFollowUpToggle,
  //   TextEditingController? totalFollowUpsController,
  //   String? followUpType,
  //   void Function(String?)? onFollowUpTypeChanged,
  //   TextEditingController? followUpDurationValueController,
  //   String? followUpDurationUnit,
  //   void Function(String?)? onFollowUpDurationUnitChanged,
  //   TextEditingController? followUpNotesController,
  // }) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Row(
  //         children: [
  //           Container(
  //             width: context.w(4),
  //             height: context.h(24),
  //             decoration: BoxDecoration(
  //               color: CustomColors.purple,
  //               borderRadius: context.appBorderRadius(all: 2),
  //             ),
  //           ),
  //           context.horizontalSpace(12),
  //           Text(title, style: context.fonts.black18w600),
  //         ],
  //       ),
  //       context.verticalSpace(24),
  //       BuildTextField(
  //         label: instructionLabel,
  //         controller: instructionController,
  //         hintText: 'Detailed instructions for the patient...',
  //         maxLines: 5,
  //       ),
  //       context.verticalSpace(32),
  //       if (isPreTreatment && dataState != null && ref != null) ...[
  //         _buildConsentFormSection(
  //           context,
  //           consentForm,
  //           onPickConsent!,
  //           onRemoveConsent!,
  //         ),
  //         context.verticalSpace(32),
  //       ],
  //       _buildAttachmentsField(
  //         context,
  //         attachments,
  //         onPickAttachments,
  //         onRemoveAttachment,
  //       ),
  //       context.verticalSpace(32),
  //       Container(
  //         padding: context.appEdgeInsets(all: 24),
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: context.appBorderRadius(all: 12),
  //           border: Border.all(color: CustomColors.border),
  //           boxShadow: AppShadows.card(context),
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Row(
  //               children: [
  //                 const Icon(
  //                   Icons.auto_awesome_rounded,
  //                   size: 20,
  //                   color: CustomColors.purple,
  //                 ),
  //                 context.horizontalSpace(12),
  //                 Text('Phase Notification', style: context.fonts.black16w600),
  //               ],
  //             ),
  //             context.verticalSpace(20),
  //             BuildTextField(
  //               label: 'Notification Title',
  //               controller: notificationTitleController,
  //               hintText: 'Title seen by patient',
  //             ),
  //             context.verticalSpace(20),
  //             BuildTextField(
  //               label: 'Notification Description',
  //               controller: notificationDescController,
  //               hintText: 'Body of the notification',
  //               maxLines: 3,
  //             ),
  //             context.verticalSpace(20),
  //             Text(offsetLabel, style: context.fonts.black14w600),
  //             context.verticalSpace(10),
  //             Container(
  //               padding: context.appEdgeInsets(horizontal: 16),
  //               decoration: BoxDecoration(
  //                 color: CustomColors.whiteGrey,
  //                 borderRadius: context.appBorderRadius(all: 12),
  //               ),
  //               child: DropdownButtonHideUnderline(
  //                 child: DropdownButton<int>(
  //                   value: selectedOffset,
  //                   hint: Text(
  //                     'Select timing',
  //                     style: context.fonts.grey14w400,
  //                   ),
  //                   isExpanded: true,
  //                   dropdownColor: Colors.white,
  //                   borderRadius: context.appBorderRadius(all: 12),
  //                   items: offsetOptions.entries.map((e) {
  //                     return DropdownMenuItem<int>(
  //                       value: e.key,
  //                       child: Text(e.value, style: context.fonts.black14w400),
  //                     );
  //                   }).toList(),
  //                   onChanged: onOffsetChanged,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       if (isPostTreatment) ...[
  //         context.verticalSpace(32),
  //         _buildFollowUpSection(
  //           context,
  //           isFollowUpRequired: isFollowUpRequired,
  //           onFollowUpToggle: onFollowUpToggle!,
  //           totalFollowUpsController: totalFollowUpsController!,
  //           followUpType: followUpType,
  //           onFollowUpTypeChanged: onFollowUpTypeChanged!,
  //           followUpDurationValueController: followUpDurationValueController!,
  //           followUpDurationUnit: followUpDurationUnit!,
  //           onFollowUpDurationUnitChanged: onFollowUpDurationUnitChanged!,
  //           followUpNotesController: followUpNotesController!,
  //         ),
  //       ],
  //     ],
  //   );
  // }

  Widget _buildFollowUpSection(
    BuildContext context, {
    required bool isFollowUpRequired,
    required void Function(bool?) onFollowUpToggle,
    required TextEditingController totalFollowUpsController,
    required String? followUpType,
    required void Function(String?) onFollowUpTypeChanged,
    required TextEditingController followUpDurationValueController,
    required String followUpDurationUnit,
    required void Function(String?) onFollowUpDurationUnitChanged,
    required TextEditingController followUpNotesController,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: context.w(24),
              height: context.w(24),
              child: Checkbox(
                value: isFollowUpRequired,
                onChanged: onFollowUpToggle,
                shape: RoundedRectangleBorder(
                  borderRadius: context.appBorderRadius(all: 4),
                ),
              ),
            ),
            context.horizontalSpace(12),
            Text('Is Follow-Up Required?', style: context.fonts.black16w600),
          ],
        ),
        if (isFollowUpRequired) ...[
          context.verticalSpace(24),
          Container(
            padding: context.appEdgeInsets(all: 24),
            decoration: BoxDecoration(
              color: CustomColors.whiteGrey,
              borderRadius: context.appBorderRadius(all: 12),
              border: Border.all(color: CustomColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Follow-Up Configuration',
                  style: context.fonts.black16w600,
                ),
                context.verticalSpace(20),
                Row(
                  children: [
                    Expanded(
                      child: BuildTextField(
                        label: 'Total Follow-Ups',
                        controller: totalFollowUpsController,
                        hintText: 'e.g. 1',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    context.horizontalSpace(24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Appointment Type',
                            style: context.fonts.black14w600,
                          ),
                          context.verticalSpace(10),
                          Container(
                            padding: context.appEdgeInsets(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: context.appBorderRadius(all: 12),
                              border: Border.all(color: CustomColors.border),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: followUpType,
                                hint: Text(
                                  'Select type',
                                  style: context.fonts.grey14w400,
                                ),
                                isExpanded: true,
                                dropdownColor: Colors.white,
                                borderRadius: context.appBorderRadius(all: 12),
                                items: [
                                  DropdownMenuItem(
                                    value: 'virtual',
                                    child: Text(
                                      'Virtual',
                                      style: context.fonts.black14w400,
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'in_person',
                                    child: Text(
                                      'In-Person',
                                      style: context.fonts.black14w400,
                                    ),
                                  ),
                                ],
                                onChanged: onFollowUpTypeChanged,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                context.verticalSpace(20),
                Text('Follow-Up Duration', style: context.fonts.black14w600),
                context.verticalSpace(10),
                Row(
                  children: [
                    Expanded(
                      child: BuildTextField(
                        label: 'Value',
                        controller: followUpDurationValueController,
                        hintText: 'e.g. 30',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    context.horizontalSpace(24),
                    Expanded(
                      child: Container(
                        margin: context.appEdgeInsets(top: 24),
                        padding: context.appEdgeInsets(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: context.appBorderRadius(all: 12),
                          border: Border.all(color: CustomColors.border),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: followUpDurationUnit,
                            isExpanded: true,
                            dropdownColor: Colors.white,
                            borderRadius: context.appBorderRadius(all: 12),
                            items: [
                              DropdownMenuItem(
                                value: 'minutes',
                                child: Text(
                                  'Minutes',
                                  style: context.fonts.black14w400,
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'hours',
                                child: Text(
                                  'Hours',
                                  style: context.fonts.black14w400,
                                ),
                              ),
                            ],
                            onChanged: onFollowUpDurationUnitChanged,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                context.verticalSpace(20),
                BuildTextField(
                  label: 'Follow-Up Notes',
                  controller: followUpNotesController,
                  hintText: 'Additional clinical instructions...',
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildConsentFormSection(
    BuildContext context,
    PlatformFile? file,
    VoidCallback onPick,
    VoidCallback onRemove,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Patient Consent Form (PDF)', style: context.fonts.black14w600),
        context.verticalSpace(12),
        if (file == null)
          InkWell(
            onTap: onPick,
            child: Container(
              width: double.infinity,
              padding: context.appEdgeInsets(vertical: 24),
              decoration: BoxDecoration(
                color: CustomColors.whiteGrey,
                borderRadius: context.appBorderRadius(all: 12),
                border: Border.all(
                  color: CustomColors.border,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.description_outlined,
                    color: CustomColors.purple,
                    size: 28,
                  ),
                  context.verticalSpace(8),
                  Text(
                    'Upload Treatment Consent Form',
                    style: context.fonts.purple14w600,
                  ),
                  context.verticalSpace(4),
                  Text(
                    'Patients must sign this before procedure',
                    style: context.fonts.grey12w400,
                  ),
                ],
              ),
            ),
          )
        else
          Container(
            padding: context.appEdgeInsets(all: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: context.appBorderRadius(all: 12),
              border: Border.all(
                color: CustomColors.purple.withValues(alpha: 0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: CustomColors.purple.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: context.appEdgeInsets(all: 10),
                  decoration: BoxDecoration(
                    color: CustomColors.red.withValues(alpha: 0.1),
                    borderRadius: context.appBorderRadius(all: 8),
                  ),
                  child: const Icon(
                    Icons.picture_as_pdf_rounded,
                    color: CustomColors.red,
                    size: 24,
                  ),
                ),
                context.horizontalSpace(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        file.name,
                        style: context.fonts.black14w600,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${(file.size / 1024).toStringAsFixed(1)} KB',
                        style: context.fonts.grey12w400,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: CustomColors.red,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildUploadedAttachmentsField(
    BuildContext context,
    List<Attachment> files,
    VoidCallback onPick,
    void Function(int) onRemove,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Supporting Media (Optional)',
              style: context.fonts.black14w600,
            ),
            TextButton.icon(
              onPressed: onPick,
              icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
              label: const Text('Add Files'),
              style: TextButton.styleFrom(foregroundColor: CustomColors.purple),
            ),
          ],
        ),
        context.verticalSpace(12),
        if (files.isEmpty)
          InkWell(
            onTap: onPick,
            child: Container(
              width: double.infinity,
              padding: context.appEdgeInsets(vertical: 20),
              decoration: BoxDecoration(
                color: CustomColors.whiteGrey,
                borderRadius: context.appBorderRadius(all: 12),
                border: Border.all(
                  color: CustomColors.border,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.cloud_upload_outlined,
                    color: CustomColors.grey,
                    size: 24,
                  ),
                  context.verticalSpace(8),
                  Text(
                    'Upload PDFs, Images, or Videos',
                    style: context.fonts.grey13w500,
                  ),
                ],
              ),
            ),
          )
        else
          Wrap(
            spacing: context.w(12),
            runSpacing: context.h(12),
            children: List.generate(files.length, (index) {
              final file = files[index];
              return Container(
                width: context.w(160),
                padding: context.appEdgeInsets(all: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: context.appBorderRadius(all: 10),
                  border: Border.all(color: CustomColors.border),
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: context.h(80),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: CustomColors.whiteGrey,
                            borderRadius: context.appBorderRadius(all: 6),
                          ),
                          child: _buildUploadedAttachmentPreview(context, file),
                        ),
                        Positioned(
                          top: 2,
                          right: 2,
                          child: InkWell(
                            onTap: () => onRemove(index),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                size: 14,
                                color: CustomColors.red,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    context.verticalSpace(8),
                    Text(
                      file.name,
                      style: context.fonts.grey10w400,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }),
          ),
      ],
    );
  }

  Widget _buildUploadedAttachmentPreview(
    BuildContext context,
    Attachment file,
  ) {
    if (file.type == 'image') {
      return AppNetworkImage(
        imageUrl: file.url,
        borderRadius: context.appBorderRadius(all: 6),
        fit: BoxFit.cover,
      );
    }
    if (file.type == 'pdf') {
      return const Icon(
        Icons.picture_as_pdf_rounded,
        color: CustomColors.red,
        size: 32,
      );
    }
    if (file.type == 'video') {
      return const Icon(
        Icons.video_collection_rounded,
        color: CustomColors.purple,
        size: 32,
      );
    }
    return const Icon(
      Icons.insert_drive_file_outlined,
      color: CustomColors.grey,
      size: 32,
    );
  }

  Widget _buildAttachmentsField(
    BuildContext context,
    List<PlatformFile> files,
    VoidCallback onPick,
    void Function(int) onRemove,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Supporting Media (Optional)',
              style: context.fonts.black14w600,
            ),
            TextButton.icon(
              onPressed: onPick,
              icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
              label: const Text('Add Files'),
              style: TextButton.styleFrom(foregroundColor: CustomColors.purple),
            ),
          ],
        ),
        context.verticalSpace(12),
        if (files.isEmpty)
          InkWell(
            onTap: onPick,
            child: Container(
              width: double.infinity,
              padding: context.appEdgeInsets(vertical: 20),
              decoration: BoxDecoration(
                color: CustomColors.whiteGrey,
                borderRadius: context.appBorderRadius(all: 12),
                border: Border.all(
                  color: CustomColors.border,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.cloud_upload_outlined,
                    color: CustomColors.grey,
                    size: 24,
                  ),
                  context.verticalSpace(8),
                  Text(
                    'Upload PDFs, Images, or Videos',
                    style: context.fonts.grey13w500,
                  ),
                ],
              ),
            ),
          )
        else
          Wrap(
            spacing: context.w(12),
            runSpacing: context.h(12),
            children: List.generate(files.length, (index) {
              final file = files[index];
              return Container(
                width: context.w(160),
                padding: context.appEdgeInsets(all: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: context.appBorderRadius(all: 10),
                  border: Border.all(color: CustomColors.border),
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: context.h(80),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: CustomColors.whiteGrey,
                            borderRadius: context.appBorderRadius(all: 6),
                          ),
                          child: _buildFilePreview(context, file),
                        ),
                        Positioned(
                          top: 2,
                          right: 2,
                          child: InkWell(
                            onTap: () => onRemove(index),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                size: 14,
                                color: CustomColors.red,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    context.verticalSpace(8),
                    Text(
                      file.name,
                      style: context.fonts.grey10w400,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }),
          ),
      ],
    );
  }

  Widget _buildFilePreview(BuildContext context, PlatformFile file) {
    final ext = file.extension?.toLowerCase();
    if (['jpg', 'jpeg', 'png', 'webp'].contains(ext)) {
      return ClipRRect(
        borderRadius: context.appBorderRadius(all: 6),
        child: kIsWeb
            ? AppNetworkImage(imageUrl: file.path!, fit: BoxFit.cover)
            : Image.file(File(file.path!), fit: BoxFit.cover),
      );
    } else if (ext == 'pdf') {
      return const Icon(
        Icons.picture_as_pdf_rounded,
        color: CustomColors.red,
        size: 32,
      );
    } else if (['mp4', 'mov', 'avi'].contains(ext)) {
      return const Icon(
        Icons.video_collection_rounded,
        color: CustomColors.purple,
        size: 32,
      );
    }
    return const Icon(
      Icons.insert_drive_file_outlined,
      color: CustomColors.grey,
      size: 32,
    );
  }

  Widget _buildStepDetails(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Basic Information'),
        context.verticalSpace(24),
        Row(
          children: [
            Expanded(
              child: BuildTextField(
                label: 'Global SKU (Treatment Identifier)',
                controller: viewModel.globalSkuController,
                hintText: 'e.g. TRT-XXXX-XXXX',
                validator: (val) => viewModel.validateGlobalSku(val),
                tooltip:
                    'Global SKU is a unique identifier used across all clinics and systems.',
                suffixIcon: TextButton(
                  onPressed: () => viewModel.generateSku(),
                  child: Text(
                    'Generate SKU',
                    style: context.fonts.purple12w700,
                  ),
                ),
              ),
            ),
            context.horizontalSpace(24),
            Expanded(
              child: BuildTextField(
                label: 'Patient Display Name',
                controller: viewModel.displayNameController,
                hintText: 'e.g. Wrinkle Relaxer',
                validator: Validators.empty,
              ),
            ),
          ],
        ),
        context.verticalSpace(32),
        _sectionTitle(context, 'Visuals'),
        context.verticalSpace(24),
        Row(
          children: [
            Expanded(
              child: _buildImageUploadTile(
                context,
                'Treatment Banner Image',
                state.treatmentImageUrl,
                () => viewModel.pickImage(false),
              ),
            ),
            context.horizontalSpace(24),
            Expanded(
              child: _buildImageUploadTile(
                context,
                'Treatment Listing Icon',
                state.treatmentIconUrl,
                () => viewModel.pickImage(true),
              ),
            ),
          ],
        ),
        context.verticalSpace(32),
        _sectionTitle(context, 'Descriptions'),
        context.verticalSpace(24),
        BuildTextField(
          label: 'Short Description',
          controller: viewModel.shortDescriptionController,
          hintText: 'Brief summary for listing...',
          maxLines: 2,
        ),
        context.verticalSpace(24),
        BuildTextField(
          label: 'Full Description',
          controller: viewModel.fullDescriptionController,
          hintText: 'Detailed medical and process information...',
          maxLines: 5,
        ),
      ],
    );
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

  double _getProductMaxQuantity(
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
        sum += double.tryParse(controllers.maxController.text) ?? 0.0;
      }
      return sum;
    } else {
      return double.tryParse(entry.maxQuantityController.text) ?? 0.0;
    }
  }

  double _calculateProductUsageDuration(TreatmentState state) {
    final allSubAreas = state.areas.expand((a) => a.subAreas).toList();
    double total = 0.0;
    for (final entry in state.productUsageEntries) {
      final minQty = _getProductMinQuantity(entry, allSubAreas);
      final perUnit =
          double.tryParse(entry.perUnitDurationController.text) ?? 0.0;
      total += minQty * perUnit;
    }
    return total;
  }

  String _formatUnitLabel(String unit) {
    if (unit.isEmpty) return 'Unit';
    return unit[0].toUpperCase() + unit.substring(1);
  }

  Widget _buildStepScheduling(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Base Duration'),
        context.verticalSpace(24),
        Row(
          children: [
            Expanded(
              child: BuildTextField(
                label: 'Base Duration (Minutes)',
                controller: viewModel.treatmentDurationController,
                hintText: 'e.g. 60',
                keyboardType: TextInputType.number,
                validator: Validators.empty,
                onChanged: (val) {
                  // Trigger state refresh for live updates
                  viewModel.updateProductPerUnitDuration(0, '');
                },
              ),
            ),
          ],
        ),
        context.verticalSpace(32),
        _sectionTitle(context, 'Product Usage Duration'),
        context.verticalSpace(16),
        if (state.productUsageEntries.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'No products selected in the Inventory Products step.',
              style: context.fonts.grey14w400,
            ),
          )
        else
          ...state.productUsageEntries.asMap().entries.map((item) {
            final idx = item.key;
            final entry = item.value;
            final allSubAreas = state.areas.expand((a) => a.subAreas).toList();
            final minQty = _getProductMinQuantity(entry, allSubAreas);
            final maxQty = _getProductMaxQuantity(entry, allSubAreas);

            return Container(
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
                  Text(entry.productName, style: context.fonts.black14w700),
                  context.verticalSpace(8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Unit of Measure: ${entry.unit}',
                        style: context.fonts.grey13w500,
                      ),
                      Text(
                        'Min Qty: ${minQty.toStringAsFixed(minQty % 1 == 0 ? 0 : 1)} | Max Qty: ${maxQty.toStringAsFixed(maxQty % 1 == 0 ? 0 : 1)}',
                        style: context.fonts.grey13w500,
                      ),
                    ],
                  ),
                  context.verticalSpace(12),
                  BuildTextField(
                    label:
                        'Per ${_formatUnitLabel(entry.unit)} Duration (minutes)',
                    controller: entry.perUnitDurationController,
                    hintText: '0.0',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onChanged: (val) {
                      viewModel.updateProductPerUnitDuration(idx, val ?? '');
                    },
                  ),
                ],
              ),
            );
          }),
        context.verticalSpace(32),
        Row(
          children: [
            Expanded(
              child: BuildTextField(
                label: 'Preparation Time (Minutes)',
                controller: viewModel.prepTimeController,
                hintText: 'e.g. 10',
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  // Trigger state refresh for live updates
                  viewModel.updateProductPerUnitDuration(0, '');
                },
              ),
            ),
            context.horizontalSpace(24),
            Expanded(
              child: BuildTextField(
                label: 'Finish / Cleanup Time (Minutes)',
                controller: viewModel.cleanupTimeController,
                hintText: 'e.g. 5',
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  // Trigger state refresh for live updates
                  viewModel.updateProductPerUnitDuration(0, '');
                },
              ),
            ),
          ],
        ),
        context.verticalSpace(32),
        _sectionTitle(context, 'Total Duration'),
        context.verticalSpace(16),
        Builder(
          builder: (context) {
            final baseDuration =
                double.tryParse(viewModel.treatmentDurationController.text) ??
                0.0;
            final productDuration = _calculateProductUsageDuration(state);
            final prepTime =
                double.tryParse(viewModel.prepTimeController.text) ?? 0.0;
            final cleanupTime =
                double.tryParse(viewModel.cleanupTimeController.text) ?? 0.0;
            final totalDuration =
                baseDuration + productDuration + prepTime + cleanupTime;

            return Container(
              padding: context.appEdgeInsets(all: 16),
              decoration: BoxDecoration(
                color: CustomColors.purple.withValues(alpha: 0.05),
                borderRadius: context.appBorderRadius(all: 10),
                border: Border.all(
                  color: CustomColors.purple.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Base Duration:', style: context.fonts.black14w600),
                      Text(
                        '${baseDuration.toStringAsFixed(baseDuration % 1 == 0 ? 0 : 1)} Minutes',
                        style: context.fonts.black14w600,
                      ),
                    ],
                  ),
                  context.verticalSpace(8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Product Usage Duration:',
                        style: context.fonts.black14w400,
                      ),
                      Text(
                        '${productDuration.toStringAsFixed(productDuration % 1 == 0 ? 0 : 1)} Minutes',
                        style: context.fonts.purple14w700,
                      ),
                    ],
                  ),
                  context.verticalSpace(8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Preparation Time:',
                        style: context.fonts.black14w400,
                      ),
                      Text(
                        '${prepTime.toStringAsFixed(prepTime % 1 == 0 ? 0 : 1)} Minutes',
                        style: context.fonts.black14w600,
                      ),
                    ],
                  ),
                  context.verticalSpace(8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Cleanup Time:', style: context.fonts.black14w400),
                      Text(
                        '${cleanupTime.toStringAsFixed(cleanupTime % 1 == 0 ? 0 : 1)} Minutes',
                        style: context.fonts.black14w600,
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Divider(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Calculated Total Duration:',
                        style: context.fonts.purple14w700,
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
          },
        ),
        context.verticalSpace(32),
        _sectionTitle(context, 'Override & Booking Controls'),
        context.verticalSpace(24),
        Row(
          children: [
            SizedBox(
              width: context.w(24),
              height: context.w(24),
              child: Checkbox(
                value: state.allowClinicOverride,
                onChanged: (val) => viewModel.toggleAllowClinicOverride(val),
                activeColor: CustomColors.purple,
              ),
            ),
            context.horizontalSpace(12),
            Text(
              'Allow Clinic Duration Override',
              style: context.fonts.black14w600,
            ),
          ],
        ),
        context.verticalSpace(16),
        Row(
          children: [
            SizedBox(
              width: context.w(24),
              height: context.w(24),
              child: Checkbox(
                value: state.allowProviderOverride,
                onChanged: (val) => viewModel.toggleAllowProviderOverride(val),
                activeColor: CustomColors.purple,
              ),
            ),
            context.horizontalSpace(12),
            Text(
              'Allow Provider Duration Override',
              style: context.fonts.black14w600,
            ),
          ],
        ),
        context.verticalSpace(16),
        Row(
          children: [
            SizedBox(
              width: context.w(24),
              height: context.w(24),
              child: Checkbox(
                value: state.onlineBookable,
                onChanged: (val) => viewModel.toggleOnlineBookable(val),
                activeColor: CustomColors.purple,
              ),
            ),
            context.horizontalSpace(12),
            Text('Online Bookable', style: context.fonts.black14w600),
          ],
        ),
        context.verticalSpace(16),
        Row(
          children: [
            SizedBox(
              width: context.w(24),
              height: context.w(24),
              child: Checkbox(
                value: state.manualApprovalRequired,
                onChanged: (val) => viewModel.toggleManualApprovalRequired(val),
                activeColor: CustomColors.purple,
              ),
            ),
            context.horizontalSpace(12),
            Text('Manual Approval Required', style: context.fonts.black14w600),
          ],
        ),
        context.verticalSpace(32),
        _sectionTitle(context, 'Booking Advance Notice Rules'),
        context.verticalSpace(24),
        Row(
          children: [
            Expanded(
              child: BuildTextField(
                label: 'Minimum Booking Notice (Hours)',
                controller: viewModel.minimumBookingNoticeController,
                hintText: 'e.g. 24',
                keyboardType: TextInputType.number,
              ),
            ),
            context.horizontalSpace(24),
            Expanded(
              child: BuildTextField(
                label: 'Maximum Days in Advance',
                controller: viewModel.maximumDaysInAdvanceController,
                hintText: 'e.g. 90',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStepCategory(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
    CategoryState categoryState,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Categorization'),
        context.verticalSpace(8),
        Text(
          'Organize treatments to help patients find them easily. Select or create categories at any level.',
          style: context.fonts.grey14w400,
        ),
        context.verticalSpace(32),
        NestedCategorySelector(
          categories: categoryState.categories,
          initialCategoryId: viewModel.categoryIdController.text,
          onSelected: (cat, path) => viewModel.onCategorySelected(cat, path),
        ),
        context.verticalSpace(32),
        if (viewModel.categoryPathController.text.isNotEmpty)
          Container(
            padding: context.appEdgeInsets(all: 16),
            decoration: BoxDecoration(
              color: CustomColors.purple.withValues(alpha: 0.05),
              borderRadius: context.appBorderRadius(all: 12),
              border: Border.all(
                color: CustomColors.purple.withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline_rounded,
                  color: CustomColors.purple,
                  size: 20,
                ),
                context.horizontalSpace(12),
                Expanded(
                  child: Text(
                    'Selected Path: ${viewModel.categoryPathController.text}',
                    style: context.fonts.black14w600.copyWith(
                      color: CustomColors.purple,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildProtocolGroup(
    BuildContext context, {
    required String title,
    required List<ProtocolItem> protocols,
    required List<String> selectedIds,
    required void Function(String) onToggle,
    required VoidCallback onAdd,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: context.fonts.black16w600),
            IconButton(
              onPressed: onAdd,
              icon: const Icon(
                Icons.add_circle_outline_rounded,
                color: CustomColors.purple,
                size: 24,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        context.verticalSpace(16),
        if (protocols.isEmpty)
          Container(
            width: double.infinity,
            padding: context.appEdgeInsets(all: 20),
            decoration: BoxDecoration(
              color: CustomColors.whiteGrey,
              borderRadius: context.appBorderRadius(all: 12),
              border: Border.all(color: CustomColors.border),
            ),
            child: Text(
              'No protocols in this group.',
              style: context.fonts.grey13w500,
            ),
          )
        else
          Wrap(
            spacing: context.w(12),
            runSpacing: context.h(12),
            children: protocols.map((protocol) {
              final isSelected = selectedIds.contains(protocol.id);
              return InkWell(
                onTap: () => onToggle(protocol.id),
                borderRadius: context.appBorderRadius(all: 10),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: context.appEdgeInsets(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? CustomColors.purple.withValues(alpha: 0.08)
                        : Colors.white,
                    borderRadius: context.appBorderRadius(all: 10),
                    border: Border.all(
                      color: isSelected
                          ? CustomColors.purple
                          : CustomColors.border,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected
                            ? Icons.check_circle_rounded
                            : Icons.circle_outlined,
                        size: 18,
                        color: isSelected
                            ? CustomColors.purple
                            : CustomColors.grey,
                      ),
                      context.horizontalSpace(10),
                      Text(
                        protocol.title,
                        style: isSelected
                            ? context.fonts.purple14w600
                            : context.fonts.black14w400,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  void _showAddProtocolDialog(
    BuildContext context,
    WidgetRef ref,
    ProtocolType type,
  ) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => StandardDialog(
        title:
            "Add ${type == ProtocolType.checkbox ? 'Checkbox' : 'Text'} Protocol",
        width: context.w(450),
        content: BuildTextField(
          label: 'Protocol Title',
          controller: controller,
          hintText:
              "e.g. ${type == ProtocolType.checkbox ? 'Cleanse treatment area' : 'Pre-Treatment Instructions'}",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          CustomPrimaryButton(
            onTap: () {
              if (controller.text.isNotEmpty) {
                ref
                    .read(treatmentDataViewModelProvider.notifier)
                    .addProtocol(controller.text.trim(), type);
                Navigator.pop(context);
              }
            },
            label: 'Save Protocol',
            width: context.w(150),
          ),
        ],
      ),
    );
  }

  void _handleAreaToggle(
    AreaModel area,
    TreatmentState state,
    TreatmentViewModel viewModel,
  ) {
    final cleanAreas = state.areas
        .where((a) => a.areaController.text.isNotEmpty)
        .toList();
    final index = cleanAreas.indexWhere(
      (a) => a.areaController.text == area.name,
    );
    if (index == -1) {
      final newEntry = AreaViewModelEntry();
      newEntry.areaController.text = area.name;
      viewModel.updateAreas([...cleanAreas, newEntry]);
    } else {
      final updated = [...cleanAreas];
      updated[index].dispose();
      updated.removeAt(index);
      viewModel.updateAreas(updated.isEmpty ? [AreaViewModelEntry()] : updated);
    }
  }

  void _handleSubAreaToggle(
    AreaModel area,
    AreaModel subArea,
    TreatmentState state,
    TreatmentViewModel viewModel,
  ) {
    final cleanAreas = state.areas
        .where((a) => a.areaController.text.isNotEmpty)
        .toList();
    final index = cleanAreas.indexWhere(
      (a) => a.areaController.text == area.name,
    );
    if (index == -1) {
      final newEntry = AreaViewModelEntry();
      newEntry.areaController.text = area.name;
      newEntry.subAreas = [SubAreaConfig(name: subArea.name, id: subArea.id)];
      viewModel.updateAreas([...cleanAreas, newEntry]);
    } else {
      final areaEntry = cleanAreas[index];
      final subIndex = areaEntry.subAreas.indexWhere(
        (s) => s.name == subArea.name,
      );
      if (subIndex == -1) {
        areaEntry.subAreas = [
          ...areaEntry.subAreas,
          SubAreaConfig(name: subArea.name, id: subArea.id),
        ];
      } else {
        areaEntry.subAreas = areaEntry.subAreas
            .where((s) => s.name != subArea.name)
            .toList();
      }
      viewModel.updateAreas(cleanAreas);
    }
  }

  void _handleSubAreaChildToggle(
    AreaModel area,
    AreaModel subArea,
    AreaModel child,
    TreatmentState state,
    TreatmentViewModel viewModel,
  ) {
    final cleanAreas = state.areas
        .where((a) => a.areaController.text.isNotEmpty)
        .toList();
    final index = cleanAreas.indexWhere(
      (a) => a.areaController.text == area.name,
    );
    if (index == -1) {
      final newEntry = AreaViewModelEntry();
      newEntry.areaController.text = area.name;
      newEntry.subAreas = [
        SubAreaConfig(
          name: subArea.name,
          id: subArea.id,
          children: [SubAreaChildConfig(name: child.name)],
        ),
      ];
      viewModel.updateAreas([...cleanAreas, newEntry]);
    } else {
      final areaEntry = cleanAreas[index];
      final subIndex = areaEntry.subAreas.indexWhere(
        (s) => s.name == subArea.name,
      );
      if (subIndex == -1) {
        areaEntry.subAreas = [
          ...areaEntry.subAreas,
          SubAreaConfig(
            name: subArea.name,
            id: subArea.id,
            children: [SubAreaChildConfig(name: child.name)],
          ),
        ];
      } else {
        final subConfig = areaEntry.subAreas[subIndex];
        final childIndex = subConfig.children.indexWhere(
          (c) => c.name == child.name,
        );
        if (childIndex == -1) {
          subConfig.children = [
            ...subConfig.children,
            SubAreaChildConfig(name: child.name),
          ];
        } else {
          subConfig.children = subConfig.children
              .where((c) => c.name != child.name)
              .toList();
        }
      }
      viewModel.updateAreas(cleanAreas);
    }
  }

  Widget _buildStepAreas(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
    TreatmentDataState dataState,
    WidgetRef ref,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Body Areas Selection'),
        context.verticalSpace(8),
        Text(
          'Select body areas and sub-areas for this treatment journey.',
          style: context.fonts.grey14w400,
        ),
        context.verticalSpace(32),
        NestedAreaSelector(
          areas: dataState.areas,
          selectedAreas: state.areas,
          onAreaToggle: (AreaModel area) =>
              _handleAreaToggle(area, state, viewModel),
          onSubAreaToggle: (AreaModel area, AreaModel subArea) =>
              _handleSubAreaToggle(area, subArea, state, viewModel),
          onSubAreaChildToggle:
              (AreaModel area, AreaModel subArea, AreaModel child) =>
                  _handleSubAreaChildToggle(
                    area,
                    subArea,
                    child,
                    state,
                    viewModel,
                  ),
          onAddArea: (String name, String sku, String icon) async {
            await ref
                .read(treatmentDataViewModelProvider.notifier)
                .addArea(name, sku: sku, icon: icon);
          },
          onAddSubArea: ref
              .read(treatmentDataViewModelProvider.notifier)
              .addSubArea,
          onAddSubAreaChild: (parentArea, parentSubArea, name, sku, icon) {
            ref
                .read(treatmentDataViewModelProvider.notifier)
                .addSubAreaChild(
                  parentArea,
                  parentSubArea,
                  name,
                  sku: sku,
                  icon: icon,
                );
          },
        ),
      ],
    );
  }

  Widget _buildStepLogic(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Onboarding Behavior'),
        context.verticalSpace(24),
        Row(
          children: [
            SizedBox(
              width: context.w(24),
              height: context.w(24),
              child: Checkbox(
                value: state.enableByDefault,
                onChanged: (val) => viewModel.toggleEnableByDefault(val),
                shape: RoundedRectangleBorder(
                  borderRadius: context.appBorderRadius(all: 4),
                ),
              ),
            ),
            context.horizontalSpace(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enable by Default for New Clinics',
                    style: context.fonts.black16w400,
                  ),
                  Text(
                    'Newly onboarded clinics will have this treatment assigned automatically.',
                    style: context.fonts.grey12w400,
                  ),
                ],
              ),
            ),
          ],
        ),
        context.verticalSpace(40),
        const Divider(),
        context.verticalSpace(32),
        _sectionTitle(context, 'AI Simulator Compatibility'),
        context.verticalSpace(16),
        Row(
          children: [
            SizedBox(
              width: context.w(24),
              height: context.w(24),
              child: Checkbox(
                value: state.useInAiSimulator,
                onChanged: (val) => viewModel.toggleAiSimulator(val),
                shape: RoundedRectangleBorder(
                  borderRadius: context.appBorderRadius(all: 4),
                ),
              ),
            ),
            context.horizontalSpace(12),
            Text('Use in AI Simulator', style: context.fonts.black16w400),
          ],
        ),
      ],
    );
  }

  Widget _buildStepMaterials(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
    TreatmentDataState dataState,
    WidgetRef ref,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Inventory Products'),
        context.verticalSpace(8),
        Text(
          'Select specific products from inventory and define clinical usage rules.',
          style: context.fonts.grey14w400,
        ),
        context.verticalSpace(32),
        if (state.isLoadingProducts) ...[
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: CircularProgressIndicator(color: CustomColors.purple),
            ),
          ),
        ] else if (state.error != null) ...[
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Column(
                children: [
                  Text(
                    'Error loading products: ${state.error}',
                    style: context.fonts.grey14w400,
                  ),
                  context.verticalSpace(12),
                  TextButton(
                    onPressed: () =>
                        viewModel.fetchProductsByTreatmentCategory(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ] else if (state.products.isEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Text(
              'No inventory products available for selected category hierarchy.',
              style: context.fonts.grey14w400,
            ),
          ),
        ] else ...[
          _buildProductSelector(context, state.products, viewModel, state),
        ],
        if (state.productUsageEntries.isNotEmpty) ...[
          context.verticalSpace(32),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.productUsageEntries.length,
            separatorBuilder: (_, _) => context.verticalSpace(24),
            itemBuilder: (context, index) {
              return _buildProductUsageCard(
                context,
                index,
                state.productUsageEntries[index],
                viewModel,
                state,
              );
            },
          ),
        ],
      ],
    );
  }

  Widget _buildProductSelector(
    BuildContext context,
    List<TreatmentProductData> products,
    TreatmentViewModel viewModel,
    TreatmentState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Product from Inventory', style: context.fonts.black14w600),
        context.verticalSpace(10),
        SearchAnchor(
          viewHintText: 'Search inventory...',
          builder: (context, controller) => AppSearchField(
            controller: controller,
            readOnly: true,
            onTap: () => controller.openView(),
            hintText: 'Select product from inventory',
            suffixIcon: const Icon(
              Icons.search_rounded,
              color: CustomColors.lightGrey,
            ),
            maxWidth: double.infinity,
          ),
          suggestionsBuilder: (context, controller) {
            final query = controller.text.toLowerCase();
            final filtered = products
                .where((p) => p.name.toLowerCase().contains(query))
                .toList();

            return filtered
                .map(
                  (p) => ListTile(
                    title: Text(p.name, style: context.fonts.black14w600),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        context.verticalSpace(4),
                        Text(
                          '${p.brand ?? "—"} • ${p.globalSku ?? "—"}',
                          style: context.fonts.grey12w400,
                        ),
                        context.verticalSpace(2),
                        Text(
                          'Usage: ${p.usageType ?? "—"}',
                          style: context.fonts.grey11w400,
                        ),
                      ],
                    ),
                    onTap: () {
                      viewModel.addProductUsage(p.id, p.name, 'Unit');
                      controller.closeView(p.name);
                    },
                  ),
                )
                .toList();
          },
        ),
      ],
    );
  }

  Widget _buildProductUsageCard(
    BuildContext context,
    int index,
    ProductUsageEntry entry,
    TreatmentViewModel viewModel,
    TreatmentState state,
  ) {
    final allSubAreas = state.areas.expand((a) => a.subAreas).toList();

    String formatUnitPlural(String unit) {
      if (unit.isEmpty) return 'Units';
      final lower = unit.toLowerCase();
      if (lower == 'unit' || lower == 'u') return 'Units';
      if (lower.contains('unit (u)')) return 'Units (U)';
      if (lower == 'syringe') return 'Syringes';
      if (lower == 'vial') return 'Vials';
      if (lower == 'bottle') return 'Bottles';
      if (lower == 'tube') return 'Tubes';
      if (lower == 'kit') return 'Kits';
      if (lower == 'pack') return 'Packs';
      if (lower == 'piece') return 'Pieces';
      if (lower.endsWith('s')) return unit;
      return '${unit}s';
    }

    final TreatmentProductData? productData =
        state.products.any((p) => p.id == entry.productId)
        ? state.products.firstWhere((p) => p.id == entry.productId)
        : null;

    final String cleanStatus = (productData?.status ?? 'active').toLowerCase();
    Color badgeColor = CustomColors.green;
    String statusLabel = 'Active';

    if (cleanStatus == 'draft') {
      badgeColor = CustomColors.amber;
      statusLabel = 'Draft';
    } else if (cleanStatus == 'deactive' || cleanStatus == 'inactive') {
      badgeColor = CustomColors.grey;
      statusLabel = 'Inactive';
    }

    final imageUrl = productData?.image;
    final hasValidImage = imageUrl != null && imageUrl.isNotEmpty;

    return Container(
      padding: context.appEdgeInsets(all: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: context.appBorderRadius(all: 12),
        border: Border.all(color: CustomColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              AppNetworkImage(
                imageUrl: hasValidImage ? imageUrl : '',
                width: 64,
                height: 64,
                borderRadius: BorderRadius.circular(8),
                fit: BoxFit.cover,
                errorIcon: Icons.broken_image,
                errorIconSize: 24,
              ),
              context.horizontalSpace(16),
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            entry.productName,
                            style: context.fonts.black14w700,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        context.horizontalSpace(8),
                        IconButton(
                          tooltip: 'View Product Details',
                          icon: const Icon(
                            Icons.visibility_outlined,
                            color: CustomColors.purple,
                            size: 18,
                          ),
                          onPressed: () async {
                            try {
                              await ref
                                  .read(productViewModelProvider.notifier)
                                  .fetchProductDetail(entry.productId);
                              if (context.mounted) {
                                context.push(ProductDetailScreen.routeName);
                              }
                            } catch (e) {
                              // Handled gracefully inside view model
                            }
                          },
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                    context.verticalSpace(4),
                    Text(
                      'Brand: ${productData?.brand ?? "—"} • Manufacturer: ${productData?.manufacturer ?? "—"}',
                      style: context.fonts.grey12w400,
                    ),
                    context.verticalSpace(4),
                    Text(
                      'SKU: ${productData?.globalSku ?? "—"}',
                      style: context.fonts.grey12w400,
                    ),
                    context.verticalSpace(4),
                    Row(
                      children: [
                        Text(
                          'Usage Type: ${productData?.usageType ?? "—"}',
                          style: context.fonts.grey12w400,
                        ),
                        context.horizontalSpace(12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: badgeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: badgeColor.withOpacity(0.2),
                            ),
                          ),
                          child: Text(
                            statusLabel,
                            style: context.fonts.grey10w700ls1.copyWith(
                              color: badgeColor,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => viewModel.removeProductUsage(entry.productId),
                icon: const Icon(
                  Icons.delete_outline,
                  color: CustomColors.red,
                  size: 20,
                ),
              ),
            ],
          ),
          context.verticalSpace(20),
          CustomDropdown<String>(
            label: 'Deduction Timing',
            hintText: 'Select',
            value: entry.deductionTiming,
            items: const [
              DropdownMenuItem(
                value: 'On_Completion',
                child: Text('On Completion'),
              ),
              DropdownMenuItem(value: 'Manual', child: Text('Manual')),
              DropdownMenuItem(
                value: 'Post_Confirmation',
                child: Text('Post Confirmation'),
              ),
            ],
            onChanged: (val) =>
                viewModel.updateProductUsageEntry(index, deductionTiming: val),
          ),
          context.verticalSpace(20),
          Row(
            children: [
              SizedBox(
                width: context.w(24),
                height: context.w(24),
                child: Checkbox(
                  value: entry.allowSubstitution,
                  onChanged: (val) => viewModel.updateProductUsageEntry(
                    index,
                    allowSubstitution: val,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: context.appBorderRadius(all: 4),
                  ),
                ),
              ),
              context.horizontalSpace(12),
              Text(
                'Allow Product Substitution',
                style: context.fonts.black14w600,
              ),
            ],
          ),
          context.verticalSpace(20),
          BuildTextField(
            label: 'Usage Notes (Optional)',
            controller: entry.notesController,
            hintText: 'Clinical instructions or restrictions...',
            maxLines: 2,
          ),
          if (allSubAreas.isNotEmpty) ...[
            context.verticalSpace(24),
            const Divider(),
            context.verticalSpace(16),
            Text(
              'Sub-Area Consumption Ranges',
              style: context.fonts.black14w600,
            ),
            context.verticalSpace(4),
            Text(
              'Define clinical product ranges for each configured sub-area.',
              style: context.fonts.grey12w400,
            ),
            context.verticalSpace(16),
            ...allSubAreas.map((subArea) {
              final controllers = entry.getControllersForSubArea(
                subArea.name,
                subAreaId: subArea.id,
              );
              final pluralUnit = formatUnitPlural(entry.unit);
              return Padding(
                padding: context.appEdgeInsets(bottom: 16),
                child: Container(
                  padding: context.appEdgeInsets(all: 16),
                  decoration: BoxDecoration(
                    color: CustomColors.whiteGrey,
                    borderRadius: context.appBorderRadius(all: 10),
                    border: Border.all(color: CustomColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.subdirectory_arrow_right,
                            size: 16,
                            color: CustomColors.purple,
                          ),
                          context.horizontalSpace(8),
                          Text(subArea.name, style: context.fonts.black14w600),
                        ],
                      ),
                      context.verticalSpace(12),
                      Row(
                        children: [
                          Expanded(
                            child: BuildTextField(
                              label: 'Min $pluralUnit',
                              controller: controllers.minController,
                              hintText: '1',
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              onChanged: (val) {
                                viewModel.updateProductPerUnitDuration(
                                  index,
                                  '',
                                );
                              },
                            ),
                          ),
                          context.horizontalSpace(16),
                          Expanded(
                            child: BuildTextField(
                              label: 'Max $pluralUnit',
                              controller: controllers.maxController,
                              hintText: '1',
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              onChanged: (val) {
                                viewModel.updateProductPerUnitDuration(
                                  index,
                                  '',
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Builder(
                        builder: (context) {
                          final minVal =
                              double.tryParse(controllers.minController.text) ??
                              0.0;
                          final maxVal =
                              double.tryParse(controllers.maxController.text) ??
                              0.0;
                          if (minVal < 1 || maxVal < 1) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Quantity must be greater than or equal to 1.',
                                style: TextStyle(
                                  color: CustomColors.red,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }
                          if (maxVal < minVal) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Maximum Quantity must be greater than or equal to Minimum Quantity.',
                                style: TextStyle(
                                  color: CustomColors.red,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),
          ] else ...[
            context.verticalSpace(24),
            const Divider(),
            context.verticalSpace(16),
            Text('Product Consumption Range', style: context.fonts.black14w600),
            context.verticalSpace(16),
            Row(
              children: [
                Expanded(
                  child: BuildTextField(
                    label: 'Min ${formatUnitPlural(entry.unit)}',
                    controller: entry.minQuantityController,
                    hintText: '1',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onChanged: (val) {
                      viewModel.updateProductPerUnitDuration(index, '');
                    },
                  ),
                ),
                context.horizontalSpace(16),
                Expanded(
                  child: BuildTextField(
                    label: 'Max ${formatUnitPlural(entry.unit)}',
                    controller: entry.maxQuantityController,
                    hintText: '1',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onChanged: (val) {
                      viewModel.updateProductPerUnitDuration(index, '');
                    },
                  ),
                ),
              ],
            ),
            Builder(
              builder: (context) {
                final minVal =
                    double.tryParse(entry.minQuantityController.text) ?? 0.0;
                final maxVal =
                    double.tryParse(entry.maxQuantityController.text) ?? 0.0;
                if (minVal < 1 || maxVal < 1) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Quantity must be greater than or equal to 1.',
                      style: TextStyle(color: CustomColors.red, fontSize: 12),
                    ),
                  );
                }
                if (maxVal < minVal) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Maximum Quantity must be greater than or equal to Minimum Quantity.',
                      style: TextStyle(color: CustomColors.red, fontSize: 12),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSubAreaMaterialConfig(
    BuildContext context,
    SubAreaConfig subArea,
  ) {
    return Container(
      padding: context.appEdgeInsets(all: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: context.appBorderRadius(all: 12),
        border: Border.all(color: CustomColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.subdirectory_arrow_right,
                size: 18,
                color: CustomColors.black,
              ),
              context.horizontalSpace(8),
              Text(subArea.name, style: context.fonts.black14w600),
            ],
          ),
          context.verticalSpace(20),
          Row(
            children: [
              Expanded(
                child: BuildTextField(
                  label: 'Base Price (\$)',
                  controller: subArea.basePriceController,
                  hintText: '0',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageUploadTile(
    BuildContext context,
    String label,
    String? imageUrl,
    VoidCallback onTap,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.fonts.black14w600),
        context.verticalSpace(10),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: context.h(160),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: context.appBorderRadius(all: 16),
              border: Border.all(color: CustomColors.border, width: 2),
              image: imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imageUrl == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: context.appEdgeInsets(all: 12),
                        decoration: const BoxDecoration(
                          color: CustomColors.whiteGrey,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add_a_photo_outlined,
                          color: CustomColors.black,
                        ),
                      ),
                      context.verticalSpace(12),
                      Text('Tap to upload', style: context.fonts.grey13w500),
                    ],
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(BuildContext context, String title, {double? fontSize}) {
    return Text(
      title,
      style: context.fonts.black18w600.copyWith(
        fontSize: fontSize != null ? context.sp(fontSize) : null,
      ),
    );
  }

  Widget _buildJourneyProtocols(
    BuildContext context,
    TreatmentDataState dataState,
    WidgetRef ref,
    List<String> selectedIds,
    void Function(String) onToggle,
  ) {
    final checkboxProtocols = dataState.protocols
        .where((p) => p.type == ProtocolType.checkbox)
        .toList();
    final textProtocols = dataState.protocols
        .where((p) => p.type == ProtocolType.text)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProtocolGroup(
          context,
          title: 'Checkboxes',
          protocols: checkboxProtocols,
          selectedIds: selectedIds,
          onToggle: onToggle,
          onAdd: () =>
              _showAddProtocolDialog(context, ref, ProtocolType.checkbox),
        ),
        context.verticalSpace(24),
        _buildProtocolGroup(
          context,
          title: 'Text Fields',
          protocols: textProtocols,
          selectedIds: selectedIds,
          onToggle: onToggle,
          onAdd: () => _showAddProtocolDialog(context, ref, ProtocolType.text),
        ),
      ],
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
    TreatmentDataState dataState,
    CategoryState categoryState,
  ) {
    final bool isLastStep = state.currentStep == 16;
    return Row(
      children: [
        if (state.currentStep > 0) ...[
          Expanded(
            child: CustomOutlinedButton(
              onTap: () => viewModel.setStep(state.currentStep - 1),
              label: 'Previous Step',
            ),
          ),
          context.horizontalSpace(16),
        ],
        Expanded(
          flex: 2,
          child: CustomPrimaryButton(
            onTap: () async {
              log('CURRENT STEP: ${state.currentStep}');
              if (state.currentStep == 0) {
                if (!await _validateAndFetchCategory(
                  context,
                  state,
                  viewModel,
                  categoryState,
                )) {
                  return;
                }
              }
              if (state.currentStep == 1) {
                if (!_validateStepDetails(context, viewModel)) return;
              }
              if (state.currentStep == 2) {
                if (!_validateSubAreas(context, state)) return;
              }
              if (state.currentStep == 3) {
                if (!_validateProductQuantities(context, state)) return;
              }
              if (state.currentStep == 4) {
                if (!_validateScheduling(context, viewModel)) return;
              }
              if (state.currentStep == 9) {
                if (!_validatePostPhotos(context, state)) return;
              }
              if (state.currentStep == 10) {
                if (!_validatePhaseNotifications(context, state)) {
                  return;
                }
              }
              if (state.currentStep == 14) {
                if (!_validateFollowUps(context, state)) {
                  return;
                }
              }

              if (state.currentStep <= 16) {
                if (state.currentStep == 0) {
                  viewModel.setStep(state.currentStep + 1);
                } else if (state.currentStep == 1) {
                  final success = await viewModel.createBasicInfo(
                    stepNumber: state.currentStep + 1,
                  );
                  if (success ?? false) {
                    viewModel.setStep(state.currentStep + 1);
                  }
                } else if (state.currentStep == 2) {
                  final success = await viewModel.createTreatmentArea(
                  );
                  if (success ?? false) {
                    viewModel.setStep(state.currentStep + 1);
                  }
                } else if (state.currentStep == 3) {
                  final success = await viewModel.callProductUsage(
                  );
                  if (success ?? false) {
                    viewModel.setStep(state.currentStep + 1);
                  }
                } else if (state.currentStep == 4) {
                  final success = await viewModel.createSchedule(
                    stepNumber: state.currentStep + 1,
                  );
                  if (success ?? false) {
                    viewModel.setStep(state.currentStep + 1);
                  }
                } else if (state.currentStep == 5) {
                  final success = await viewModel.callStepPricing(
                    stepNumber: state.currentStep + 1,
                  );
                  if (success ?? false) {
                    viewModel.setStep(state.currentStep + 1);
                  }
                } else if (state.currentStep == 6) {
                  final bytes = await ProtocolFormPreview.getPdfBytes(
                    state: state,
                    dataState: dataState,
                    categoryState: categoryState,
                  );

                  final success = await viewModel.callProtocol(
                    bytes: bytes,
                    stepNumber: state.currentStep + 1,
                  );
                  if (success ?? false) {
                    viewModel.setStep(state.currentStep + 1);
                  }
                } else if (state.currentStep == 7) {
                  final success = await viewModel.callPreTreatmentInstructions(
                  );
                  if (success ?? false) {
                    viewModel.setStep(state.currentStep + 1);
                  }
                } else if (state.currentStep == 8) {
                  final success = await viewModel.callPostTreatmentInstructions(
                  );
                  if (success ?? false) {
                    viewModel.setStep(state.currentStep + 1);
                  }
                } else if (state.currentStep == 9) {
                  final success = await viewModel.callPostTreatmentPhotos();
                  if (success ?? false) {
                    viewModel.setStep(10);
                  }
                } else if (state.currentStep == 10) {
                  final success = await viewModel.callPhaseNotifications();
                  if (success ?? false) {
                    viewModel.setStep(11);
                  }
                } else if (state.currentStep == 11) {
                  final success = await viewModel.callDownTimeLevels(
                  );
                  if (success ?? false) {
                    viewModel.setStep(12);
                  }
                } else if (state.currentStep == 12) {
                  final success = await viewModel.callAllowedProviderRoles(
                  );
                  if (success ?? false) {
                    viewModel.setStep(state.currentStep + 1);
                  }
                } else if (state.currentStep == 13) {
                  final success = await viewModel.callSessionsSetup();
                  if (success ?? false) {
                    viewModel.setStep(14);
                  }
                } else if (state.currentStep == 14) {
                  final success = await viewModel.callFollowUpConfig();
                  if (success ?? false) {
                    viewModel.setStep(15);
                  }
                } else if (state.currentStep == 15) {
                  final success = await viewModel.callConsentFormSelection(
                  );
                  if (success ?? false) {
                    viewModel.setStep(16);
                  }
                } else if (state.currentStep == 16) {
                  final success = await viewModel.callBusinessLogic();
                  if (success ?? false) {
                    //viewModel.setStep(17);
                    viewModel
                    .submitTreatment(
                      context,
                      categories: categoryState.categories,
                    )
                    .then((_) {
                      if (context.mounted) context.pop();
                    });
                  }
                }
                // // TODO : this is only for now to go on forward step have to remove once stepper API are completed
                // else {
                //   viewModel.setStep(state.currentStep + 1);
                // }
              } else {
                viewModel
                    .submitTreatment(
                      context,
                      categories: categoryState.categories,
                    )
                    .then((_) {
                      if (context.mounted) context.pop();
                    });
              }
            },
            label: isLastStep ? 'Finish & Create Treatment' : 'Next Step',
          ),
        ),
      ],
    );
  }

  Future<bool> _validateAndFetchCategory(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
    CategoryState categoryState,
  ) async {
    final categoryIdStr = viewModel.categoryIdController.text;
    if (categoryIdStr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category.'),
          backgroundColor: CustomColors.red,
        ),
      );
      return false;
    }

    final categoryId = int.tryParse(categoryIdStr);
    if (categoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category.'),
          backgroundColor: CustomColors.red,
        ),
      );
      return false;
    }

    CategoryModel? findCategory(List<CategoryModel> list, int id) {
      for (final cat in list) {
        if (cat.id == id) return cat;
        final nested = findCategory(cat.subCategories, id);
        if (nested != null) return nested;
      }
      return null;
    }

    final selectedNode = findCategory(categoryState.categories, categoryId);
    if (selectedNode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category.'),
          backgroundColor: CustomColors.red,
        ),
      );
      return false;
    }

    if (selectedNode.subCategories.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a subcategory.'),
          backgroundColor: CustomColors.red,
        ),
      );
      return false;
    }

    try {
      final success = await viewModel.fetchAndPopulateCategoryDefaults(
        categoryId,
      );
      if (!success) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Unable to load category configuration. Please try again.',
              ),
              backgroundColor: CustomColors.red,
            ),
          );
        }
        return false;
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Unable to load category configuration. Please try again.',
            ),
            backgroundColor: CustomColors.red,
          ),
        );
      }
      return false;
    }

    return true;
  }

  bool _validatePostPhotos(BuildContext context, TreatmentState state) {
    if (state.requirePostTreatmentPhotos) {
      if (state.requiredPostTreatmentPhotoCount <= 0) {
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
    final allSubAreas = state.areas.expand((a) => a.subAreas).toList();
    for (final entry in state.productUsageEntries) {
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

  bool _validateStepDetails(
    BuildContext context,
    TreatmentViewModel viewModel,
  ) {
    final skuError = viewModel.validateGlobalSku(
      viewModel.globalSkuController.text.trim(),
    );
    if (skuError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(skuError), backgroundColor: CustomColors.red),
      );
      return false;
    }
    if (viewModel.displayNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter Patient Display Name'),
          backgroundColor: CustomColors.red,
        ),
      );
      return false;
    }
    return true;
  }

  bool _validateScheduling(BuildContext context, TreatmentViewModel viewModel) {
    if (viewModel.treatmentDurationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid treatment duration'),
          backgroundColor: CustomColors.red,
        ),
      );
      return false;
    }
    final duration =
        int.tryParse(viewModel.treatmentDurationController.text) ?? 0;
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

  bool _validateSubAreas(BuildContext context, TreatmentState state) {
    for (final area in state.areas) {
      if (area.subAreas.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Please select at least one sub-area for '${area.areaController.text}'",
            ),
            backgroundColor: CustomColors.red,
          ),
        );
        return false;
      }
    }
    return true;
  }

  bool _validatePhaseNotifications(BuildContext context, TreatmentState state) {
    log(
      'NOTIFICATION: ${state.preNotificationEntries.length} ${state.postNotificationEntries.length}',
    );
    if (state.preNotificationEntries.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Should have at least one notification in Pre-Notifications',
          ),
          backgroundColor: CustomColors.red,
        ),
      );
      return false;
    } else if (state.postNotificationEntries.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Should have at least one notification in Post-Notifications',
          ),
          backgroundColor: CustomColors.red,
        ),
      );
      return false;
    }
    for (final entry in [
      ...state.postNotificationEntries,
      ...state.preNotificationEntries,
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

  bool _validateFollowUps(BuildContext context, TreatmentState state) {
    for (final session in state.sessions) {
      if (session.totalFollowUpsController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Total Follow Up number is required!'),
            backgroundColor: CustomColors.red,
          ),
        );
        return false;
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

  Widget _buildPostTreatmentPhotosStep(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Require Post Treatment Photos',
                    style: context.fonts.black16w600,
                  ),
                  Text(
                    state.requirePostTreatmentPhotos
                        ? 'Provider must capture photos to complete treatment.'
                        : 'Post treatment photos are optional for this treatment.',
                    style: context.fonts.grey12w400,
                  ),
                ],
              ),
            ),
            Switch.adaptive(
              value: state.requirePostTreatmentPhotos,
              activeColor: CustomColors.purple,
              onChanged: (val) =>
                  viewModel.toggleRequirePostTreatmentPhotos(val),
            ),
          ],
        ),
        if (state.requirePostTreatmentPhotos) ...[
          context.verticalSpace(32),
          const Divider(),
          context.verticalSpace(32),
          Text('Required Number of Photos', style: context.fonts.black16w600),
          context.verticalSpace(8),
          Text(
            'Specify how many photos the provider is expected to upload.',
            style: context.fonts.grey12w400,
          ),
          context.verticalSpace(20),
          Row(
            children: [
              _counterButton(
                icon: Icons.remove,
                onTap: () {
                  final current =
                      int.tryParse(
                        viewModel.postTreatmentPhotoCountController.text,
                      ) ??
                      0;
                  if (current > 1) {
                    final newVal = (current - 1).toString();
                    viewModel.postTreatmentPhotoCountController.text = newVal;
                    viewModel.updateRequiredPostTreatmentPhotoCount(newVal);
                  }
                },
              ),
              Container(
                width: context.w(100),
                margin: context.appEdgeInsets(horizontal: 16),
                child: BuildTextField(
                  label: '',
                  controller: viewModel.postTreatmentPhotoCountController,
                  hintText: '0',
                  keyboardType: TextInputType.number,
                  onChanged: (val) => viewModel
                      .updateRequiredPostTreatmentPhotoCount(val ?? '0'),
                ),
              ),
              _counterButton(
                icon: Icons.add,
                onTap: () {
                  final current =
                      int.tryParse(
                        viewModel.postTreatmentPhotoCountController.text,
                      ) ??
                      0;
                  final newVal = (current + 1).toString();
                  viewModel.postTreatmentPhotoCountController.text = newVal;
                  viewModel.updateRequiredPostTreatmentPhotoCount(newVal);
                },
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _counterButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: CustomColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: CustomColors.purple),
      ),
    );
  }
}

typedef SubAreaSetter =
    void Function({
      required int parentAreaId,
      required String parentAreaName,
      required String name,
      String? sku,
      String? icon,
    });

class NestedAreaSelector extends ConsumerStatefulWidget {
  final List<AreaModel> areas;
  final List<AreaViewModelEntry> selectedAreas;
  final void Function(AreaModel area) onAreaToggle;
  final void Function(AreaModel area, AreaModel subArea) onSubAreaToggle;
  final void Function(AreaModel area, AreaModel subArea, AreaModel child)
  onSubAreaChildToggle;

  // Creation callbacks
  final void Function(String name, String sku, String icon) onAddArea;
  final SubAreaSetter onAddSubArea;
  final void Function(
    String parentArea,
    String parentSubArea,
    String name,
    String sku,
    String? icon,
  )
  onAddSubAreaChild;

  const NestedAreaSelector({
    super.key,
    required this.areas,
    required this.selectedAreas,
    required this.onAreaToggle,
    required this.onSubAreaToggle,
    required this.onSubAreaChildToggle,
    required this.onAddArea,
    required this.onAddSubArea,
    required this.onAddSubAreaChild,
  });

  @override
  ConsumerState<NestedAreaSelector> createState() => _NestedAreaSelectorState();
}

class _NestedAreaSelectorState extends ConsumerState<NestedAreaSelector> {
  String? _focusedAreaName;
  String? _focusedSubAreaName;

  @override
  void initState() {
    super.initState();
    if (widget.areas.isNotEmpty) {
      _focusedAreaName = widget.areas.first.name;
    }
  }

  void _showAddNodeDialog({
    required BuildContext context,
    required String title,
    required void Function(String name, String sku, String iconPath) onAdd,
  }) {
    final nameController = TextEditingController();
    final skuController = TextEditingController();
    String? pickedIconPath;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return StandardDialog(
              title: title,
              width: context.w(450),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BuildTextField(
                    label: 'Name',
                    controller: nameController,
                    hintText: 'e.g. Left Forehead',
                  ),
                  context.verticalSpace(16),
                  BuildTextField(
                    label: 'Global SKU',
                    controller: skuController,
                    hintText: 'e.g. FORE-1111',
                    tooltip:
                        'Must follow pattern AAAA-1234 (4 letters, hyphen, 4 digits) and be unique.',
                  ),
                  context.verticalSpace(16),
                  Text('Icon', style: context.fonts.black14w600),
                  context.verticalSpace(8),
                  Row(
                    children: [
                      AppNetworkImage(
                        imageUrl: pickedIconPath ?? '',
                        width: 48,
                        height: 48,
                        borderRadius: BorderRadius.circular(8),
                        fit: BoxFit.cover,
                        errorIcon: Icons.image_outlined,
                      ),
                      context.horizontalSpace(12),
                      CustomOutlinedButton(
                        onTap: () async {
                          final picker = ImagePicker();
                          final file = await picker.pickImage(
                            source: ImageSource.gallery,
                          );
                          if (file != null) {
                            setDialogState(() {
                              pickedIconPath = file.path;
                            });
                          }
                        },
                        label: 'Upload Icon',
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                CustomOutlinedButton(
                  onTap: () => Navigator.pop(context),
                  label: 'Cancel',
                ),
                context.horizontalSpace(12),
                CustomPrimaryButton(
                  onTap: () async {
                    final name = nameController.text.trim();
                    final sku = skuController.text.trim().toUpperCase();

                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Name is required'),
                          backgroundColor: CustomColors.red,
                        ),
                      );
                      return;
                    }

                    final regex = RegExp(r'^[A-Z]{4}-[0-9]{4}$');
                    if (!regex.hasMatch(sku)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Invalid SKU format. Must be AAAA-1234.',
                          ),
                          backgroundColor: CustomColors.red,
                        ),
                      );
                      return;
                    }

                    // uniqueness check
                    final dataViewModel = ref.read(
                      treatmentDataViewModelProvider.notifier,
                    );
                    if (!dataViewModel.isAreaSkuUnique(sku)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'SKU must be globally unique across all levels.',
                          ),
                          backgroundColor: CustomColors.red,
                        ),
                      );
                      return;
                    }

                    if (pickedIconPath == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Area icon must be selected!'),
                          backgroundColor: CustomColors.red,
                        ),
                      );
                      return;
                    }
                    onAdd(name, sku, pickedIconPath!);
                    Navigator.pop(context);
                  },
                  label: 'Add',
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildLiveSelectionPreview(BuildContext context) {
    // Find all selected areas and render them hierarchically as beautiful cards
    final List<Widget> previewNodes = [];

    for (final area in widget.areas) {
      final isAreaSelected = widget.selectedAreas.any(
        (a) => a.areaController.text == area.name,
      );
      final areaEntry = widget.selectedAreas.firstWhere(
        (a) => a.areaController.text == area.name,
        orElse: AreaViewModelEntry.new,
      );

      final selectedSubAreas = area.subAreas.where((s) {
        return areaEntry.subAreas.any((sa) => sa.name == s.name);
      }).toList();

      if (isAreaSelected || selectedSubAreas.isNotEmpty) {
        // Build children widgets
        final List<String> subAreaStrings = [];
        for (final s in selectedSubAreas) {
          final subAreaConfig = areaEntry.subAreas.firstWhere(
            (sa) => sa.name == s.name,
          );

          final selectedChildren = s.subAreas.where((c) {
            return subAreaConfig.children.any((sac) => sac.name == c.name);
          }).toList();

          if (selectedChildren.isNotEmpty) {
            final childrenNames = selectedChildren
                .map((c) => '${c.name} (${c.globalSku})')
                .join(', ');
            subAreaStrings.add(
              '${s.name} (${s.globalSku}) -> [$childrenNames]',
            );
          } else {
            subAreaStrings.add('${s.name} (${s.globalSku})');
          }
        }

        previewNodes.add(
          _SelectedSummaryCard(
            title: area.name,
            sku: area.globalSku,
            icon: area.icon,
            subLabel: 'Selected Sub-Areas:',
            items: subAreaStrings,
          ),
        );
      }
    }

    if (previewNodes.isEmpty) {
      return Text('No areas selected', style: context.fonts.grey13w500);
    }

    return Wrap(spacing: 16, runSpacing: 16, children: previewNodes);
  }

  @override
  Widget build(BuildContext context) {
    if (_focusedAreaName == null ||
        !widget.areas.any((a) => a.name == _focusedAreaName)) {
      _focusedAreaName = widget.areas.isNotEmpty
          ? widget.areas.first.name
          : null;
    }

    final focusedArea = widget.areas.firstWhere(
      (a) => a.name == _focusedAreaName,
      orElse: () => widget.areas.first,
    );

    final areaEntry = widget.selectedAreas.firstWhere(
      (a) => a.areaController.text == focusedArea.name,
      orElse: AreaViewModelEntry.new,
    );

    if (_focusedSubAreaName == null ||
        !focusedArea.subAreas.any((s) => s.name == _focusedSubAreaName)) {
      _focusedSubAreaName = focusedArea.subAreas.isNotEmpty
          ? focusedArea.subAreas.first.name
          : null;
    }

    final focusedSubArea = focusedArea.subAreas.firstWhereOrNull(
      (s) => s.name == _focusedSubAreaName,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Level 0: Main Areas
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Main Body Areas', style: context.fonts.black14w600),
            IconButton(
              onPressed: () {
                _showAddNodeDialog(
                  context: context,
                  title: 'Create New Main Area',
                  onAdd: (name, sku, icon) => widget.onAddArea(name, sku, icon),
                );
              },
              icon: const Icon(
                Icons.add_circle_outline_rounded,
                size: 20,
                color: CustomColors.purple,
              ),
              tooltip: 'Add Root Area',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        context.verticalSpace(16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: widget.areas.map((area) {
            final isSelected = widget.selectedAreas.any(
              (a) => a.areaController.text == area.name,
            );
            final isFocused = _focusedAreaName == area.name;

            return IconImageContainer(
              title: area.name,
              imageUrl: area.image,
              iconUrl: area.icon,
              isSelected: isSelected || isFocused,
              onTap: () {
                setState(() {
                  if (isSelected || isFocused) {
                    _focusedAreaName = null;
                    _focusedSubAreaName = null;
                  } else {
                    _focusedAreaName = area.name;
                    _focusedSubAreaName = area.subAreas.isNotEmpty
                        ? area.subAreas.first.name
                        : null;
                  }
                });
                widget.onAreaToggle(area);

                ref
                    .read(treatmentViewModelProvider.notifier)
                    .setSelectedTreatmentAreaIds(area.id);
              },
              onAddChild: () {
                _showAddNodeDialog(
                  context: context,
                  title: 'Create New Sub-Area in ${area.name}',
                  onAdd: (name, sku, icon) => widget.onAddSubArea(
                    // TODO: Add actual parent area id.
                    parentAreaId: area.id,
                    parentAreaName: area.name,
                    name: name,
                    sku: sku,
                    icon: icon,
                  ),
                );
              },
            );
          }).toList(),
        ),

        // Level 1: Sub-Areas
        if (focusedArea.subAreas.isNotEmpty) ...[
          context.verticalSpace(32),
          const Divider(),
          context.verticalSpace(24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sub-Areas of ${focusedArea.name}',
                style: context.fonts.black14w600,
              ),
              IconButton(
                onPressed: () {
                  _showAddNodeDialog(
                    context: context,
                    title: 'Create New Sub-Area in ${focusedArea.name}',
                    onAdd: (name, sku, icon) => widget.onAddSubArea(
                      // TODO: Send actual parent area id here;
                      parentAreaId: 0,
                      parentAreaName: focusedArea.name,
                      name: name,
                      sku: sku,
                      icon: icon,
                    ),
                  );
                },
                icon: const Icon(
                  Icons.add_circle_outline_rounded,
                  size: 20,
                  color: CustomColors.purple,
                ),
                tooltip: 'Add Sub-Area',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          context.verticalSpace(16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: focusedArea.subAreas.map((subArea) {
              final isSelected = areaEntry.subAreas.any(
                (s) => s.name == subArea.name,
              );
              final isFocused = _focusedSubAreaName == subArea.name;

              return IconImageContainer(
                title: subArea.name,
                imageUrl: subArea.image,
                iconUrl: subArea.icon,
                isSelected: isSelected || isFocused,
                onTap: () {
                setState(() {
                  if (isSelected || isFocused) {
                    _focusedSubAreaName = null;
                  } else {
                    _focusedSubAreaName = subArea.name;
                  }
                });
                widget.onSubAreaToggle(focusedArea, subArea);

                  ref
                      .read(treatmentViewModelProvider.notifier)
                      .setSelectedTreatmentAreaIds(subArea.id);
                },
                onAddChild: () {
                  _showAddNodeDialog(
                    context: context,
                    title: 'Create New Child Area in ${subArea.name}',
                    onAdd: (name, sku, icon) => widget.onAddSubAreaChild(
                      focusedArea.name,
                      subArea.name,
                      name,
                      sku,
                      icon,
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ],

        // Level 2: Sub-Area Children
        if (focusedSubArea != null &&
            focusedSubArea.name.isNotEmpty &&
            focusedSubArea.subAreas.isNotEmpty) ...[
          context.verticalSpace(32),
          const Divider(),
          context.verticalSpace(24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Child Areas of ${focusedSubArea.name}',
                style: context.fonts.black14w600,
              ),
              IconButton(
                onPressed: () {
                  _showAddNodeDialog(
                    context: context,
                    title: 'Create New Child in ${focusedSubArea.name}',
                    onAdd: (name, sku, icon) => widget.onAddSubAreaChild(
                      focusedArea.name,
                      focusedSubArea.name,
                      name,
                      sku,
                      icon,
                    ),
                  );
                },
                icon: const Icon(
                  Icons.add_circle_outline_rounded,
                  size: 20,
                  color: CustomColors.purple,
                ),
                tooltip: 'Add Child Area',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          context.verticalSpace(16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: focusedSubArea.subAreas.map((child) {
              final subAreaConfig = areaEntry.subAreas.firstWhere(
                (s) => s.name == focusedSubArea.name,
                orElse: () => SubAreaConfig(
                  name: focusedSubArea.name,
                  id: focusedSubArea.id,
                ),
              );
              final isSelected = subAreaConfig.children.any(
                (c) => c.name == child.name,
              );

              return IconImageContainer(
                title: child.name,
                imageUrl: child.image,
                iconUrl: child.icon,
                isSelected: isSelected,
                onTap: () {
                  widget.onSubAreaChildToggle(
                    focusedArea,
                    focusedSubArea,
                    child,
                  );

                  ref
                      .read(treatmentViewModelProvider.notifier)
                      .setSelectedTreatmentAreaIds(child.id);
                },
                onAddChild: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Deepest level reached. Cannot add further children.',
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ],

        // Live Selection Preview Card Section
        context.verticalSpace(32),
        const Divider(),
        context.verticalSpace(24),
        Container(
          width: double.infinity,
          padding: context.appEdgeInsets(all: 20),
          decoration: BoxDecoration(
            color: CustomColors.softGrey.withValues(alpha: 0.1),
            borderRadius: context.appBorderRadius(all: 12),
            border: Border.all(color: CustomColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Selected Anatomical Structure Preview',
                    style: context.fonts.black16w700,
                  ),
                  const Icon(
                    Icons.analytics_outlined,
                    color: CustomColors.purple,
                    size: 20,
                  ),
                ],
              ),
              context.verticalSpace(16),
              _buildLiveSelectionPreview(context),
            ],
          ),
        ),
      ],
    );
  }
}



class _SelectedSummaryCard extends StatelessWidget {
  final String title;
  final String sku;
  final String? icon;
  final String subLabel;
  final List<String> items;

  const _SelectedSummaryCard({
    required this.title,
    required this.sku,
    required this.icon,
    required this.subLabel,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.w(300),
      padding: context.appEdgeInsets(all: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: context.appBorderRadius(all: 16),
        border: Border.all(color: CustomColors.border),
        boxShadow: AppShadows.xs(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: CustomColors.purple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    _getIconData(icon),
                    size: 16,
                    color: CustomColors.purple,
                  ),
                ),
              ),
              context.horizontalSpace(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: context.fonts.black14w600),
                    Text('SKU: $sku', style: context.fonts.grey12w400),
                  ],
                ),
              ),
            ],
          ),
          if (items.isNotEmpty) ...[
            context.verticalSpace(12),
            const Divider(),
            context.verticalSpace(8),
            Text(
              subLabel,
              style: context.fonts.black12w600.copyWith(
                color: CustomColors.purple,
              ),
            ),
            context.verticalSpace(6),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_outline_rounded,
                      size: 12,
                      color: CustomColors.purple,
                    ),
                    context.horizontalSpace(6),
                    Expanded(
                      child: Text(item, style: context.fonts.black12w400),
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

  IconData _getIconData(String? iconName) {
    switch (iconName?.toLowerCase()) {
      case 'face':
        return Icons.face_retouching_natural_rounded;
      case 'neck':
        return Icons.line_weight_rounded;
      case 'hands':
        return Icons.back_hand_outlined;
      case 'body':
        return Icons.accessibility_new_outlined;
      case 'scalp':
        return Icons.spa_outlined;
      default:
        return Icons.location_on_outlined;
    }
  }
}

class ProtocolNotesCard extends StatefulWidget {
  final ProtocolItem protocol;
  final List<TreatmentProtocolNoteItem> initialNotes;
  final void Function(List<TreatmentProtocolNoteItem>) onNotesChanged;

  const ProtocolNotesCard({
    super.key,
    required this.protocol,
    required this.initialNotes,
    required this.onNotesChanged,
  });

  @override
  State<ProtocolNotesCard> createState() => _ProtocolNotesCardState();
}

class _ProtocolNotesCardState extends State<ProtocolNotesCard> {
  late List<Map<String, TextEditingController>> _noteControllers;

  @override
  void initState() {
    super.initState();
    _noteControllers = widget.initialNotes
        .map(
          (note) => {
            'title': TextEditingController(text: note.title),
            'description': TextEditingController(text: note.description),
          },
        )
        .toList();
  }

  @override
  void dispose() {
    for (final note in _noteControllers) {
      note['title']?.dispose();
      note['description']?.dispose();
    }
    super.dispose();
  }

  void _notify() {
    final List<TreatmentProtocolNoteItem> updatedNotes = [];
    for (int i = 0; i < _noteControllers.length; i++) {
      final title = _noteControllers[i]['title']!.text.trim();
      final desc = _noteControllers[i]['description']!.text.trim();
      updatedNotes.add(
        TreatmentProtocolNoteItem(
          title: title.isEmpty ? null : title,
          description: desc,
          order: i + 1,
        ),
      );
    }
    widget.onNotesChanged(updatedNotes);
  }

  @override
  Widget build(BuildContext context) {
    return BorderdContainerWidget(
      margin: const EdgeInsets.only(top: 16),
      padding: context.appEdgeInsets(all: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.assignment_turned_in_outlined,
                    color: CustomColors.purple,
                    size: 20,
                  ),
                  context.horizontalSpace(12),
                  Text(widget.protocol.title, style: context.fonts.black16w600),
                ],
              ),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _noteControllers.add({
                      'title': TextEditingController(),
                      'description': TextEditingController(),
                    });
                  });
                  _notify();
                },
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Protocol Note'),
                style: TextButton.styleFrom(
                  foregroundColor: CustomColors.purple,
                ),
              ),
            ],
          ),
          if (_noteControllers.isNotEmpty) ...[
            context.verticalSpace(16),
            const Divider(),
            context.verticalSpace(16),
            ..._noteControllers.asMap().entries.map((entry) {
              final idx = entry.key;
              final controllers = entry.value;
              final titleCtrl = controllers['title']!;
              final descCtrl = controllers['description']!;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: context.appEdgeInsets(all: 16),
                decoration: BoxDecoration(
                  color: CustomColors.whiteGrey,
                  borderRadius: context.appBorderRadius(all: 10),
                  border: Border.all(color: CustomColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Note #${idx + 1}',
                          style: context.fonts.black14w600,
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_upward, size: 16),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: idx > 0
                                  ? () {
                                      setState(() {
                                        final temp = _noteControllers[idx];
                                        _noteControllers[idx] =
                                            _noteControllers[idx - 1];
                                        _noteControllers[idx - 1] = temp;
                                      });
                                      _notify();
                                    }
                                  : null,
                            ),
                            context.horizontalSpace(8),
                            IconButton(
                              icon: const Icon(Icons.arrow_downward, size: 16),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: idx < _noteControllers.length - 1
                                  ? () {
                                      setState(() {
                                        final temp = _noteControllers[idx];
                                        _noteControllers[idx] =
                                            _noteControllers[idx + 1];
                                        _noteControllers[idx + 1] = temp;
                                      });
                                      _notify();
                                    }
                                  : null,
                            ),
                            context.horizontalSpace(12),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                size: 18,
                                color: CustomColors.red,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                setState(() {
                                  _noteControllers[idx]['title']!.dispose();
                                  _noteControllers[idx]['description']!
                                      .dispose();
                                  _noteControllers.removeAt(idx);
                                });
                                _notify();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    context.verticalSpace(12),
                    BuildTextField(
                      label: 'Title (Optional)',
                      controller: titleCtrl,
                      hintText: 'e.g. Pre Care',
                      onChanged: (_) => _notify(),
                    ),
                    context.verticalSpace(12),
                    BuildTextField(
                      label: 'Description (Required)',
                      controller: descCtrl,
                      hintText: 'Enter protocol instruction notes...',
                      maxLines: 2,
                      onChanged: (_) => _notify(),
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
}
