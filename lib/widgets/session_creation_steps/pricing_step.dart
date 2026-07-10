import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/utils/validators.dart';
import 'package:skinsync_admin/view_models/session_view_model.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';

class PricingStep extends ConsumerWidget {
  const PricingStep({super.key});

  Widget _sectionTitle(BuildContext context, String title, {double? fontSize}) {
    return Text(
      title,
      style: context.fonts.black18w600.copyWith(
        fontSize: fontSize != null ? context.sp(fontSize) : null,
      ),
    );
  }

  String _formatUnitLabel(String unit) {
    if (unit.isEmpty) return '';
    return unit[0].toUpperCase() + unit.substring(1);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionViewModelProvider);
    final viewModel = ref.read(sessionViewModelProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Pricing Configuration'),
        context.verticalSpace(8),
        Text(
          'Choose between a dynamic base price with overrides or a flat fixed price.',
          style: context.fonts.grey14w400,
        ),
        context.verticalSpace(24),
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: context.appBorderRadius(all: 12),
            border: Border.all(color: CustomColors.border),
          ),
          child: Padding(
            padding: context.appEdgeInsets(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Use Fixed Price',
                        style: context.fonts.black14w600,
                      ),
                      context.verticalSpace(4),
                      Text(
                        'Specify a flat fixed price instead of base price and unit-based overrides.',
                        style: context.fonts.grey12w400,
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: state.isFixedPrice,
                  onChanged: viewModel.toggleIsFixedPrice,
                  activeColor: CustomColors.purple,
                ),
              ],
            ),
          ),
        ),
        context.verticalSpace(32),
        if (state.isFixedPrice) ...[
          _sectionTitle(context, 'Fixed Pricing'),
          context.verticalSpace(24),
          BuildTextField(
            label: 'Fixed Price (\$)',
            controller: viewModel.fixedPriceController,
            hintText: '100',
            keyboardType: TextInputType.number,
            validator: Validators.empty,
          ),
        ] else ...[
          _sectionTitle(context, 'Base Pricing'),
          context.verticalSpace(24),
          BuildTextField(
            label: 'Treatment Base Price (\$)',
            controller: viewModel.basePriceController,
            hintText: '100',
            keyboardType: TextInputType.number,
            validator: Validators.empty,
          ),
          if (state.productUsageEntries.isNotEmpty) ...[
            context.verticalSpace(40),
            _sectionTitle(context, 'Unit-Based Pricing Overrides'),
            context.verticalSpace(8),
            Text(
              'Define dynamic pricing overrides for each configured unit up to the maximum quantity specified in materials setup.',
              style: context.fonts.grey14w400,
            ),
            context.verticalSpace(24),
            ...state.productUsageEntries.map((entry) {
              final maxQty = (double.tryParse(entry.maxQuantityController.text) ?? 1.0).ceil();
              final formattedUnit = _formatUnitLabel(entry.unit);
              entry.syncUnitPriceControllers(maxQty);

              return Container(
                margin: const EdgeInsets.only(bottom: 24),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.productName,
                                style: context.fonts.black16w600,
                              ),
                              context.verticalSpace(4),
                              Text(
                                'Unit: $formattedUnit | Max Qty: $maxQty',
                                style: context.fonts.grey12w400,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'Different price for each unit',
                              style: context.fonts.black12w600,
                            ),
                            context.horizontalSpace(8),
                            Switch(
                              value: entry.useDifferentPricingPerUnit,
                              onChanged: (val) {
                                entry.useDifferentPricingPerUnit = val;
                                // Trigger rebuild inside the provider to reflect changes
                                ref.read(sessionViewModelProvider.notifier).syncUnitPriceControllersForState();
                              },
                              activeColor: CustomColors.purple,
                            ),
                          ],
                        ),
                      ],
                    ),
                    context.verticalSpace(20),
                    if (entry.useDifferentPricingPerUnit) ...[
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: List.generate(maxQty, (i) {
                          return SizedBox(
                            width: context.w(180),
                            child: BuildTextField(
                              label: 'Unit ${i + 1} Price (\$)',
                              controller: entry.unitPriceControllers[i],
                              hintText: '0',
                              keyboardType: TextInputType.number,
                            ),
                          );
                        }),
                      ),
                    ] else ...[
                      SizedBox(
                        width: context.w(200),
                        child: BuildTextField(
                          label: 'Price Per $formattedUnit (\$)',
                          controller: entry.unitPriceControllers[0],
                          hintText: '0',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }),
          ],
        ],
      ],
    );
  }
}
