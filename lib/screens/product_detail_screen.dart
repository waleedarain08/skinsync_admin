import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/responses/product_detail_response.dart';
import 'package:skinsync_admin/models/treatment_model.dart';
import 'package:skinsync_admin/screens/treatment_detail_screen.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';
import 'package:skinsync_admin/view_models/product_view_model.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';
import 'package:skinsync_admin/widgets/custom_cashed_image_widget.dart';

class ProductDetailScreen extends ConsumerWidget {
  static const String routeName = '/product-detail';
  const ProductDetailScreen({super.key});

  String _formatValue(dynamic val) {
    if (val == null) return '—';
    if (val is String && val.trim().isEmpty) return '—';
    if (val is num && val == 0) return '—';
    return val.toString();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productViewModelProvider);
    final product = productState.selectedProduct;
    final treatments = ref.watch(treatmentViewModelProvider).treatments;

    if (product == null) {
      return GradientScaffold(
        body: Center(
          child: Text('No Product Data Found', style: context.fonts.black16w400),
        ),
      );
    }

    final usedInTreatments = treatments.where((t) {
      return t.productUsages?.any((u) => u.productId == product.id) ?? false;
    }).toList();

    return GradientScaffold(
      appBar: AppBar(
        flexibleSpace: AppDecorations.appBarGradient,
        title: Text('Product Detail', style: context.fonts.black18w600),
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
            constraints: BoxConstraints(maxWidth: context.w(1100)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(context, product),
                context.verticalSpace(32),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          _buildProductInfoSection(context, product),
                          context.verticalSpace(24),
                          _buildPackagingSection(context, product),
                          context.verticalSpace(24),
                          _buildBillingAndPricingSection(context, product),
                          context.verticalSpace(24),
                          _buildUsedInTreatmentsSection(context, ref, usedInTreatments),
                        ],
                      ),
                    ),
                    context.horizontalSpace(32),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          _buildSupplierSection(context, product),
                          context.verticalSpace(24),
                          _buildComplianceAndTrackingSection(context, product),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, ProductDetailModel product) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 32),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: context.appBorderRadius(all: 20),
            child: SizedBox(
              width: context.w(120),
              height: context.w(120),
              child: product.image.isEmpty
                  ? Container(
                      color: CustomColors.whiteGrey,
                      child: Icon(Icons.inventory_2_outlined, size: context.sp(48), color: CustomColors.grey),
                    )
                  : CustomCachedImage(
                      imageUrl: product.image,
                      fit: BoxFit.cover,
                    ),
            ),
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
                        _formatValue(product.name),
                        style: context.fonts.black26w700,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    context.horizontalSpace(16),
                    _statusBadge(context, product.status ?? 'Active'),
                  ],
                ),
                context.verticalSpace(8),
                Text(
                  _formatValue(product.brand),
                  style: context.fonts.purple14w600,
                ),
                context.verticalSpace(16),
                Wrap(
                  spacing: 12.w,
                  runSpacing: 12.h,
                  children: [
                    _infoChip(context, Icons.tag_rounded, "SKU: ${_formatValue(product.globalSku)}"),
                    _infoChip(context, Icons.barcode_reader, "Barcode: ${_formatValue(product.barcode)}"),
                    _infoChip(context, Icons.category_outlined, _formatValue(product.category)),
                    _infoChip(context, Icons.settings_input_component_outlined, _formatValue(product.usageType)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfoSection(BuildContext context, ProductDetailModel product) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Basic Information', style: context.fonts.black18w600),
          context.verticalSpace(24),
          _labelValueRow(context, 'Product Name', _formatValue(product.name)),
          _labelValueRow(context, 'Brand', _formatValue(product.brand)),
          _labelValueRow(context, 'Global SKU', _formatValue(product.globalSku)),
          _labelValueRow(context, 'Barcode', _formatValue(product.barcode)),
          _labelValueRow(context, 'Category', _formatValue(product.category)),
          _labelValueRow(context, 'Selected Category IDs', _formatValue(product.selectedCategoryIds?.join(', '))),
          _labelValueRow(context, 'Status', _formatValue(product.status)),
          const Divider(height: 32),
          Text('Description', style: context.fonts.black14w700),
          context.verticalSpace(12),
          Text(
            product.description.isNotEmpty ? product.description : 'No description provided.',
            style: context.fonts.grey14w400h16,
          ),
        ],
      ),
    );
  }

  Widget _buildPackagingSection(BuildContext context, ProductDetailModel product) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Packaging Information', style: context.fonts.black18w600),
          context.verticalSpace(24),
          _labelValueRow(context, 'Unit Type', _formatValue(product.unitType)),
          _labelValueRow(context, 'Package Type', _formatValue(product.packageType)),
          _labelValueRow(context, 'Box Quantity', _formatValue(product.boxQuantity)),
          _labelValueRow(context, 'Item Quantity Per Box', _formatValue(product.itemQuantityPerBox)),
        ],
      ),
    );
  }

  Widget _buildBillingAndPricingSection(BuildContext context, ProductDetailModel product) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Billing & Pricing Information', style: context.fonts.black18w600),
          context.verticalSpace(24),
          _labelValueRow(context, 'Billable Unit', _formatValue(product.billableUnit)),
          _labelValueRow(context, 'Billable Quantity Per Item', _formatValue(product.billableQuantityPerItem)),
          _labelValueRow(context, 'Total Billable Quantity', _formatValue(product.totalBillableQuantity)),
          const Divider(height: 32),
          _labelValueRow(context, 'Clinic Cost', product.clinicCost != null ? '\$${product.clinicCost}' : '—'),
          _labelValueRow(context, 'Retail Price Per Unit', product.retailPricePerUnit != null ? '\$${product.retailPricePerUnit}' : '—'),
        ],
      ),
    );
  }

  Widget _buildSupplierSection(BuildContext context, ProductDetailModel product) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Supplier Information', style: context.fonts.black16w700),
          context.verticalSpace(24),
          _statRow(context, Icons.store_outlined, 'Supplier', _formatValue(product.supplier)),
          _statRow(context, Icons.pin_outlined, 'Lot Number', _formatValue(product.lotNumber)),
          _statRow(
            context,
            Icons.date_range_outlined,
            'Expiration Date',
            product.expirationDate != null
                ? product.expirationDate!.toIso8601String().split('T').first
                : '—',
          ),
        ],
      ),
    );
  }

  Widget _buildComplianceAndTrackingSection(BuildContext context, ProductDetailModel product) {
    final enforce = product.enforceLotTracking ?? false;
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Compliance & Tracking', style: context.fonts.black16w700),
          context.verticalSpace(24),
          _statRow(
            context,
            Icons.security_rounded,
            'Lot Tracking',
            enforce ? 'Yes' : 'No',
            color: enforce ? CustomColors.green : null,
          ),
          _statRow(context, Icons.verified_user_outlined, 'Verification', 'FDA Validated'),
          _statRow(context, Icons.timer_outlined, 'Shelf Life', '24 Months'),
        ],
      ),
    );
  }

  Widget _buildUsedInTreatmentsSection(
    BuildContext context,
    WidgetRef ref,
    List<TreatmentModel> treatments,
  ) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Used In Treatments', style: context.fonts.black18w600),
              if (treatments.isNotEmpty)
                _infoChip(context, Icons.list_alt_rounded, '${treatments.length} Treatments'),
            ],
          ),
          context.verticalSpace(24),
          if (treatments.isEmpty)
            Container(
              width: double.infinity,
              padding: context.appEdgeInsets(all: 20),
              decoration: BoxDecoration(
                color: CustomColors.whiteGrey,
                borderRadius: context.appBorderRadius(all: 12),
              ),
              child: Text(
                'This product is not currently used in any clinical treatments.',
                style: context.fonts.grey14w500,
                textAlign: TextAlign.center,
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: treatments.length,
              separatorBuilder: (_, __) => context.verticalSpace(12),
              itemBuilder: (context, index) {
                final treatment = treatments[index];
                return InkWell(
                  onTap: () {
                    ref.read(treatmentViewModelProvider.notifier).selectTreatment(treatment);
                    context.push(TreatmentDetailScreen.routeName);
                  },
                  borderRadius: context.appBorderRadius(all: 12),
                  child: Container(
                    padding: context.appEdgeInsets(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: CustomColors.whiteGrey,
                      borderRadius: context.appBorderRadius(all: 12),
                      border: Border.all(color: CustomColors.border),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.medical_services_outlined, size: context.sp(20), color: CustomColors.purple),
                        context.horizontalSpace(16),
                        Expanded(
                          child: Text(
                            treatment.name ?? 'Unnamed Treatment',
                            style: context.fonts.black14w600,
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios_rounded, size: context.sp(14), color: CustomColors.grey),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _labelValueRow(BuildContext context, String label, String value) {
    return Padding(
      padding: context.appEdgeInsets(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: context.w(180),
            child: Text(label, style: context.fonts.grey14w500),
          ),
          Expanded(
            child: Text(value, style: context.fonts.black14w600),
          ),
        ],
      ),
    );
  }

  Widget _statRow(BuildContext context, IconData icon, String label, String value, {Color? color}) {
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
          Flexible(
            child: Text(
              value,
              style: context.fonts.black14w600.copyWith(color: color),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(BuildContext context, String status) {
    final bool isActive = status.toLowerCase() == 'active';
    return Container(
      padding: context.appEdgeInsets(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? CustomColors.green.withValues(alpha: 0.1) : CustomColors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isActive ? CustomColors.green.withValues(alpha: 0.2) : CustomColors.red.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        status.toUpperCase(),
        style: isActive ? context.fonts.green11w600 : context.fonts.red11w600,
      ),
    );
  }

  Widget _infoChip(BuildContext context, IconData icon, String label) {
    return Container(
      padding: context.appEdgeInsets(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: CustomColors.whiteGrey,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: CustomColors.border),
      ),
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
