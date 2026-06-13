import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/treatment_model.dart';
import 'package:skinsync_admin/screens/create_treatment_screen.dart';
import 'package:skinsync_admin/screens/manage_treatment_data_screen.dart';
import 'package:skinsync_admin/screens/treatment_detail_screen.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/treatment_data_view_model.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';
import 'package:skinsync_admin/widgets/app_badge.dart';
import 'package:skinsync_admin/widgets/app_search_field.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'package:skinsync_admin/widgets/dailogbox/standard_dialog.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';

import '../widgets/app_loader.dart';

class TreatmentManagementScreen extends ConsumerStatefulWidget {
  const TreatmentManagementScreen({super.key});
  static const String routeName = '/treatment-management';

  @override
  ConsumerState<TreatmentManagementScreen> createState() =>
      _TreatmentManagementScreenState();
}

class _TreatmentManagementScreenState
    extends ConsumerState<TreatmentManagementScreen> {
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

    return GradientScaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.pagePaddingH,
          vertical: AppSpacing.pagePaddingV,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: AppSpacing.xxl),
            _buildSearchAndFilterBar(viewModel, dataState),
            SizedBox(height: AppSpacing.xl),
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
            Text("Treatment Library", style: CustomFonts.black26w700),
            SizedBox(height: 6.h),
            Text(
              "Manage medical aesthetic procedures and treatment logic.",
              style: CustomFonts.grey13w500,
            ),
          ],
        ),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: () =>
                  context.push(ManageTreatmentDataScreen.routeName),
              icon: const Icon(Icons.tune_rounded, size: 20),
              label: const Text('Configure Meta-Data'),
              style: OutlinedButton.styleFrom(backgroundColor: Colors.white),
            ),
            SizedBox(width: AppSpacing.md),
            CustomPrimaryButton(
              onTap: () {
                ref.read(treatmentViewModelProvider.notifier).resetForm();
                context.push(CreateTreatmentScreen.routeName);
              },
              icon: Icons.add_rounded,
              label: 'New Treatment',
              width: 180.w,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchAndFilterBar(
    TreatmentViewModel viewModel,
    TreatmentDataState dataState,
  ) {
    return Row(
      children: [
        AppSearchField(
          controller: viewModel.searchController,
          hintText: "Search treatments by keyword, category, or area...",
          onChanged: (val) => viewModel.onSearchChanged(val),
          onClear: () => viewModel.onSearchChanged(""),
        ),
        SizedBox(width: AppSpacing.md),
        OutlinedButton.icon(
          onPressed: () => _showFiltersModal(context, viewModel, dataState),
          icon: const Icon(Icons.filter_list_rounded, size: 20),
          label: const Text("Refine Results"),
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            minimumSize: Size(0, 52.h),
          ),
        ),
      ],
    );
  }

  void _showFiltersModal(
    BuildContext context,
    TreatmentViewModel viewModel,
    TreatmentDataState dataState,
  ) {
    showDialog(
      context: context,
      builder: (context) => StandardDialog(
        title: "Filter Library",
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
                      suggestions: dataState.categories
                          .map((c) => c.name)
                          .toList(),
                      onSelected: (val) {
                        viewModel.onFilterCategorySelected(val);
                        setModalState(() {});
                      },
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _buildModalSearchField(
                      label: "Subcategory",
                      hint: "All Subcategories",
                      controller: viewModel.filterSubcategoryController,
                      suggestions: dataState.categories
                          .firstWhere(
                            (c) =>
                                c.name ==
                                viewModel.filterCategoryController.text,
                            orElse: () => dataState.categories.first,
                          )
                          .subcategories
                          .map((s) => s.name)
                          .toList(),
                      onSelected: (val) => viewModel.onFilterChanged(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  Expanded(
                    child: _buildModalSearchField(
                      label: "Target Area",
                      hint: "All Areas",
                      controller: viewModel.filterAreaController,
                      suggestions: dataState.areas.map((a) => a.name).toList(),
                      onSelected: (val) {
                        viewModel.onFilterAreaSelected(val);
                        setModalState(() {});
                      },
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _buildModalSearchField(
                      label: "Visibility",
                      hint: "Any Status",
                      controller: viewModel.filterStatusController,
                      suggestions: ["Active", "Inactive"],
                      onSelected: (val) => viewModel.onFilterChanged(),
                    ),
                  ),
                ],
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
            child: const Text("Reset Filters"),
          ),
          CustomPrimaryButton(
            onTap: () => Navigator.pop(context),
            label: "Apply Refinements",
            width: 180.w,
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
        Text(label, style: CustomFonts.black14w600),
        SizedBox(height: 8.h),
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
              style: CustomFonts.grey14w400,
              onTap: () {
                searchController.text = controller.text;
                searchController.openView();
              },
              decoration: InputDecoration(
                hintText: hint,
                suffixIcon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                ),
                filled: true,
                fillColor: CustomColors.whiteGrey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: BorderSide.none,
                ),
              ),
            );
          },
          suggestionsBuilder: (context, searchController) {
            final query = searchController.text.toLowerCase();
            return [
              ListTile(
                title: Text(
                  "All $label",
                  style: CustomFonts.black14w600.copyWith(
                    color: CustomColors.purple,
                  ),
                ),
                onTap: () {
                  controller.clear();
                  onSelected("");
                  searchController.closeView("");
                },
              ),
              ...suggestions
                  .where((s) => s.toLowerCase().contains(query))
                  .map(
                    (item) => ListTile(
                      title: Text(item, style: CustomFonts.grey14w400),
                      onTap: () {
                        controller.text = item;
                        onSelected(item);
                        searchController.closeView(item);
                      },
                    ),
                  ),
            ];
          },
        ),
      ],
    );
  }

  Widget _buildTreatmentList(
    TreatmentState state,
    TreatmentViewModel viewModel,
  ) {
    if (state.loading) return const Center(child: AppLoader());

    if (state.filteredTreatments.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.only(top: 80.h),
          child: Column(
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 48.sp,
                color: CustomColors.lightGrey,
              ),
              SizedBox(height: AppSpacing.md),
              Text(
                "No matching treatments found.",
                style: CustomFonts.black16w400.copyWith(
                  color: CustomColors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.filteredTreatments.length,
      separatorBuilder: (context, index) => SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) =>
          _buildTreatmentListItem(state.filteredTreatments[index], viewModel),
    );
  }

  Widget _buildTreatmentListItem(
    TreatmentModel treatment,
    TreatmentViewModel viewModel,
  ) {
    return BorderdContainerWidget(
      enableHover: true,
      padding: EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 72.w,
            height: 72.w,
            decoration: BoxDecoration(
              color: CustomColors.softGrey,
              borderRadius: BorderRadius.circular(AppRadius.md),
              image: (treatment.image != null && treatment.image!.isNotEmpty)
                  ? DecorationImage(
                      image: NetworkImage(treatment.image!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: (treatment.image == null || treatment.image!.isEmpty)
                ? Icon(
                    Icons.image_outlined,
                    color: CustomColors.lightGrey,
                    size: 24.sp,
                  )
                : null,
          ),
          SizedBox(width: AppSpacing.xl),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      treatment.name ?? "N/A",
                      style: CustomFonts.black14w600.copyWith(fontSize: 15.sp),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    _statusBadge(treatment.isActive),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  "${treatment.category ?? 'General'} • ${treatment.subcategory ?? 'N/A'}",
                  style: CustomFonts.grey12w400,
                ),
                SizedBox(height: 6.h),
                Text(
                  treatment.shortDescription ??
                      treatment.description ??
                      "No description provided.",
                  style: CustomFonts.grey13w500,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 8.h,
            ),
            decoration: BoxDecoration(
              color: CustomColors.palePurple,
              borderRadius: BorderRadius.circular(AppRadius.full),
              border: Border.all(
                color: CustomColors.green.withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.layers_outlined,
                  size: 14.sp,
                  color: CustomColors.green,
                ),
                SizedBox(width: 8.w),
                Text(
                  "${treatment.sideAreas?.length ?? 0} Active Areas",
                  style: CustomFonts.black14w600.copyWith(
                    fontSize: 11.sp,
                    color: CustomColors.green,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.xxl),

          _buildMoreMenu(treatment, viewModel),
        ],
      ),
    );
  }

  Widget _statusBadge(bool isActive) {
    return AppBadge(
      label: isActive ? "ACTIVE" : "INACTIVE",
      variant: isActive ? AppBadgeVariant.success : AppBadgeVariant.neutral,
    );
  }

  Widget _buildMoreMenu(
    TreatmentModel treatment,
    TreatmentViewModel viewModel,
  ) {
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
      icon: const Icon(
        Icons.more_horiz_rounded,
        size: 24,
        color: CustomColors.grey,
      ),
      offset: const Offset(0, 40),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'detail',
          child: Row(
            children: [
              const Icon(
                Icons.visibility_outlined,
                size: 18,
                color: CustomColors.grey,
              ),
              SizedBox(width: AppSpacing.sm),
              const Text("View Profile"),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'toggle',
          child: Row(
            children: [
              Icon(
                treatment.isActive
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 18,
                color: treatment.isActive
                    ? CustomColors.amber
                    : CustomColors.green,
              ),
              SizedBox(width: AppSpacing.sm),
              Text(treatment.isActive ? "Deactivate" : "Activate"),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              const Icon(
                Icons.delete_outline_rounded,
                size: 18,
                color: CustomColors.red,
              ),
              SizedBox(width: AppSpacing.sm),
              Text(
                "Archive Treatment",
                style: TextStyle(color: CustomColors.red),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(
    TreatmentModel treatment,
    TreatmentViewModel viewModel,
  ) {
    showDialog(
      context: context,
      builder: (context) => StandardDialog(
        title: "Archive Treatment",
        width: 400.w,
        content: Text(
          "Confirm archiving '${treatment.name}'? It will be removed from all active catalogs.",
          style: CustomFonts.grey14w400,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          CustomPrimaryButton(
            onTap: () {
              viewModel.deleteTreatment(treatment.id ?? 0);
              Navigator.pop(context);
            },
            label: "Archive",
            width: 120.w,
          ),
        ],
      ),
    );
  }
}
