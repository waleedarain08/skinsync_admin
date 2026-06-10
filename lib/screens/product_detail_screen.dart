import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/product_model.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';

class SelectedProductNotifier extends Notifier<ProductModel?> {
  @override
  ProductModel? build() => null;
  void set(ProductModel? p) => state = p;
}

final selectedProductProvider = NotifierProvider<SelectedProductNotifier, ProductModel?>(
  SelectedProductNotifier.new,
);

class ProductDetailScreen extends ConsumerWidget {
  static const String routeName = '/product-detail';
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(selectedProductProvider);

    if (product == null) {
      return GradientScaffold(
        body: Center(
          child: Text("No Product Data Found", style: context.fonts.black16w400),
        ),
      );
    }

    return GradientScaffold(
      appBar: AppBar(
        flexibleSpace: AppDecorations.appBarGradient,
        title: Text("Product Detail", style: context.fonts.black18w600),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: CustomColors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(horizontal: 24, vertical: 32),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.w(1000)),
            child: Column(
              children: [
                _buildHeaderSection(context, product),
                context.verticalSpace(32),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: _buildMainContent(context, product)),
                    context.horizontalSpace(32),
                    Expanded(flex: 2, child: _buildStatsSidebar(context, product)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, ProductModel product) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 32),
      child: Row(
        children: [
          Container(
            width: context.w(100),
            height: context.w(100),
            decoration: BoxDecoration(
              color: CustomColors.whiteGrey,
              borderRadius: context.borderRadius(all: 20),
              image: product.image.isNotEmpty
                  ? DecorationImage(image: NetworkImage(product.image), fit: BoxFit.cover)
                  : null,
            ),
            child: product.image.isEmpty
                ? Icon(Icons.inventory_2_outlined, size: context.sp(40), color: CustomColors.black)
                : null,
          ),
          context.horizontalSpace(32),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        product.name,
                        style: context.fonts.black26w700,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    context.horizontalSpace(16),
                    _statusBadge(context, product.status ?? "Active"),
                  ],
                ),
                context.verticalSpace(8),
                Text(product.brand ?? 'Global Manufacturer', style: context.fonts.purple14w600),
                context.verticalSpace(16),
                Wrap(
                  spacing: 12.w,
                  runSpacing: 12.h,
                  children: [
                    _infoChip(context, Icons.tag_rounded, "SKU: ${product.globalSku ?? product.sku ?? 'N/A'}"),
                    _infoChip(context, Icons.category_outlined, "Category: ${product.category ?? 'Clinical'}"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, ProductModel product) {
    return Column(
      children: [
        _infoSection(context, "Basic Information", [
          _detailRow(context, "Product Name", product.name),
          _detailRow(context, "Brand / Manufacturer", product.brand ?? "N/A"),
          _detailRow(context, "Global SKU / Reference", product.globalSku ?? product.sku ?? "N/A"),
          _detailRow(context, "Classification Group", product.category ?? "General Catalog"),
        ]),
        context.verticalSpace(24),
        _infoSection(context, "Usage & Configuration", [
          _detailRow(context, "Product Purpose", product.productPurpose ?? "Variable Usage"),
          _detailRow(context, "UOM Base Unit", product.unitType ?? product.unit),
          _detailRow(context, "Enforce Lot Tracking", (product.enforceLotTracking ?? false) ? "Yes (Mandatory)" : "No (Optional)"),
        ]),
        context.verticalSpace(24),
        _infoSection(context, "Description / Notes", [
          Text(
            product.description.isNotEmpty ? product.description : "No description provided for this catalog product.",
            style: context.fonts.grey14w400h16,
          ),
        ]),
      ],
    );
  }

  Widget _buildStatsSidebar(BuildContext context, ProductModel product) {
    return Column(
      children: [
        _infoSection(context, "Inventory Overview", [
          _statRow(context, Icons.warehouse_outlined, "Current Stock", "${product.quantity ?? 120} Units"),
          _statRow(context, Icons.storefront_outlined, "Total Clinics Using", "34 MedSpas"),
          _statRow(context, Icons.analytics_outlined, "Avg Consumption / Mo", "45.2 Units"),
        ]),
        context.verticalSpace(24),
        _infoSection(context, "Compliance", [
          _statRow(context, Icons.security_rounded, "Lot & Expiration Tracking", (product.enforceLotTracking ?? false) ? "Enforced" : "Standard"),
          _statRow(context, Icons.gavel_rounded, "Quality Standard", "FDA Approved"),
        ]),
      ],
    );
  }

  Widget _infoSection(BuildContext context, String title, List<Widget> children) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.fonts.black16w700),
          context.verticalSpace(24),
          ...children,
        ],
      ),
    );
  }

  Widget _detailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: context.appEdgeInsets(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: context.fonts.grey13w500),
          context.verticalSpace(4),
          Text(value, style: context.fonts.black14w600),
        ],
      ),
    );
  }

  Widget _statRow(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: context.appEdgeInsets(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: context.sp(18), color: CustomColors.grey),
              context.horizontalSpace(12),
              Text(label, style: context.fonts.grey13w500),
            ],
          ),
          Flexible(child: Text(value, style: context.fonts.grey14w600, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  Widget _statusBadge(BuildContext context, String status) {
    final bool isActive = status.toLowerCase() == 'active';
    return Container(
      padding: context.appEdgeInsets(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? CustomColors.green.withValues(alpha: 0.1) : CustomColors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        status.toUpperCase(),
        style: isActive ? context.fonts.green10w700 : context.fonts.red10w700,
      ),
    );
  }

  Widget _infoChip(BuildContext context, IconData icon, String label) {
    return Container(
      padding: context.appEdgeInsets(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: CustomColors.whiteGrey, borderRadius: BorderRadius.circular(8.r)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: context.sp(14), color: CustomColors.grey),
          context.horizontalSpace(8),
          Text(label, style: context.fonts.grey13w500),
        ],
      ),
    );
  }
}
