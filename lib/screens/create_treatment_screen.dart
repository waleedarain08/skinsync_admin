import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/utils/validators.dart';
import 'package:skinsync_admin/view_models/treatment_data_view_model.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';
import 'package:skinsync_admin/widgets/app_search_field.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'package:skinsync_admin/widgets/custom_outlined_button.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';
import 'package:skinsync_admin/widgets/custom_dropdown_widget.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';
import 'package:skinsync_admin/widgets/nested_category_selector.dart';
import 'package:skinsync_admin/widgets/dailogbox/standard_dialog.dart';
import 'package:skinsync_admin/models/treatment_data_models.dart';

class CreateTreatmentScreen extends ConsumerWidget {
  const CreateTreatmentScreen({super.key});

  static const String routeName = '/create-treatment';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(treatmentViewModelProvider);
    final viewModel = ref.read(treatmentViewModelProvider.notifier);
    final dataState = ref.watch(treatmentDataViewModelProvider);

    final bool isDesktop = context.screenWidth > 1200;
    final bool isTablet = context.screenWidth > 800 && context.screenWidth <= 1200;

    return GradientScaffold(
      appBar: AppBar(
        flexibleSpace: AppDecorations.appBarGradient,
        elevation: 0,
        centerTitle: true,
        title: Text("Treatment Builder", style: context.fonts.black18w600),
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
          if (isDesktop || isTablet) _buildLeftSidebar(context, state, viewModel),
          Expanded(
            child: Column(
              children: [
                if (!isDesktop && !isTablet) _buildMobileProgress(context, state),
                Expanded(
                  child: SingleChildScrollView(
                    padding: context.appEdgeInsets(horizontal: 24, vertical: 32),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: context.w(isDesktop ? 800 : 900)),
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
                              child: _buildCurrentStepContent(context, state, viewModel, dataState, ref),
                            ),
                            context.verticalSpace(48),
                            _buildActionButtons(context, state, viewModel),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isDesktop) _buildRightSidebar(context, state, viewModel, dataState),
        ],
      ),
    );
  }

