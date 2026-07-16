import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/responses/treatment_products_response.dart';
import 'package:skinsync_admin/models/responses/unit_types_list_response.dart';
import 'package:skinsync_admin/screens/product_detail_screen.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/product_view_model.dart';
import 'package:skinsync_admin/view_models/session_view_model.dart';
import 'package:skinsync_admin/widgets/app_network_image.dart';
import 'package:skinsync_admin/widgets/app_search_field.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';
import 'package:skinsync_admin/widgets/custom_dropdown_widget.dart';
import 'package:skinsync_admin/widgets/session_creation_steps/authorized_roles_widget.dart';

class MaterialsStep extends ConsumerStatefulWidget {
  const MaterialsStep({super.key});

  @override
  ConsumerState<MaterialsStep> createState() => _MaterialsStepState();
}

class _MaterialsStepState extends ConsumerState<MaterialsStep> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(productViewModelProvider.notifier).fetchUnitTypes();
      await ref.read(sessionViewModelProvider.notifier).fetchProductsByTreatmentCategory();

      final viewModel = ref.read(sessionViewModelProvider.notifier);
      viewModel.minUnitsController.addListener(_onUnitsChanged);
      viewModel.maxUnitsController.addListener(_onUnitsChanged);
    });
  }

  void _onUnitsChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    try {
      final viewModel = ref.read(sessionViewModelProvider.notifier);
      viewModel.minUnitsController.removeListener(_onUnitsChanged);
      viewModel.maxUnitsController.removeListener(_onUnitsChanged);
    } catch (_) {}
    super.dispose();
  }

  Widget _sectionTitle(BuildContext context, String title, {double? fontSize}) {
    return Text(
      title,
      style: context.fonts.black18w600.copyWith(
        fontSize: fontSize != null ? context.sp(fontSize) : null,
      ),
    );
  }

  Widget _buildProductSelector(
    BuildContext context,
    List<TreatmentProductData> products,
    SessionViewModel viewModel, {
    bool isOtherMaterial = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isOtherMaterial
              ? 'Select other material from inventory'
              : 'Select Product from Inventory',
          style: context.fonts.black14w600,
        ),
        context.verticalSpace(10),
        SearchAnchor(
          viewHintText: 'Search inventory...',
          builder: (context, controller) => AppSearchField(
            controller: controller,
            readOnly: true,
            onTap: () => controller.openView(),
            hintText: isOtherMaterial
                ? 'Select other material from inventory'
                : 'Select product from inventory',
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
                      if (isOtherMaterial) {
                        viewModel.addOtherMaterial(p.id, p.name);
                      } else {
                        viewModel.addProductUsage(p.id, p.name, 'Unit');
                      }
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
    int index,
    ProductUsageEntry entry,
    SessionViewModel viewModel, {
    bool isOtherMaterial = false,
  }) {
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
                onPressed: () => isOtherMaterial
                    ? viewModel.removeOtherMaterial(entry.productId)
                    : viewModel.removeProductUsage(entry.productId),
                icon: const Icon(
                  Icons.delete_outline,
                  color: CustomColors.red,
                  size: 20,
                ),
              ),
            ],
          ),
          if (!isOtherMaterial) ...[
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
              onChanged: (val) => viewModel.updateProductUsageEntry(index, deductionTiming: val),
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
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sessionViewModelProvider);
    final viewModel = ref.read(sessionViewModelProvider.notifier);

    // ProductViewModel holds unit types list
    final productState = ref.watch(productViewModelProvider);
    final unitTypes = productState.unitTypes ?? [];

    // Dynamically retrieve selected Unit Type Name
    final selectedUnitType = unitTypes.firstWhere(
      (u) => u.id == state.selectedUnitTypeId,
      orElse: () => const UnitTypeModel(id: 0, name: ''),
    );
    final unitTypeName = selectedUnitType.name.isNotEmpty
        ? selectedUnitType.name
        : (state.selectedUnitTypeName ?? 'Unit');

    final minUnits = double.tryParse(viewModel.minUnitsController.text) ?? 0.0;
    final maxUnits = double.tryParse(viewModel.maxUnitsController.text) ?? 0.0;

    final String minLabel = minUnits > 1 && !unitTypeName.toLowerCase().endsWith('s')
        ? '${unitTypeName}s'
        : unitTypeName;
    final String maxLabel = maxUnits > 1 && !unitTypeName.toLowerCase().endsWith('s')
        ? '${unitTypeName}s'
        : unitTypeName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Unit Configuration'),
        context.verticalSpace(8),
        Text(
          'Select the unit type and consumption boundaries for this clinical session setup.',
          style: context.fonts.grey14w400,
        ),
        context.verticalSpace(24),
        CustomDropdown<int>(
          label: 'Unit Type',
          hintText: 'Select Unit Type',
          value: state.selectedUnitTypeId,
          items: unitTypes.map((u) {
            return DropdownMenuItem<int>(
              value: u.id,
              child: Text(u.name),
            );
          }).toList(),
          onChanged: (id) {
            final selected = unitTypes.firstWhere(
              (u) => u.id == id,
              orElse: () => const UnitTypeModel(id: 0, name: ''),
            );
            viewModel.selectUnitType(id, selected.name);
          },
        ),
        context.verticalSpace(20),
        Row(
          children: [
            Expanded(
              child: BuildTextField(
                label: 'Minimum $minLabel',
                controller: viewModel.minUnitsController,
                hintText: '0',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            context.horizontalSpace(16),
            Expanded(
              child: BuildTextField(
                label: 'Maximum $maxLabel',
                controller: viewModel.maxUnitsController,
                hintText: '0',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
          ],
        ),
        context.verticalSpace(32),

        // Conditional display based on Minimum Units > 0
        if (minUnits > 0) ...[
          const Divider(),
          context.verticalSpace(24),
          _sectionTitle(context, 'Billable Materials'),
          context.verticalSpace(8),
          Text(
            'Select specific inventory products to be deducted and configure Clinical Usage rules.',
            style: context.fonts.grey14w400,
          ),
          context.verticalSpace(24),
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
            _buildProductSelector(context, state.products, viewModel),
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
                  index,
                  state.productUsageEntries[index],
                  viewModel,
                );
              },
            ),
          ],
          context.verticalSpace(32),
        ],

        // Section 3: Other Materials
        const Divider(),
        context.verticalSpace(24),
        _sectionTitle(context, 'Other Materials'),
        context.verticalSpace(8),
        Text(
          'Select products from inventory required as other physical materials for this session.',
          style: context.fonts.grey14w400,
        ),
        context.verticalSpace(20),

        // Select from inventory
        if (state.products.isNotEmpty) ...[
          _buildProductSelector(
            context,
            state.products,
            viewModel,
            isOtherMaterial: true,
          ),
        ],

        if (state.otherMaterialsUsageEntries.isNotEmpty) ...[
          context.verticalSpace(32),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.otherMaterialsUsageEntries.length,
            separatorBuilder: (_, _) => context.verticalSpace(24),
            itemBuilder: (context, index) {
              return _buildProductUsageCard(
                context,
                index,
                state.otherMaterialsUsageEntries[index],
                viewModel,
                isOtherMaterial: true,
              );
            },
          ),
        ],
        context.verticalSpace(32),
        const Divider(),
        context.verticalSpace(24),
        AuthorizedRolesWidget(
          providerRolesSource: state.materialsRolesSource,
          selectedRoles: state.materialsRoles,
          onProviderRolesSourceChanged: viewModel.setMaterialsRolesSource,
          onRoleToggled: viewModel.toggleMaterialsRole,
          onSetRoles: viewModel.setMaterialsRoles,
        ),
        context.verticalSpace(32),
      ],
    );
  }
}
