import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/treatment_model.dart';
import 'package:skinsync_admin/screens/create_treatment_screen.dart';
import 'package:skinsync_admin/screens/treatment_detail_screen.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/treatment_data_view_model.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';
import 'package:skinsync_admin/widgets/app_search_field.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'package:skinsync_admin/widgets/app_badge.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/screens/manage_treatment_data_screen.dart';
import 'package:skinsync_admin/widgets/dailogbox/standard_dialog.dart';

import 'package:skinsync_admin/widgets/gradient_scaffold.dart';

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

    return GradientScaffold(
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(
          horizontal: 28,
          vertical: 28,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            context.verticalSpace(32),
            _buildSearchAndFilterBar(context, viewModel, dataState),
            context.verticalSpace(24),
            _buildTreatmentList(context, state, viewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Treatment Library", style: context.fonts.black26w700),
            context.verticalSpace(6),
            Text(
              "Manage medical aesthetic procedures and treatment logic.",
              style: context.fonts.grey13w500,
            ),
          ],
        ),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: () => context.push(ManageTreatmentDataScreen.routeName),
              icon: const Icon(Icons.tune_rounded, size: 20),
              label: const Text('Configure Meta-Data'),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
            ),
            context.horizontalSpace(16),
            CustomPrimaryButton(
              onTap: () {
                ref.read(treatmentViewModelProvider.notifier).resetForm();
                context.push(CreateTreatmentScreen.routeName);
              },
              icon: Icons.add_rounded,
              label: 'New Treatment',
              width: context.w(180),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchAndFilterBar(BuildContext context, TreatmentViewModel viewModel, TreatmentDataState dataState) {
    return Row(
      children: [
        AppSearchField(
          controller: viewModel.searchController,
          hintText: "Search treatments by keyword, category, or area...",
          onChanged: (val) => viewModel.onSearchChanged(val),
          onClear: () => viewModel.onSearchChanged(""),
        ),
        context.horizontalSpace(16),
        OutlinedButton.icon(
          onPressed: () => _showFiltersModal(context, viewModel, dataState),
          icon: const Icon(Icons.filter_list_rounded, size: 20),
          label: const Text("Refine Results"),
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            minimumSize: Size(0, context.h(52)),
          ),
        ),
      ],
    );
  }

  void _showFiltersModal(BuildContext context, TreatmentViewModel viewModel, TreatmentDataState dataState) {
    showDialog(
      context: context,
      builder: (context) => StandardDialog(
        title: "Filter Library",
        width: context.w(600),
        content: StatefulBuilder(
          builder: (context, setModalState) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildModalSearchField(
                      context,
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
                  context.horizontalSpace(16),
                  Expanded(
                    child: _buildModalSearchField(
                      context,
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
              context.verticalSpace(24),
              Row(
                children: [
                  Expanded(
                    child: _buildModalSearchField(
                      context,
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
                  context.horizontalSpace(16),
                  Expanded(
                    child: _buildModalSearchField(
                      context,
                      label: "Visibility",
                      hint: "Any Status",
                      controller: viewModel.filterStatusController,
                      suggestions: const ["Active", "Inactive"],
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
            width: context.w(180),
          ),
        ],
      ),
    );
  }

  Widget _buildModalSearchField(
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
        Text(label, style: context.fonts.black14w600),
        context.verticalSpace(8),
        SearchAnchor(
          viewHintText: hint,
          viewConstraints: BoxConstraints(maxHeight: context.h(350)),
          builder: (context, searchController) {
            if (searchController.text.isEmpty && controller.text.isNotEmpty) {
              searchController.text = controller.text;
            }
            return TextFormField(
              controller: controller,
              readOnly: true,
              style: context.fonts.grey14w400,
              onTap: () {
                searchController.text = controller.text;
                searchController.openView();
              },
              decoration: InputDecoration(
                hintText: hint,
                suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
                filled: true,
                fillColor: CustomColors.whiteGrey,
                border: OutlineInputBorder(borderRadius: context.borderRadius(all: 12), borderSide: BorderSide.none),
              ),
            );
          },
          suggestionsBuilder: (context, searchController) {
            final query = searchController.text.toLowerCase();
            return [
              ListTile(
                title: Text("All $label", style: context.fonts.black14w600.copyWith(color: CustomColors.purple)),
                onTap: () {
                  controller.clear();
                  onSelected("");
                  searchController.closeView("");
                },
              ),
              ...suggestions
                  .where((s) => s.toLowerCase().contains(query))
                  .map((item) => ListTile(
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

  Widget _buildTreatmentList(BuildContext context, TreatmentState state, TreatmentViewModel viewModel) {
    if (state.loading) return const Center(child: CircularProgressIndicator());
    
    if (state.filteredTreatments.isEmpty) {
      return Center(
        child: Padding(
          padding: context.appEdgeInsets(top: 80),
          child: Column(
            children: [
              Icon(Icons.search_off_rounded, size: context.sp(48), color: CustomColors.lightGrey),
              context.verticalSpace(16),
              Text("No matching treatments found.", style: context.fonts.black16w400.copyWith(color: CustomColors.grey)),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.filteredTreatments.length,
      separatorBuilder: (context, index) => context.verticalSpace(16),
      itemBuilder: (context, index) => _buildTreatmentListItem(context, state.filteredTreatments[index], viewModel),
    );
  }

  Widget _buildTreatmentListItem(BuildContext context, TreatmentModel treatment, TreatmentViewModel viewModel) {
    return BorderdContainerWidget(
      enableHover: true,
      padding: context.appEdgeInsets(all: 16),
      child: Row(
        children: [
          Container(
            width: context.w(72),
            height: context.w(72),
            decoration: BoxDecoration(
              color: CustomColors.softGrey,
              borderRadius: context.borderRadius(all: 12),
              image: (treatment.image != null && treatment.image!.isNotEmpty)
                  ? DecorationImage(
                      image: NetworkImage(treatment.image!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: (treatment.image == null || treatment.image!.isEmpty)
                ? Icon(Icons.image_outlined, color: CustomColors.lightGrey, size: context.sp(24))
                : null,
          ),
          context.horizontalSpace(24),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(treatment.name ?? "N/A", style: context.fonts.black14w600.copyWith(fontSize: context.sp(15))),
                    context.horizontalSpace(12),
                    _statusBadge(treatment.isActive),
                  ],
                ),
                context.verticalSpace(4),
                Text(
                  "${treatment.category ?? 'General'} • ${treatment.subcategory ?? 'N/A'}",
                  style: context.fonts.grey12w400,
                ),
                context.verticalSpace(6),
                Text(
                  treatment.shortDescription ?? treatment.description ?? "No description provided.",
                  style: context.fonts.grey13w500,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          Container(
            padding: context.appEdgeInsets(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: CustomColors.palePurple,
              borderRadius: context.borderRadius(all: 999),
              border: Border.all(color: CustomColors.green.withValues(alpha: 0.1)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.layers_outlined, size: context.sp(14), color: CustomColors.green),
                context.horizontalSpace(8),
                Text(
                  "${treatment.sideAreas?.length ?? 0} Active Areas",
                  style: context.fonts.black14w600.copyWith(fontSize: context.sp(11), color: CustomColors.green),
                ),
              ],
            ),
          ),
          context.horizontalSpace(32),
          
          _buildMoreMenu(context, treatment, viewModel),
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

  Widget _buildMoreMenu(BuildContext context, TreatmentModel treatment, TreatmentViewModel viewModel) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'detail':
            viewModel.selectTreatment(treatment);
            context.push(TreatmentDetailScreen.routeName);
            break;
          case 'delete':
            _showDeleteConfirmation(context, treatment, viewModel);
            break;
          case 'toggle':
            viewModel.toggleTreatmentStatus(treatment.id ?? 0);
            break;
        }
      },
      icon: const Icon(Icons.more_horiz_rounded, size: 24, color: CustomColors.grey),
      offset: const Offset(0, 40),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: context.borderRadius(all: 12)),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'detail',
          child: Row(
            children: [
              const Icon(Icons.visibility_outlined, size: 18, color: CustomColors.grey),
              context.horizontalSpace(12),
              const Text("View Profile"),
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
                color: treatment.isActive ? CustomColors.amber : CustomColors.green,
              ),
              context.horizontalSpace(12),
              Text(treatment.isActive ? "Deactivate" : "Activate"),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              const Icon(Icons.delete_outline_rounded, size: 18, color: CustomColors.red),
              context.horizontalSpace(12),
              const Text("Archive Treatment", style: TextStyle(color: CustomColors.red)),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, TreatmentModel treatment, TreatmentViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => StandardDialog(
        title: "Archive Treatment",
        width: context.w(400),
        content: Text("Confirm archiving '${treatment.name}'? It will be removed from all active catalogs.", style: context.fonts.grey14w400),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          CustomPrimaryButton(
            onTap: () {
              viewModel.deleteTreatment(treatment.id ?? 0);
              Navigator.pop(context);
            },
            label: "Archive",
            width: context.w(120),
          ),
        ],
      ),
    );
  }
}
