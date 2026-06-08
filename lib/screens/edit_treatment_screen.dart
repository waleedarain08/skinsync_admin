import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/product_model.dart';
import 'package:skinsync_admin/utils/dummy_data.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/utils/validators.dart';
import 'package:skinsync_admin/view_models/treatment_data_view_model.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';
import 'package:skinsync_admin/widgets/app_search_field.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';
import 'package:skinsync_admin/widgets/custom_dropdown_widget.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';
import 'package:skinsync_admin/widgets/nested_category_selector.dart';
import 'package:skinsync_admin/widgets/dailogbox/standard_dialog.dart';
import 'package:skinsync_admin/models/treatment_data_models.dart';
import 'package:skinsync_admin/view_models/product_view_model.dart';

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
              viewModel.updateTreatment(context, categories: dataState.categories).then((_) {
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
                _buildNotificationsSection(context, state, viewModel, dataState),
                context.verticalSpace(32),
                _buildDowntimeSection(context, state, viewModel, dataState),
                context.verticalSpace(32),
                _buildRolesSection(context, state, viewModel, dataState),
                context.verticalSpace(32),
                _buildFollowUpEditSection(context, state, viewModel, ref),
                context.verticalSpace(32),
                _buildConsentSection(context, state, viewModel, ref),
                context.verticalSpace(32),
                _buildAreasSection(context, state, viewModel, dataState),
                context.verticalSpace(32),
                _buildProductsUsageSection(context, state, viewModel, ref),
                context.verticalSpace(32),
                _buildLogicSection(context, state, viewModel),
                context.verticalSpace(32),
                _buildPricingSection(context, state, viewModel),
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
          Text("Pre-Treatment Instructions", style: context.fonts.black18w600),
          context.verticalSpace(24),
          BuildTextField(
            label: "Instructions",
            controller: viewModel.preTreatmentInstructionsController,
            hintText: "Detailed instructions...",
            maxLines: 5,
          ),
          context.verticalSpace(32),
          _buildAttachmentsField(
            context, 
            state.existingPreAttachments, 
            state.preTreatmentAttachments, 
            () => viewModel.pickAttachments(true), 
            (idx) => viewModel.removeExistingAttachment(true, idx), 
            (idx) => viewModel.removeAttachment(true, idx)
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
          Text("Post-Treatment Instructions", style: context.fonts.black18w600),
          context.verticalSpace(24),
          BuildTextField(
            label: "Aftercare Guidelines",
            controller: viewModel.postTreatmentInstructionsController,
            hintText: "Detailed instructions...",
            maxLines: 5,
          ),
          context.verticalSpace(32),
          _buildAttachmentsField(
            context, 
            state.existingPostAttachments, 
            state.postTreatmentAttachments, 
            () => viewModel.pickAttachments(false), 
            (idx) => viewModel.removeExistingAttachment(false, idx), 
            (idx) => viewModel.removeAttachment(false, idx)
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsSection(BuildContext context, TreatmentState state, TreatmentViewModel viewModel, TreatmentDataState dataState) {
    CategoryItem? selectedCategory;
    if (viewModel.categoryIdController.text.isNotEmpty) {
      selectedCategory = viewModel.findCategoryById(dataState.categories, viewModel.categoryIdController.text);
    }

    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Phase Notifications", style: context.fonts.black18w600),
          context.verticalSpace(24),
          _expandableSection(
            context,
            title: "Pre-Treatment Notification",
            icon: Icons.notifications_none_rounded,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Notification Source", style: context.fonts.black14w600),
                context.verticalSpace(12),
                Row(
                  children: [
                    _radioOption(context, "Use Category Default", state.preNotificationSource == 'category', () => viewModel.setPreNotificationSource('category')),
                    context.horizontalSpace(32),
                    _radioOption(context, "Create Custom", state.preNotificationSource == 'custom', () => viewModel.setPreNotificationSource('custom')),
                  ],
                ),
                context.verticalSpace(24),
                if (state.preNotificationSource == 'category') ...[
                  _buildNotificationPreview(
                    context,
                    title: "Category Default",
                    message: selectedCategory?.preNotification?.message ?? "No message defined in category.",
                    timing: selectedCategory?.preNotification?.timing != null ? "${selectedCategory!.preNotification!.timing} Hours Before" : "Not set",
                  ),
                ] else ...[
                  BuildTextField(
                    label: "Notification Title",
                    controller: viewModel.preNotificationTitleController,
                    hintText: "Enter title...",
                  ),
                  context.verticalSpace(20),
                  BuildTextField(
                    label: "Notification Description",
                    controller: viewModel.preNotificationDescriptionController,
                    hintText: "Enter description...",
                    maxLines: 3,
                  ),
                  context.verticalSpace(20),
                  _buildOffsetDropdown(
                    context,
                    label: "Reminder Timing",
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
              ],
            ),
          ),
          context.verticalSpace(24),
          _expandableSection(
            context,
            title: "Post-Treatment Notification",
            icon: Icons.notifications_active_outlined,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Notification Source", style: context.fonts.black14w600),
                context.verticalSpace(12),
                Row(
                  children: [
                    _radioOption(context, "Use Category Default", state.postNotificationSource == 'category', () => viewModel.setPostNotificationSource('category')),
                    context.horizontalSpace(32),
                    _radioOption(context, "Create Custom", state.postNotificationSource == 'custom', () => viewModel.setPostNotificationSource('custom')),
                  ],
                ),
                context.verticalSpace(24),
                if (state.postNotificationSource == 'category') ...[
                  _buildNotificationPreview(
                    context,
                    title: "Category Default",
                    message: selectedCategory?.postNotification?.message ?? "No message defined in category.",
                    timing: selectedCategory?.postNotification?.timing != null ? "${selectedCategory!.postNotification!.timing} Hours After" : "Not set",
                  ),
                ] else ...[
                  BuildTextField(
                    label: "Notification Title",
                    controller: viewModel.postNotificationTitleController,
                    hintText: "Enter title...",
                  ),
                  context.verticalSpace(20),
                  BuildTextField(
                    label: "Notification Description",
                    controller: viewModel.postNotificationDescriptionController,
                    hintText: "Enter description...",
                    maxLines: 3,
                  ),
                  context.verticalSpace(20),
                  _buildOffsetDropdown(
                    context,
                    label: "Engagement Timing",
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationPreview(BuildContext context, {required String title, required String message, required String timing}) {
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
                decoration: BoxDecoration(color: CustomColors.purple.withValues(alpha: 0.1), borderRadius: context.appBorderRadius(all: 4)),
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

  Widget _buildDowntimeSection(BuildContext context, TreatmentState state, TreatmentViewModel viewModel, TreatmentDataState dataState) {
    CategoryItem? selectedCategory;
    if (viewModel.categoryIdController.text.isNotEmpty) {
      selectedCategory = viewModel.findCategoryById(dataState.categories, viewModel.categoryIdController.text);
    }
    final presets = selectedCategory?.downtimePresets ?? DowntimePresets();

    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Downtime Level", style: context.fonts.black18w600),
          context.verticalSpace(24),
          _downtimeOption(context, "None", "${presets.none} Days", state.downtimeLevel == 'None', () => viewModel.setDowntimeLevel('None')),
          context.verticalSpace(16),
          _downtimeOption(context, "Low", "${presets.low} Days", state.downtimeLevel == 'Low', () => viewModel.setDowntimeLevel('Low')),
          context.verticalSpace(16),
          _downtimeOption(context, "Moderate", "${presets.moderate} Days", state.downtimeLevel == 'Moderate', () => viewModel.setDowntimeLevel('Moderate')),
          context.verticalSpace(16),
          _downtimeOption(context, "High", "${presets.high} Days", state.downtimeLevel == 'High', () => viewModel.setDowntimeLevel('High')),
        ],
      ),
    );
  }

  Widget _downtimeOption(BuildContext context, String title, String duration, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: context.appBorderRadius(all: 12),
      child: Container(
        padding: context.appEdgeInsets(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? CustomColors.purple.withValues(alpha: 0.05) : Colors.white,
          borderRadius: context.appBorderRadius(all: 12),
          border: Border.all(color: isSelected ? CustomColors.purple : CustomColors.border, width: isSelected ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Text(title, style: context.fonts.black16w600),
            const Spacer(),
            Text(duration, style: context.fonts.purple14w700),
            context.horizontalSpace(16),
            Icon(isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded, color: isSelected ? CustomColors.purple : CustomColors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildRolesSection(BuildContext context, TreatmentState state, TreatmentViewModel viewModel, TreatmentDataState dataState) {
    CategoryItem? selectedCategory;
    if (viewModel.categoryIdController.text.isNotEmpty) {
      selectedCategory = viewModel.findCategoryById(dataState.categories, viewModel.categoryIdController.text);
    }
    final List<String> availableRoles = ["Injector", "Aesthetician", "MD", "Nurse", "Specialist"];
    final List<String> categoryRoles = selectedCategory?.defaultRoles ?? [];

    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Allowed Provider Roles", style: context.fonts.black18w600),
          context.verticalSpace(24),
          Row(
            children: [
              _radioOption(context, "Use Category Defaults", state.providerRolesSource == 'category', () {
                viewModel.setProviderRolesSource('category');
                viewModel.setRoles(categoryRoles);
              }),
              context.horizontalSpace(32),
              _radioOption(context, "Define Custom Roles", state.providerRolesSource == 'custom', () => viewModel.setProviderRolesSource('custom')),
            ],
          ),
          context.verticalSpace(32),
          if (state.providerRolesSource == 'category') ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categoryRoles.map((role) => Chip(label: Text(role), backgroundColor: CustomColors.purple.withOpacity(0.1))).toList(),
            ),
          ] else ...[
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: availableRoles.map((role) {
                final isSelected = state.selectedRoles.contains(role);
                return FilterChip(
                  label: Text(role),
                  selected: isSelected,
                  onSelected: (_) => viewModel.toggleRole(role),
                  selectedColor: CustomColors.purple.withOpacity(0.2),
                  checkmarkColor: CustomColors.purple,
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFollowUpEditSection(BuildContext context, TreatmentState state, TreatmentViewModel viewModel, WidgetRef ref) {
    final dataState = ref.watch(treatmentDataViewModelProvider);
    CategoryItem? selectedCategory;
    if (viewModel.categoryIdController.text.isNotEmpty) {
      selectedCategory = viewModel.findCategoryById(dataState.categories, viewModel.categoryIdController.text);
    }

    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Follow-Up Configuration", style: context.fonts.black18w600),
          context.verticalSpace(24),
          Row(
            children: [
              _radioOption(context, "Active Follow-Up", state.isFollowUpRequired, () => viewModel.toggleFollowUpRequired(true)),
              context.horizontalSpace(32),
              _radioOption(context, "No Follow-Up", !state.isFollowUpRequired, () => viewModel.toggleFollowUpRequired(false)),
            ],
          ),
          if (state.isFollowUpRequired) ...[
            context.verticalSpace(32),
            Text("Configuration Source", style: context.fonts.black16w600),
            context.verticalSpace(16),
            Row(
              children: [
                _radioOption(
                  context, 
                  "Use Category Default", 
                  state.followUpSource == 'category', 
                  () => viewModel.setFollowUpSource('category')
                ),
                context.horizontalSpace(32),
                _radioOption(
                  context, 
                  "Treatment-Specific", 
                  state.followUpSource == 'custom', 
                  () => viewModel.setFollowUpSource('custom')
                ),
              ],
            ),
            context.verticalSpace(32),
            if (state.followUpSource == 'category') ...[
              _buildCategoryFollowUpPreview(context, selectedCategory),
            ] else ...[
              BuildTextField(
                label: "Total Follow-Ups",
                controller: viewModel.totalFollowUpsController,
                hintText: "e.g. 1",
                keyboardType: TextInputType.number,
                onChanged: (String? val) => viewModel.updateFollowUpCount(val ?? ''),
              ),
              context.verticalSpace(24),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.followUpEntries.length,
                separatorBuilder: (_, __) => context.verticalSpace(20),
                itemBuilder: (context, index) {
                  return _buildFollowUpEntryCard(context, index, state.followUpEntries[index], viewModel);
                },
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryFollowUpPreview(BuildContext context, CategoryItem? category) {
    final configs = category?.defaultFollowUps ?? [];

    return Container(
      width: double.infinity,
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
              const Icon(Icons.info_outline_rounded, color: CustomColors.purple, size: 20),
              context.horizontalSpace(12),
              Text("Inherited from ${category?.name ?? 'Category'}", style: context.fonts.black14w600),
            ],
          ),
          context.verticalSpace(16),
          if (configs.isEmpty)
            Text("No default follow-ups configured for this category.", style: context.fonts.grey14w400)
          else
            ...configs.asMap().entries.map((entry) {
              final idx = entry.key + 1;
              final config = entry.value;
              return Padding(
                padding: context.appEdgeInsets(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(color: CustomColors.purple, shape: BoxShape.circle),
                    ),
                    context.horizontalSpace(12),
                    Expanded(
                      child: Text(
                        "Follow-Up $idx: ${config.type.toUpperCase()} - ${config.durationValue} ${config.durationUnit} (${config.intervalValue} ${config.intervalUnit} after)",
                        style: context.fonts.black14w400,
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

  Widget _buildFollowUpEntryCard(BuildContext context, int index, FollowUpEntry entry, TreatmentViewModel viewModel) {
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
          Text("Follow-Up ${index + 1}", style: context.fonts.purple12w700),
          context.verticalSpace(16),
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
              context.horizontalSpace(20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Duration", style: context.fonts.black14w600),
                    context.verticalSpace(8),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: BuildTextField(
                            label: "",
                            controller: entry.durationValueController,
                            hintText: "30",
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        context.horizontalSpace(8),
                        Expanded(
                          flex: 3,
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
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          context.verticalSpace(16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Interval", style: context.fonts.black14w600),
                    context.verticalSpace(8),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: BuildTextField(
                            label: "",
                            controller: entry.intervalValueController,
                            hintText: "1",
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        context.horizontalSpace(8),
                        Expanded(
                          flex: 3,
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
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
          context.verticalSpace(16),
          BuildTextField(
            label: "Notes",
            controller: entry.notesController,
            hintText: "Clinical notes...",
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildConsentSection(BuildContext context, TreatmentState state, TreatmentViewModel viewModel, WidgetRef ref) {
    final dataState = ref.watch(treatmentDataViewModelProvider);
    CategoryItem? selectedCategory;
    if (viewModel.categoryIdController.text.isNotEmpty) {
      selectedCategory = viewModel.findCategoryById(dataState.categories, viewModel.categoryIdController.text);
    }

    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Patient Consent Form", style: context.fonts.black18w600),
          context.verticalSpace(24),
          Row(
            children: [
              _radioOption(context, "Use Category Default", state.consentType == 'category', () => viewModel.setConsentType('category')),
              context.horizontalSpace(32),
              _radioOption(context, "Upload Custom Form", state.consentType == 'custom', () => viewModel.setConsentType('custom')),
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
                          selectedCategory?.consentFormName ?? "No default form found.",
                          style: context.fonts.grey12w400,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            _buildConsentFormSection(context, state.preTreatmentConsentForm, state.existingConsentForm, () => viewModel.pickConsentForm(), () => viewModel.removeConsentForm()),
          ],
        ],
      ),
    );
  }

  Widget _buildProductsUsageSection(BuildContext context, TreatmentState state, TreatmentViewModel viewModel, WidgetRef ref) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Inventory Products", style: context.fonts.black18w600),
          context.verticalSpace(24),
          _buildProductSelector(context, viewModel, state),
          if (state.productUsageEntries.isNotEmpty) ...[
            context.verticalSpace(32),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.productUsageEntries.length,
              separatorBuilder: (_, __) => context.verticalSpace(24),
              itemBuilder: (context, index) {
                return _buildProductUsageCard(context, index, state.productUsageEntries[index], viewModel);
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProductSelector(BuildContext context, TreatmentViewModel viewModel, TreatmentState state) {
    final inventoryProducts = TreatmentData.dummyInventoryProducts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select Product from Inventory", style: context.fonts.black14w600),
        context.verticalSpace(10),
        SearchAnchor(
          viewHintText: "Search inventory...",
          builder: (context, controller) => AppSearchField(
            controller: controller,
            readOnly: true,
            onTap: () => controller.openView(),
            hintText: "Select product from inventory",
            suffixIcon: const Icon(Icons.add_circle_outline_rounded, color: CustomColors.purple),
            maxWidth: double.infinity,
          ),
          suggestionsBuilder: (context, controller) {
            final query = controller.text.toLowerCase();
            final filtered = inventoryProducts.where((p) => p.name.toLowerCase().contains(query)).toList();
            
            return filtered.map((p) => ListTile(
              title: Text(p.name),
              subtitle: Text("${p.category} • Unit: ${p.unit}"),
              onTap: () {
                viewModel.addProductUsage(p.id!, p.name, p.unit);
                controller.closeView(p.name);
              },
            )).toList();
          },
        ),
      ],
    );
  }

  Widget _buildProductUsageCard(BuildContext context, int index, ProductUsageEntry entry, TreatmentViewModel viewModel) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.productName, style: context.fonts.black14w700),
                  Text("Unit of Measure: ${entry.unit}", style: context.fonts.grey12w400),
                ],
              ),
              IconButton(
                onPressed: () => viewModel.removeProductUsage(entry.productId),
                icon: const Icon(Icons.delete_outline, color: CustomColors.red, size: 20),
              ),
            ],
          ),
          context.verticalSpace(20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomDropdown<String>(
                  label: "Usage Type",
                  hintText: "Select",
                  value: entry.usageType,
                  items: const [
                    DropdownMenuItem(value: 'Required', child: Text("Required")),
                    DropdownMenuItem(value: 'Optional', child: Text("Optional")),
                    DropdownMenuItem(value: 'Variable', child: Text("Variable")),
                    DropdownMenuItem(value: 'Setup', child: Text("Setup")),
                    DropdownMenuItem(value: 'Post_Care', child: Text("Post Care")),
                    DropdownMenuItem(value: 'Device', child: Text("Device")),
                  ],
                  onChanged: (val) => viewModel.updateProductUsageEntry(index, usageType: val),
                ),
              ),
              context.horizontalSpace(16),
              Expanded(
                child: CustomDropdown<String>(
                  label: "Deduction Timing",
                  hintText: "Select",
                  value: entry.deductionTiming,
                  items: const [
                    DropdownMenuItem(value: 'On_Completion', child: Text("On Completion")),
                    DropdownMenuItem(value: 'Manual', child: Text("Manual")),
                    DropdownMenuItem(value: 'Post_Confirmation', child: Text("Post Confirmation")),
                  ],
                  onChanged: (val) => viewModel.updateProductUsageEntry(index, deductionTiming: val),
                ),
              ),
            ],
          ),
          context.verticalSpace(20),
          Row(
            children: [
              Expanded(
                child: BuildTextField(
                  label: "Min Quantity",
                  controller: entry.minQuantityController,
                  hintText: "0",
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              context.horizontalSpace(16),
              Expanded(
                child: BuildTextField(
                  label: "Max Quantity",
                  controller: entry.maxQuantityController,
                  hintText: "0",
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
            ],
          ),
          context.verticalSpace(20),
          Row(
            children: [
              SizedBox(
                width: context.w(24),
                height: context.w(24),
                child: Checkbox(
                  value: entry.allowSubstitution,
                  onChanged: (val) => viewModel.updateProductUsageEntry(index, allowSubstitution: val),
                  shape: RoundedRectangleBorder(borderRadius: context.appBorderRadius(all: 4)),
                ),
              ),
              context.horizontalSpace(12),
              Text("Allow Product Substitution", style: context.fonts.black14w600),
            ],
          ),
          context.verticalSpace(20),
          BuildTextField(
            label: "Usage Notes (Optional)",
            controller: entry.notesController,
            hintText: "Clinical instructions or restrictions...",
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildLogicSection(BuildContext context, TreatmentState state, TreatmentViewModel viewModel) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Business Logic", style: context.fonts.black18w600),
          context.verticalSpace(24),
          Row(
            children: [
              SizedBox(
                width: context.w(24),
                height: context.w(24),
                child: Checkbox(
                  value: state.enableByDefault,
                  onChanged: (val) => viewModel.toggleEnableByDefault(val),
                  shape: RoundedRectangleBorder(borderRadius: context.appBorderRadius(all: 4)),
                ),
              ),
              context.horizontalSpace(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Enable by Default for New Clinics", style: context.fonts.black16w400),
                    Text("Newly onboarded clinics will have this treatment assigned automatically.", style: context.fonts.grey12w400),
                  ],
                ),
              ),
            ],
          ),
          context.verticalSpace(32),
          const Divider(),
          context.verticalSpace(32),
          Text("AI Simulator Compatibility", style: context.fonts.black16w600),
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
      ),
    );
  }

  Widget _buildPricingSection(BuildContext context, TreatmentState state, TreatmentViewModel viewModel) {
    final allSubAreas = state.areas.expand((a) => a.subAreas).toList();

    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Pricing Setup", style: context.fonts.black18w600),
          context.verticalSpace(24),
          BuildTextField(
            label: "Treatment Base Price (\$)",
            controller: viewModel.basePriceController,
            hintText: "100",
            keyboardType: TextInputType.number,
          ),
          if (allSubAreas.isNotEmpty) ...[
            context.verticalSpace(32),
            Text("Sub-Area Pricing Adjustments", style: context.fonts.black16w400),
            context.verticalSpace(16),
            ...allSubAreas.map((subArea) => Padding(
              padding: context.appEdgeInsets(bottom: 12),
              child: _buildSubAreaConfigCard(context, subArea),
            )),
          ],
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
          BuildTextField(
            label: "Base Price (\$)",
            controller: subArea.basePriceController,
            hintText: "0",
            keyboardType: TextInputType.number,
          ),
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

  Widget _buildConsentFormSection(BuildContext context, PlatformFile? file, Attachment? existing, VoidCallback onPick, VoidCallback onRemove) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Patient Consent Form (PDF)", style: context.fonts.black14w600),
        context.verticalSpace(12),
        if (file == null && existing == null)
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
                      Text(file?.name ?? existing?.name ?? "Consent Form", style: context.fonts.black14w600, maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text(file != null ? "${(file.size / 1024).toStringAsFixed(1)} KB" : "Existing PDF", style: context.fonts.grey12w400),
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

  Widget _buildOffsetDropdown(BuildContext context, {required String label, required int? value, required Map<int, String> options, required Function(int?) onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.fonts.black14w600),
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
              value: value,
              isExpanded: true,
              items: options.entries.map((e) => DropdownMenuItem<int>(value: e.key, child: Text(e.value))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
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
      child: ExpansionTile(
        initiallyExpanded: true,
        leading: Icon(icon, color: CustomColors.purple),
        title: Text(title, style: context.fonts.black16w600),
        children: [
          Padding(
            padding: context.appEdgeInsets(all: 20),
            child: content,
          ),
        ],
      ),
    );
  }
}
