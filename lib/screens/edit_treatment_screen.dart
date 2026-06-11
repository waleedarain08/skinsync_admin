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
                _buildCategorizationSection(context, state, viewModel, dataState),
                context.verticalSpace(32),
                _buildBasicDetailsSection(context, state, viewModel),
                context.verticalSpace(32),
                _buildAreasSection(context, state, viewModel, dataState),
                context.verticalSpace(32),
                _buildProductsUsageSection(context, state, viewModel, ref),
                context.verticalSpace(32),
                _buildPricingSection(context, state, viewModel),
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
                _buildSessionsSection(context, state, viewModel, dataState),
                context.verticalSpace(32),
                _buildFollowUpEditSection(context, state, viewModel, ref),
                context.verticalSpace(32),
                _buildConsentSection(context, state, viewModel, ref),
                context.verticalSpace(32),
                _buildLogicSection(context, state, viewModel),
                context.verticalSpace(48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _validateForm(BuildContext context, TreatmentViewModel viewModel, TreatmentState state) {
    final skuError = viewModel.validateGlobalSku(viewModel.globalSkuController.text.trim(), currentTreatmentId: state.selectedTreatment?.id);
    if (skuError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(skuError), backgroundColor: CustomColors.red),
      );
      return false;
    }
    if (viewModel.displayNameController.text.isEmpty ||
        viewModel.basePriceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields"), backgroundColor: CustomColors.red),
      );
      return false;
    }
    if (!_validateProductQuantities(context, state)) {
      return false;
    }
    return true;
  }

  bool _validateProductQuantities(BuildContext context, TreatmentState state) {
    final allSubAreas = state.areas.expand((a) => a.subAreas).toList();
    for (var entry in state.productUsageEntries) {
      if (allSubAreas.isNotEmpty) {
        for (var subArea in allSubAreas) {
          final controllers = entry.getControllersForSubArea(subArea.name);
          final minVal = double.tryParse(controllers.minController.text) ?? 0.0;
          final maxVal = double.tryParse(controllers.maxController.text) ?? 0.0;
          if (minVal < 1 || maxVal < 1) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Quantity for ${entry.productName} in ${subArea.name} must be greater than or equal to 1."),
                backgroundColor: CustomColors.red,
              ),
            );
            return false;
          }
          if (maxVal < minVal) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Maximum Quantity must be greater than or equal to Minimum Quantity for ${entry.productName} in ${subArea.name}."),
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
              content: Text("Quantity for ${entry.productName} must be greater than or equal to 1."),
              backgroundColor: CustomColors.red,
            ),
          );
          return false;
        }
        if (maxVal < minVal) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Maximum Quantity must be greater than or equal to Minimum Quantity for ${entry.productName}."),
              backgroundColor: CustomColors.red,
            ),
          );
          return false;
        }
      }
    }
    return true;
  }

  double _getProductMinQuantity(ProductUsageEntry entry, List<SubAreaConfig> allSubAreas) {
    if (allSubAreas.isNotEmpty) {
      double sum = 0.0;
      for (var subArea in allSubAreas) {
        final controllers = entry.getControllersForSubArea(subArea.name);
        sum += double.tryParse(controllers.minController.text) ?? 0.0;
      }
      return sum;
    } else {
      return double.tryParse(entry.minQuantityController.text) ?? 0.0;
    }
  }

  double _getProductMaxQuantity(ProductUsageEntry entry, List<SubAreaConfig> allSubAreas) {
    if (allSubAreas.isNotEmpty) {
      double sum = 0.0;
      for (var subArea in allSubAreas) {
        final controllers = entry.getControllersForSubArea(subArea.name);
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
    for (var entry in state.productUsageEntries) {
      final minQty = _getProductMinQuantity(entry, allSubAreas);
      final perUnit = double.tryParse(entry.perUnitDurationController.text) ?? 0.0;
      total += minQty * perUnit;
    }
    return total;
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
                  label: "Global SKU (Treatment Identifier)",
                  controller: viewModel.globalSkuController,
                  hintText: "e.g. TRT-XXXX-XXXX",
                  readOnly: true,
                  tooltip: "Global SKU is a unique identifier used across all clinics and systems and cannot be changed after creation.",
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
                  onChanged: (val) {
                    viewModel.updateProductPerUnitDuration(0, "");
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
                  onChanged: (val) {
                    viewModel.updateProductPerUnitDuration(0, "");
                  },
                ),
              ),
            ],
          ),
          context.verticalSpace(24),
          Row(
            children: [
              Expanded(
                child: BuildTextField(
                  label: "Preparation Time (Minutes)",
                  controller: viewModel.prepTimeController,
                  hintText: "e.g. 10",
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    viewModel.updateProductPerUnitDuration(0, "");
                  },
                ),
              ),
              context.horizontalSpace(24),
              Expanded(
                child: BuildTextField(
                  label: "Finish / Cleanup Time (Minutes)",
                  controller: viewModel.cleanupTimeController,
                  hintText: "e.g. 5",
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    viewModel.updateProductPerUnitDuration(0, "");
                  },
                ),
              ),
            ],
          ),
          context.verticalSpace(24),
          // Display Calculated Total Duration
          Builder(
            builder: (context) {
              final hours = double.tryParse(viewModel.durationHoursController.text) ?? 0.0;
              final minutes = double.tryParse(viewModel.durationMinutesController.text) ?? 0.0;
              final baseDuration = hours * 60 + minutes;
              final productDuration = _calculateProductUsageDuration(state);
              final prepTime = double.tryParse(viewModel.prepTimeController.text) ?? 0.0;
              final cleanupTime = double.tryParse(viewModel.cleanupTimeController.text) ?? 0.0;
              final totalDuration = baseDuration + productDuration + prepTime + cleanupTime;
              
              return Container(
                padding: context.appEdgeInsets(all: 16),
                decoration: BoxDecoration(
                  color: CustomColors.purple.withValues(alpha: 0.05),
                  borderRadius: context.appBorderRadius(all: 10),
                  border: Border.all(color: CustomColors.purple.withValues(alpha: 0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Base Duration:", style: context.fonts.black14w600),
                        Text("${baseDuration.toStringAsFixed(baseDuration % 1 == 0 ? 0 : 1)} Minutes", style: context.fonts.black14w600),
                      ],
                    ),
                    context.verticalSpace(8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Product Usage Duration:", style: context.fonts.black14w400),
                        Text("${productDuration.toStringAsFixed(productDuration % 1 == 0 ? 0 : 1)} Minutes", style: context.fonts.purple14w700),
                      ],
                    ),
                    context.verticalSpace(8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Preparation Time:", style: context.fonts.black14w400),
                        Text("${prepTime.toStringAsFixed(prepTime % 1 == 0 ? 0 : 1)} Minutes", style: context.fonts.black14w600),
                      ],
                    ),
                    context.verticalSpace(8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Cleanup Time:", style: context.fonts.black14w400),
                        Text("${cleanupTime.toStringAsFixed(cleanupTime % 1 == 0 ? 0 : 1)} Minutes", style: context.fonts.black14w600),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Divider(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Calculated Total Duration:", style: context.fonts.purple14w700),
                        Text("${totalDuration.toStringAsFixed(totalDuration % 1 == 0 ? 0 : 1)} Minutes", style: context.fonts.purple16w700),
                      ],
                    ),
                  ],
                ),
              );
            }
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
                    message: (selectedCategory?.preNotifications.isNotEmpty ?? false) 
                        ? selectedCategory!.preNotifications.first.message ?? "No message defined in category." 
                        : "No message defined in category.",
                    timing: (selectedCategory?.preNotifications.isNotEmpty ?? false) 
                        ? "${selectedCategory!.preNotifications.first.timing ?? 0} Hours Before" 
                        : "Not set",
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
                    message: (selectedCategory?.postNotifications.isNotEmpty ?? false) 
                        ? selectedCategory!.postNotifications.first.message ?? "No message defined in category." 
                        : "No message defined in category.",
                    timing: (selectedCategory?.postNotifications.isNotEmpty ?? false) 
                        ? "${selectedCategory!.postNotifications.first.timing ?? 0} Hours After" 
                        : "Not set",
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

  Widget _buildSessionsSection(BuildContext context, TreatmentState state, TreatmentViewModel viewModel, TreatmentDataState dataState) {
    CategoryItem? selectedCategory;
    if (viewModel.categoryIdController.text.isNotEmpty) {
      selectedCategory = viewModel.findCategoryById(dataState.categories, viewModel.categoryIdController.text);
    }
    final int categorySessions = selectedCategory?.totalSessions ?? 1;

    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Sessions Configuration", style: context.fonts.black18w600),
          context.verticalSpace(24),
          Row(
            children: [
              _radioOption(
                context, 
                "Use Category Sessions ($categorySessions)", 
                state.sessionSource == 'category', 
                () {
                  viewModel.setSessionSource('category', category: selectedCategory);
                }
              ),
              context.horizontalSpace(32),
              _radioOption(
                context, 
                "Custom Session Count", 
                state.sessionSource == 'custom', 
                () => viewModel.setSessionSource('custom')
              ),
            ],
          ),
          if (state.sessionSource == 'custom') ...[
            context.verticalSpace(32),
            BuildTextField(
              label: "Total Sessions",
              controller: viewModel.totalSessionsController,
              hintText: "e.g. 3",
              keyboardType: TextInputType.number,
              onChanged: (val) => viewModel.setTotalSessions(val ?? '1'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFollowUpEditSection(BuildContext context, TreatmentState state, TreatmentViewModel viewModel, WidgetRef ref) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Follow-Up Configuration", style: context.fonts.black18w600),
          context.verticalSpace(8),
          Text("Configure session-scoped follow-ups.", style: context.fonts.grey14w400),
          context.verticalSpace(32),
          
          ...state.sessions.asMap().entries.map((sessionEntry) {
            final int sIdx = sessionEntry.key;
            final session = sessionEntry.value;
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: context.appEdgeInsets(all: 16),
                  decoration: BoxDecoration(
                    color: CustomColors.purple.withValues(alpha: 0.05),
                    borderRadius: context.appBorderRadius(all: 12),
                  ),
                  child: Row(
                    children: [
                      Text("SESSION ${session.sessionNumber}", style: context.fonts.purple14w700),
                      const Spacer(),
                      SizedBox(
                        width: context.w(150),
                        child: BuildTextField(
                          label: "Follow-Ups",
                          controller: session.totalFollowUpsController,
                          hintText: "0",
                          keyboardType: TextInputType.number,
                          onChanged: (val) => viewModel.updateSessionFollowUpCount(sIdx, val ?? '0'),
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
                    separatorBuilder: (_, __) => context.verticalSpace(16),
                    itemBuilder: (context, fuIdx) {
                      return _buildFollowUpEntryCardV2(context, sIdx, fuIdx, session.followUps[fuIdx], viewModel);
                    },
                  ),
                ],
                context.verticalSpace(24),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFollowUpEntryCardV2(BuildContext context, int sIdx, int fuIdx, FollowUpEntry entry, TreatmentViewModel viewModel) {
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
          Text("S${sIdx + 1} - Follow-Up ${fuIdx + 1}", style: context.fonts.purple12w700),
          context.verticalSpace(20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomDropdown<String>(
                  label: "Type",
                  hintText: "Select type",
                  value: entry.type,
                  items: const [
                    DropdownMenuItem(value: 'virtual', child: Text("Virtual")),
                    DropdownMenuItem(value: 'in_person', child: Text("In-Person")),
                  ],
                  onChanged: (val) => viewModel.updateSessionFollowUpEntry(sIdx, fuIdx, type: val),
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
                          child: TextFormField(
                            controller: entry.durationValueController,
                            keyboardType: TextInputType.number,
                            decoration: AppDecorations.input(context, hint: "30"),
                            onChanged: (v) => viewModel.updateSessionFollowUpEntry(sIdx, fuIdx),
                          ),
                        ),
                        context.horizontalSpace(12),
                        Expanded(
                          flex: 3,
                          child: DropdownButtonHideUnderline(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: CustomColors.border),
                              ),
                              child: DropdownButton<String>(
                                value: entry.durationUnit,
                                isExpanded: true,
                                icon: const Icon(Icons.arrow_drop_down, color: CustomColors.grey),
                                items: const [
                                  DropdownMenuItem(value: 'minutes', child: Text("Minutes")),
                                  DropdownMenuItem(value: 'hours', child: Text("Hours")),
                                ],
                                onChanged: (val) => viewModel.updateSessionFollowUpEntry(sIdx, fuIdx, durationUnit: val),
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
                    Text("Interval", style: context.fonts.black14w600),
                    context.verticalSpace(10),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: entry.intervalValueController,
                            keyboardType: TextInputType.number,
                            decoration: AppDecorations.input(context, hint: "1"),
                            onChanged: (v) => viewModel.updateSessionFollowUpEntry(sIdx, fuIdx),
                          ),
                        ),
                        context.horizontalSpace(12),
                        Expanded(
                          flex: 3,
                          child: DropdownButtonHideUnderline(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: CustomColors.border),
                              ),
                              child: DropdownButton<String>(
                                value: entry.intervalUnit,
                                isExpanded: true,
                                icon: const Icon(Icons.arrow_drop_down, color: CustomColors.grey),
                                items: const [
                                  DropdownMenuItem(value: 'days', child: Text("Days After")),
                                  DropdownMenuItem(value: 'weeks', child: Text("Weeks After")),
                                ],
                                onChanged: (val) => viewModel.updateSessionFollowUpEntry(sIdx, fuIdx, intervalUnit: val),
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
                    Text("Requirements", style: context.fonts.black14w600),
                    context.verticalSpace(10),
                    Container(
                      padding: context.appEdgeInsets(horizontal: 12, vertical: 4),
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
                            onChanged: (val) => viewModel.updateSessionFollowUpEntry(
                              sIdx, 
                              fuIdx, 
                              isImageRequired: val ?? false,
                            ),
                          ),
                          Text("Image Required", style: context.fonts.black14w600),
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
                return _buildProductUsageCard(context, index, state.productUsageEntries[index], viewModel, state);
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

  Widget _buildProductUsageCard(BuildContext context, int index, ProductUsageEntry entry, TreatmentViewModel viewModel, TreatmentState state) {
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
            label: "Per ${entry.unit} Duration (Minutes)",
            controller: entry.perUnitDurationController,
            hintText: "e.g. 0.5",
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (val) {
              viewModel.updateProductPerUnitDuration(index, val ?? "");
            },
          ),
          context.verticalSpace(20),
          BuildTextField(
            label: "Usage Notes (Optional)",
            controller: entry.notesController,
            hintText: "Clinical instructions or restrictions...",
            maxLines: 2,
          ),
          if (allSubAreas.isNotEmpty) ...[
            context.verticalSpace(24),
            const Divider(),
            context.verticalSpace(16),
            Text("Sub-Area Consumption Ranges", style: context.fonts.black14w600),
            context.verticalSpace(4),
            Text("Define clinical product ranges for each configured sub-area.", style: context.fonts.grey12w400),
            context.verticalSpace(16),
            ...allSubAreas.map((subArea) {
              final controllers = entry.getControllersForSubArea(subArea.name);
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
                          const Icon(Icons.subdirectory_arrow_right, size: 16, color: CustomColors.purple),
                          context.horizontalSpace(8),
                          Text(subArea.name, style: context.fonts.black14w600),
                        ],
                      ),
                      context.verticalSpace(12),
                      Row(
                        children: [
                          Expanded(
                            child: BuildTextField(
                              label: "Min $pluralUnit",
                              controller: controllers.minController,
                              hintText: "1",
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              onChanged: (val) {
                                viewModel.updateProductPerUnitDuration(index, "");
                              },
                            ),
                          ),
                          context.horizontalSpace(16),
                          Expanded(
                            child: BuildTextField(
                              label: "Max $pluralUnit",
                              controller: controllers.maxController,
                              hintText: "1",
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              onChanged: (val) {
                                viewModel.updateProductPerUnitDuration(index, "");
                              },
                            ),
                          ),
                        ],
                      ),
                      Builder(
                        builder: (context) {
                          final minVal = double.tryParse(controllers.minController.text) ?? 0.0;
                          final maxVal = double.tryParse(controllers.maxController.text) ?? 0.0;
                          if (minVal < 1 || maxVal < 1) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text(
                                "Quantity must be greater than or equal to 1.",
                                style: TextStyle(color: CustomColors.red, fontSize: 12),
                              ),
                            );
                          }
                          if (maxVal < minVal) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text(
                                "Maximum Quantity must be greater than or equal to Minimum Quantity.",
                                style: TextStyle(color: CustomColors.red, fontSize: 12),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        }
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ] else ...[
            context.verticalSpace(24),
            const Divider(),
            context.verticalSpace(16),
            Text("Product Consumption Range", style: context.fonts.black14w600),
            context.verticalSpace(16),
            Row(
              children: [
                Expanded(
                  child: BuildTextField(
                    label: "Min ${formatUnitPlural(entry.unit)}",
                    controller: entry.minQuantityController,
                    hintText: "1",
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (val) {
                      viewModel.updateProductPerUnitDuration(index, "");
                    },
                  ),
                ),
                context.horizontalSpace(16),
                Expanded(
                  child: BuildTextField(
                    label: "Max ${formatUnitPlural(entry.unit)}",
                    controller: entry.maxQuantityController,
                    hintText: "1",
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (val) {
                      viewModel.updateProductPerUnitDuration(index, "");
                    },
                  ),
                ),
              ],
            ),
            Builder(
              builder: (context) {
                final minVal = double.tryParse(entry.minQuantityController.text) ?? 0.0;
                final maxVal = double.tryParse(entry.maxQuantityController.text) ?? 0.0;
                if (minVal < 1 || maxVal < 1) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Quantity must be greater than or equal to 1.",
                      style: TextStyle(color: CustomColors.red, fontSize: 12),
                    ),
                  );
                }
                if (maxVal < minVal) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Maximum Quantity must be greater than or equal to Minimum Quantity.",
                      style: TextStyle(color: CustomColors.red, fontSize: 12),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }
            ),
          ],
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
    final uniqueUnits = state.productUsageEntries
        .map((e) => e.unit)
        .where((unit) => unit.trim().isNotEmpty)
        .toSet()
        .toList();

    String formatUnitLabel(String unit) {
      if (unit.isEmpty) return '';
      return unit[0].toUpperCase() + unit.substring(1);
    }

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
          if (uniqueUnits.isNotEmpty) ...[
            context.verticalSpace(32),
            Text("Unit-Based Pricing Overrides", style: context.fonts.black16w400),
            context.verticalSpace(8),
            Text("Define dynamic pricing overrides for each unit of measure from the selected inventory products.", style: context.fonts.grey14w400),
            context.verticalSpace(24),
            Container(
              padding: context.appEdgeInsets(all: 16),
              decoration: BoxDecoration(
                color: CustomColors.whiteGrey,
                borderRadius: context.appBorderRadius(all: 10),
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
                      label: "Price Per $formattedUnit (\$)",
                      controller: viewModel.getControllerForUnit(unit),
                      hintText: "0",
                      keyboardType: TextInputType.number,
                    ),
                  );
                }).toList(),
              ),
            ),
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
