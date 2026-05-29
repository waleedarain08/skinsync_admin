import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/treatment_model.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/utils/validators.dart';
import 'package:skinsync_admin/view_models/treatment_data_view_model.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';

import 'package:skinsync_admin/widgets/gradient_scaffold.dart';

class EditTreatmentScreen extends ConsumerWidget {
  const EditTreatmentScreen({super.key});

  static const String routeName = '/edit-treatment';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(treatmentViewModelProvider);
    final viewModel = ref.read(treatmentViewModelProvider.notifier);
    final dataState = ref.watch(treatmentDataViewModelProvider);

    if (state.selectedTreatment == null) {
      return GradientScaffold(body: Center(child: Text("No Treatment Selected", style: CustomFonts.black16w400)));
    }

    return GradientScaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text("Edit Treatment", style: CustomFonts.black18w600),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: CustomColors.black),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (!_validateForm(context, viewModel, state)) return;
              viewModel.updateTreatment(context).then((_) {
                if (context.mounted) context.pop();
              });
            },
            child: Text("Save Changes", style: CustomFonts.black16w400),
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 1000.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBasicDetailsSection(state, viewModel),
                SizedBox(height: 32.h),
                _buildCategorizationSection(state, viewModel, dataState),
                SizedBox(height: 32.h),
                _buildAreasSection(state, viewModel, dataState),
                SizedBox(height: 32.h),
                _buildMaterialsAndLogicSection(state, viewModel, dataState),
                SizedBox(height: 48.h),
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

  Widget _buildBasicDetailsSection(TreatmentState state, TreatmentViewModel viewModel) {
    return BorderdContainerWidget(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Basic Information", style: CustomFonts.black18w600),
          SizedBox(height: 24.h),
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
              SizedBox(width: 24.w),
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
          SizedBox(height: 24.h),
          BuildTextField(
            label: "Treatment Base Price (\$)",
            controller: viewModel.basePriceController,
            hintText: "0",
            keyboardType: TextInputType.number,
            validator: Validators.empty,
          ),
          SizedBox(height: 24.h),
          Text("Base Duration", style: CustomFonts.black14w600),
          SizedBox(height: 10.h),
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
              SizedBox(width: 24.w),
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
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(child: _buildImageTile("Banner Image", state.treatmentImage, () => viewModel.pickImage(false))),
              SizedBox(width: 24.w),
              Expanded(child: _buildImageTile("Listing Icon", state.treatmentIcon, () => viewModel.pickImage(true))),
            ],
          ),
          SizedBox(height: 24.h),
          BuildTextField(
            label: "Short Description",
            controller: viewModel.shortDescriptionController,
            hintText: "Brief summary...",
            maxLines: 2,
          ),
          SizedBox(height: 24.h),
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

  Widget _buildCategorizationSection(TreatmentState state, TreatmentViewModel viewModel, TreatmentDataState dataState) {
    return BorderdContainerWidget(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Categorization", style: CustomFonts.black18w600),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                child: _buildSearchField(
                  label: "Category",
                  hint: "Select category",
                  controller: viewModel.categoryController,
                  suggestions: dataState.categories.map((c) => c.name).toList(),
                  onSelected: (val) => viewModel.onCategorySelected(val),
                ),
              ),
              SizedBox(width: 24.w),
              Expanded(
                child: _buildSearchField(
                  label: "Subcategory",
                  hint: "Select subcategory",
                  controller: viewModel.subcategoryController,
                  suggestions: dataState.categories.isEmpty
                      ? []
                      : dataState.categories
                          .firstWhere((c) => c.name == viewModel.categoryController.text,
                              orElse: () => dataState.categories.first)
                          .subcategories
                          .map((s) => s.name)
                          .toList(),
                  onSelected: (val) {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAreasSection(TreatmentState state, TreatmentViewModel viewModel, TreatmentDataState dataState) {
    return BorderdContainerWidget(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Body Areas", style: CustomFonts.black18w600),
              TextButton.icon(
                onPressed: () => viewModel.addArea(),
                icon: const Icon(Icons.add),
                label: const Text("Add Area"),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.areas.length,
            separatorBuilder: (_, __) => const Divider(height: 32),
            itemBuilder: (context, index) {
              final entry = state.areas[index];
              return Column(
                children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(
                      child: _buildSearchField(
                        label: "Area Name",
                        hint: "e.g. Upper Face",
                        controller: entry.areaController,
                        suggestions: dataState.areas.map((a) => a.name).toList(),
                        onSelected: (val) => viewModel.onAreaSelected(index, val),
                      ),
                    ),
                    if (state.areas.length > 1)
                      IconButton(
                        padding: EdgeInsets.only(top: 32.h),
                        onPressed: () => viewModel.removeArea(index),
                        icon: const Icon(Icons.delete_outline, color: CustomColors.red),
                      ),
                  ]),
                  SizedBox(height: 16.h),
                  _buildSubAreaSection(index, entry, viewModel, dataState),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSubAreaSection(int areaIndex, AreaViewModelEntry entry, TreatmentViewModel viewModel, TreatmentDataState dataState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSearchField(
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
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: entry.subAreas.map((sub) => Chip(
              label: Text(sub.name, style: CustomFonts.grey13w500),
              onDeleted: () => viewModel.removeSubArea(areaIndex, sub.name),
              backgroundColor: CustomColors.green.withValues(alpha: 0.1),
              side: BorderSide(color: CustomColors.green.withValues(alpha: 0.2)),
            )).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildMaterialsAndLogicSection(TreatmentState state, TreatmentViewModel viewModel, TreatmentDataState dataState) {
    final allSubAreas = state.areas.expand((a) => a.subAreas).toList();

    return BorderdContainerWidget(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Materials & Configuration", style: CustomFonts.black18w600),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: _buildSearchField(
                  label: "Material Name",
                  hint: "Select material",
                  controller: viewModel.materialNameController,
                  suggestions: dataState.materials,
                  onSelected: (val) {},
                ),
              ),
              SizedBox(width: 24.w),
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
            SizedBox(height: 32.h),
            Text("Configuration Per Sub-Area", style: CustomFonts.black16w400),
            SizedBox(height: 16.h),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: allSubAreas.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final subArea = allSubAreas[index];
                return _buildSubAreaConfigCard(subArea);
              },
            ),
          ],
          SizedBox(height: 32.h),
          const Divider(),
          SizedBox(height: 24.h),
          Row(
            children: [
              SizedBox(
                width: 24.w,
                height: 24.w,
                child: Checkbox(
                  value: state.useInAiSimulator,
                  onChanged: (val) => viewModel.toggleAiSimulator(val),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
                ),
              ),
              SizedBox(width: 12.w),
              Text("Use in AI Simulator", style: CustomFonts.black16w400),
            ],
          ),
          SizedBox(height: 32.h),
          Text("Combinable Treatments", style: CustomFonts.black16w400),
          SizedBox(height: 8.h),
          Text("Select treatments that can be performed alongside this one.", style: CustomFonts.grey13w500),
          SizedBox(height: 16.h),
          _buildSearchField(
            label: "Search Treatments",
            hint: "Search to add...",
            controller: viewModel.combinableSearchController,
            suggestions: state.treatments.map((t) => t.name ?? '').toList(),
            onSelected: (val) {
              final treatment = state.treatments.firstWhere((t) => t.name == val, orElse: () => TreatmentModel(name: val));
              viewModel.addCombinableTreatment(treatment);
            },
          ),
          if (state.combinableTreatments.isNotEmpty) ...[
            SizedBox(height: 16.h),
            Wrap(
              spacing: 12.w,
              runSpacing: 12.h,
              children: state.combinableTreatments.map((t) => Chip(
                label: Text(t.name ?? "N/A"),
                onDeleted: () => viewModel.removeCombinableTreatment(t.id ?? 0),
                backgroundColor: CustomColors.purple.withValues(alpha: 0.1),
                side: BorderSide(color: CustomColors.purple.withValues(alpha: 0.2)),
                labelStyle: CustomFonts.black12w400,
                deleteIconColor: CustomColors.black,
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSubAreaConfigCard(SubAreaConfig subArea) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: CustomColors.whiteGrey,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: CustomColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subArea.name, style: CustomFonts.grey14w600),
          SizedBox(height: 12.h),
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
              SizedBox(width: 16.w),
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

  Widget _buildImageTile(String label, dynamic file, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: CustomFonts.grey14w600),
        SizedBox(height: 10.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 120.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: CustomColors.whiteGrey,
              borderRadius: BorderRadius.circular(12.r),
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

  Widget _buildSearchField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required List<String> suggestions,
    required Function(String) onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: CustomFonts.grey14w600),
        SizedBox(height: 10.h),
        SearchAnchor(
          viewHintText: hint,
          viewConstraints: BoxConstraints(maxHeight: 350.h),
          viewShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          viewSurfaceTintColor: Colors.white,
          viewBackgroundColor: Colors.white,
          viewElevation: 12,
          builder: (context, searchController) {
            if (searchController.text.isEmpty && controller.text.isNotEmpty) {
              searchController.text = controller.text;
            }
            return TextFormField(
              controller: controller,
              readOnly: true,
              style: CustomFonts.grey14w400,
              onTap: () {
                searchController.text = controller.text;
                searchController.openView();
              },
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: CustomFonts.grey13w500,
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: const BorderSide(color: CustomColors.border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: const BorderSide(color: CustomColors.border)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: const BorderSide(color: CustomColors.green)),
                suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded, color: CustomColors.grey),
              ),
            );
          },
          suggestionsBuilder: (context, searchController) {
            final query = searchController.text.toLowerCase();
            final filteredList = suggestions.where((s) => s.toLowerCase().contains(query)).toList();

            return [
              if (searchController.text.isNotEmpty && !suggestions.contains(searchController.text))
                ListTile(
                  title: Text('Use "${searchController.text}"', style: CustomFonts.black14w700),
                  onTap: () {
                    controller.text = searchController.text;
                    onSelected(searchController.text);
                    searchController.closeView(searchController.text);
                  },
                ),
              ...filteredList.map((item) => ListTile(
                leading: Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(color: CustomColors.whiteGrey, borderRadius: BorderRadius.circular(6.r)),
                  child: const Icon(Icons.circle_outlined, size: 14, color: CustomColors.grey),
                ),
                title: Text(item, style: CustomFonts.grey14w400),
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
