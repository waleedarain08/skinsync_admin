import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/treatment_model.dart';
import 'package:skinsync_admin/utils/color_constant.dart';
import 'package:skinsync_admin/utils/custom_fonts.dart';
import 'package:skinsync_admin/utils/dummy_data.dart';
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
      backgroundColor: CustomColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text("Create New Treatment", style: CustomFonts.textMain20w600),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: CustomColors.textMain),
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
            color: isCompleted ? CustomColors.success : (isActive ? CustomColors.brandPrimary : Colors.white),
            shape: BoxShape.circle,
            border: Border.all(color: isActive ? Colors.transparent : Colors.grey[300]!),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : Text(
                    "${step + 1}",
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.grey[400],
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          label,
          style: CustomFonts.textMain14w600.copyWith(
            color: isActive ? CustomColors.textMain : Colors.grey[400],
          ),
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
        color: isCompleted ? CustomColors.success : Colors.grey[200],
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
        Text("Organize treatments to help patients find them easily.", style: CustomFonts.textMuted14w400),
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
                backgroundColor: CustomColors.brandCyan.withOpacity(0.1),
                foregroundColor: CustomColors.brandPrimary,
              ),
            ),
          ],
        ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Materials & AI Simulator Logic (Optional)"),
        SizedBox(height: 8.h),
        Text("Define the materials used and treatment compatibility.", style: CustomFonts.textMuted14w400),
        SizedBox(height: 32.h),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: _buildSearchField(
                label: "Material / Consumable Name",
                hint: "e.g. Syringes, Units, Vials",
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
            Text("Use in AI Simulator", style: CustomFonts.textMain16w600),
          ],
        ),
        SizedBox(height: 40.h),
        _buildCombinableTreatmentsField(state, viewModel),
      ],
    );
  }

  Widget _buildCombinableTreatmentsField(TreatmentState state, TreatmentViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Combinable Treatments"),
        SizedBox(height: 8.h),
        Text("Select treatments that can be performed alongside this one.", style: CustomFonts.textMuted12w400),
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
              backgroundColor: CustomColors.brandPurple.withOpacity(0.1),
              side: BorderSide(color: CustomColors.brandPurple.withOpacity(0.2)),
              labelStyle: const TextStyle(color: CustomColors.brandPrimary),
              deleteIconColor: CustomColors.brandPrimary,
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
        border: Border.all(color: Colors.grey[200]!),
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
                    icon: const Icon(Icons.delete_outline, color: CustomColors.error),
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
          label: "Sub Areas (Optional)",
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
                label: Text(sub),
                onDeleted: () => viewModel.removeSubArea(areaIndex, sub),
                backgroundColor: CustomColors.brandCyan.withOpacity(0.1),
                side: BorderSide(color: CustomColors.brandCyan.withOpacity(0.2)),
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
        Text(label, style: CustomFonts.textMain14w600),
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
              style: CustomFonts.textMain14w400,
              onTap: () {
                searchController.text = controller.text;
                searchController.openView();
              },
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: CustomFonts.textMuted14w400,
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: CustomColors.brandPrimary),
                ),
                suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded, color: CustomColors.textMuted),
              ),
            );
          },
          suggestionsBuilder: (context, searchController) {
            final query = searchController.text.toLowerCase();
            final filteredList = suggestions.where((s) => s.toLowerCase().contains(query)).toList();

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
                        color: CustomColors.brandPrimary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: CustomColors.brandPrimary.withOpacity(0.1)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.add_circle_outline_rounded, color: CustomColors.brandPrimary, size: 20),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              'Create new: "${searchController.text}"',
                              style: CustomFonts.textMain14w600.copyWith(color: CustomColors.brandPrimary),
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
                        decoration: BoxDecoration(color: CustomColors.surfaceGhost, borderRadius: BorderRadius.circular(6.r)),
                        child: const Icon(Icons.circle_outlined, size: 14, color: CustomColors.textMuted),
                      ),
                      title: Text(item, style: CustomFonts.textMain14w400),
                      hoverColor: CustomColors.brandCyan.withOpacity(0.05),
                      onTap: () {
                        controller.text = item;
                        onSelected(item);
                        searchController.closeView(item);
                      },
                    ),
                    const Divider(height: 1, indent: 24, endIndent: 24, color: Color(0xFFF1F5F9)),
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
        Text(label, style: CustomFonts.textMain14w600),
        SizedBox(height: 10.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 160.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Colors.grey[200]!, width: 2),
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
                        decoration: BoxDecoration(color: CustomColors.surfaceGhost, shape: BoxShape.circle),
                        child: const Icon(Icons.add_a_photo_outlined, color: CustomColors.brandPrimary),
                      ),
                      SizedBox(height: 12.h),
                      Text("Tap to upload", style: CustomFonts.textMuted13w500),
                    ],
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title, style: CustomFonts.textMain20w600);
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
                viewModel.submitTreatment(context).then((_) {
                  if (context.mounted) context.pop();
                });
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: CustomColors.brandPrimary),
                foregroundColor: CustomColors.brandPrimary,
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
}
