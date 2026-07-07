import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/responses/treatment_products_response.dart';
import 'package:skinsync_admin/screens/product_detail_screen.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/product_view_model.dart';
import 'package:skinsync_admin/view_models/session_view_model.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';
import 'package:skinsync_admin/widgets/app_network_image.dart';
import 'package:skinsync_admin/widgets/app_search_field.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';
import 'package:skinsync_admin/widgets/custom_dropdown_widget.dart';

class MaterialsStep extends ConsumerWidget {
  const MaterialsStep({super.key});

  Widget _sectionTitle(BuildContext context, String title, {double? fontSize}) {
    return Text(
      title,
      style: context.fonts.black18w600.copyWith(
        fontSize: fontSize != null ? context.sp(fontSize) : null,
      ),
    );
  }



  String _formatUnitPlural(String unit) {
    if (unit.isEmpty) return 'Units';
    final lower = unit.toLowerCase();
    if (lower == 'unit' || lower == 'u') return 'Units';
    if (lower.contains('unit (u)')) return 'Units (U)';
    if (lower == 'syringe') return 'Syringes';
    if (lower == 'vial') return 'Vials';
    if (lower == 'bottle') return 'Bottles';
    if (lower == 'tube') return 'Tubes';
    if (lower == 'kit') return 'Kits';
    if (lower == 'pack') return 'Packs';
    if (lower == 'piece') return 'Pieces';
    if (lower.endsWith('s')) return unit;
    return '${unit}s';
  }

