import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/utils/enums.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';
import 'package:skinsync_admin/widgets/custom_outlined_button.dart';
import 'package:skinsync_admin/widgets/select_or_create_dropdown_widget.dart';

import '../../models/product_model.dart';
import '../../models/responses/manufacturers_list_response.dart';
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
import '../manage_inventory_data_screen.dart';
import '../../widgets/app_network_image.dart';
import '../../widgets/status_toggle_switch.dart';

class ProductManagement extends ConsumerStatefulWidget {
  const ProductManagement({super.key});
  static const String routeName = '/product-management';

  @override
  ConsumerState<ProductManagement> createState() => _ProductManagementState();
}

class _ProductManagementState extends ConsumerState<ProductManagement> {
  final TextEditingController _searchController = TextEditingController();
  ProductStatus _selectedStatus = ProductStatus.all;
  String? _selectedPurpose;

  bool _isManufacturerView = false;
  int? _expandedManufacturerId;
  int? _activeBrandId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(productViewModelProvider.notifier)
          .fetchProducts(page: 1, limit: 20);
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

      return matchesQuery;
    }).toList();

    final paginatedProducts = filteredProducts;

    return GradientScaffold(
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            context.verticalSpace(32),
            _buildCatalogOverview(),
            context.verticalSpace(32),
            _buildFilters(),
            context.verticalSpace(24),
            _isManufacturerView
                ? _buildManufacturerViewSection(state)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCatalogTable(paginatedProducts),
                      if (state.totalPages >= 1)
                        Padding(
                          padding: context.appEdgeInsets(vertical: 24),
                          child: Center(
                            child: NumberPaginator(
                              totalPages: state.totalPages,
                              currentPage: state.currentPage - 1,
                              onPageChanged: (pageIndex) {
                                ref
                                    .read(productViewModelProvider.notifier)
                                    .fetchProducts(
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
            context.verticalSpace(8),
            Text(
              'Manage platform-wide product definitions and template specifications for clinics.',
              style: context.fonts.grey14w400,
            ),
          ],
        ),
        Row(
          children: [
            CustomOutlinedButton(
              onTap: () => context.push(ManageInventoryDataScreen.routeName),
              icon: Icons.tune_rounded,
              label: 'Configure Meta-Data',
              color: Colors.white,
              textColor: CustomColors.purple,
            ),
            context.horizontalSpace(16),
            CustomPrimaryButton(
              onTap: () {
                context.push(CreateProductScreen.routeName, extra: null);
              },
              icon: Icons.add_circle_outline,
              label: 'Create Catalog Product',
              width: context.w(240),
            ),
          ],
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
        context.horizontalSpace(16),
        _buildCatalogStat(
          'Published Brands',
          '$totalBrands',
          Icons.workspace_premium_outlined,
          CustomColors.amber,
        ),
        context.horizontalSpace(16),
        _buildCatalogStat(
          'Lot Tracking Enabled',
          '$lotTrackingEnabled',
          Icons.pin_outlined,
          CustomColors.green,
        ),
        context.horizontalSpace(16),
        _buildCatalogStat(
          'Device Catalog',
          '$devicesCount Devices',
          Icons.biotech_outlined,
          CustomColors.black,
        ),
      ],
    );
  }

  void _showCreateMasterItemDialog(
    BuildContext context,
    WidgetRef ref,
    String title,
    void Function(String name) onAdd,
  ) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create New $title', style: context.fonts.black18w600),
          content: BuildTextField(
            label: 'Name',
            controller: controller,
            hintText: 'Enter name...',
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: CustomPrimaryButton(
                onTap: () {
                  final name = controller.text.trim();
                  if (name.isNotEmpty) {
                    onAdd(name);
                    Navigator.pop(context);
                  }
                },
                label: 'Add',
                width: context.w(100),
              ),
            ),
            context.verticalSpace(10),
            CustomOutlinedButton(
              onTap: () => Navigator.pop(context),
              label: 'Cancel',
            ),
          ],
        );
      },
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
        padding: context.appEdgeInsets(all: 20),
        child: Row(
          children: [
            Container(
              padding: context.appEdgeInsets(all: 12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: context.appBorderRadius(all: 10),
              ),
              child: Icon(icon, color: color, size: context.sp(24)),
            ),
            context.horizontalSpace(16),
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
      padding: context.appEdgeInsets(all: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            flex: 3,
            child: AppSearchField(
              controller: _searchController,
              hintText:
                  'Search master catalog by product name, SKU or brand manufacturer...',
              onChanged: (val) {
                ref
                    .read(productViewModelProvider.notifier)
                    .fetchProducts(search: val, page: 1, limit: state.pageSize);
              },
            ),
          ),
          context.horizontalSpace(16),
          CustomOutlinedButton(
            onTap: () {
              setState(() {
                _isManufacturerView = !_isManufacturerView;
                if (_isManufacturerView) {
                  ref.read(productViewModelProvider.notifier).fetchManufacturer();
                } else {
                  _expandedManufacturerId = null;
                  _activeBrandId = null;
                }
              });
            },
            icon: _isManufacturerView
                ? Icons.table_rows_rounded
                : Icons.business_outlined,
            label: _isManufacturerView ? 'Table View' : 'Browse by Manufacturer',
            textColor: CustomColors.purple,
            color: Colors.white,
          ),
          context.horizontalSpace(16),
          Expanded(
            child: Consumer(
              builder: (context, ref, _) {
                final usageType =
                    ref.watch(productViewModelProvider).usageType ?? [];

                return SelectOrCreateDropdown<String>(
                  label: 'Usage Type',
                  hint: 'Select Usage Type',
                  value: _selectedPurpose,
                  showAddIcon: false,
                  items: usageType.map((e) => e.name).toList(),
                  // ← convert to List<String>
                  itemLabel: (usageType) => usageType,
                  // ← String displays itself
                  onChanged: (val) {
                    setState(() {
                      _selectedPurpose = val;
                    });
                    ref
                        .read(productViewModelProvider.notifier)
                        .fetchProducts(
                          search: state.searchKeyword,
                          selectedPurpose: _selectedPurpose,
                        );
                  },
                  onOpen: () => ref
                      .read(productViewModelProvider.notifier)
                      .fetchUsageType(),
                  onCreate: () => _showCreateMasterItemDialog(
                    context,
                    ref,
                    'UsageType',
                    (name) => setState(() => _selectedPurpose = name),
                  ),
                );
              },
            ),
          ),
          context.horizontalSpace(12),
          Expanded(
            child: CustomDropdown<ProductStatus>(
              label: 'Product Status',
              hintText: 'Select a status',
              value: _selectedStatus,
              items: ProductStatus.values
                  .map(
                    (status) => DropdownMenuItem(
                      value: status,
                      child: Text(status.label),
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _selectedStatus = val ?? ProductStatus.all;
                  ref
                      .read(productViewModelProvider.notifier)
                      .fetchProducts(
                        search: state.searchKeyword,
                        status: _selectedStatus,
                      );
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManufacturerViewSection(ProductState state) {
    if (state.loading && (state.manufacturers == null || state.manufacturers!.isEmpty)) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 48),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state.manufacturers == null || state.manufacturers!.isEmpty) {
      return BorderdContainerWidget(
        padding: context.appEdgeInsets(all: 48),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.business_outlined,
                size: context.sp(48),
                color: CustomColors.grey,
              ),
              context.verticalSpace(16),
              Text('No manufacturers found', style: context.fonts.black16w600),
            ],
          ),
        ),
      );
    }

    return _buildManufacturerTree(state.manufacturers!, state);
  }

  Widget _buildManufacturerTree(
    List<ManufacturersModel> manufacturers,
    ProductState state,
  ) {
    return Column(
      children: manufacturers.map((man) {
        final bool isExpanded = _expandedManufacturerId == man.id;

        return Padding(
          padding: context.appEdgeInsets(vertical: 4),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: context.appBorderRadius(all: 12),
              border: Border.all(
                color: isExpanded
                    ? CustomColors.purple.withValues(alpha: 0.3)
                    : CustomColors.border,
                width: isExpanded ? 1.5 : 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: context.appBorderRadius(all: 12),
              child: ExpansionTile(
                key: ValueKey('man_tile_${man.id}_$isExpanded'),
                initiallyExpanded: isExpanded,
                onExpansionChanged: (expanded) {
                  setState(() {
                    if (expanded) {
                      _expandedManufacturerId = man.id;
                    } else {
                      if (_expandedManufacturerId == man.id) {
                        _expandedManufacturerId = null;
                      }
                    }
                  });
                },
                leading: Container(
                  width: context.w(36),
                  height: context.w(36),
                  decoration: BoxDecoration(
                    color: CustomColors.whiteGrey,
                    borderRadius: context.appBorderRadius(all: 6),
                  ),
                  child: Icon(
                    Icons.business_outlined,
                    color: CustomColors.purple,
                    size: context.sp(18),
                  ),
                ),
                title: Text(
                  man.name,
                  style: context.fonts.black14w600.copyWith(
                    color: isExpanded
                        ? CustomColors.purple
                        : CustomColors.black,
                  ),
                ),
                childrenPadding: context.appEdgeInsets(
                  horizontal: 16,
                  vertical: 12,
                ),
                backgroundColor: Colors.transparent,
                collapsedBackgroundColor: Colors.transparent,
                shape: const Border(),
                collapsedShape: const Border(),
                children: [
                  if (man.brand.isEmpty)
                    Padding(
                      padding: context.appEdgeInsets(vertical: 8),
                      child: Text(
                        'No brands associated with this manufacturer.',
                        style: context.fonts.grey12w400,
                      ),
                    )
                  else
                    Column(
                      children: man.brand.map((brand) {
                        final bool isBrandExpanded = _activeBrandId == brand.id;

                        // Filter products of this brand dynamically from catalog
                        final brandProducts = state.products.where((p) =>
                            p.brand?.toLowerCase().trim() == brand.name.toLowerCase().trim()
                        ).toList();

                        return Padding(
                          padding: context.appEdgeInsets(vertical: 4),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: CustomColors.whiteGrey,
                              borderRadius: context.appBorderRadius(all: 8),
                              border: Border.all(
                                color: isBrandExpanded
                                    ? CustomColors.purple.withValues(alpha: 0.2)
                                    : CustomColors.border.withValues(alpha: 0.5),
                              ),
                            ),
                            child: ExpansionTile(
                              key: ValueKey('brand_tile_${brand.id}_$isBrandExpanded'),
                              initiallyExpanded: isBrandExpanded,
                              onExpansionChanged: (expanded) {
                                setState(() {
                                  if (expanded) {
                                    _activeBrandId = brand.id;
                                  } else {
                                    if (_activeBrandId == brand.id) {
                                      _activeBrandId = null;
                                    }
                                  }
                                });
                              },
                              leading: Icon(
                                Icons.branding_watermark_outlined,
                                color: isBrandExpanded ? CustomColors.purple : CustomColors.grey,
                                size: context.sp(18),
                              ),
                              title: Text(
                                brand.name,
                                style: context.fonts.black13w600.copyWith(
                                  color: isBrandExpanded ? CustomColors.purple : CustomColors.black,
                                ),
                              ),
                              childrenPadding: context.appEdgeInsets(horizontal: 12, vertical: 12),
                              shape: const Border(),
                              collapsedShape: const Border(),
                              children: [
                                _buildCatalogTable(brandProducts),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCatalogTable(List<ProductModel> products) {
    if (products.isEmpty) {
      return BorderdContainerWidget(
        padding: context.appEdgeInsets(all: 40),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.inventory_2_outlined,
                color: CustomColors.grey,
                size: context.sp(48),
              ),
              context.verticalSpace(16),
              Text(
                'No Matching Products Found',
                style: context.fonts.black16w600,
              ),
              context.verticalSpace(4),
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
        borderRadius: context.appBorderRadius(all: 12),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(4), // Product & Brand
            1: FlexColumnWidth(2), // SKU
            2: FlexColumnWidth(2), // Purpose / Usage Type
            3: FlexColumnWidth(2), // Status
            4: FlexColumnWidth(2), // Actions
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
                _tableHeaderCell('STATUS'),
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
                    (() {
                      final sku = p.globalSku ?? p.sku ?? '';
                      return sku.trim().isEmpty ? 'N/A' : sku;
                    })(),
                    style: context.fonts.grey14w400,
                  ),
                  _usageBadgeCell(
                    p.usageType ?? '',
                  ),
                  _statusCell(p, ref),
                  _actionsCell(p),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _tableHeaderCell(String label) {
    return Padding(
      padding: context.appEdgeInsets(horizontal: 16, vertical: 16),
      child: Text(
        label,
        style: context.fonts.grey12w600.copyWith(letterSpacing: 1),
      ),
    );
  }

  Widget _productNameCell(ProductModel product) {
    final displayName = product.name.trim().isEmpty ? 'N/A' : product.name;
    final displayBrand = product.brand == null || product.brand!.trim().isEmpty ? 'N/A' : product.brand!;
    return Padding(
      padding: context.appEdgeInsets(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: context.appBorderRadius(all: 8),
            child: SizedBox(
              width: context.w(48),
              height: context.w(48),
              child: product.image.isEmpty
                  ? const DecoratedBox(
                      decoration: BoxDecoration(color: CustomColors.whiteGrey),
                      child: Icon(Icons.broken_image, color: CustomColors.grey),
                    )
                  : AppNetworkImage(imageUrl: product.image, fit: BoxFit.cover),
            ),
          ),
          context.horizontalSpace(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: context.fonts.black14w600,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                context.verticalSpace(2),
                Text(
                  displayBrand,
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
      padding: context.appEdgeInsets(horizontal: 16, vertical: 16),
      child: Text(
        text,
        style: style,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _usageBadgeCell(String purpose) {
    final trimmed = purpose.trim();
    if (trimmed.isEmpty) {
      return Padding(
        padding: context.appEdgeInsets(horizontal: 16, vertical: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: context.appEdgeInsets(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: CustomColors.grey.withValues(alpha: 0.1),
                borderRadius: context.appBorderRadius(all: 20),
                border: Border.all(color: CustomColors.grey.withValues(alpha: 0.2)),
              ),
              child: Text(
                'N/A',
                style: context.fonts.amber10w800ls1.copyWith(
                  color: CustomColors.grey,
                  fontSize: context.sp(10),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final lower = trimmed.toLowerCase();
    Color badgeColor = CustomColors.purple;
    String label = trimmed;

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
    } else if (lower == 'variable') {
      badgeColor = CustomColors.purple;
      label = 'Variable';
    }

    return Padding(
      padding: context.appEdgeInsets(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: context.appEdgeInsets(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.1),
              borderRadius: context.appBorderRadius(all: 20),
              border: Border.all(color: badgeColor.withValues(alpha: 0.2)),
            ),
            child: Text(
              label,
              style: context.fonts.amber10w800ls1.copyWith(
                color: badgeColor,
                fontSize: context.sp(10),
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _statusCell(ProductModel p, WidgetRef ref) {
    return Padding(
      padding: context.appEdgeInsets(horizontal: 16, vertical: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: StatusToggleSwitch(
          status: p.status,
          onChanged: (newStatus) {
            ref
                .read(productViewModelProvider.notifier)
                .updateProductStatus(p.id!, newStatus);
          }, width: context.w(100), height: context.h(45),
        ),
      ),
    );
  }

  Widget _actionsCell(ProductModel product) {
    return Padding(
      padding: context.appEdgeInsets(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          IconButton(
            tooltip: 'View Details',
            icon: Icon(
              Icons.visibility_outlined,
              color: CustomColors.grey,
              size: context.sp(20),
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
              size: context.sp(20),
            ),
            onPressed: () async {
              if (product.id != null) {
                try {
                  await ref
                      .read(productViewModelProvider.notifier)
                      .fetchProductDetail(product.id!);
                  final detailedProduct = ref
                      .read(productViewModelProvider)
                      .selectedProduct;
                  if (context.mounted && detailedProduct != null) {
                    context.push(
                      CreateProductScreen.routeName,
                      extra: detailedProduct.toProductModel(),
                    );
                  }
                } catch (e) {
                  // Error handled gracefully by runSafely wrapper
                }
              }
            },
          ),
          IconButton(
            tooltip: 'Archive',
            icon: Icon(
              Icons.archive_outlined,
              color: CustomColors.red,
              size: context.sp(20),
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
