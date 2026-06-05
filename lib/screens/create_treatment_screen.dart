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

    return GradientScaffold(
      appBar: AppBar(
        flexibleSpace: AppDecorations.appBarGradient,
        elevation: 0,
        centerTitle: true,
        title: Text("Create New Treatment", style: context.fonts.black18w600),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: CustomColors.black),
          onPressed: () {
            viewModel.resetForm();
            context.pop();
          },
        ),
      ),
      body: Column(
        children: [
          _buildProgressIndicator(context, state.currentStep),
          Expanded(
            child: SingleChildScrollView(
              padding: context.appEdgeInsets(horizontal: 24, vertical: 32),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: context.w(900)),
                  child: Column(
                    children: [
                      _buildCurrentStepContent(context, state, viewModel, dataState, ref),
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
    );
  }

  Widget _buildProgressIndicator(BuildContext context, int currentStep) {
    return Container(
      color: Colors.white,
      padding: context.appEdgeInsets(vertical: 20, horizontal: 40),
      child: Row(
        children: [
          _stepIndicator(context, 0, "Category", currentStep),
          _stepConnector(0, currentStep),
          _stepIndicator(context, 1, "Details", currentStep),
          _stepConnector(1, currentStep),
          _stepIndicator(context, 2, "Patient Journey", currentStep),
          _stepConnector(2, currentStep),
          _stepIndicator(context, 3, "Areas", currentStep),
          _stepConnector(3, currentStep),
          _stepIndicator(context, 4, "Logic", currentStep),
        ],
      ),
    );
  }

  Widget _stepIndicator(BuildContext context, int step, String label, int currentStep) {
    final bool isActive = currentStep >= step;
    final bool isCompleted = currentStep > step;

    return Row(
      children: [
        Container(
          width: context.w(32),
          height: context.w(32),
          decoration: BoxDecoration(
            color: isCompleted ? CustomColors.green : (isActive ? CustomColors.black : Colors.white),
            shape: BoxShape.circle,
            border: Border.all(color: isActive ? Colors.transparent : CustomColors.border),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : Text(
                    "${step + 1}",
                    style: isActive ? context.fonts.white12w700 : context.fonts.grey12w700,
                  ),
          ),
        ),
        context.horizontalSpace(12),
        Text(
          label,
          style: isActive ? context.fonts.black14w600 : context.fonts.grey14w400,
        ),
      ],
    );
  }

  Widget _stepConnector(int step, int currentStep) {
    final bool isCompleted = currentStep > step;
    return Expanded(
      child: Builder(
        builder: (context) {
          return Container(
            margin: context.appEdgeInsets(horizontal: 16),
            height: context.h(2),
            color: isCompleted ? CustomColors.green : CustomColors.border,
          );
        }
      ),
    );
  }

  Widget _buildCurrentStepContent(BuildContext context, TreatmentState state, TreatmentViewModel viewModel, TreatmentDataState dataState, WidgetRef ref) {
    switch (state.currentStep) {
      case 0: return _buildStepCategory(context, state, viewModel, dataState);
      case 1: return _buildStepDetails(context, state, viewModel);
      case 2: return _buildStepPatientJourney(context, state, viewModel, dataState, ref);
      case 3: return _buildStepAreas(context, state, viewModel, dataState);
      case 4: return _buildStepLogic(context, state, viewModel, dataState);
      default: return const SizedBox.shrink();
    }
  }

  Widget _buildStepPatientJourney(BuildContext context, TreatmentState state, TreatmentViewModel viewModel, TreatmentDataState dataState, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, "Patient Journey & Notifications"),
        context.verticalSpace(8),
        Text("Standardize patient experience with automated instructions, protocols, and reminders.", style: context.fonts.grey14w400),
        context.verticalSpace(32),

        _buildJourneySection(
          context,
          title: "Pre-Treatment Phase",
          instructionController: viewModel.preTreatmentInstructionsController,
          instructionLabel: "Preparation Instructions",
          notificationTitleController: viewModel.preNotificationTitleController,
          notificationDescController: viewModel.preNotificationDescriptionController,
          selectedOffset: state.preNotificationOffset,
          offsetOptions: {
            15: "15 Minutes Before",
            30: "30 Minutes Before",
            60: "1 Hour Before",
            120: "2 Hours Before",
            360: "6 Hours Before",
            720: "12 Hours Before",
            1440: "24 Hours Before",
          },
          offsetLabel: "Send automated reminder",
          onOffsetChanged: (val) => viewModel.setPreNotificationOffset(val),
          attachments: state.preTreatmentAttachments,
          onPickAttachments: () => viewModel.pickAttachments(true),
          onRemoveAttachment: (idx) => viewModel.removeAttachment(true, idx),
          isPreTreatment: true,
          dataState: dataState,
          ref: ref,
          selectedProtocolIds: state.selectedProtocolIds,
          onProtocolToggle: (id) => viewModel.toggleProtocolSelection(id),
        ),

        context.verticalSpace(48),
        const Divider(),
        context.verticalSpace(48),

        _buildJourneySection(
          context,
          title: "Post-Treatment Phase",
          instructionController: viewModel.postTreatmentInstructionsController,
          instructionLabel: "Aftercare Instructions",
          notificationTitleController: viewModel.postNotificationTitleController,
          notificationDescController: viewModel.postNotificationDescriptionController,
          selectedOffset: state.postNotificationOffset,
          offsetOptions: {
            0: "Immediately After",
            60: "1 Hour After",
            360: "6 Hours After",
            1440: "24 Hours After",
            2880: "2 Days After",
            10080: "7 Days After",
          },
          offsetLabel: "Send follow-up notification",
          onOffsetChanged: (val) => viewModel.setPostNotificationOffset(val),
          attachments: state.postTreatmentAttachments,
          onPickAttachments: () => viewModel.pickAttachments(false),
          onRemoveAttachment: (idx) => viewModel.removeAttachment(false, idx),
          isPostTreatment: true,
          isFollowUpRequired: state.isFollowUpRequired,
          onFollowUpToggle: (val) => viewModel.toggleFollowUpRequired(val),
          totalFollowUpsController: viewModel.totalFollowUpsController,
          followUpType: state.followUpType,
          onFollowUpTypeChanged: (val) => viewModel.setFollowUpType(val),
          followUpDurationValueController: viewModel.followUpDurationValueController,
          followUpDurationUnit: state.followUpDurationUnit,
          onFollowUpDurationUnitChanged: (val) => viewModel.setFollowUpDurationUnit(val),
          followUpNotesController: viewModel.followUpNotesController,
        ),
      ],
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
        if (isPreTreatment && dataState != null && ref != null && selectedProtocolIds != null && onProtocolToggle != null) ...[
          _buildJourneyProtocols(context, dataState, ref, selectedProtocolIds, onProtocolToggle),
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
        BuildTextField(
          label: "Treatment Base Price (\$)",
          controller: viewModel.basePriceController,
          hintText: "100",
          keyboardType: TextInputType.number,
          validator: Validators.empty,
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
        _sectionTitle(context, "Materials & Configuration"),
        context.verticalSpace(8),
        Text("Define the materials used and specific configuration per sub-area.", style: context.fonts.grey14w400),
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
          Text("Material Configuration Per Sub-Area", style: context.fonts.black16w400),
          context.verticalSpace(16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: allSubAreas.length,
            separatorBuilder: (_, _) => context.verticalSpace(12),
            itemBuilder: (context, index) {
              final subArea = allSubAreas[index];
              return _buildSubAreaMaterialConfig(context, subArea);
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
        Text("Phase Protocols", style: context.fonts.black14w600),
        context.verticalSpace(16),
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
    final bool isLastStep = state.currentStep == 4;
    final bool isStepAreas = state.currentStep == 3;

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
        if (isStepAreas) ...[
          Expanded(
            flex: 2,
            child: CustomOutlinedButton(
              onTap: () {
                if (!_validateSubAreas(context, state)) return;
                viewModel.submitTreatment(context).then((_) {
                  if (context.mounted) context.pop();
                });
              },
              label: "Finish & Create Now",
              color: CustomColors.black,
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
              if (state.currentStep == 3) {
                if (!_validateSubAreas(context, state)) return;
              }
              
              if (state.currentStep < 4) {
                viewModel.setStep(state.currentStep + 1);
              } else {
                viewModel.submitTreatment(context).then((_) {
                  if (context.mounted) context.pop();
                });
              }
            },
            label: isLastStep ? "Finish & Create Treatment" : (isStepAreas ? "Add Materials" : "Next Step"),
          ),
        ),
      ],
    );
  }

  bool _validateStepDetails(BuildContext context, TreatmentViewModel viewModel) {
    if (viewModel.internalNameController.text.isEmpty ||
        viewModel.displayNameController.text.isEmpty ||
        viewModel.basePriceController.text.isEmpty) {
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