  Widget _buildLeftSidebar(BuildContext context, TreatmentState state, TreatmentViewModel viewModel) {
    final steps = [
      "Categories",
      "Basic Information",
      "Treatment Areas",
      "Protocols",
      "Pre-Treatment Instructions",
      "Post-Treatment Instructions",
      "Phase Notifications",
      "Follow-Up Setup",
      "Patient Consent",
      "Materials & Logic",
      "Pricing"
    ];

    return Container(
      width: context.w(280),
      decoration: BoxDecoration(
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
                Text("Progress", style: context.fonts.grey12w600),
                context.verticalSpace(12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${state.currentStep + 1} / ${steps.length}", style: context.fonts.black14w700),
                    Text("${((state.currentStep + 1) / steps.length * 100).toInt()}%", style: context.fonts.purple14w700),
                  ],
                ),
                context.verticalSpace(12),
                ClipRRect(
                  borderRadius: context.appBorderRadius(all: 10),
                  child: LinearProgressIndicator(
                    value: (state.currentStep + 1) / steps.length,
                    minHeight: context.h(8),
                    backgroundColor: CustomColors.whiteGrey,
                    valueColor: const AlwaysStoppedAnimation<Color>(CustomColors.purple),
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
                  onTap: index < state.currentStep ? () => viewModel.setStep(index) : null,
                  child: Container(
                    padding: context.appEdgeInsets(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: isActive ? CustomColors.purple.withValues(alpha: 0.05) : Colors.transparent,
                      border: Border(right: BorderSide(color: isActive ? CustomColors.purple : Colors.transparent, width: 3)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: context.w(24),
                          height: context.w(24),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCompleted ? CustomColors.green : (isActive ? CustomColors.purple : Colors.white),
                            border: Border.all(color: isActive || isCompleted ? Colors.transparent : CustomColors.border),
                          ),
                          child: Center(
                            child: isCompleted
                                ? const Icon(Icons.check, color: Colors.white, size: 14)
                                : Text("${index + 1}", style: isActive ? context.fonts.white10w700 : context.fonts.grey10w700),
                          ),
                        ),
                        context.horizontalSpace(16),
                        Expanded(
                          child: Text(
                            steps[index],
                            style: isActive ? context.fonts.purple14w600 : (isCompleted ? context.fonts.black14w400 : context.fonts.grey14w400),
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
      "Categorization",
      "Basic Information",
      "Body Areas",
      "Clinical Protocols",
      "Pre-Treatment Instructions",
      "Post-Treatment Instructions",
      "Phase Notifications",
      "Follow-Up Configuration",
      "Patient Consent Form",
      "Materials & Logic",
      "Pricing Setup"
    ];
    final descriptions = [
      "Organize treatments to help patients and staff find them easily.",
      "Core identification details including status and duration.",
      "Define mandatory sub-areas and max material quantities.",
      "Standardize procedures with checklists and required text fields.",
      "Detailed instructions and supporting media for patients before the procedure.",
      "Aftercare guidelines and recovery media for patients after the procedure.",
      "Automated reminders and follow-up engagement messages.",
      "Manage rules and scheduling for post-procedure clinical check-ins.",
      "Upload and manage legal procedural consent documentation.",
      "Configure materials and AI simulator settings.",
      "Finalize treatment base price and sub-area pricing adjustments."
    ];
    final icons = [
      Icons.category_outlined,
      Icons.description_outlined,
      Icons.accessibility_new_outlined,
      Icons.assignment_turned_in_outlined,
      Icons.login_rounded,
      Icons.logout_rounded,
      Icons.notifications_active_outlined,
      Icons.replay_outlined,
      Icons.fact_check_outlined,
      Icons.inventory_2_outlined,
      Icons.payments_outlined
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
              child: Icon(icons[state.currentStep], color: CustomColors.purple, size: 24),
            ),
            context.horizontalSpace(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titles[state.currentStep], style: context.fonts.black20w600),
                  Text(descriptions[state.currentStep], style: context.fonts.grey14w400),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRightSidebar(BuildContext context, TreatmentState state, TreatmentViewModel viewModel, TreatmentDataState dataState) {
    return Container(
      width: context.w(350),
      decoration: BoxDecoration(
        color: CustomColors.whiteGrey.withValues(alpha: 0.5),
        border: Border(left: BorderSide(color: CustomColors.border)),
      ),
      child: SingleChildScrollView(
        padding: context.appEdgeInsets(all: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Live Preview", style: context.fonts.black16w600),
            context.verticalSpace(20),
            _buildPreviewCard(context, viewModel, state),
            context.verticalSpace(32),
            Text("Clinical Protocol Form Preview", style: context.fonts.black16w600),
            context.verticalSpace(16),
            _buildProtocolFormPreview(context, state, dataState),
            context.verticalSpace(32),
            Text("Patient Journey Preview", style: context.fonts.black16w600),
            context.verticalSpace(16),
            _buildPatientJourneyPreview(context, state, viewModel),
            context.verticalSpace(32),
            Text("Configuration Summary", style: context.fonts.black16w600),
            context.verticalSpace(16),
            _buildSummaryChips(context, viewModel, state, dataState),
          ],
        ),
      ),
    );
  }

  Widget _buildProtocolFormPreview(BuildContext context, TreatmentState state, TreatmentDataState dataState) {
    final selectedProtocols = dataState.protocols.where((p) => state.selectedProtocolIds.contains(p.id)).toList();
    final checkboxes = selectedProtocols.where((p) => p.type == ProtocolType.checkbox).toList();
    final textFields = selectedProtocols.where((p) => p.type == ProtocolType.text).toList();

    return Container(
      width: double.infinity,
      padding: context.appEdgeInsets(all: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: context.appBorderRadius(all: 12),
        border: Border.all(color: CustomColors.border),
      ),
      child: selectedProtocols.isEmpty
          ? Center(
              child: Text(
                "No clinical protocols configured yet.",
                style: context.fonts.grey12w400,
                textAlign: TextAlign.center,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (checkboxes.isNotEmpty) ...[
                  Text("CHECKLIST", style: context.fonts.grey10w700ls1),
                  context.verticalSpace(12),
                  ...checkboxes.map((p) => Padding(
                        padding: context.appEdgeInsets(bottom: 12),
                        child: Row(
                          children: [
                            Container(
                              width: context.w(18),
                              height: context.w(18),
                              decoration: BoxDecoration(
                                borderRadius: context.appBorderRadius(all: 4),
                                border: Border.all(color: CustomColors.border, width: 1.5),
                              ),
                            ),
                            context.horizontalSpace(12),
                            Expanded(child: Text(p.title, style: context.fonts.black13w400)),
                          ],
                        ),
                      )),
                ],
                if (checkboxes.isNotEmpty && textFields.isNotEmpty) context.verticalSpace(12),
                if (textFields.isNotEmpty) ...[
                  Text("NOTES", style: context.fonts.grey10w700ls1),
                  context.verticalSpace(12),
                  ...textFields.map((p) => Padding(
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
                          ],
                        ),
                      )),
                ],
              ],
            ),
    );
  }

  Widget _buildPreviewCard(BuildContext context, TreatmentViewModel viewModel, TreatmentState state) {
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
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              image: state.treatmentImage != null
                  ? DecorationImage(
                      image: kIsWeb ? NetworkImage(state.treatmentImage!.path) : FileImage(File(state.treatmentImage!.path)) as ImageProvider,
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: state.treatmentImage == null ? const Center(child: Icon(Icons.image_outlined, color: CustomColors.grey, size: 40)) : null,
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
                        viewModel.displayNameController.text.isEmpty ? "New Treatment" : viewModel.displayNameController.text,
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
                  viewModel.shortDescriptionController.text.isEmpty ? "No description provided yet." : viewModel.shortDescriptionController.text,
                  style: context.fonts.grey12w400,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                context.verticalSpace(16),
                const Divider(),
                context.verticalSpace(16),
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded, size: 16, color: CustomColors.grey),
                    context.horizontalSpace(8),
                    Text(
                      "${viewModel.durationHoursController.text}h ${viewModel.durationMinutesController.text}m",
                      style: context.fonts.black12w600,
                    ),
                    const Spacer(),
                    Container(
                      padding: context.appEdgeInsets(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: CustomColors.green.withValues(alpha: 0.1),
                        borderRadius: context.appBorderRadius(all: 20),
                      ),
                      child: Text("Active", style: context.fonts.green10w700),
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

  Widget _buildSummaryChips(BuildContext context, TreatmentViewModel viewModel, TreatmentState state, TreatmentDataState dataState) {
    final checkboxCount = dataState.protocols.where((p) => p.type == ProtocolType.checkbox && state.selectedProtocolIds.contains(p.id)).length;
    final textCount = dataState.protocols.where((p) => p.type == ProtocolType.text && state.selectedProtocolIds.contains(p.id)).length;

    return Wrap(
      spacing: context.w(8),
      runSpacing: context.h(8),
      children: [
        if (viewModel.categoryPathController.text.isNotEmpty) _summaryChip(context, viewModel.categoryPathController.text, Icons.category_outlined),
        if (state.areas.any((a) => a.areaController.text.isNotEmpty)) _summaryChip(context, "${state.areas.where((a) => a.areaController.text.isNotEmpty).length} Areas", Icons.location_on_outlined),
        if (checkboxCount > 0) _summaryChip(context, "$checkboxCount Checkboxes", Icons.check_box_outlined),
        if (textCount > 0) _summaryChip(context, "$textCount Text Protocols", Icons.text_snippet_outlined),
        if (state.preTreatmentConsentForm != null || state.existingConsentForm != null) _summaryChip(context, "Consent Required", Icons.fact_check_outlined),
        if (state.isFollowUpRequired) _summaryChip(context, "Follow-Up Required", Icons.replay_outlined),
        if (state.useInAiSimulator) _summaryChip(context, "AI Compatible", Icons.auto_awesome_outlined),
        _summaryChip(context, state.status.toUpperCase(), Icons.info_outline_rounded),
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

  Widget _buildPatientJourneyPreview(BuildContext context, TreatmentState state, TreatmentViewModel viewModel) {
    final hasPreInstructions = viewModel.preTreatmentInstructionsController.text.isNotEmpty;
    final hasPreNotification = viewModel.preNotificationTitleController.text.isNotEmpty;
    final hasPostInstructions = viewModel.postTreatmentInstructionsController.text.isNotEmpty;
    final hasPostNotification = viewModel.postNotificationTitleController.text.isNotEmpty;

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
          _previewRow(context, "Pre-Treatment Instructions", hasPreInstructions),
          _previewRow(context, "Pre-Treatment Notification", hasPreNotification),
          if (state.preTreatmentAttachments.isNotEmpty)
            _previewText(context, "${state.preTreatmentAttachments.length} Pre-Treatment Files"),
          context.verticalSpace(16),
          _previewRow(context, "Post-Treatment Instructions", hasPostInstructions),
          _previewRow(context, "Post-Treatment Notification", hasPostNotification),
          if (state.postTreatmentAttachments.isNotEmpty)
            _previewText(context, "${state.postTreatmentAttachments.length} Post-Treatment Files"),
          context.verticalSpace(16),
          _previewRow(context, "Follow-Up Required", state.isFollowUpRequired),
          if (state.isFollowUpRequired) ...[
            _previewText(context, "${state.followUpEntries.length} Follow-Ups"),
            ...state.followUpEntries.asMap().entries.map((entry) {
              final idx = entry.key + 1;
              final e = entry.value;
              return _previewText(context, "FU $idx: ${e.type.toUpperCase()} - ${e.durationValueController.text} ${e.durationUnit}");
            }),
          ],
        ],
      ),
    );
  }

  Widget _previewRow(BuildContext context, String label, bool check) {
    return Padding(
      padding: context.appEdgeInsets(bottom: 8),
      child: Row(
        children: [
          Icon(check ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded, 
               size: 16, color: check ? CustomColors.green : CustomColors.grey),
          context.horizontalSpace(12),
          Expanded(child: Text(label, style: check ? context.fonts.black13w600 : context.fonts.grey13w500)),
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
              Text("Step ${state.currentStep + 1} of 11", style: context.fonts.black14w700),
              Text("${((state.currentStep + 1) / 11 * 100).toInt()}%", style: context.fonts.purple14w700),
            ],
          ),
          context.verticalSpace(8),
          LinearProgressIndicator(
            value: (state.currentStep + 1) / 11,
            minHeight: context.h(4),
            backgroundColor: CustomColors.whiteGrey,
            valueColor: const AlwaysStoppedAnimation<Color>(CustomColors.purple),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStepContent(BuildContext context, TreatmentState state, TreatmentViewModel viewModel, TreatmentDataState dataState, WidgetRef ref) {
    switch (state.currentStep) {
      case 0: return _buildStepCategory(context, state, viewModel, dataState);
      case 1: return _buildStepDetails(context, state, viewModel);
      case 2: return _buildStepAreas(context, state, viewModel, dataState);
      case 3: return _buildStepProtocolsStep(context, state, viewModel, dataState, ref);
      case 4: return _buildStepPreInstructions(context, state, viewModel);
      case 5: return _buildStepPostInstructions(context, state, viewModel);
      case 6: return _buildStepNotifications(context, state, viewModel);
      case 7: return _buildStepFollowUp(context, state, viewModel);
      case 8: return _buildStepConsent(context, state, viewModel, ref);
      case 9: return _buildStepLogic(context, state, viewModel, dataState);
      case 10: return _buildStepPricing(context, state, viewModel);
      default: return const SizedBox.shrink();
    }
  }

  Widget _buildStepPricing(BuildContext context, TreatmentState state, TreatmentViewModel viewModel) {
    final allSubAreas = state.areas.expand((a) => a.subAreas).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, "Base Pricing"),
        context.verticalSpace(24),
        BuildTextField(
          label: "Treatment Base Price (\$)",
          controller: viewModel.basePriceController,
          hintText: "100",
          keyboardType: TextInputType.number,
          validator: Validators.empty,
        ),
        if (allSubAreas.isNotEmpty) ...[
          context.verticalSpace(40),
          _sectionTitle(context, "Sub-Area Pricing Adjustments"),
          context.verticalSpace(8),
          Text("Define specific pricing per sub-area if it differs from the base price.", style: context.fonts.grey14w400),
          context.verticalSpace(24),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: allSubAreas.length,
            separatorBuilder: (_, _) => context.verticalSpace(12),
            itemBuilder: (context, index) {
              final subArea = allSubAreas[index];
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
                        const Icon(Icons.subdirectory_arrow_right, size: 18, color: CustomColors.black),
                        context.horizontalSpace(8),
                        Text(subArea.name, style: context.fonts.black14w600),
                      ],
                    ),
                    context.verticalSpace(20),
                    BuildTextField(
                      label: "Base Price (\$)",
                      controller: subArea.basePriceController,
                      hintText: "0",
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ],
    );
  }


  Widget _buildStepPreInstructions(BuildContext context, TreatmentState state, TreatmentViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BuildTextField(
          label: "Pre-Treatment Instructions",
          controller: viewModel.preTreatmentInstructionsController,
          hintText: "Instructions for the patient before their procedure...",
          maxLines: 8,
        ),
        context.verticalSpace(32),
        _buildAttachmentsField(context, state.preTreatmentAttachments, () => viewModel.pickAttachments(true), (idx) => viewModel.removeAttachment(true, idx)),
      ],
    );
  }

  Widget _buildStepPostInstructions(BuildContext context, TreatmentState state, TreatmentViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BuildTextField(
          label: "Post-Treatment Instructions",
          controller: viewModel.postTreatmentInstructionsController,
          hintText: "Aftercare and recovery guidelines...",
          maxLines: 8,
        ),
        context.verticalSpace(32),
        _buildAttachmentsField(context, state.postTreatmentAttachments, () => viewModel.pickAttachments(false), (idx) => viewModel.removeAttachment(false, idx)),
      ],
    );
  }

  Widget _buildStepNotifications(BuildContext context, TreatmentState state, TreatmentViewModel viewModel) {
    return Column(
      children: [
        _expandableSection(
          context,
          title: "Pre-Treatment Notification",
          icon: Icons.notifications_none_rounded,
          content: Column(
            children: [
              BuildTextField(
                label: "Notification Title",
                controller: viewModel.preNotificationTitleController,
                hintText: "e.g. Appointment Reminder",
              ),
              context.verticalSpace(20),
              BuildTextField(
                label: "Notification Description",
                controller: viewModel.preNotificationDescriptionController,
                hintText: "Body of the notification",
                maxLines: 3,
              ),
              context.verticalSpace(20),
              _buildOffsetDropdown(
                context,
                label: "Reminder Timing (Minutes Before)",
                value: state.preNotificationOffset,
                options: {
                  15: "15 Minutes Before",
                  30: "30 Minutes Before",
                  60: "1 Hour Before",
                  120: "2 Hours Before",
                  360: "6 Hours Before",
                  720: "12 Hours Before",
                  1440: "24 Hours Before",
                },
                onChanged: (val) => viewModel.setPreNotificationOffset(val),
              ),
            ],
          ),
        ),
        context.verticalSpace(24),
        _expandableSection(
          context,
          title: "Post-Treatment Notification",
          icon: Icons.notifications_active_outlined,
          content: Column(
            children: [
              BuildTextField(
                label: "Notification Title",
                controller: viewModel.postNotificationTitleController,
                hintText: "e.g. Aftercare Reminder",
              ),
              context.verticalSpace(20),
              BuildTextField(
                label: "Notification Description",
                controller: viewModel.postNotificationDescriptionController,
                hintText: "Body of the notification",
                maxLines: 3,
              ),
              context.verticalSpace(20),
              _buildOffsetDropdown(
                context,
                label: "Engagement Timing (Minutes After)",
                value: state.postNotificationOffset,
                options: {
                  0: "Immediately After",
                  60: "1 Hour After",
                  360: "6 Hours After",
                  1440: "24 Hours After",
                  2880: "2 Days After",
                  10080: "7 Days After",
                },
                onChanged: (val) => viewModel.setPostNotificationOffset(val),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepFollowUp(BuildContext context, TreatmentState state, TreatmentViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _radioOption(context, "Active Follow-Up", state.isFollowUpRequired, () => viewModel.toggleFollowUpRequired(true)),
            context.horizontalSpace(32),
            _radioOption(context, "No Follow-Up", !state.isFollowUpRequired, () => viewModel.toggleFollowUpRequired(false)),
          ],
        ),
        if (state.isFollowUpRequired) ...[
          context.verticalSpace(32),
          BuildTextField(
            label: "Total Follow-Ups",
            controller: viewModel.totalFollowUpsController,
            hintText: "e.g. 1",
            keyboardType: TextInputType.number,
            onChanged: (String? val) => viewModel.updateFollowUpCount(val ?? ''),
          ),
          context.verticalSpace(32),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.followUpEntries.length,
            separatorBuilder: (_, __) => context.verticalSpace(24),
            itemBuilder: (context, index) {
              return _buildFollowUpEntryCard(context, index, state.followUpEntries[index], viewModel);
            },
          ),
        ],
      ],
    );
  }

  Widget _buildFollowUpEntryCard(BuildContext context, int index, FollowUpEntry entry, TreatmentViewModel viewModel) {
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
                child: Text("Follow-Up ${index + 1}", style: context.fonts.purple12w700),
              ),
            ],
          ),
          context.verticalSpace(20),
          Row(
            children: [
              Expanded(
                child: CustomDropdown<String>(
                  label: "Appointment Type",
                  hintText: "Select type",
                  value: entry.type,
                  items: const [
                    DropdownMenuItem(value: 'virtual', child: Text("Virtual")),
                    DropdownMenuItem(value: 'in_person', child: Text("In-Person")),
                  ],
                  onChanged: (val) => viewModel.updateFollowUpEntry(index, type: val),
                ),
              ),
              context.horizontalSpace(24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Duration", style: context.fonts.black14w600),
                    context.verticalSpace(10),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: BuildTextField(
                            label: "Value",
                            controller: entry.durationValueController,
                            hintText: "30",
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        context.horizontalSpace(12),
                        Expanded(
                          flex: 3,
                          child: Container(
                            margin: context.appEdgeInsets(top: 24),
                            child: CustomDropdown<String>(
                              label: "",
                              hintText: "Unit",
                              value: entry.durationUnit,
                              items: const [
                                DropdownMenuItem(value: 'minutes', child: Text("Minutes")),
                                DropdownMenuItem(value: 'hours', child: Text("Hours")),
                              ],
                              onChanged: (val) => viewModel.updateFollowUpEntry(index, durationUnit: val),
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
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Scheduling Interval", style: context.fonts.black14w600),
                    context.verticalSpace(10),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: BuildTextField(
                            label: "Interval",
                            controller: entry.intervalValueController,
                            hintText: "1",
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        context.horizontalSpace(12),
                        Expanded(
                          flex: 3,
                          child: Container(
                            margin: context.appEdgeInsets(top: 24),
                            child: CustomDropdown<String>(
                              label: "",
                              hintText: "Unit",
                              value: entry.intervalUnit,
                              items: const [
                                DropdownMenuItem(value: 'days', child: Text("Days After")),
                                DropdownMenuItem(value: 'weeks', child: Text("Weeks After")),
                              ],
                              onChanged: (val) => viewModel.updateFollowUpEntry(index, intervalUnit: val),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
          context.verticalSpace(20),
          BuildTextField(
            label: "Clinical Notes",
            controller: entry.notesController,
            hintText: "Specific instructions for this follow-up...",
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _radioOption(BuildContext context, String label, bool isSelected, VoidCallback onTap) {
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

  Widget _buildStepConsent(BuildContext context, TreatmentState state, TreatmentViewModel viewModel, WidgetRef ref) {
    final dataState = ref.watch(treatmentDataViewModelProvider);
    CategoryItem? selectedCategory;
    if (viewModel.categoryIdController.text.isNotEmpty) {
      selectedCategory = viewModel.findCategoryById(dataState.categories, viewModel.categoryIdController.text);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Consent Form Selection", style: context.fonts.black18w600),
        context.verticalSpace(24),
        Row(
          children: [
            _radioOption(
              context,
              "Use Category Default",
              state.consentType == 'category',
              () => viewModel.setConsentType('category'),
            ),
            context.horizontalSpace(32),
            _radioOption(
              context,
              "Upload Custom Form",
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
                const Icon(Icons.info_outline_rounded, color: CustomColors.purple),
                context.horizontalSpace(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Default Category Form", style: context.fonts.black14w600),
                      context.verticalSpace(4),
                      Text(
                        selectedCategory?.consentFormName ?? "No default form found for this category.",
                        style: context.fonts.grey12w400,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          _buildConsentFormSection(context, state.preTreatmentConsentForm, () => viewModel.pickConsentForm(), () => viewModel.removeConsentForm()),
        ],
        context.verticalSpace(24),
        Text(
          "Patients must digitally sign the selected consent form before the procedure begins.",
          style: context.fonts.grey14w400,
        ),
      ],
    );
  }

  CategoryItem? _findCategoryInTree(List<CategoryItem> items, String id) {
    for (var item in items) {
      if (item.id == id) return item;
      if (item.children.isNotEmpty) {
        final found = _findCategoryInTree(item.children, id);
        if (found != null) return found;
      }
    }
    return null;
  }

  Widget _buildOffsetDropdown(BuildContext context, {required String label, required int? value, required Map<int, String> options, required Function(int?) onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.fonts.black14w600),
        context.verticalSpace(10),
        Container(
          padding: context.appEdgeInsets(horizontal: 16),
          decoration: BoxDecoration(
            color: CustomColors.whiteGrey,
            borderRadius: context.appBorderRadius(all: 12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: value,
              hint: Text("Select timing", style: context.fonts.grey14w400),
              isExpanded: true,
              dropdownColor: Colors.white,
              borderRadius: context.appBorderRadius(all: 12),
              items: options.entries.map((e) => DropdownMenuItem<int>(value: e.key, child: Text(e.value, style: context.fonts.black14w400))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepProtocolsStep(BuildContext context, TreatmentState state, TreatmentViewModel viewModel, TreatmentDataState dataState, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildJourneyProtocols(context, dataState, ref, state.selectedProtocolIds, (id) => viewModel.toggleProtocolSelection(id)),
      ],
    );
  }

  Widget _expandableSection(BuildContext context, {required String title, required IconData icon, required Widget content}) {
    return Container(
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
            decoration: BoxDecoration(color: CustomColors.purple.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: CustomColors.purple, size: 18),
          ),
          title: Text(title, style: context.fonts.black16w600),
          children: [
            const Divider(height: 1),
            Padding(
              padding: context.appEdgeInsets(all: 24),
              child: content,
            ),
          ],
        ),
      ),
    );
  }




  Widget _buildJourneySection(
    BuildContext context, {
    required String title,
    required TextEditingController instructionController,
    required String instructionLabel,
    required TextEditingController notificationTitleController,
    required TextEditingController notificationDescController,
    required int? selectedOffset,
    required Map<int, String> offsetOptions,
    required String offsetLabel,
    required Function(int?) onOffsetChanged,
    required List<PlatformFile> attachments,
    required VoidCallback onPickAttachments,
    required Function(int) onRemoveAttachment,
    bool isPreTreatment = false,
    bool isPostTreatment = false,
    TreatmentDataState? dataState,
    WidgetRef? ref,
    List<String>? selectedProtocolIds,
    Function(String)? onProtocolToggle,
    PlatformFile? consentForm,
    VoidCallback? onPickConsent,
    VoidCallback? onRemoveConsent,
    bool isFollowUpRequired = false,
    Function(bool?)? onFollowUpToggle,
    TextEditingController? totalFollowUpsController,
    String? followUpType,
    Function(String?)? onFollowUpTypeChanged,
    TextEditingController? followUpDurationValueController,
    String? followUpDurationUnit,
    Function(String?)? onFollowUpDurationUnitChanged,
    TextEditingController? followUpNotesController,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: context.w(4),
              height: context.h(24),
              decoration: BoxDecoration(
                color: CustomColors.purple,
                borderRadius: context.appBorderRadius(all: 2),
              ),
            ),
            context.horizontalSpace(12),
            Text(title, style: context.fonts.black18w600),
          ],
        ),
        context.verticalSpace(24),
        BuildTextField(
          label: instructionLabel,
          controller: instructionController,
          hintText: "Detailed instructions for the patient...",
          maxLines: 5,
        ),
        context.verticalSpace(32),
        if (isPreTreatment && dataState != null && ref != null) ...[
          _buildConsentFormSection(context, consentForm, onPickConsent!, onRemoveConsent!),
          context.verticalSpace(32),
        ],
        _buildAttachmentsField(context, attachments, onPickAttachments, onRemoveAttachment),
        context.verticalSpace(32),
        Container(
          padding: context.appEdgeInsets(all: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: context.appBorderRadius(all: 12),
            border: Border.all(color: CustomColors.border),
            boxShadow: AppShadows.card(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_awesome_rounded, size: 20, color: CustomColors.purple),
                  context.horizontalSpace(12),
                  Text("Phase Notification", style: context.fonts.black16w600),
                ],
              ),
              context.verticalSpace(20),
              BuildTextField(
                label: "Notification Title",
                controller: notificationTitleController,
                hintText: "Title seen by patient",
              ),
              context.verticalSpace(20),
              BuildTextField(
                label: "Notification Description",
                controller: notificationDescController,
                hintText: "Body of the notification",
                maxLines: 3,
              ),
              context.verticalSpace(20),
              Text(offsetLabel, style: context.fonts.black14w600),
              context.verticalSpace(10),
              Container(
                padding: context.appEdgeInsets(horizontal: 16),
                decoration: BoxDecoration(
                  color: CustomColors.whiteGrey,
                  borderRadius: context.appBorderRadius(all: 12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: selectedOffset,
                    hint: Text("Select timing", style: context.fonts.grey14w400),
                    isExpanded: true,
                    dropdownColor: Colors.white,
                    borderRadius: context.appBorderRadius(all: 12),
                    items: offsetOptions.entries.map((e) {
                      return DropdownMenuItem<int>(
                        value: e.key,
                        child: Text(e.value, style: context.fonts.black14w400),
                      );
                    }).toList(),
                    onChanged: onOffsetChanged,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isPostTreatment) ...[
          context.verticalSpace(32),
          _buildFollowUpSection(
            context,
            isFollowUpRequired: isFollowUpRequired,
            onFollowUpToggle: onFollowUpToggle!,
            totalFollowUpsController: totalFollowUpsController!,
            followUpType: followUpType,
            onFollowUpTypeChanged: onFollowUpTypeChanged!,
            followUpDurationValueController: followUpDurationValueController!,
            followUpDurationUnit: followUpDurationUnit!,
            onFollowUpDurationUnitChanged: onFollowUpDurationUnitChanged!,
            followUpNotesController: followUpNotesController!,
          ),
        ],
      ],
    );
  }

  Widget _buildFollowUpSection(
    BuildContext context, {
    required bool isFollowUpRequired,
    required Function(bool?) onFollowUpToggle,
    required TextEditingController totalFollowUpsController,
    required String? followUpType,
    required Function(String?) onFollowUpTypeChanged,
    required TextEditingController followUpDurationValueController,
    required String followUpDurationUnit,
    required Function(String?) onFollowUpDurationUnitChanged,
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
                shape: RoundedRectangleBorder(borderRadius: context.appBorderRadius(all: 4)),
              ),
            ),
            context.horizontalSpace(12),
            Text("Is Follow-Up Required?", style: context.fonts.black16w600),
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
                Text("Follow-Up Configuration", style: context.fonts.black16w600),
                context.verticalSpace(20),
                Row(
                  children: [
                    Expanded(
                      child: BuildTextField(
                        label: "Total Follow-Ups",
                        controller: totalFollowUpsController,
                        hintText: "e.g. 1",
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    context.horizontalSpace(24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Appointment Type", style: context.fonts.black14w600),
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
                                hint: Text("Select type", style: context.fonts.grey14w400),
                                isExpanded: true,
                                dropdownColor: Colors.white,
                                borderRadius: context.appBorderRadius(all: 12),
                                items: [
                                  DropdownMenuItem(value: 'virtual', child: Text("Virtual", style: context.fonts.black14w400)),
                                  DropdownMenuItem(value: 'in_person', child: Text("In-Person", style: context.fonts.black14w400)),
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
                Text("Follow-Up Duration", style: context.fonts.black14w600),
                context.verticalSpace(10),
                Row(
                  children: [
                    Expanded(
                      child: BuildTextField(
                        label: "Value",
                        controller: followUpDurationValueController,
                        hintText: "e.g. 30",
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
                              DropdownMenuItem(value: 'minutes', child: Text("Minutes", style: context.fonts.black14w400)),
                              DropdownMenuItem(value: 'hours', child: Text("Hours", style: context.fonts.black14w400)),
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
                  label: "Follow-Up Notes",
                  controller: followUpNotesController,
                  hintText: "Additional clinical instructions...",
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildConsentFormSection(BuildContext context, PlatformFile? file, VoidCallback onPick, VoidCallback onRemove) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Patient Consent Form (PDF)", style: context.fonts.black14w600),
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
                border: Border.all(color: CustomColors.border, style: BorderStyle.solid),
              ),
              child: Column(
                children: [
                  const Icon(Icons.description_outlined, color: CustomColors.purple, size: 28),
                  context.verticalSpace(8),
                  Text("Upload Treatment Consent Form", style: context.fonts.purple14w600),
                  context.verticalSpace(4),
                  Text("Patients must sign this before procedure", style: context.fonts.grey12w400),
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
              border: Border.all(color: CustomColors.purple.withValues(alpha: 0.3)),
              boxShadow: [
                BoxShadow(color: CustomColors.purple.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: context.appEdgeInsets(all: 10),
                  decoration: BoxDecoration(color: CustomColors.red.withValues(alpha: 0.1), borderRadius: context.appBorderRadius(all: 8)),
                  child: const Icon(Icons.picture_as_pdf_rounded, color: CustomColors.red, size: 24),
                ),
                context.horizontalSpace(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(file.name, style: context.fonts.black14w600, maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text("${(file.size / 1024).toStringAsFixed(1)} KB", style: context.fonts.grey12w400),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_outline_rounded, color: CustomColors.red, size: 20),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildAttachmentsField(BuildContext context, List<PlatformFile> files, VoidCallback onPick, Function(int) onRemove) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Supporting Media (Optional)", style: context.fonts.black14w600),
            TextButton.icon(
              onPressed: onPick,
              icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
              label: const Text("Add Files"),
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
                border: Border.all(color: CustomColors.border, style: BorderStyle.solid),
              ),
              child: Column(
                children: [
                  const Icon(Icons.cloud_upload_outlined, color: CustomColors.grey, size: 24),
                  context.verticalSpace(8),
                  Text("Upload PDFs, Images, or Videos", style: context.fonts.grey13w500),
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
                              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                              child: const Icon(Icons.close_rounded, size: 14, color: CustomColors.red),
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
          ? Image.network(file.path!, fit: BoxFit.cover) 
          : Image.file(File(file.path!), fit: BoxFit.cover),
      );
    } else if (ext == 'pdf') {
      return const Icon(Icons.picture_as_pdf_rounded, color: CustomColors.red, size: 32);
    } else if (['mp4', 'mov', 'avi'].contains(ext)) {
      return const Icon(Icons.video_collection_rounded, color: CustomColors.purple, size: 32);
    }
    return const Icon(Icons.insert_drive_file_outlined, color: CustomColors.grey, size: 32);
  }

  Widget _buildStepDetails(BuildContext context, TreatmentState state, TreatmentViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, "Basic Information"),
        context.verticalSpace(24),
        Row(
          children: [
            Expanded(
              child: BuildTextField(
                label: "Internal Treatment Name",
                controller: viewModel.internalNameController,
                hintText: "e.g. Botox Cosmetic",
                validator: Validators.empty,
              ),
            ),
            context.horizontalSpace(24),
            Expanded(
              child: BuildTextField(
                label: "Patient Display Name",
                controller: viewModel.displayNameController,
                hintText: "e.g. Wrinkle Relaxer",
                validator: Validators.empty,
              ),
            ),
          ],
        ),
        context.verticalSpace(24),
        Text("Base Duration", style: context.fonts.black14w600),
        context.verticalSpace(10),
        Row(
          children: [
            Expanded(
              child: BuildTextField(
                label: "Hours",
                controller: viewModel.durationHoursController,
                hintText: "0",
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) return null;
                  final hours = int.tryParse(val);
                  if (hours == null || hours < 0) return "Invalid";
                  return null;
                },
              ),
            ),
            context.horizontalSpace(24),
            Expanded(
              child: BuildTextField(
                label: "Minutes",
                controller: viewModel.durationMinutesController,
                hintText: "0",
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) return null;
                  final minutes = int.tryParse(val);
                  if (minutes == null || minutes < 0 || minutes > 59) return "0-59";
                  return null;
                },
              ),
            ),
          ],
        ),
        context.verticalSpace(32),
        _sectionTitle(context, "Visuals"),
        context.verticalSpace(24),
        Row(
          children: [
            Expanded(child: _buildImageUploadTile(context, "Treatment Banner Image", state.treatmentImage, () => viewModel.pickImage(false))),
            context.horizontalSpace(24),
            Expanded(child: _buildImageUploadTile(context, "Treatment Listing Icon", state.treatmentIcon, () => viewModel.pickImage(true))),
          ],
        ),
        context.verticalSpace(32),
        _sectionTitle(context, "Descriptions"),
        context.verticalSpace(24),
        BuildTextField(
          label: "Short Description",
          controller: viewModel.shortDescriptionController,
          hintText: "Brief summary for listing...",
          maxLines: 2,
        ),
        context.verticalSpace(24),
        BuildTextField(
          label: "Full Description",
          controller: viewModel.fullDescriptionController,
          hintText: "Detailed medical and process information...",
          maxLines: 5,
        ),
        context.verticalSpace(24),
        CustomDropdown<String>(
          label: "Treatment Status",
          hintText: "Select status",
          value: state.status,
          items: [
            DropdownMenuItem(value: 'active', child: Text("Active", style: context.fonts.black14w400)),
            DropdownMenuItem(value: 'deactive', child: Text("Deactive", style: context.fonts.black14w400)),
            DropdownMenuItem(value: 'draft', child: Text("Draft", style: context.fonts.black14w400)),
          ],
          onChanged: (val) => viewModel.setStatus(val ?? 'active'),
        ),
      ],
    );
  }

  Widget _buildStepCategory(BuildContext context, TreatmentState state, TreatmentViewModel viewModel, TreatmentDataState dataState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, "Categorization"),
        context.verticalSpace(8),
        Text("Organize treatments to help patients find them easily. Select or create categories at any level.", style: context.fonts.grey14w400),
        context.verticalSpace(32),
        NestedCategorySelector(
          categories: dataState.categories,
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
              border: Border.all(color: CustomColors.purple.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_outline_rounded, color: CustomColors.purple, size: 20),
                context.horizontalSpace(12),
                Expanded(
                  child: Text(
                    "Selected Path: ${viewModel.categoryPathController.text}",
                    style: context.fonts.black14w600.copyWith(color: CustomColors.purple),
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
    required Function(String) onToggle,
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
              icon: const Icon(Icons.add_circle_outline_rounded, color: CustomColors.purple, size: 24),
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
            child: Text("No protocols in this group.", style: context.fonts.grey13w500),
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
                    color: isSelected ? CustomColors.purple.withValues(alpha: 0.08) : Colors.white,
                    borderRadius: context.appBorderRadius(all: 10),
                    border: Border.all(
                      color: isSelected ? CustomColors.purple : CustomColors.border,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
                        size: 18,
                        color: isSelected ? CustomColors.purple : CustomColors.grey,
                      ),
                      context.horizontalSpace(10),
                      Text(
                        protocol.title,
                        style: isSelected ? context.fonts.purple14w600 : context.fonts.black14w400,
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

  void _showAddProtocolDialog(BuildContext context, WidgetRef ref, ProtocolType type) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => StandardDialog(
        title: "Add ${type == ProtocolType.checkbox ? 'Checkbox' : 'Text'} Protocol",
        width: context.w(450),
        content: BuildTextField(
          label: "Protocol Title",
          controller: controller,
          hintText: "e.g. ${type == ProtocolType.checkbox ? 'Cleanse treatment area' : 'Pre-Treatment Instructions'}",
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          CustomPrimaryButton(
            onTap: () {
              if (controller.text.isNotEmpty) {
                ref.read(treatmentDataViewModelProvider.notifier).addProtocol(controller.text.trim(), type);
                Navigator.pop(context);
              }
            },
            label: "Save Protocol",
            width: context.w(150),
          ),
        ],
      ),
    );
  }

  Widget _buildStepAreas(BuildContext context, TreatmentState state, TreatmentViewModel viewModel, TreatmentDataState dataState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _sectionTitle(context, "Treatment Areas"),
            CustomPrimaryButton(
              onTap: () => viewModel.addArea(),
              icon: Icons.add_location_alt_outlined,
              label: "Add New Area",
              width: context.w(200),
            ),
          ],
        ),
        context.verticalSpace(8),
        Text("Select areas and mandatory sub-areas for this treatment.", style: context.fonts.grey14w400),
        context.verticalSpace(32),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.areas.length,
          separatorBuilder: (_, _) => context.verticalSpace(24),
          itemBuilder: (context, index) {
            return _buildAreaRow(context, index, state.areas[index], viewModel, dataState);
          },
        ),
      ],
    );
  }

  Widget _buildStepLogic(BuildContext context, TreatmentState state, TreatmentViewModel viewModel, TreatmentDataState dataState) {
    final allSubAreas = state.areas.expand((a) => a.subAreas).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, "Materials & Inventory"),
        context.verticalSpace(8),
        Text("Define the materials used and maximum quantity allowed per sub-area.", style: context.fonts.grey14w400),
        context.verticalSpace(32),
        _buildSearchField(
          context,
          label: "Material / Consumable Name",
          hint: "e.g. Syringes, Units, Vials",
          controller: viewModel.materialNameController,
          suggestions: dataState.materials,
          onSelected: (val) {},
        ),
        if (allSubAreas.isNotEmpty) ...[
          context.verticalSpace(32),
          Text("Inventory Configuration Per Sub-Area", style: context.fonts.black16w400),
          context.verticalSpace(16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: allSubAreas.length,
            separatorBuilder: (_, _) => context.verticalSpace(12),
            itemBuilder: (context, index) {
              final subArea = allSubAreas[index];
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
                        const Icon(Icons.subdirectory_arrow_right, size: 18, color: CustomColors.black),
                        context.horizontalSpace(8),
                        Text(subArea.name, style: context.fonts.black14w600),
                      ],
                    ),
                    context.verticalSpace(20),
                    BuildTextField(
                      label: "Max Quantity",
                      controller: subArea.maxQuantityController,
                      hintText: "0",
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        context.verticalSpace(40),
        const Divider(),
        context.verticalSpace(32),
        _sectionTitle(context, "AI Simulator Compatibility"),
        context.verticalSpace(16),
        Row(
          children: [
            SizedBox(
              width: context.w(24),
              height: context.w(24),
              child: Checkbox(
                value: state.useInAiSimulator,
                onChanged: (val) => viewModel.toggleAiSimulator(val),
                shape: RoundedRectangleBorder(borderRadius: context.appBorderRadius(all: 4)),
              ),
            ),
            context.horizontalSpace(12),
            Text("Use in AI Simulator", style: context.fonts.black16w400),
          ],
        ),
      ],
    );
  }

  Widget _buildSubAreaMaterialConfig(BuildContext context, SubAreaConfig subArea) {
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
              const Icon(Icons.subdirectory_arrow_right, size: 18, color: CustomColors.black),
              context.horizontalSpace(8),
              Text(subArea.name, style: context.fonts.black14w600),
            ],
          ),
          context.verticalSpace(20),
          Row(
            children: [
              Expanded(
                child: BuildTextField(
                  label: "Max Quantity",
                  controller: subArea.maxQuantityController,
                  hintText: "0",
                  keyboardType: TextInputType.number,
                ),
              ),
              context.horizontalSpace(20),
              Expanded(
                child: BuildTextField(
                  label: "Base Price (\$)",
                  controller: subArea.basePriceController,
                  hintText: "0",
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAreaRow(BuildContext context, int index, AreaViewModelEntry entry, TreatmentViewModel viewModel, TreatmentDataState dataState) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildSearchField(
                  context,
                  label: "Area Name",
                  hint: "e.g. Upper Face",
                  controller: entry.areaController,
                  suggestions: dataState.areas.map((a) => a.name).toList(),
                  onSelected: (val) => viewModel.onAreaSelected(index, val),
                ),
              ),
              if (index > 0)
                Padding(
                  padding: context.appEdgeInsets(top: 32, left: 16),
                  child: IconButton(
                    onPressed: () => viewModel.removeArea(index),
                    icon: const Icon(Icons.delete_outline, color: CustomColors.red),
                  ),
                ),
            ],
          ),
          context.verticalSpace(24),
          _buildSubAreaSection(context, index, entry, viewModel, dataState),
        ],
      ),
    );
  }

  Widget _buildSubAreaSection(BuildContext context, int areaIndex, AreaViewModelEntry entry, TreatmentViewModel viewModel, TreatmentDataState dataState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSearchField(
          context,
          label: "Sub Areas (Mandatory)",
          hint: "Select or type to add sub areas",
          controller: entry.subAreaController,
          suggestions: dataState.areas.isEmpty 
              ? [] 
              : dataState.areas
                  .firstWhere((a) => a.name == entry.areaController.text,
                      orElse: () => dataState.areas.first)
                  .subAreas
                  .map((s) => s.name)
                  .toList(),
          onSelected: (val) => viewModel.addSubArea(areaIndex, val),
        ),
        if (entry.subAreas.isNotEmpty) ...[
          context.verticalSpace(16),
          Wrap(
            spacing: context.w(12),
            runSpacing: context.h(12),
            children: entry.subAreas.map((sub) {
              return Chip(
                avatar: const Icon(Icons.subdirectory_arrow_right, size: 14),
                label: Text(sub.name, style: context.fonts.grey13w500),
                onDeleted: () => viewModel.removeSubArea(areaIndex, sub.name),
                backgroundColor: CustomColors.green.withValues(alpha: 0.1),
                side: BorderSide(color: CustomColors.green.withValues(alpha: 0.2)),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildSearchField(
    BuildContext context, {
    required String label,
    required String hint,
    required TextEditingController controller,
    required List<String> suggestions,
    required Function(String) onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.fonts.black14w600),
        context.verticalSpace(10),
        SearchAnchor(
          viewHintText: hint,
          viewConstraints: BoxConstraints(maxHeight: context.h(350)),
          viewShape: RoundedRectangleBorder(borderRadius: context.appBorderRadius(all: 16)),
          viewSurfaceTintColor: Colors.white,
          viewBackgroundColor: Colors.white,
          viewElevation: 12,
          builder: (context, searchController) {
            if (searchController.text.isEmpty && controller.text.isNotEmpty) {
              searchController.text = controller.text;
            }
            
            return AppSearchField(
              controller: controller,
              readOnly: true,
              onTap: () {
                searchController.text = controller.text;
                searchController.openView();
              },
              hintText: hint,
              suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded, color: CustomColors.grey),
              maxWidth: double.infinity,
            );
          },
          suggestionsBuilder: (context, searchController) {
            final query = searchController.text.toLowerCase();
            // final filteredList = suggestions.where((s) => s.toLowerCase().contains(query)).toList();

            return [
              if (searchController.text.isNotEmpty && !suggestions.contains(searchController.text))
                Padding(
                  padding: context.appEdgeInsets(left: 16, top: 12, right: 16, bottom: 8),
                  child: InkWell(
                    onTap: () {
                      controller.text = searchController.text;
                      onSelected(searchController.text);
                      searchController.closeView(searchController.text);
                    },
                    borderRadius: context.appBorderRadius(all: 10),
                    child: Container(
                      padding: context.appEdgeInsets(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: CustomColors.purple.withValues(alpha: 0.05),
                        borderRadius: context.appBorderRadius(all: 10),
                        border: Border.all(color: CustomColors.purple.withValues(alpha: 0.1)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.add_circle_outline_rounded, color: CustomColors.black, size: 20),
                          context.horizontalSpace(12),
                          Expanded(
                            child: Text(
                              'Create new: "${searchController.text}"',
                              style: context.fonts.black14w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ...suggestions.map((item) {
                final bool isMatch = item.toLowerCase().contains(query);
                if (!isMatch && query.isNotEmpty) return const SizedBox.shrink();
                
                return Column(
                  children: [
                    ListTile(
                      contentPadding: context.appEdgeInsets(horizontal: 24, vertical: 4),
                      leading: Container(
                        width: context.w(32),
                        height: context.w(32),
                        decoration: BoxDecoration(color: CustomColors.whiteGrey, borderRadius: context.appBorderRadius(all: 6)),
                        child: const Icon(Icons.circle_outlined, size: 14, color: CustomColors.grey),
                      ),
                      title: Text(item, style: context.fonts.grey14w400),
                      hoverColor: CustomColors.green.withValues(alpha: 0.05),
                      onTap: () {
                        controller.text = item;
                        onSelected(item);
                        searchController.closeView(item);
                      },
                    ),
                    const Divider(height: 1, indent: 24, endIndent: 24, color: CustomColors.border),
                  ],
                );
              }),
            ];
          },
        ),
      ],
    );
  }

  Widget _buildImageUploadTile(BuildContext context, String label, dynamic file, VoidCallback onTap) {
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
              image: file != null
                  ? DecorationImage(
                      image: kIsWeb ? NetworkImage(file.path) : FileImage(File(file.path)) as ImageProvider,
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: file == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: context.appEdgeInsets(all: 12),
                        decoration: const BoxDecoration(color: CustomColors.whiteGrey, shape: BoxShape.circle),
                        child: const Icon(Icons.add_a_photo_outlined, color: CustomColors.black),
                      ),
                      context.verticalSpace(12),
                      Text("Tap to upload", style: context.fonts.grey13w500),
                    ],
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Text(title, style: context.fonts.black18w600);
  }

  Widget _buildJourneyProtocols(BuildContext context, TreatmentDataState dataState, WidgetRef ref, List<String> selectedIds, Function(String) onToggle) {
    final checkboxProtocols = dataState.protocols.where((p) => p.type == ProtocolType.checkbox).toList();
    final textProtocols = dataState.protocols.where((p) => p.type == ProtocolType.text).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProtocolGroup(
          context,
          title: "Checkboxes",
          protocols: checkboxProtocols,
          selectedIds: selectedIds,
          onToggle: onToggle,
          onAdd: () => _showAddProtocolDialog(context, ref, ProtocolType.checkbox),
        ),
        context.verticalSpace(24),
        _buildProtocolGroup(
          context,
          title: "Text Fields",
          protocols: textProtocols,
          selectedIds: selectedIds,
          onToggle: onToggle,
          onAdd: () => _showAddProtocolDialog(context, ref, ProtocolType.text),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, TreatmentState state, TreatmentViewModel viewModel) {
    final bool isLastStep = state.currentStep == 10;

    return Row(
      children: [
        if (state.currentStep > 0) ...[
          Expanded(
            child: CustomOutlinedButton(
              onTap: () => viewModel.setStep(state.currentStep - 1),
              label: "Previous Step",
            ),
          ),
          context.horizontalSpace(16),
        ],
        Expanded(
          flex: 2,
          child: CustomPrimaryButton(
            onTap: () {
              if (state.currentStep == 1) {
                if (!_validateStepDetails(context, viewModel)) return;
              }
              if (state.currentStep == 2) {
                if (!_validateSubAreas(context, state)) return;
              }
              
              if (state.currentStep < 10) {
                viewModel.setStep(state.currentStep + 1);
              } else {
                viewModel.submitTreatment(context).then((_) {
                  if (context.mounted) context.pop();
                });
              }
            },
            label: isLastStep ? "Finish & Create Treatment" : "Next Step",
          ),
        ),
      ],
    );
  }

  bool _validateStepDetails(BuildContext context, TreatmentViewModel viewModel) {
    if (viewModel.internalNameController.text.isEmpty ||
        viewModel.displayNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields"), backgroundColor: CustomColors.red),
      );
      return false;
    }

    final hours = int.tryParse(viewModel.durationHoursController.text) ?? 0;
    final minutes = int.tryParse(viewModel.durationMinutesController.text) ?? 0;

    if (hours <= 0 && minutes <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid treatment duration"), backgroundColor: CustomColors.red),
      );
      return false;
    }

    if (minutes > 59) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Minutes must be between 0 and 59"), backgroundColor: CustomColors.red),
      );
      return false;
    }

    return true;
  }

  bool _validateSubAreas(BuildContext context, TreatmentState state) {
    for (var area in state.areas) {
      if (area.subAreas.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please select at least one sub-area for '${area.areaController.text}'"),
            backgroundColor: CustomColors.red,
          ),
        );
        return false;
      }
    }
    return true;
  }
}
