import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/responses/brands_list_response.dart';
import 'package:skinsync_admin/models/responses/manufacturers_list_response.dart';
import 'package:skinsync_admin/models/responses/package_type_list_response.dart';
import 'package:skinsync_admin/models/responses/unit_types_list_response.dart';
import 'package:skinsync_admin/models/responses/usage_type_list_response.dart';
import 'package:skinsync_admin/models/responses/supplier_list_response.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/product_view_model.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';

class ManageInventoryDataScreen extends ConsumerStatefulWidget {
  const ManageInventoryDataScreen({super.key});

  static const String routeName = '/manage-inventory-data';

  @override
  ConsumerState<ManageInventoryDataScreen> createState() =>
      _ManageInventoryDataScreenState();
}

class _ManageInventoryDataScreenState extends ConsumerState<ManageInventoryDataScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _tabController.addListener(_handleTabSelection);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Clear previous metadata to ensure fresh state on entry
      ref.read(productViewModelProvider.notifier).clearMetadata();
      // Fetch the first tab (Manufacturers)
      _fetchTabIfNeeded(0);
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    _fetchTabIfNeeded(_tabController.index);
  }

  void _fetchTabIfNeeded(int index) {
    final notifier = ref.read(productViewModelProvider.notifier);
    final state = ref.read(productViewModelProvider);

    switch (index) {
      case 0:
        if (state.manufacturers == null) {
          notifier.fetchManufacturer();
        }
        break;
      case 1:
        if (state.brands == null) {
          notifier.fetchBrand();
        }
        break;
      case 2:
        if (state.usageType == null) {
          notifier.fetchUsageType();
        }
        break;
      case 3:
        if (state.packageTypes == null) {
          notifier.fetchPackageTypes();
        }
        break;
      case 4:
        if (state.unitTypes == null) {
          notifier.fetchUnitTypes();
        }
        break;
      case 5:
        if (state.suppliers == null) {
          notifier.fetchSuppliers();
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productViewModelProvider);

    return GradientScaffold(
      appBar: AppBar(
        flexibleSpace: AppDecorations.appBarGradient,
        elevation: 0,
        title: Text(
          'Manage Product Taxonomy',
          style: context.fonts.black20w600,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: CustomColors.black),
          onPressed: () => context.pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: CustomColors.purple,
          unselectedLabelColor: CustomColors.grey,
          indicatorColor: CustomColors.purple,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Manufacturers'),
            Tab(text: 'Brands'),
            Tab(text: 'Usage Types'),
            Tab(text: 'Package Types'),
            Tab(text: 'Unit Types'),
            Tab(text: 'Suppliers'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildManufacturersTab(context, state),
          _buildBrandsTab(context, state),
          _buildUsageTypesTab(context, state),
          _buildPackageTypesTab(context, state),
          _buildUnitTypesTab(context, state),
          _buildSuppliersTab(context, state),
        ],
      ),
    );
  }

  Widget _buildTabHeader({
    required BuildContext context,
    required String title,
    required int count,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: context.fonts.black18w600),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: CustomColors.whiteGrey,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: CustomColors.border),
          ),
          child: Text(
            '$count items',
            style: context.fonts.purple14w600,
          ),
        ),
      ],
    );
  }

  Widget _buildListContainer<T>({
    required BuildContext context,
    required List<T>? items,
    required String title,
    required Widget Function(T item, int index) itemBuilder,
  }) {
    if (items == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (items.isEmpty) {
      return Center(
        child: Text(
          'No items found',
          style: context.fonts.grey14w400,
        ),
      );
    }
    return SingleChildScrollView(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTabHeader(context: context, title: title, count: items.length),
          context.verticalSpace(24),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => context.verticalSpace(16),
            itemBuilder: (context, index) => itemBuilder(items[index], index),
          ),
        ],
      ),
    );
  }

  Widget _buildManufacturersTab(BuildContext context, ProductState state) {
    return _buildListContainer<ManufacturersModel>(
      context: context,
      items: state.manufacturers,
      title: 'Product Manufacturers',
      itemBuilder: (manufacturer, index) {
        return BorderdContainerWidget(
          padding: EdgeInsets.zero,
          child: ExpansionTile(
            shape: const RoundedRectangleBorder(side: BorderSide.none),
            leading: Container(
              width: context.w(40),
              height: context.w(40),
              decoration: BoxDecoration(
                color: CustomColors.whiteGrey,
                borderRadius: context.borderRadius(all: 8),
              ),
              child: const Icon(
                Icons.business_outlined,
                color: CustomColors.purple,
              ),
            ),
            title: Text(manufacturer.name, style: context.fonts.black16w600),
            subtitle: Text(
              '${manufacturer.brand.length} associated brands',
              style: context.fonts.grey12w400,
            ),
            children: [
              if (manufacturer.brand.isEmpty)
                Padding(
                  padding: context.appEdgeInsets(all: 16),
                  child: Text(
                    'No brands associated with this manufacturer.',
                    style: context.fonts.grey12w400,
                  ),
                )
              else
                Padding(
                  padding: context.appEdgeInsets(all: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: manufacturer.brand.map((brand) {
                      return ListTile(
                        dense: true,
                        leading: const Icon(
                          Icons.branding_watermark_outlined,
                          size: 18,
                          color: CustomColors.grey,
                        ),
                        title: Text(brand.name, style: context.fonts.black14w400),
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBrandsTab(BuildContext context, ProductState state) {
    return _buildListContainer<BrandModel>(
      context: context,
      items: state.brands,
      title: 'Product Brands',
      itemBuilder: (brand, index) {
        return BorderdContainerWidget(
          padding: context.appEdgeInsets(all: 16),
          child: Row(
            children: [
              Container(
                width: context.w(40),
                height: context.w(40),
                decoration: BoxDecoration(
                  color: CustomColors.whiteGrey,
                  borderRadius: context.borderRadius(all: 8),
                ),
                child: const Icon(
                  Icons.branding_watermark_outlined,
                  color: CustomColors.purple,
                ),
              ),
              context.horizontalSpace(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(brand.name, style: context.fonts.black16w600),
                    context.verticalSpace(4),
                    Text(
                      'ID: ${brand.id}',
                      style: context.fonts.grey12w400,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUsageTypesTab(BuildContext context, ProductState state) {
    return _buildListContainer<UsageTypeModel>(
      context: context,
      items: state.usageType,
      title: 'Product Usage Types',
      itemBuilder: (usage, index) {
        return BorderdContainerWidget(
          padding: context.appEdgeInsets(all: 16),
          child: Row(
            children: [
              Container(
                width: context.w(40),
                height: context.w(40),
                decoration: BoxDecoration(
                  color: CustomColors.whiteGrey,
                  borderRadius: context.borderRadius(all: 8),
                ),
                child: const Icon(
                  Icons.category_outlined,
                  color: CustomColors.purple,
                ),
              ),
              context.horizontalSpace(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(usage.name, style: context.fonts.black16w600),
                    context.verticalSpace(4),
                    Text(
                      'ID: ${usage.id}',
                      style: context.fonts.grey12w400,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPackageTypesTab(BuildContext context, ProductState state) {
    return _buildListContainer<PackageTypeModel>(
      context: context,
      items: state.packageTypes,
      title: 'Product Package Types',
      itemBuilder: (package, index) {
        return BorderdContainerWidget(
          padding: context.appEdgeInsets(all: 16),
          child: Row(
            children: [
              Container(
                width: context.w(40),
                height: context.w(40),
                decoration: BoxDecoration(
                  color: CustomColors.whiteGrey,
                  borderRadius: context.borderRadius(all: 8),
                ),
                child: const Icon(
                  Icons.inventory_2_outlined,
                  color: CustomColors.purple,
                ),
              ),
              context.horizontalSpace(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(package.name, style: context.fonts.black16w600),
                    context.verticalSpace(4),
                    Text(
                      'ID: ${package.id}',
                      style: context.fonts.grey12w400,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUnitTypesTab(BuildContext context, ProductState state) {
    return _buildListContainer<UnitTypeModel>(
      context: context,
      items: state.unitTypes,
      title: 'Product Unit Types',
      itemBuilder: (unit, index) {
        return BorderdContainerWidget(
          padding: context.appEdgeInsets(all: 16),
          child: Row(
            children: [
              Container(
                width: context.w(40),
                height: context.w(40),
                decoration: BoxDecoration(
                  color: CustomColors.whiteGrey,
                  borderRadius: context.borderRadius(all: 8),
                ),
                child: const Icon(
                  Icons.square_foot_outlined,
                  color: CustomColors.purple,
                ),
              ),
              context.horizontalSpace(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(unit.name, style: context.fonts.black16w600),
                    context.verticalSpace(4),
                    Text(
                      'ID: ${unit.id}',
                      style: context.fonts.grey12w400,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSuppliersTab(BuildContext context, ProductState state) {
    return _buildListContainer<SupplierModel>(
      context: context,
      items: state.suppliers,
      title: 'Product Suppliers',
      itemBuilder: (supplier, index) {
        return BorderdContainerWidget(
          padding: context.appEdgeInsets(all: 16),
          child: Row(
            children: [
              Container(
                width: context.w(40),
                height: context.w(40),
                decoration: BoxDecoration(
                  color: CustomColors.whiteGrey,
                  borderRadius: context.borderRadius(all: 8),
                ),
                child: const Icon(
                  Icons.local_shipping_outlined,
                  color: CustomColors.purple,
                ),
              ),
              context.horizontalSpace(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(supplier.name, style: context.fonts.black16w600),
                    context.verticalSpace(4),
                    Text(
                      'ID: ${supplier.id}',
                      style: context.fonts.grey12w400,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}