  Widget _buildProductSelector(
    BuildContext context,
    List<TreatmentProductData> products,
    SessionViewModel viewModel,
    TreatmentState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Product from Inventory', style: context.fonts.black14w600),
        context.verticalSpace(10),
        SearchAnchor(
          viewHintText: 'Search inventory...',
          builder: (context, controller) => AppSearchField(
            controller: controller,
            readOnly: true,
            onTap: () => controller.openView(),
            hintText: 'Select product from inventory',
            suffixIcon: const Icon(
              Icons.search_rounded,
              color: CustomColors.lightGrey,
            ),
            maxWidth: double.infinity,
          ),
          suggestionsBuilder: (context, controller) {
            final query = controller.text.toLowerCase();
            final filtered = products
                .where((p) => p.name.toLowerCase().contains(query))
                .toList();

            return filtered
                .map(
                  (p) => ListTile(
                    title: Text(p.name, style: context.fonts.black14w600),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        context.verticalSpace(4),
                        Text(
                          '${p.brand ?? "—"} • ${p.globalSku ?? "—"}',
                          style: context.fonts.grey12w400,
                        ),
                        context.verticalSpace(2),
                        Text(
                          'Usage: ${p.usageType ?? "—"}',
                          style: context.fonts.grey11w400,
                        ),
                      ],
                    ),
                    onTap: () {
                      viewModel.addProductUsage(p.id, p.name, 'Unit');
                      controller.closeView(p.name);
                    },
                  ),
                )
                .toList();
          },
        ),
      ],
    );
  }

  Widget _buildProductUsageCard(
    BuildContext context,
    WidgetRef ref,
    int index,
    ProductUsageEntry entry,
    SessionViewModel viewModel,
    TreatmentState state,
  ) {
    final sessionState = ref.read(sessionViewModelProvider);
    final TreatmentProductData? productData =
        sessionState.products.any((p) => p.id == entry.productId)
        ? sessionState.products.firstWhere((p) => p.id == entry.productId)
        : null;

    final String cleanStatus = (productData?.status ?? 'active').toLowerCase();
    Color badgeColor = CustomColors.green;
    String statusLabel = 'Active';

    if (cleanStatus == 'draft') {
      badgeColor = CustomColors.amber;
      statusLabel = 'Draft';
    } else if (cleanStatus == 'deactive' || cleanStatus == 'inactive') {
      badgeColor = CustomColors.grey;
      statusLabel = 'Inactive';
    }

    final imageUrl = productData?.image;
    final hasValidImage = imageUrl != null && imageUrl.isNotEmpty;

    return Container(
      padding: context.appEdgeInsets(all: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: context.appBorderRadius(all: 12),
        border: Border.all(color: CustomColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              AppNetworkImage(
                imageUrl: hasValidImage ? imageUrl : '',
                width: 64,
                height: 64,
                borderRadius: BorderRadius.circular(8),
                fit: BoxFit.cover,
                errorIcon: Icons.broken_image,
                errorIconSize: 24,
              ),
              context.horizontalSpace(16),
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            entry.productName,
                            style: context.fonts.black14w700,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        context.horizontalSpace(8),
                        IconButton(
                          tooltip: 'View Product Details',
                          icon: const Icon(
                            Icons.visibility_outlined,
                            color: CustomColors.purple,
                            size: 18,
                          ),
                          onPressed: () async {
                            try {
                              await ref
                                  .read(productViewModelProvider.notifier)
                                  .fetchProductDetail(entry.productId);
                              if (context.mounted) {
                                context.push(ProductDetailScreen.routeName);
                              }
                            } catch (e) {
                              // Handled gracefully inside view model
                            }
                          },
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                    context.verticalSpace(4),
                    Text(
                      'Brand: ${productData?.brand ?? "—"} • Manufacturer: ${productData?.manufacturer ?? "—"}',
                      style: context.fonts.grey12w400,
                    ),
                    context.verticalSpace(4),
                    Text(
                      'SKU: ${productData?.globalSku ?? "—"}',
                      style: context.fonts.grey12w400,
                    ),
                    context.verticalSpace(4),
                    Row(
                      children: [
                        Text(
                          'Usage Type: ${productData?.usageType ?? "—"}',
                          style: context.fonts.grey12w400,
                        ),
                        context.horizontalSpace(12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: badgeColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: badgeColor.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Text(
                            statusLabel,
                            style: context.fonts.grey10w700ls1.copyWith(
                              color: badgeColor,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (entry.packageType != null || entry.boxQuantity != null || entry.clinicCost != null || entry.retailPricePerUnit != null) ...[
                      context.verticalSpace(8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (entry.packageType != null && entry.packageType!.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: CustomColors.whiteGrey,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: CustomColors.border),
                              ),
                              child: Text(
                                'Package: ${entry.packageType}',
                                style: context.fonts.grey12w400,
                              ),
                            ),
                          if (entry.boxQuantity != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: CustomColors.whiteGrey,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: CustomColors.border),
                              ),
                              child: Text(
                                'Box Qty: ${entry.boxQuantity}',
                                style: context.fonts.grey12w400,
                              ),
                            ),
                          if (entry.clinicCost != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: CustomColors.whiteGrey,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: CustomColors.border),
                              ),
                              child: Text(
                                'Cost: \$${entry.clinicCost}',
                                style: context.fonts.grey12w400,
                              ),
                            ),
                          if (entry.retailPricePerUnit != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: CustomColors.whiteGrey,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: CustomColors.border),
                              ),
                              child: Text(
                                'Retail/Unit: \$${entry.retailPricePerUnit}',
                                style: context.fonts.grey12w400,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                onPressed: () => viewModel.removeProductUsage(entry.productId),
                icon: const Icon(
                  Icons.delete_outline,
                  color: CustomColors.red,
                  size: 20,
                ),
              ),
            ],
          ),
          context.verticalSpace(20),
          CustomDropdown<String>(
            label: 'Deduction Timing',
            hintText: 'Select',
            value: entry.deductionTiming,
            items: const [
              DropdownMenuItem(
                value: 'On_Completion',
                child: Text('On Completion'),
              ),
              DropdownMenuItem(value: 'Manual', child: Text('Manual')),
              DropdownMenuItem(
                value: 'Post_Confirmation',
                child: Text('Post Confirmation'),
              ),
            ],
            onChanged: (val) =>
                viewModel.updateProductUsageEntry(index, deductionTiming: val),
          ),
          context.verticalSpace(20),
          Row(
            children: [
              SizedBox(
                width: context.w(24),
                height: context.w(24),
                child: Checkbox(
                  value: entry.allowSubstitution,
                  onChanged: (val) => viewModel.updateProductUsageEntry(
                    index,
                    allowSubstitution: val,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: context.appBorderRadius(all: 4),
                  ),
                ),
              ),
              context.horizontalSpace(12),
              Text(
                'Allow Product Substitution',
                style: context.fonts.black14w600,
              ),
            ],
          ),
          context.verticalSpace(20),
          BuildTextField(
            label: 'Usage Notes (Optional)',
            controller: entry.notesController,
            hintText: 'Clinical instructions or restrictions...',
            maxLines: 2,
          ),
          context.verticalSpace(24),
          const Divider(),
          context.verticalSpace(16),
          Text('Product Consumption Range', style: context.fonts.black14w600),
          context.verticalSpace(16),
          Row(
            children: [
              Expanded(
                child: BuildTextField(
                  label: 'Min ${_formatUnitPlural(entry.unit)}',
                  controller: entry.minQuantityController,
                  hintText: '1',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (val) {
                    viewModel.updateProductPerUnitDuration(index, '');
                  },
                ),
              ),
              context.horizontalSpace(16),
              Expanded(
                child: BuildTextField(
                  label: 'Max ${_formatUnitPlural(entry.unit)}',
                  controller: entry.maxQuantityController,
                  hintText: '1',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (val) {
                    viewModel.updateProductPerUnitDuration(index, '');
                  },
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionViewModelProvider);
    final treatmentState = ref.watch(treatmentViewModelProvider);
    final viewModel = ref.read(sessionViewModelProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Inventory Products'),
        context.verticalSpace(8),
        Text(
          'Select specific products from inventory and define clinical usage rules.',
          style: context.fonts.grey14w400,
        ),
        context.verticalSpace(32),
        if (state.isLoadingProducts) ...[
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: CircularProgressIndicator(color: CustomColors.purple),
            ),
          ),
        ] else if (state.error != null) ...[
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Column(
                children: [
                  Text(
                    'Error loading products: ${state.error}',
                    style: context.fonts.grey14w400,
                  ),
                  context.verticalSpace(12),
                  TextButton(
                    onPressed: viewModel.fetchProductsByTreatmentCategory,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ] else if (state.products.isEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Text(
              'No inventory products available for selected category hierarchy.',
              style: context.fonts.grey14w400,
            ),
          ),
        ] else ...[
          _buildProductSelector(context, state.products, viewModel, treatmentState),
        ],
        if (state.productUsageEntries.isNotEmpty) ...[
          context.verticalSpace(32),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.productUsageEntries.length,
            separatorBuilder: (_, _) => context.verticalSpace(24),
            itemBuilder: (context, index) {
              return _buildProductUsageCard(
                context,
                ref,
                index,
                state.productUsageEntries[index],
                viewModel,
                treatmentState,
              );
            },
          ),
        ],
      ],
    );
  }
}