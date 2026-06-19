import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/product_model.dart';
import '../../utils/theme.dart';
import '../../view_models/product_view_model.dart';
import '../../widgets/app_search_field.dart';
import '../../widgets/borderd_container_widget.dart';
import '../../widgets/custom_dropdown_widget.dart';
import '../../widgets/custom_primary_button.dart';
import '../../widgets/gradient_scaffold.dart';
import '../../widgets/number_paginator.dart';
import '../create_product_screen.dart';
import '../product_detail_screen.dart';
import '../../widgets/custom_cashed_image_widget.dart';

class ProductManagement extends ConsumerStatefulWidget {
  const ProductManagement({super.key});
  static const String routeName = '/product-management';

  @override
  ConsumerState<ProductManagement> createState() => _ProductManagementState();
}

class _ProductManagementState extends ConsumerState<ProductManagement> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedPurposeFilter = 'All Purposes';
  String _selectedTrackingFilter = 'All Statuses';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productViewModelProvider.notifier).fetchProducts(page: 1, limit: 20);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productViewModelProvider);
    final catalogProducts = state.products;

    // Filter products dynamically
    final filteredProducts = catalogProducts.where((p) {
      final query = _searchController.text.toLowerCase();
      final matchesQuery =
          query.isEmpty ||
          p.name.toLowerCase().contains(query) ||
          (p.brand?.toLowerCase().contains(query) ?? false) ||
          (p.globalSku?.toLowerCase().contains(query) ?? false);

      final matchesPurpose =
          _selectedPurposeFilter == 'All Purposes' ||
          p.productPurpose == _selectedPurposeFilter.toLowerCase();

      final matchesTracking =
          _selectedTrackingFilter == 'All Statuses' ||
          (_selectedTrackingFilter == 'Tracking Enabled' &&
              (p.enforceLotTracking ?? false)) ||
          (_selectedTrackingFilter == 'Tracking Disabled' &&
              !(p.enforceLotTracking ?? false));

      return matchesQuery && matchesPurpose && matchesTracking;
    }).toList();

    final paginatedProducts = filteredProducts;

    return GradientScaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 32.h),
            _buildCatalogOverview(),
            SizedBox(height: 32.h),
            _buildFilters(),
            SizedBox(height: 24.h),
            _buildCatalogTable(paginatedProducts),
            if (state.totalPages >= 1)
              Padding(
                padding: context.appEdgeInsets(vertical: 24),
                child: Center(
                  child: NumberPaginator(
                    totalPages: state.totalPages,
                    currentPage: state.currentPage - 1,
                    onPageChanged: (pageIndex) {
                      ref.read(productViewModelProvider.notifier).fetchProducts(
                            search: state.searchKeyword,
                            page: pageIndex + 1,
                            limit: state.pageSize,
                          );
                    },
                  ),
                ),
              ),
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
            Text('Global Product Catalog', style: context.fonts.black32w700),
            SizedBox(height: 8.h),
            Text(
              'Manage platform-wide product definitions and template specifications for clinics.',
              style: context.fonts.grey14w400,
            ),
          ],
        ),
        CustomPrimaryButton(
          onTap: () {
            context.push(CreateProductScreen.routeName, extra: null);
          },
          icon: Icons.add_circle_outline,
          label: 'Create Catalog Product',
          width: 240.w,
        ),
      ],
    );
  }

  Widget _buildCatalogOverview() {
    final state = ref.watch(productViewModelProvider);
    final catalogProducts = state.products;

    final totalSkus = catalogProducts.length;
    final totalBrands = catalogProducts.map((p) => p.brand).toSet().length;
    final lotTrackingEnabled = catalogProducts
        .where((p) => p.enforceLotTracking ?? false)
        .length;
    final devicesCount = catalogProducts
        .where((p) => p.productPurpose == 'device')
        .length;

    return Row(
      children: [
        _buildCatalogStat(
          'Total Master SKUs',
          '$totalSkus',
          Icons.inventory_2_outlined,
          CustomColors.purple,
        ),
        SizedBox(width: 16.w),
        _buildCatalogStat(
          'Published Brands',
          '$totalBrands',
          Icons.workspace_premium_outlined,
          CustomColors.amber,
        ),
        SizedBox(width: 16.w),
        _buildCatalogStat(
          'Lot Tracking Enabled',
          '$lotTrackingEnabled',
          Icons.pin_outlined,
          CustomColors.green,
        ),
        SizedBox(width: 16.w),
        _buildCatalogStat(
          'Device Catalog',
          '$devicesCount Devices',
          Icons.biotech_outlined,
          CustomColors.black,
        ),
      ],
    );
  }

  Widget _buildCatalogStat(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: BorderdContainerWidget(
        padding: EdgeInsets.all(20.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: color, size: 24.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: context.fonts.black20w600,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    title,
                    style: context.fonts.grey12w400,
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

  Widget _buildFilters() {
    final state = ref.watch(productViewModelProvider);
    return BorderdContainerWidget(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: AppSearchField(
              controller: _searchController,
              hintText:
                  'Search master catalog by product name, SKU or brand manufacturer...',
              onChanged: (val) {
                ref.read(productViewModelProvider.notifier).fetchProducts(
                      search: val,
                      page: 1,
                      limit: state.pageSize,
                    );
              },
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: CustomDropdown<String>(
              label: 'Product Purpose',
              hintText: 'All Purposes',
              value: _selectedPurposeFilter,
              items: const [
                'All Purposes',
                'Variable',
                'Required',
                'Setup/Supply',
                'Retail/Sale',
                'Device',
              ].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedPurposeFilter = val ?? 'All Purposes';
                });
              },
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: CustomDropdown<String>(
              label: 'Lot Enforcement',
              hintText: 'All Statuses',
              value: _selectedTrackingFilter,
              items: const [
                'All Statuses',
                'Tracking Enabled',
                'Tracking Disabled',
              ].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedTrackingFilter = val ?? 'All Statuses';
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCatalogTable(List<ProductModel> products) {
    if (products.isEmpty) {
      return BorderdContainerWidget(
        padding: EdgeInsets.all(40.w),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.inventory_2_outlined,
                color: CustomColors.grey,
                size: 48.sp,
              ),
              SizedBox(height: 16.h),
              Text(
                'No Matching Products Found',
                style: context.fonts.black16w600,
              ),
              SizedBox(height: 4.h),
              Text(
                'Try refining your filters or search keywords.',
                style: context.fonts.grey14w400,
              ),
            ],
          ),
        ),
      );
    }

    return BorderdContainerWidget(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(4), // Product & Brand
            1: FlexColumnWidth(2), // SKU
            2: FlexColumnWidth(2), // Purpose / Usage Type
            3: FlexColumnWidth(2), // Base Unit
            4: FlexColumnWidth(2), // Lot Tracking
            5: FlexColumnWidth(2), // Actions
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
                _tableHeaderCell('PRODUCT & BRAND'),
                _tableHeaderCell('GLOBAL SKU'),
                _tableHeaderCell('USAGE TYPE'),
                _tableHeaderCell('BASE UNIT'),
                _tableHeaderCell('LOT TRACKING'),
                _tableHeaderCell('ACTIONS'),
              ],
            ),
            // Data Rows
            ...products.map((p) {
              return TableRow(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: CustomColors.border),
                  ),
                ),
                children: [
                  _productNameCell(p),
                  _tableTextCell(
                    p.globalSku ?? p.sku ?? 'N/A',
                    style: context.fonts.grey14w400,
                  ),
                  _purposeBadgeCell(
                    p.productPurpose ?? p.category ?? 'variable',
                  ),
                  _tableTextCell(
                    (p.unitType ?? p.unit).toUpperCase(),
                    style: context.fonts.black14w600,
                  ),
                  _lotTrackingCell(p.enforceLotTracking ?? true),
                  _actionsCell(p),
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

  Widget _productNameCell(ProductModel product) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: SizedBox(
              width: 48.w,
              height: 48.w,
              child: product.image.isEmpty
                  ? const DecoratedBox(
                      decoration: BoxDecoration(color: CustomColors.whiteGrey),
                      child: Icon(Icons.broken_image, color: CustomColors.grey),
                    )
                  : CustomCachedImage(
                      imageUrl: product.image,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: context.fonts.black14w600,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  product.brand ?? 'Unknown Brand',
                  style: context.fonts.purple12w700,
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

  Widget _purposeBadgeCell(String purpose) {
    final lower = purpose.toLowerCase();
    Color badgeColor = CustomColors.purple;
    String label = 'Variable';

    if (lower == 'required') {
      badgeColor = CustomColors.green;
      label = 'Required';
    } else if (lower == 'setup/supply') {
      badgeColor = CustomColors.amber;
      label = 'Setup/Supply';
    } else if (lower == 'retail/sale') {
      badgeColor = Colors.orange;
      label = 'Retail/Sale';
    } else if (lower == 'device') {
      badgeColor = CustomColors.red;
      label = 'Device';
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: badgeColor.withValues(alpha: 0.2)),
            ),
            child: Text(
              label,
              style: context.fonts.amber10w800ls1.copyWith(
                color: badgeColor,
                fontSize: 10.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _lotTrackingCell(bool enforce) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        children: [
          Icon(
            enforce ? Icons.check_circle_rounded : Icons.cancel_rounded,
            size: 18.sp,
            color: enforce ? CustomColors.green : CustomColors.grey,
          ),
          SizedBox(width: 8.w),
          Text(
            enforce ? 'Enabled' : 'Disabled',
            style: enforce
                ? context.fonts.grey12w600.copyWith(color: CustomColors.green)
                : context.fonts.grey12w600,
          ),
        ],
      ),
    );
  }

  Widget _actionsCell(ProductModel product) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        children: [
          IconButton(
            tooltip: 'View Details',
            icon: Icon(
              Icons.visibility_outlined,
              color: CustomColors.grey,
              size: 20.sp,
            ),
            onPressed: () async {
              if (product.id != null) {
                try {
                  await ref
                      .read(productViewModelProvider.notifier)
                      .fetchProductDetail(product.id!);
                  if (context.mounted) {
                    context.push(ProductDetailScreen.routeName);
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
            onPressed: () {
              context.push(CreateProductScreen.routeName, extra: product);
            },
          ),
          IconButton(
            tooltip: 'Archive',
            icon: Icon(
              Icons.archive_outlined,
              color: CustomColors.red,
              size: 20.sp,
            ),
            onPressed: () {
              if (product.id != null) {
                ref
                    .read(productViewModelProvider.notifier)
                    .deleteProduct(product.id!);
              }
            },
          ),
        ],
      ),
    );
  }
}
