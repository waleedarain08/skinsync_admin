import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/product_model.dart';
import 'package:skinsync_admin/models/treatment_model.dart';
import 'package:skinsync_admin/screens/treatment_detail_screen.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';
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
                          _buildUsedInTreatmentsSection(context, ref, usedInTreatments),
                        ],
                      ),
                    ),
                    context.horizontalSpace(32),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          _buildInventoryStatsSection(context, product),
                          context.verticalSpace(24),
                          _buildComplianceSection(context, product),
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

  Widget _buildHeaderSection(BuildContext context, ProductModel product) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 32),
      child: Row(
        children: [
          Container(
            width: context.w(120),
            height: context.w(120),
            decoration: BoxDecoration(
              color: CustomColors.whiteGrey,
              borderRadius: context.appBorderRadius(all: 20),
              image: product.image.isNotEmpty
                  ? DecorationImage(image: NetworkImage(product.image), fit: BoxFit.cover)
                  : null,
              border: Border.all(color: CustomColors.border),
            ),
            child: product.image.isEmpty
                ? Icon(Icons.inventory_2_outlined, size: context.sp(48), color: CustomColors.grey)
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
                    _statusBadge(context, product.status ?? 'Active'),
                  ],
                ),
                context.verticalSpace(8),
                Text(
                  '${product.brand ?? 'Global'} • ${product.manufacturer ?? 'Manufacturer'}',
                  style: context.fonts.purple14w600,
                ),
                context.verticalSpace(16),
                Wrap(
                  spacing: 12.w,
                  runSpacing: 12.h,
                  children: [
                    _infoChip(context, Icons.tag_rounded, "SKU: ${product.globalSku ?? product.sku ?? 'N/A'}"),
                    _infoChip(context, Icons.category_outlined, product.category ?? 'Clinical'),
                    _infoChip(context, Icons.settings_input_component_outlined, product.productPurpose ?? 'Usage'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfoSection(BuildContext context, ProductModel product) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Product & Packaging Details', style: context.fonts.black18w600),
          context.verticalSpace(24),
          _labelValueRow(context, 'Product Name', product.name),
          _labelValueRow(context, 'Brand', product.brand ?? 'N/A'),
          _labelValueRow(context, 'Manufacturer', product.manufacturer ?? 'N/A'),
          _labelValueRow(context, 'Category', product.category ?? 'General Catalog'),
          _labelValueRow(context, 'Global SKU', product.globalSku ?? product.sku ?? 'N/A'),
          _labelValueRow(context, 'Base Unit', product.unitType ?? product.unit),
          _labelValueRow(context, 'Package Type', product.packageType ?? 'Individual'),
          _labelValueRow(context, 'Units Per Package', '${product.unitsPerPackage ?? 1} Units'),
          const Divider(height: 32),
          Text('Description', style: context.fonts.black14w700),
          context.verticalSpace(12),
          Text(
            product.description.isNotEmpty ? product.description : 'No description provided for this catalog product.',
            style: context.fonts.grey14w400h16,
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryStatsSection(BuildContext context, ProductModel product) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Inventory Overview', style: context.fonts.black16w700),
          context.verticalSpace(24),
          _statRow(context, Icons.warehouse_outlined, 'Current Stock', '${product.quantity ?? 0} ${product.unit}'),
          _statRow(context, Icons.storefront_outlined, 'Clinics Using', '34 Clinics'),
          _statRow(context, Icons.analytics_outlined, 'Monthly Usage', '45.2 Avg'),
          _statRow(context, Icons.history_rounded, 'Last Stock Update', '2 days ago'),
        ],
      ),
    );
  }

  Widget _buildComplianceSection(BuildContext context, ProductModel product) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Compliance & Rules', style: context.fonts.black16w700),
          context.verticalSpace(24),
          _statRow(
            context,
            Icons.security_rounded,
            'Lot Tracking',
            (product.enforceLotTracking ?? false) ? 'Enforced' : 'Optional',
            color: (product.enforceLotTracking ?? false) ? CustomColors.purple : null,
          ),
          _statRow(context, Icons.verified_user_outlined, 'Verification', 'FDA Validated'),
          _statRow(context, Icons.timer_outlined, 'Shelf Life', '24 Months'),
        ],
      ),
    );
  }

  Widget _buildUsedInTreatmentsSection(BuildContext context, WidgetRef ref, List<TreatmentModel> treatments) {
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
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: treatments.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisExtent: context.h(60),
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final treatment = treatments[index];
                return InkWell(
                  onTap: () {
                    ref.read(treatmentViewModelProvider.notifier).selectTreatment(treatment);
                    context.push(TreatmentDetailScreen.routeName);
                  },
                  borderRadius: context.appBorderRadius(all: 12),
                  child: Container(
                    padding: context.appEdgeInsets(horizontal: 20),
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
