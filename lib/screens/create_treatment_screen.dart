import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/treatment_model.dart';
import 'package:skinsync_admin/utils/color_constant.dart';
import 'package:skinsync_admin/utils/custom_fonts.dart';
import 'package:skinsync_admin/utils/validators.dart';
import 'package:skinsync_admin/view_models/treatment_data_view_model.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';

class CreateTreatmentScreen extends ConsumerWidget {
  const CreateTreatmentScreen({super.key});

  static const String routeName = '/create-treatment';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(treatmentViewModelProvider);
    final viewModel = ref.read(treatmentViewModelProvider.notifier);
    final dataState = ref.watch(treatmentDataViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
          _buildProgressIndicator(state.currentStep),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 900.w),
                  child: Column(
                    children: [
                      _buildCurrentStepContent(state, viewModel, dataState),
                      SizedBox(height: 48.h),
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

  Widget _buildProgressIndicator(int currentStep) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 40.w),
      child: Row(
        children: [
          _stepIndicator(0, "Basic Details", currentStep),
          _stepConnector(0, currentStep),
          _stepIndicator(1, "Category", currentStep),
          _stepConnector(1, currentStep),
          _stepIndicator(2, "Areas", currentStep),
          _stepConnector(2, currentStep),
          _stepIndicator(3, "Materials & Logic", currentStep),
        ],
      ),
    );
  }

  Widget _stepIndicator(int step, String label, int currentStep) {
    final bool isActive = currentStep >= step;
    final bool isCompleted = currentStep > step;

    return Row(
      children: [
        Container(
          width: 32.w,
          height: 32.w,
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
        SizedBox(width: 12.w),
        Text(
          label,
          style: isActive ? CustomFonts.black14w600 : CustomFonts.grey14w400,
        ),
      ],
    );
  }

  Widget _stepConnector(int step, int currentStep) {
    final bool isCompleted = currentStep > step;
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        height: 2.h,
        color: isCompleted ? CustomColors.green : CustomColors.border,
      ),
    );
  }

  Widget _buildCurrentStepContent(TreatmentState state, TreatmentViewModel viewModel, TreatmentDataState dataState) {
    switch (state.currentStep) {
      case 0: return _buildStep1(state, viewModel);
      case 1: return _buildStep2(state, viewModel, dataState);
      case 2: return _buildStep3(state, viewModel, dataState);
      case 3: return _buildStep4(state, viewModel, dataState);
      default: return const SizedBox.shrink();
    }
  }

  Widget _buildStep1(TreatmentState state, TreatmentViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Basic Information"),
        SizedBox(height: 24.h),
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
          hintText: "100",
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
                validator: (val) {
                  if (val == null || val.isEmpty) return null;
                  final hours = int.tryParse(val);
                  if (hours == null || hours < 0) return "Invalid";
                  return null;
                },
              ),
            ),
            SizedBox(width: 24.w),
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
        SizedBox(height: 32.h),
        _sectionTitle("Visuals"),
        SizedBox(height: 24.h),
        Row(
          children: [
            Expanded(child: _buildImageUploadTile("Treatment Banner Image", state.treatmentImage, () => viewModel.pickImage(false))),
            SizedBox(width: 24.w),
            Expanded(child: _buildImageUploadTile("Treatment Listing Icon", state.treatmentIcon, () => viewModel.pickImage(true))),
          ],
        ),
        SizedBox(height: 32.h),
        _sectionTitle("Descriptions"),
        SizedBox(height: 24.h),
        BuildTextField(
          label: "Short Description",
          controller: viewModel.shortDescriptionController,
          hintText: "Brief summary for listing...",
          maxLines: 2,
        ),
        SizedBox(height: 24.h),
        BuildTextField(
          label: "Full Description",
          controller: viewModel.fullDescriptionController,
          hintText: "Detailed medical and process information...",
          maxLines: 5,
        ),
      ],
    );
  }

  Widget _buildStep2(TreatmentState state, TreatmentViewModel viewModel, TreatmentDataState dataState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Categorization"),
        SizedBox(height: 8.h),
        Text("Organize treatments to help patients find them easily.", style: CustomFonts.grey14w400),
        SizedBox(height: 32.h),
        _buildSearchField(
          label: "Treatment Category",
          hint: "Select or type a category",
          controller: viewModel.categoryController,
          suggestions: dataState.categories.map((c) => c.name).toList(),
          onSelected: (val) => viewModel.onCategorySelected(val),
        ),
        SizedBox(height: 32.h),
        _buildSearchField(
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

  Widget _buildStep3(TreatmentState state, TreatmentViewModel viewModel, TreatmentDataState dataState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _sectionTitle("Treatment Areas"),
            ElevatedButton.icon(
              onPressed: () => viewModel.addArea(),
              icon: const Icon(Icons.add_location_alt_outlined, size: 18),
              label: const Text("Add New Area"),
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.green.withValues(alpha: 0.1),
                foregroundColor: CustomColors.black,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text("Select areas and mandatory sub-areas for this treatment.", style: CustomFonts.grey14w400),
        SizedBox(height: 32.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.areas.length,
          separatorBuilder: (_, __) => SizedBox(height: 24.h),
          itemBuilder: (context, index) {
            return _buildAreaRow(index, state.areas[index], viewModel, dataState);
          },
        ),
      ],
    );
  }

  Widget _buildStep4(TreatmentState state, TreatmentViewModel viewModel, TreatmentDataState dataState) {
    final allSubAreas = state.areas.expand((a) => a.subAreas).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Materials & Configuration"),
        SizedBox(height: 8.h),
        Text("Define the materials used and specific configuration per sub-area.", style: CustomFonts.grey14w400),
        SizedBox(height: 32.h),
        _buildSearchField(
          label: "Material / Consumable Name",
          hint: "e.g. Syringes, Units, Vials",
          controller: viewModel.materialNameController,
          suggestions: dataState.materials,
          onSelected: (val) {},
        ),
        if (allSubAreas.isNotEmpty) ...[
          SizedBox(height: 32.h),
          Text("Material Configuration Per Sub-Area", style: CustomFonts.black16w400),
          SizedBox(height: 16.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: allSubAreas.length,
            separatorBuilder: (_, __) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              final subArea = allSubAreas[index];
              return _buildSubAreaMaterialConfig(subArea);
            },
          ),
        ],
        SizedBox(height: 40.h),
        const Divider(),
        SizedBox(height: 32.h),
        _sectionTitle("AI Simulator Compatibility"),
        SizedBox(height: 16.h),
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
        SizedBox(height: 40.h),
        _buildCombinableTreatmentsField(state, viewModel),
      ],
    );
  }

  Widget _buildSubAreaMaterialConfig(SubAreaConfig subArea) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: CustomColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.subdirectory_arrow_right, size: 18, color: CustomColors.black),
              SizedBox(width: 8.w),
              Text(subArea.name, style: CustomFonts.black14w600),
            ],
          ),
          SizedBox(height: 20.h),
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
              SizedBox(width: 20.w),
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

  Widget _buildCombinableTreatmentsField(TreatmentState state, TreatmentViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Combinable Treatments"),
        SizedBox(height: 8.h),
        Text("Select treatments that can be performed alongside this one.", style: CustomFonts.grey13w500),
        SizedBox(height: 16.h),
        _buildSearchField(
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
    );
  }

  Widget _buildAreaRow(int index, AreaViewModelEntry entry, TreatmentViewModel viewModel, TreatmentDataState dataState) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
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
                  label: "Area Name",
                  hint: "e.g. Upper Face",
                  controller: entry.areaController,
                  suggestions: dataState.areas.map((a) => a.name).toList(),
                  onSelected: (val) => viewModel.onAreaSelected(index, val),
                ),
              ),
              if (index > 0)
                Padding(
                  padding: EdgeInsets.only(top: 32.h, left: 16.w),
                  child: IconButton(
                    onPressed: () => viewModel.removeArea(index),
                    icon: const Icon(Icons.delete_outline, color: CustomColors.red),
                  ),
                ),
            ],
          ),
          SizedBox(height: 24.h),
          _buildSubAreaSection(index, entry, viewModel, dataState),
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
          SizedBox(height: 16.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
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
        Text(label, style: CustomFonts.black14w600),
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: CustomColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: CustomColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: CustomColors.green),
                ),
                suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded, color: CustomColors.grey),
              ),
            );
          },
          suggestionsBuilder: (context, searchController) {
            final query = searchController.text.toLowerCase();
            // final filteredList = suggestions.where((s) => s.toLowerCase().contains(query)).toList();

            return [
              if (searchController.text.isNotEmpty && !suggestions.contains(searchController.text))
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
                  child: InkWell(
                    onTap: () {
                      controller.text = searchController.text;
                      onSelected(searchController.text);
                      searchController.closeView(searchController.text);
                    },
                    borderRadius: BorderRadius.circular(10.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: CustomColors.purple.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: CustomColors.purple.withValues(alpha: 0.1)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.add_circle_outline_rounded, color: CustomColors.black, size: 20),
                          SizedBox(width: 12.w),
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
                      contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
                      leading: Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: BoxDecoration(color: CustomColors.whiteGrey, borderRadius: BorderRadius.circular(6.r)),
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

  Widget _buildImageUploadTile(String label, dynamic file, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: CustomFonts.black14w600),
        SizedBox(height: 10.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 160.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
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
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(color: CustomColors.whiteGrey, shape: BoxShape.circle),
                        child: const Icon(Icons.add_a_photo_outlined, color: CustomColors.black),
                      ),
                      SizedBox(height: 12.h),
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
          SizedBox(width: 16.w),
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
          SizedBox(width: 16.w),
        ],
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: () {
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
            child: Text(isLastStep ? "Finish & Create Treatment" : (isStep3 ? "Add Materials" : "Next Step")),
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
