import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/treatment_model.dart';
import 'package:skinsync_admin/screens/create_treatment_screen.dart';
import 'package:skinsync_admin/screens/treatment_detail_screen.dart';
import 'package:skinsync_admin/utils/color_constant.dart';
import 'package:skinsync_admin/utils/custom_fonts.dart';
import 'package:skinsync_admin/view_models/treatment_data_view_model.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/screens/manage_treatment_data_screen.dart';
import 'package:skinsync_admin/widgets/dailogbox/standard_dialog.dart';

class TreatmentManagementScreen extends ConsumerStatefulWidget {
  const TreatmentManagementScreen({super.key});
  static const String routeName = '/treatment-management';

  @override
  ConsumerState<TreatmentManagementScreen> createState() => _TreatmentManagementScreenState();
}

class _TreatmentManagementScreenState extends ConsumerState<TreatmentManagementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(treatmentViewModelProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(treatmentViewModelProvider);
    final viewModel = ref.read(treatmentViewModelProvider.notifier);
    final dataState = ref.watch(treatmentDataViewModelProvider);

    return Scaffold(
      backgroundColor: CustomColors.backgroundLight,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 32.h),
            _buildSearchAndFilterBar(viewModel, dataState),
            SizedBox(height: 32.h),
            _buildTreatmentList(state, viewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Treatment Directory", style: CustomFonts.textMain32w700),
            SizedBox(height: 8.h),
            Text(
              "Manage and monitor all treatments in your network.",
              style: CustomFonts.textMain14w400.copyWith(color: CustomColors.textMuted),
            ),
          ],
        ),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: () => context.push(ManageTreatmentDataScreen.routeName),
              icon: const Icon(Icons.settings_suggest_rounded, color: CustomColors.brandPrimary),
              label: Text('Manage Categories & Areas', style: CustomFonts.textMain14w600.copyWith(color: CustomColors.brandPrimary)),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                side: const BorderSide(color: CustomColors.brandPrimary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
            ),
            SizedBox(width: 16.w),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(treatmentViewModelProvider.notifier).resetForm();
                context.push(CreateTreatmentScreen.routeName);
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: Text('Create New Treatment', style: CustomFonts.white14w500),
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.deepNavy,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchAndFilterBar(TreatmentViewModel viewModel, TreatmentDataState dataState) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 54.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey[200]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: viewModel.searchController,
              onChanged: (val) => viewModel.onSearchChanged(val),
              style: CustomFonts.textMain14w400,
              decoration: InputDecoration(
                hintText: "Search treatments by name or description...",
                hintStyle: CustomFonts.textMuted14w400,
                prefixIcon: const Icon(Icons.search_rounded, color: CustomColors.textMuted, size: 20),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 15.h),
                suffixIcon: viewModel.searchController.text.isNotEmpty 
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18),
                        onPressed: () {
                          viewModel.searchController.clear();
                          viewModel.onSearchChanged("");
                          setState(() {});
                        },
                      )
                    : null,
              ),
            ),
          ),
        ),
        SizedBox(width: 16.w),
        _buildFilterButton(viewModel, dataState),
      ],
    );
  }

  Widget _buildFilterButton(TreatmentViewModel viewModel, TreatmentDataState dataState) {
    return ElevatedButton.icon(
      onPressed: () => _showFiltersModal(context, viewModel, dataState),
      icon: const Icon(Icons.filter_list_rounded, size: 20, color: Colors.white),
      label: Text("Filters", style: CustomFonts.white14w500),
      style: ElevatedButton.styleFrom(
        backgroundColor: CustomColors.brandPrimary,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      ),
    );
  }

  void _showFiltersModal(BuildContext context, TreatmentViewModel viewModel, TreatmentDataState dataState) {
    showDialog(
      context: context,
      builder: (context) => StandardDialog(
        title: "Filter Treatments",
        width: 600.w,
        content: StatefulBuilder(
          builder: (context, setModalState) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildModalSearchField(
                      label: "Category",
                      hint: "All Categories",
                      controller: viewModel.filterCategoryController,
                      suggestions: dataState.categories.map((c) => c.name).toList(),
                      onSelected: (val) {
                        viewModel.onFilterCategorySelected(val);
                        setModalState(() {});
                      },
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: _buildModalSearchField(
                      label: "Subcategory",
                      hint: "All Subcategories",
                      controller: viewModel.filterSubcategoryController,
                      suggestions: dataState.categories
                          .firstWhere((c) => c.name == viewModel.filterCategoryController.text,
                              orElse: () => dataState.categories.first)
                          .subcategories
                          .map((s) => s.name)
                          .toList(),
                      onSelected: (val) => viewModel.onFilterChanged(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: _buildModalSearchField(
                      label: "Anatomical Area",
                      hint: "All Areas",
                      controller: viewModel.filterAreaController,
                      suggestions: dataState.areas.map((a) => a.name).toList(),
                      onSelected: (val) {
                        viewModel.onFilterAreaSelected(val);
                        setModalState(() {});
                      },
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: _buildModalSearchField(
                      label: "Status",
                      hint: "All Status",
                      controller: viewModel.filterStatusController,
                      suggestions: ["Active", "Inactive"],
                      onSelected: (val) => viewModel.onFilterChanged(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              _buildModalSearchField(
                label: "Material",
                hint: "All Materials",
                controller: viewModel.filterMaterialController,
                suggestions: dataState.materials,
                onSelected: (val) => viewModel.onFilterChanged(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              viewModel.clearFilters();
              Navigator.pop(context);
            },
            child: const Text("Reset All"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Apply Filters"),
          ),
        ],
      ),
    );
  }

  Widget _buildModalSearchField({
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
                suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
                filled: true,
                fillColor: CustomColors.surfaceGhost,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
              ),
            );
          },
          suggestionsBuilder: (context, searchController) {
            final query = searchController.text.toLowerCase();
            return [
              ListTile(
                title: Text("All $label", style: CustomFonts.textMain14w600.copyWith(color: CustomColors.brandPrimary)),
                onTap: () {
                  controller.clear();
                  onSelected("");
                  searchController.closeView("");
                },
              ),
              ...suggestions
                  .where((s) => s.toLowerCase().contains(query))
                  .map((item) => ListTile(
                        title: Text(item, style: CustomFonts.textMain14w400),
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

  Widget _buildTreatmentList(TreatmentState state, TreatmentViewModel viewModel) {
    if (state.loading) return const Center(child: CircularProgressIndicator());
    
    if (state.filteredTreatments.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.only(top: 100.h),
          child: Text("No treatments found matching your filters.", style: CustomFonts.textMuted16w500),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.filteredTreatments.length,
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
      itemBuilder: (context, index) => _buildTreatmentListItem(state.filteredTreatments[index], viewModel),
    );
  }

  Widget _buildTreatmentListItem(TreatmentModel treatment, TreatmentViewModel viewModel) {
    return BorderdContainerWidget(
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          // Treatment Image
          Container(
            width: 70.w,
            height: 70.w,
            decoration: BoxDecoration(
              color: CustomColors.surfaceGhost,
              borderRadius: BorderRadius.circular(10.r),
              image: (treatment.image != null && treatment.image!.isNotEmpty)
                  ? DecorationImage(
                      image: NetworkImage(treatment.image!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: (treatment.image == null || treatment.image!.isEmpty)
                ? Icon(Icons.image_outlined, color: CustomColors.textMuted.withOpacity(0.5), size: 24.sp)
                : null,
          ),
          SizedBox(width: 16.w),
          
          // Treatment Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(treatment.name ?? "N/A", style: CustomFonts.textMain16w600),
                    SizedBox(width: 8.w),
                    _statusBadge(treatment.isActive),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  "${treatment.category ?? 'General'} • ${treatment.subcategory ?? 'N/A'}",
                  style: CustomFonts.textMuted11w400,
                ),
                SizedBox(height: 4.h),
                Text(
                  treatment.shortDescription ?? treatment.description ?? "No description",
                  style: CustomFonts.textMuted12w400,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Area Info Pill
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: CustomColors.brandCyan.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: CustomColors.brandCyan.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.layers_outlined, size: 14.sp, color: CustomColors.brandPrimary),
                SizedBox(width: 6.w),
                Text(
                  "${treatment.sideAreas?.length ?? 0} Areas",
                  style: CustomFonts.textMain14w600.copyWith(fontSize: 11.sp, color: CustomColors.brandPrimary),
                ),
              ],
            ),
          ),
          SizedBox(width: 20.w),
          
          // Actions
          _buildMoreMenu(treatment, viewModel),
        ],
      ),
    );
  }

  Widget _statusBadge(bool isActive) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: (isActive ? CustomColors.success : CustomColors.textMuted).withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        isActive ? "ACTIVE" : "INACTIVE",
        style: TextStyle(
          color: isActive ? CustomColors.success : CustomColors.textMuted,
          fontSize: 9.sp,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildMoreMenu(TreatmentModel treatment, TreatmentViewModel viewModel) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'detail':
            viewModel.selectTreatment(treatment);
            context.push(TreatmentDetailScreen.routeName);
            break;
          case 'delete':
            _showDeleteConfirmation(treatment, viewModel);
            break;
          case 'toggle':
            viewModel.toggleTreatmentStatus(treatment.id ?? 0);
            break;
        }
      },
      tooltip: "Show Actions",
      icon: const Icon(Icons.more_vert_rounded, size: 24, color: CustomColors.textMain),
      offset: const Offset(0, 40),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'detail',
          child: Row(
            children: [
              const Icon(Icons.visibility_outlined, size: 18, color: CustomColors.brandPrimary),
              SizedBox(width: 12.w),
              Text("View Detail", style: CustomFonts.textMain14w400),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'toggle',
          child: Row(
            children: [
              Icon(
                treatment.isActive ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                size: 18,
                color: treatment.isActive ? Colors.orange : Colors.green,
              ),
              SizedBox(width: 12.w),
              Text(
                treatment.isActive ? "Deactivate" : "Activate",
                style: CustomFonts.textMain14w400,
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              const Icon(Icons.delete_outline_rounded, size: 18, color: CustomColors.error),
              SizedBox(width: 12.w),
              Text(
                "Delete Treatment",
                style: CustomFonts.textMain14w400.copyWith(color: CustomColors.error),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(TreatmentModel treatment, TreatmentViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => StandardDialog(
        title: "Delete Treatment",
        width: 400.w,
        content: Text("Are you sure you want to delete '${treatment.name}'? This action cannot be undone.", style: CustomFonts.textMain14w400),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: CustomColors.error),
            onPressed: () {
              viewModel.deleteTreatment(treatment.id ?? 0);
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}
