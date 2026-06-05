import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/treatment_model.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/utils/validators.dart';
import 'package:skinsync_admin/view_models/treatment_data_view_model.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';
import 'package:skinsync_admin/widgets/app_search_field.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';
import 'package:skinsync_admin/widgets/nested_category_selector.dart';
import 'package:skinsync_admin/widgets/dailogbox/standard_dialog.dart';
import 'package:skinsync_admin/models/treatment_data_models.dart';

class EditTreatmentScreen extends ConsumerWidget {
  const EditTreatmentScreen({super.key});

  static const String routeName = '/edit-treatment';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(treatmentViewModelProvider);
    final viewModel = ref.read(treatmentViewModelProvider.notifier);
    final dataState = ref.watch(treatmentDataViewModelProvider);

    if (state.selectedTreatment == null) {
      return GradientScaffold(body: Center(child: Text("No Treatment Selected", style: context.fonts.black16w400)));
    }

    return GradientScaffold(
      appBar: AppBar(
        flexibleSpace: AppDecorations.appBarGradient,
        elevation: 0,
        centerTitle: true,
        title: Text("Edit Treatment", style: context.fonts.black18w600),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: CustomColors.black),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (!_validateForm(context, viewModel, state)) return;
              viewModel.updateTreatment(context).then((_) {
                if (context.mounted) Navigator.pop(context);
              });
            },
            child: Text("Save Changes", style: context.fonts.black16w400),
          ),
          context.horizontalSpace(16),
        ],
      ),
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(horizontal: 24, vertical: 32),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.w(1000)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBasicDetailsSection(context, state, viewModel),
                context.verticalSpace(32),
                _buildCategorizationSection(context, state, viewModel, dataState),
                context.verticalSpace(32),
                _buildPreTreatmentSection(context, state, viewModel, dataState, ref),
                context.verticalSpace(32),
                _buildPostTreatmentSection(context, state, viewModel),
                context.verticalSpace(32),
                _buildAreasSection(context, state, viewModel, dataState),
                context.verticalSpace(32),
                _buildMaterialsAndLogicSection(context, state, viewModel, dataState),
                context.verticalSpace(48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _validateForm(BuildContext context, TreatmentViewModel viewModel, TreatmentState state) {
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

    for (var area in state.areas) {
      if (area.subAreas.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Each area must have at least one sub-area: ${area.areaController.text}"),
            backgroundColor: CustomColors.red,
          ),
        );
        return false;
      }
    }
    return true;
  }

  Widget _buildBasicDetailsSection(BuildContext context, TreatmentState state, TreatmentViewModel viewModel) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Basic Information", style: context.fonts.black18w600),
          context.verticalSpace(24),
          Row(
            children: [
              Expanded(
                child: BuildTextField(
                  label: "Internal Name",
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
            hintText: "0",
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
                ),
              ),
              context.horizontalSpace(24),
              Expanded(
                child: BuildTextField(
                  label: "Minutes",
                  controller: viewModel.durationMinutesController,
                  hintText: "0",
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          context.verticalSpace(24),
          Row(
            children: [
              Expanded(child: _buildImageTile(context, "Banner Image", state.treatmentImage, () => viewModel.pickImage(false))),
              context.horizontalSpace(24),
              Expanded(child: _buildImageTile(context, "Listing Icon", state.treatmentIcon, () => viewModel.pickImage(true))),
            ],
          ),
          context.verticalSpace(24),
          BuildTextField(
            label: "Short Description",
            controller: viewModel.shortDescriptionController,
            hintText: "Brief summary...",
            maxLines: 2,
          ),
          context.verticalSpace(24),
          BuildTextField(
            label: "Full Description",
            controller: viewModel.fullDescriptionController,
            hintText: "Detailed info...",
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildCategorizationSection(BuildContext context, TreatmentState state, TreatmentViewModel viewModel, TreatmentDataState dataState) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Categorization", style: context.fonts.black18w600),
          context.verticalSpace(24),
          Text("Selected Category", style: context.fonts.black14w600),
          context.verticalSpace(10),
          InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => NestedCategorySelector(
                  categories: dataState.categories,
                  initialCategoryId: viewModel.categoryIdController.text,
                  onSelected: (cat, path) => viewModel.onCategorySelected(cat, path),
                ),
              );
            },
            child: Container(
              padding: context.appEdgeInsets(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: context.appBorderRadius(all: 12),
                border: Border.all(color: CustomColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.category_outlined, color: CustomColors.purple, size: 20),
                  context.horizontalSpace(12),
                  Expanded(
                    child: Text(
                      viewModel.categoryPathController.text.isEmpty 
                          ? "Tap to select category" 
                          : viewModel.categoryPathController.text,
                      style: viewModel.categoryPathController.text.isEmpty 
                          ? context.fonts.grey14w400 
                          : context.fonts.black14w600,
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down_rounded, color: CustomColors.grey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreTreatmentSection(BuildContext context, TreatmentState state, TreatmentViewModel viewModel, TreatmentDataState dataState, WidgetRef ref) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildJourneySubSection(
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
            existingAttachments: state.existingPreAttachments,
            newAttachments: state.preTreatmentAttachments,
            onPickAttachments: () => viewModel.pickAttachments(true),
            onRemoveExisting: (idx) => viewModel.removeExistingAttachment(true, idx),
            onRemoveNew: (idx) => viewModel.removeAttachment(true, idx),
            isPreTreatment: true,
            dataState: dataState,
            ref: ref,
            selectedProtocolIds: state.selectedProtocolIds,
            onProtocolToggle: (id) => viewModel.toggleProtocolSelection(id),
          ),
        ],
      ),
    );
  }

  Widget _buildPostTreatmentSection(BuildContext context, TreatmentState state, TreatmentViewModel viewModel) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildJourneySubSection(
            context,
            title: "Post-Treatment Phase",
            instructionController: viewModel.postTreatmentInstructionsController,
            instructionLabel: "Aftercare Instructions",
            notificationTitleController: viewModel.postNotificationTitleController,
            notificationDescController: viewModel.postNotificationDescriptionController,
            selectedOffset: state.postNotificationOffset,
            offsetOptions: {
              0: "Immediately",
              60: "1 Hour After",
              360: "6 Hours After",
              1440: "24 Hours After",
              2880: "2 Days After",
              10080: "7 Days After",
            },
            offsetLabel: "Send follow-up notification",
            onOffsetChanged: (val) => viewModel.setPostNotificationOffset(val),
            existingAttachments: state.existingPostAttachments,
            newAttachments: state.postTreatmentAttachments,
            onPickAttachments: () => viewModel.pickAttachments(false),
            onRemoveExisting: (idx) => viewModel.removeExistingAttachment(false, idx),
            onRemoveNew: (idx) => viewModel.removeAttachment(false, idx),
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
      ),
    );
  }

  Widget _buildJourneySubSection(
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
    required List<Attachment> existingAttachments,
    required List<PlatformFile> newAttachments,
    required VoidCallback onPickAttachments,
    required Function(int) onRemoveExisting,
    required Function(int) onRemoveNew,
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
              height: context.h(20),
              decoration: BoxDecoration(
                color: CustomColors.purple,
                borderRadius: context.appBorderRadius(all: 2),
              ),
            ),
            context.horizontalSpace(12),
            Text(title, style: context.fonts.black16w600),
          ],
        ),
        context.verticalSpace(24),
        BuildTextField(
          label: instructionLabel,
          controller: instructionController,
          hintText: "Detailed instructions...",
          maxLines: 5,
        ),
        context.verticalSpace(32),
        if (isPreTreatment && dataState != null && ref != null && selectedProtocolIds != null && onProtocolToggle != null) ...[
          _buildJourneyProtocols(context, dataState, ref, selectedProtocolIds, onProtocolToggle),
          context.verticalSpace(32),
        ],
        _buildAttachmentsField(
          context, 
          existingAttachments, 
          newAttachments, 
          onPickAttachments, 
          onRemoveExisting, 
          onRemoveNew
        ),
        context.verticalSpace(32),
        Container(
          padding: context.appEdgeInsets(all: 20),
          decoration: BoxDecoration(
            color: CustomColors.whiteGrey,
            borderRadius: context.appBorderRadius(all: 12),
            border: Border.all(color: CustomColors.border),
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
                hintText: "Enter title...",
              ),
              context.verticalSpace(20),
              BuildTextField(
                label: "Notification Description",
                controller: notificationDescController,
                hintText: "Enter description...",
                maxLines: 3,
              ),
              context.verticalSpace(20),
              Text(offsetLabel, style: context.fonts.black14w600),
              context.verticalSpace(8),
              Container(
                padding: context.appEdgeInsets(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: context.appBorderRadius(all: 12),
                  border: Border.all(color: CustomColors.border),
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

  Widget _buildAttachmentsField(
    BuildContext context, 
    List<Attachment> existing, 
    List<PlatformFile> newFiles, 
    VoidCallback onPick, 
    Function(int) onRemoveExisting, 
    Function(int) onRemoveNew
  ) {
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
        if (existing.isEmpty && newFiles.isEmpty)
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
            children: [
              ...List.generate(existing.length, (index) {
                final file = existing[index];
                return _buildFileCard(context, file.name, _buildExistingPreview(context, file), () => onRemoveExisting(index));
              }),
              ...List.generate(newFiles.length, (index) {
                final file = newFiles[index];
                return _buildFileCard(context, file.name, _buildNewPreview(context, file), () => onRemoveNew(index));
              }),
            ],
          ),
      ],
    );
  }

  Widget _buildFileCard(BuildContext context, String name, Widget preview, VoidCallback onRemove) {
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
                child: preview,
              ),
              Positioned(
                top: 2,
                right: 2,
                child: InkWell(
                  onTap: onRemove,
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
            name,
            style: context.fonts.grey10w400,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildExistingPreview(BuildContext context, Attachment file) {
    if (file.type == 'image') {
      return ClipRRect(
        borderRadius: context.appBorderRadius(all: 6),
        child: Image.network(file.url, fit: BoxFit.cover),
      );
    } else if (file.type == 'pdf') {
      return const Icon(Icons.picture_as_pdf_rounded, color: CustomColors.red, size: 32);
    } else if (file.type == 'video') {
      return const Icon(Icons.video_collection_rounded, color: CustomColors.purple, size: 32);
    }
    return const Icon(Icons.insert_drive_file_outlined, color: CustomColors.grey, size: 32);
  }

  Widget _buildNewPreview(BuildContext context, PlatformFile file) {
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

  Widget _buildAreasSection(BuildContext context, TreatmentState state, TreatmentViewModel viewModel, TreatmentDataState dataState) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Body Areas", style: context.fonts.black18w600),
              TextButton.icon(
                onPressed: () => viewModel.addArea(),
                icon: const Icon(Icons.add),
                label: const Text("Add Area"),
              ),
            ],
          ),
          context.verticalSpace(16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.areas.length,
            separatorBuilder: (_, _) => const Divider(height: 32),
            itemBuilder: (context, index) {
              final entry = state.areas[index];
              return Column(
                children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                    if (state.areas.length > 1)
                      IconButton(
                        padding: context.appEdgeInsets(top: 32),
                        onPressed: () => viewModel.removeArea(index),
                        icon: const Icon(Icons.delete_outline, color: CustomColors.red),
                      ),
                  ]),
                  context.verticalSpace(16),
                  _buildSubAreaSection(context, index, entry, viewModel, dataState),
                ],
              );
            },
          ),
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
          hint: "Add sub area",
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
          context.verticalSpace(12),
          Wrap(
            spacing: context.w(8),
            runSpacing: context.h(8),
            children: entry.subAreas.map((sub) => Chip(
              label: Text(sub.name, style: context.fonts.grey13w500),
              onDeleted: () => viewModel.removeSubArea(areaIndex, sub.name),
              backgroundColor: CustomColors.green.withValues(alpha: 0.1),
              side: BorderSide(color: CustomColors.green.withValues(alpha: 0.2)),
            )).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildSubAreaConfigCard(BuildContext context, SubAreaConfig subArea) {
    return Container(
      padding: context.appEdgeInsets(all: 16),
      decoration: BoxDecoration(
        color: CustomColors.whiteGrey,
        borderRadius: context.appBorderRadius(all: 10),
        border: Border.all(color: CustomColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subArea.name, style: context.fonts.grey14w600),
          context.verticalSpace(12),
          Row(
            children: [
              Expanded(
                child: BuildTextField(
                  label: "Max Qty",
                  controller: subArea.maxQuantityController,
                  hintText: "0",
                  keyboardType: TextInputType.number,
                ),
              ),
              context.horizontalSpace(16),
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

  Widget _buildMaterialsAndLogicSection(BuildContext context, TreatmentState state, TreatmentViewModel viewModel, TreatmentDataState dataState) {
    final allSubAreas = state.areas.expand((a) => a.subAreas).toList();

    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Materials & Configuration", style: context.fonts.black18w600),
          context.verticalSpace(24),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: _buildSearchField(
                  context,
                  label: "Material Name",
                  hint: "Select material",
                  controller: viewModel.materialNameController,
                  suggestions: dataState.materials,
                  onSelected: (val) {},
                ),
              ),
              context.horizontalSpace(24),
              Expanded(
                child: BuildTextField(
                  label: "Max Quantity",
                  controller: viewModel.maxMaterialQuantityController,
                  hintText: "0",
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          if (allSubAreas.isNotEmpty) ...[
            context.verticalSpace(32),
            Text("Configuration Per Sub-Area", style: context.fonts.black16w400),
            context.verticalSpace(16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: allSubAreas.length,
              separatorBuilder: (_, _) => context.verticalSpace(12),
              itemBuilder: (context, index) {
                final subArea = allSubAreas[index];
                return _buildSubAreaConfigCard(context, subArea);
              },
            ),
          ],
          context.verticalSpace(32),
          const Divider(),
          context.verticalSpace(24),
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
          context.verticalSpace(32),
          Text("Combinable Treatments", style: context.fonts.black16w400),
          context.verticalSpace(8),
          Text("Select treatments that can be performed alongside this one.", style: context.fonts.grey13w500),
        ],
      ),
    );
  }

  Widget _buildImageTile(BuildContext context, String label, dynamic file, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.fonts.grey14w600),
        context.verticalSpace(10),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: context.h(120),
            width: double.infinity,
            decoration: BoxDecoration(
              color: CustomColors.whiteGrey,
              borderRadius: context.appBorderRadius(all: 12),
              image: file != null ? DecorationImage(
                image: kIsWeb ? NetworkImage(file.path) : FileImage(File(file.path)) as ImageProvider,
                fit: BoxFit.cover,
              ) : null,
            ),
            child: file == null ? const Center(child: Icon(Icons.add_a_photo_outlined, color: CustomColors.grey)) : null,
          ),
        ),
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
        Text(label, style: context.fonts.grey14w600),
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
            final filteredList = suggestions.where((s) => s.toLowerCase().contains(query)).toList();

            return [
              if (searchController.text.isNotEmpty && !suggestions.contains(searchController.text))
                ListTile(
                  title: Text('Use "${searchController.text}"', style: context.fonts.black14w700),
                  onTap: () {
                    controller.text = searchController.text;
                    onSelected(searchController.text);
                    searchController.closeView(searchController.text);
                  },
                ),
              ...filteredList.map((item) => ListTile(
                leading: Container(
                  width: context.w(32),
                  height: context.w(32),
                  decoration: BoxDecoration(color: CustomColors.whiteGrey, borderRadius: context.appBorderRadius(all: 6)),
                  child: const Icon(Icons.circle_outlined, size: 14, color: CustomColors.grey),
                ),
                title: Text(item, style: context.fonts.grey14w400),
                onTap: () {
                  controller.text = item;
                  onSelected(item);
                  searchController.closeView(item);
                },
              )),
            ];
          },
        ),
      ],
    );
  }
}
