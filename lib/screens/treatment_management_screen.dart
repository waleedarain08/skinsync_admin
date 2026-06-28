import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/treatment_data_models.dart';
import 'package:skinsync_admin/screens/create_treatment_screen.dart';
import 'package:skinsync_admin/view_models/category_view_model.dart';

import '../../widgets/app_network_image.dart';
import '../../widgets/custom_dropdown_widget.dart';
import '../../widgets/status_toggle_switch.dart';
import '../utils/theme.dart';
import '../view_models/treatment_view_model.dart';
import '../widgets/app_search_field.dart';
import '../widgets/borderd_container_widget.dart';
import '../widgets/custom_outlined_button.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/number_paginator.dart';
import 'edit_treatment_screen.dart';
import 'manage_treatment_data_screen.dart';
import 'treatment_detail_screen.dart';

class TreatmentManagementScreen extends ConsumerStatefulWidget {
  const TreatmentManagementScreen({super.key});
  static const String routeName = '/treatment-management';

  @override
  ConsumerState<TreatmentManagementScreen> createState() =>
      _TreatmentManagementScreenState();
}

class _TreatmentManagementScreenState
    extends ConsumerState<TreatmentManagementScreen> {
  String _selectedCategoryFilter = 'All Categories';
  String _selectedSubcategoryFilter = 'All Subcategories';
  String _selectedStatusFilter = 'All Statuses';

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
    final categoryState = ref.watch(categoryViewModelProvider);

    // Parent categories (top-level)
    final parentCategories = categoryState.categories;

    // Find currently selected parent category if any
    CategoryModel? selectedParent;
    if (_selectedCategoryFilter != 'All Categories') {
      selectedParent = parentCategories
          .where((c) => c.name == _selectedCategoryFilter)
          .firstOrNull;
    }

    // Subcategories of selected parent
    final subCategories = selectedParent?.subCategories ?? [];

    // Filter treatments dynamically based on inline filters
    final filteredTreatments = state.treatments.where((t) {
      final query = viewModel.searchController.text.toLowerCase();
      final matchesQuery =
          query.isEmpty ||
          (t.name?.toLowerCase().contains(query) ?? false) ||
          (t.description?.toLowerCase().contains(query) ?? false) ||
          (t.shortDescription?.toLowerCase().contains(query) ?? false);

      final matchesCategory =
          _selectedCategoryFilter == 'All Categories' ||
          t.categoryPath == null ||
          (t.categoryPath?.toLowerCase().contains(
                _selectedCategoryFilter.toLowerCase(),
              ) ??
              false) ||
          (t.categoryName?.toLowerCase() ==
              _selectedCategoryFilter.toLowerCase());

      final matchesSubcategory =
          _selectedSubcategoryFilter == 'All Subcategories' ||
          t.categoryPath == null ||
          (t.categoryPath?.toLowerCase().contains(
                _selectedSubcategoryFilter.toLowerCase(),
              ) ??
              false);

      final matchesStatus =
          _selectedStatusFilter == 'All Statuses' ||
          (_selectedStatusFilter == 'Active' && t.status.toLowerCase() == 'active') ||
          (_selectedStatusFilter == 'Inactive' && (t.status.toLowerCase() == 'deactive' || t.status.toLowerCase() == 'inactive')) ||
          (_selectedStatusFilter == 'Draft' && t.status.toLowerCase() == 'draft');

      return matchesQuery &&
          matchesCategory &&
          matchesSubcategory &&
          matchesStatus;
    }).toList();

    return GradientScaffold(
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(horizontal: 28, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            context.verticalSpace(32),
            _buildQuickInsights(state),
            context.verticalSpace(32),
            _buildFilters(viewModel, parentCategories, subCategories),
            context.verticalSpace(24),
            _buildTreatmentTable(filteredTreatments, viewModel),
            if (state.totalPages > 1)
              Padding(
                padding: context.appEdgeInsets(vertical: 24),
                child: Center(
                  child: NumberPaginator(
                    totalPages: state.totalPages,
                    currentPage: state.currentPage - 1,
                    onPageChanged: (pageIndex) {
                      viewModel.getTreatments(page: pageIndex + 1);
                    },
                  ),
                ),
              ),
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
            Text('Treatment Library', style: context.fonts.black26w700),
            context.verticalSpace(6),
            Text(
              'Manage medical aesthetic procedures, dynamic pricing, and product consumption.',
              style: context.fonts.grey13w500,
            ),
          ],
        ),
        Row(
          children: [
            CustomOutlinedButton(
              onTap: () => context.push(ManageTreatmentDataScreen.routeName),
              icon: Icons.tune_rounded,
              label: 'Configure Meta-Data',
              color: Colors.white,
              textColor: CustomColors.purple,
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

  Widget _buildQuickInsights(TreatmentState state) {
    final totalTreatments = state.treatments.length;
    final activeTreatments = state.treatments
        .where((t) => t.status == 'active')
        .length;
    final categoriesCovered = state.treatments
        .map((t) => t.categoryName)
        .where((c) => c != null && c.isNotEmpty)
        .toSet()
        .length;
    final enabledByDefault = state.treatments
        .where((t) => t.enableByDefault)
        .length;
    return Row(
      children: [
        _buildStatCard(
          'Total Treatments',
          '$totalTreatments',
          Icons.layers_outlined,
          CustomColors.purple,
        ),
        context.horizontalSpace(16),
        _buildStatCard(
          'Active Treatments',
          '$activeTreatments',
          Icons.check_circle_outline_rounded,
          CustomColors.green,
        ),
        context.horizontalSpace(16),
        _buildStatCard(
          'Categories Covered',
          '$categoriesCovered',
          Icons.category_outlined,
          CustomColors.amber,
        ),
        context.horizontalSpace(16),
        _buildStatCard(
          'Auto-Assigned',
          '$enabledByDefault',
          Icons.auto_awesome_outlined,
          Colors.blue,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: BorderdContainerWidget(
        padding: context.appEdgeInsets(all: 16),
        child: Row(
          children: [
            Container(
              padding: context.appEdgeInsets(all: 10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: context.borderRadius(all: 8),
              ),
              child: Icon(icon, color: color, size: context.sp(20)),
            ),
            context.horizontalSpace(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: context.fonts.black18w600,
                    overflow: TextOverflow.ellipsis,
                  ),
                  context.verticalSpace(2),
                  Text(
                    title,
                    style: context.fonts.grey11w400,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters(
    TreatmentViewModel viewModel,
    List<CategoryModel> parentCategories,
    List<CategoryModel> subCategories,
  ) {
    return BorderdContainerWidget(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: AppSearchField(
              controller: viewModel.searchController,
              hintText: 'Search treatments by keyword or name...',
              onChanged: (val) {
                viewModel.getTreatments(page: 1, search: val);
              },
              onClear: () {
                viewModel.searchController.clear();
                viewModel.getTreatments(page: 1, search: '');
              },
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: CustomDropdown<String>(
              label: 'Category',
              hintText: 'All Categories',
              value: _selectedCategoryFilter,
              items: [
                'All Categories',
                ...parentCategories.map((c) => c.name),
              ].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedCategoryFilter = val ?? 'All Categories';
                  _selectedSubcategoryFilter =
                      'All Subcategories'; // Reset subcategory when parent changes
                });
              },
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: CustomDropdown<String>(
              label: 'Subcategory',
              hintText: 'All Subcategories',
              value: _selectedSubcategoryFilter,
              items: [
                'All Subcategories',
                ...subCategories.map((c) => c.name),
              ].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedSubcategoryFilter = val ?? 'All Subcategories';
                });
              },
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: CustomDropdown<String>(
              label: 'Status',
              hintText: 'All Statuses',
              value: _selectedStatusFilter,
              items: const [
                'All Statuses',
                'Active',
                'Inactive',
                'Draft',
              ].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedStatusFilter = val ?? 'All Statuses';
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentTable(
    List<TreatmentModel> treatments,
    TreatmentViewModel viewModel,
  ) {
    if (treatments.isEmpty) {
      return _buildEmptyState(context, viewModel);
    }

    return BorderdContainerWidget(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(4), // Treatment Name / Category
            1: FlexColumnWidth(2), // Global SKU
            2: FlexColumnWidth(2.2), // Status
            3: FlexColumnWidth(1.8), // Actions
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            // Header Row
            TableRow(
              decoration: const BoxDecoration(
                color: CustomColors.whiteGrey,
                border: Border(bottom: BorderSide(color: CustomColors.border)),
              ),
              children: [
                _tableHeaderCell('TREATMENT NAME'),
                _tableHeaderCell('GLOBAL SKU'),
                _tableHeaderCell('STATUS'),
                _tableHeaderCell('ACTIONS'),
              ],
            ),
            // Data Rows
            ...treatments.map((t) {
              return TableRow(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: CustomColors.border),
                  ),
                ),
                children: [
                  _treatmentNameCell(t),
                  _tableTextCell(
                    t.globalSku ?? '—',
                    style: context.fonts.black14w600,
                  ),
                  _statusBadgeCell(t, ref),
                  _actionsCell(t, viewModel),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _tableHeaderCell(String label) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Text(
        label,
        style: context.fonts.grey12w600.copyWith(letterSpacing: 1),
      ),
    );
  }

  Widget _treatmentNameCell(TreatmentModel treatment) {
    final displayImage = (treatment.image != null && treatment.image!.isNotEmpty)
        ? treatment.image
        : (treatment.icon != null && treatment.icon!.isNotEmpty)
            ? treatment.icon
            : null;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: CustomColors.whiteGrey,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: CustomColors.border),
            ),
            child: (displayImage != null && displayImage.isNotEmpty)
                ? AppNetworkImage(
                    imageUrl: displayImage,
                    width: 48.w,
                    height: 48.w,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.circular(8.r),
                  )
                : const Center(
                    child: Icon(Icons.image_outlined, color: CustomColors.grey),
                  ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  treatment.name ?? 'N/A',
                  style: context.fonts.black14w600,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  treatment.shortDescription ?? 'General',
                  style: context.fonts.purple12w700,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableTextCell(String text, {required TextStyle style}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Text(
        text,
        style: style,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _statusBadgeCell(TreatmentModel t, WidgetRef ref) {
    final status = t.status;
    final String currentStatus = status.toLowerCase() == 'deactive' ? 'Inactive' : status;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: StatusToggleSwitch(
        status: currentStatus,
        onChanged: (newStatus) {
          if (t.id != null) {
            ref.read(treatmentViewModelProvider.notifier).updateTreatmentStatus(t.id!, newStatus);
          }
        },
      ),
    );
  }

  Widget _actionsCell(TreatmentModel treatment, TreatmentViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        children: [
          IconButton(
            tooltip: 'View Profile',
            icon: Icon(
              Icons.visibility_outlined,
              color: CustomColors.grey,
              size: 20.sp,
            ),
            onPressed: () async {
              if (treatment.id != null) {
                try {
                  await ref
                      .read(treatmentViewModelProvider.notifier)
                      .fetchTreatmentDetail(treatment.id!);
                  if (mounted) {
                    await context.push(TreatmentDetailScreen.routeName);
                  }
                } catch (e) {
                  // Error handled gracefully by runSafely wrapper
                }
              }
            },
          ),
          IconButton(
            tooltip: 'Edit Template',
            icon: Icon(
              Icons.edit_road_rounded,
              color: CustomColors.purple,
              size: 20.sp,
            ),
            onPressed: () async {
              if (treatment.id != null) {
                try {
                  await ref
                      .read(treatmentViewModelProvider.notifier)
                      .fetchTreatmentDetail(treatment.id!);
                  if (mounted) {
                    await context.push(EditTreatmentScreen.routeName);
                  }
                } catch (e) {
                  // Error handled gracefully by runSafely wrapper
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, TreatmentViewModel viewModel) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 48),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: context.appEdgeInsets(all: 20),
              decoration: const BoxDecoration(
                color: CustomColors.whiteGrey,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: context.sp(48),
                color: CustomColors.grey,
              ),
            ),
            context.verticalSpace(24),
            Text(
              'No treatments match your refinements',
              style: context.fonts.black18w600,
            ),
            context.verticalSpace(8),
            Text(
              'Try clearing your search keyword, resetting the filters, or create a brand new treatment profile.',
              style: context.fonts.grey14w400,
              textAlign: TextAlign.center,
            ),
            context.verticalSpace(24),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomOutlinedButton(
                  onTap: () {
                    viewModel.searchController.clear();
                    setState(() {
                      _selectedCategoryFilter = 'All Categories';
                      _selectedSubcategoryFilter = 'All Subcategories';
                      _selectedStatusFilter = 'All Statuses';
                    });
                  },
                  label: 'Clear All Filters',
                  color: Colors.white,
                  textColor: CustomColors.purple,
                ),
                context.horizontalSpace(16),
                CustomPrimaryButton(
                  onTap: () {
                    viewModel.resetForm();
                    context.push(CreateTreatmentScreen.routeName);
                  },
                  icon: Icons.add_rounded,
                  label: 'Create Treatment',
                  width: context.w(180),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}