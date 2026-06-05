import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
                _buildProtocolsSection(context, state, viewModel, dataState, ref),
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

  Widget _buildProtocolsSection(BuildContext context, TreatmentState state, TreatmentViewModel viewModel, TreatmentDataState dataState, WidgetRef ref) {
    final checkboxProtocols = dataState.protocols.where((p) => p.type == ProtocolType.checkbox).toList();
    final textProtocols = dataState.protocols.where((p) => p.type == ProtocolType.text).toList();

    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Treatment Protocols", style: context.fonts.black18w600),
          context.verticalSpace(8),
          Text("Standardize procedures with checklists and instructions.", style: context.fonts.grey13w500),
          context.verticalSpace(32),
          
          _buildProtocolGroup(
            context,
            title: "Checkboxes",
            protocols: checkboxProtocols,
            selectedIds: state.selectedProtocolIds,
            onToggle: (id) => viewModel.toggleProtocolSelection(id),
            onAdd: () => _showAddProtocolDialog(context, ref, ProtocolType.checkbox),
          ),
          
          context.verticalSpace(32),
          
          _buildProtocolGroup(
            context,
            title: "Text Fields",
            protocols: textProtocols,
            selectedIds: state.selectedProtocolIds,
            onToggle: (id) => viewModel.toggleProtocolSelection(id),
            onAdd: () => _showAddProtocolDialog(context, ref, ProtocolType.text),
          ),
        ],
      ),
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
