import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/treatment_model.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/utils/validators.dart';
import 'package:skinsync_admin/view_models/treatment_data_view_model.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';
import 'package:skinsync_admin/widgets/app_search_field.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';

import 'package:skinsync_admin/widgets/gradient_scaffold.dart';

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
        title: Text("Create New Treatment", style: CustomFonts.black18w600),
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
                      _buildCurrentStepContent(context, state, viewModel, dataState),
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
          _stepIndicator(context, 0, "Basic Details", currentStep),
          _stepConnector(context, 0, currentStep),
          _stepIndicator(context, 1, "Category", currentStep),
          _stepConnector(context, 1, currentStep),
          _stepIndicator(context, 2, "Areas", currentStep),
          _stepConnector(context, 2, currentStep),
          _stepIndicator(context, 3, "Materials & Logic", currentStep),
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
                    style: isActive ? CustomFonts.white12w700 : CustomFonts.grey12w700,
                  ),
          ),
        ),
        context.horizontalSpace(12),
        Text(
          label,
          style: isActive ? CustomFonts.black14w600 : CustomFonts.grey14w400,
        ),
      ],
    );
  }

  Widget _stepConnector(BuildContext context, int step, int currentStep) {
    final bool isCompleted = currentStep > step;
    return Expanded(
      child: Container(
        margin: context.appEdgeInsets(horizontal: 16),
        height: context.h(2),
        color: isCompleted ? CustomColors.green : CustomColors.border,
      ),
    );
  }

  Widget _buildCurrentStepContent(BuildContext context, TreatmentState state, TreatmentViewModel viewModel, TreatmentDataState dataState) {
    switch (state.currentStep) {
      case 0: return _buildStep1(context, state, viewModel);
      case 1: return _buildStep2(context, state, viewModel, dataState);
      case 2: return _buildStep3(context, state, viewModel, dataState);
      case 3: return _buildStep4(context, state, viewModel, dataState);
      default: return const SizedBox.shrink();
    }
  }

  Widget _buildStep1(BuildContext context, TreatmentState state, TreatmentViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Basic Information"),
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
        Text("Base Duration", style: CustomFonts.black14w600),
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
        _sectionTitle("Visuals"),
        context.verticalSpace(24),
        Row(
          children: [
            Expanded(child: _buildImageUploadTile(context, "Treatment Banner Image", state.treatmentImage, () => viewModel.pickImage(false))),
            context.horizontalSpace(24),
            Expanded(child: _buildImageUploadTile(context, "Treatment Listing Icon", state.treatmentIcon, () => viewModel.pickImage(true))),
          ],
        ),
        context.verticalSpace(32),
        _sectionTitle("Descriptions"),
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

  Widget _buildStep2(BuildContext context, TreatmentState state, TreatmentViewModel viewModel, TreatmentDataState dataState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Categorization"),
        context.verticalSpace(8),
        Text("Organize treatments to help patients find them easily.", style: CustomFonts.grey14w400),
        context.verticalSpace(32),
        _buildSearchField(
          context,
          label: "Treatment Category",
          hint: "Select or type a category",
          controller: viewModel.categoryController,
          suggestions: dataState.categories.map((c) => c.name).toList(),
          onSelected: (val) => viewModel.onCategorySelected(val),
        ),
        context.verticalSpace(32),
        _buildSearchField(
          context,
          label: "Treatment Subcategory",
          hint: "Select or type a subcategory",
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
      ],
    );
  }

  Widget _buildStep3(BuildContext context, TreatmentState state, TreatmentViewModel viewModel, TreatmentDataState dataState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _sectionTitle("Treatment Areas"),
            CustomPrimaryButton(
              onTap: () => viewModel.addArea(),
              icon: Icons.add_location_alt_outlined,
              label: "Add New Area",
              width: context.w(200),
            ),
          ],
        ),
        context.verticalSpace(8),
        Text("Select areas and mandatory sub-areas for this treatment.", style: CustomFonts.grey14w400),
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

  Widget _buildStep4(BuildContext context, TreatmentState state, TreatmentViewModel viewModel, TreatmentDataState dataState) {
    final allSubAreas = state.areas.expand((a) => a.subAreas).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Materials & Configuration"),
        context.verticalSpace(8),
        Text("Define the materials used and specific configuration per sub-area.", style: CustomFonts.grey14w400),
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
          Text("Material Configuration Per Sub-Area", style: CustomFonts.black16w400),
          context.verticalSpace(16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: allSubAreas.length,
            separatorBuilder: (_, _) => context.verticalSpace(16),
            itemBuilder: (context, index) {
              final subArea = allSubAreas[index];
              return _buildSubAreaMaterialConfig(context, subArea);
            },
          ),
        ],
        context.verticalSpace(40),
        const Divider(),
        context.verticalSpace(32),
        _sectionTitle("AI Simulator Compatibility"),
        context.verticalSpace(16),
        Row(
          children: [
            SizedBox(
              width: context.w(24),
              height: context.w(24),
              child: Checkbox(
                value: state.useInAiSimulator,
                onChanged: (val) => viewModel.toggleAiSimulator(val),
                shape: RoundedRectangleBorder(borderRadius: context.borderRadius(all: 4)),
              ),
            ),
            context.horizontalSpace(12),
            Text("Use in AI Simulator", style: CustomFonts.black16w400),
          ],
        ),
        context.verticalSpace(40),
        _buildCombinableTreatmentsField(context, state, viewModel),
      ],
    );
  }

  Widget _buildSubAreaMaterialConfig(BuildContext context, SubAreaConfig subArea) {
    return Container(
      padding: context.appEdgeInsets(all: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: context.borderRadius(all: 12),
        border: Border.all(color: CustomColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.subdirectory_arrow_right, size: 18, color: CustomColors.black),
              context.horizontalSpace(8),
              Text(subArea.name, style: CustomFonts.black14w600),
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

  Widget _buildCombinableTreatmentsField(BuildContext context, TreatmentState state, TreatmentViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Combinable Treatments"),
        context.verticalSpace(8),
        Text("Select treatments that can be performed alongside this one.", style: CustomFonts.grey13w500),
        context.verticalSpace(16),
        _buildSearchField(
          context,
          label: "Search Treatments",
          hint: "e.g. Botox, Chemical Peel",
          controller: viewModel.combinableSearchController,
          suggestions: state.treatments.map((t) => t.name ?? '').toList(),
          onSelected: (val) {
            final treatment = state.treatments.firstWhere((t) => t.name == val, orElse: () => TreatmentModel(name: val));
            viewModel.addCombinableTreatment(treatment);
          },
        ),
        if (state.combinableTreatments.isNotEmpty) ...[
          context.verticalSpace(16),
          Wrap(
            spacing: context.w(12),
            runSpacing: context.h(12),
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
    );
  }

  Widget _buildAreaRow(BuildContext context, int index, AreaViewModelEntry entry, TreatmentViewModel viewModel, TreatmentDataState dataState) {
    return Container(
      padding: context.appEdgeInsets(all: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: context.borderRadius(all: 16),
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
                label: Text(sub.name, style: CustomFonts.grey13w500),
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
        Text(label, style: CustomFonts.black14w600),
        context.verticalSpace(10),
        SearchAnchor(
          viewHintText: hint,
          viewConstraints: BoxConstraints(maxHeight: context.h(350)),
          viewShape: RoundedRectangleBorder(borderRadius: context.borderRadius(all: 16)),
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
                    borderRadius: context.borderRadius(all: 10),
                    child: Container(
                      padding: context.appEdgeInsets(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: CustomColors.purple.withValues(alpha: 0.05),
                        borderRadius: context.borderRadius(all: 10),
                        border: Border.all(color: CustomColors.purple.withValues(alpha: 0.1)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.add_circle_outline_rounded, color: CustomColors.black, size: 20),
                          context.horizontalSpace(12),
                          Expanded(
                            child: Text(
                              'Create new: "${searchController.text}"',
                              style: CustomFonts.black14w700,
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
                        decoration: BoxDecoration(color: CustomColors.whiteGrey, borderRadius: context.borderRadius(all: 6)),
                        child: const Icon(Icons.circle_outlined, size: 14, color: CustomColors.grey),
                      ),
                      title: Text(item, style: CustomFonts.grey14w400),
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
        Text(label, style: CustomFonts.black14w600),
        context.verticalSpace(10),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: context.h(160),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: context.borderRadius(all: 16),
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
                      Text("Tap to upload", style: CustomFonts.grey13w500),
                    ],
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title, style: CustomFonts.black18w600);
  }

  Widget _buildActionButtons(BuildContext context, TreatmentState state, TreatmentViewModel viewModel) {
    final bool isLastStep = state.currentStep == 3;
    final bool isStep3 = state.currentStep == 2;

    return Row(
      children: [
        if (state.currentStep > 0) ...[
          Expanded(
            child: OutlinedButton(
              onPressed: () => viewModel.setStep(state.currentStep - 1),
              child: const Text("Previous Step"),
            ),
          ),
          context.horizontalSpace(16),
        ],
        if (isStep3) ...[
          Expanded(
            flex: 2,
            child: OutlinedButton(
              onPressed: () {
                if (!_validateSubAreas(context, state)) return;
                viewModel.submitTreatment(context).then((_) {
                  if (context.mounted) context.pop();
                });
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: CustomColors.black),
                foregroundColor: CustomColors.black,
              ),
              child: const Text("Finish & Create Now"),
            ),
          ),
          context.horizontalSpace(16),
        ],
        Expanded(
          flex: 2,
          child: CustomPrimaryButton(
            onTap: () {
              if (state.currentStep == 0) {
                if (!_validateStep1(context, viewModel)) return;
              }
              if (state.currentStep == 2) {
                if (!_validateSubAreas(context, state)) return;
              }
              
              if (state.currentStep < 3) {
                viewModel.setStep(state.currentStep + 1);
              } else {
                viewModel.submitTreatment(context).then((_) {
                  if (context.mounted) context.pop();
                });
              }
            },
            label: isLastStep ? "Finish & Create Treatment" : (isStep3 ? "Add Materials" : "Next Step"),
          ),
        ),
      ],
    );
  }

  bool _validateStep1(BuildContext context, TreatmentViewModel viewModel) {
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
