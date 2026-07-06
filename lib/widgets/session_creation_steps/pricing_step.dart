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

    final uniqueUnits = state.productUsageEntries
        .map((e) => e.unit)
        .where((unit) => unit.trim().isNotEmpty)
        .toSet()
        .toList();

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
          if (uniqueUnits.isNotEmpty) ...[
            context.verticalSpace(40),
            _sectionTitle(context, 'Unit-Based Pricing Overrides'),
            context.verticalSpace(8),
            Text(
              'Define dynamic pricing overrides for each unit of measure from the selected inventory products.',
              style: context.fonts.grey14w400,
            ),
            context.verticalSpace(24),
            Container(
              padding: context.appEdgeInsets(all: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: context.appBorderRadius(all: 12),
                border: Border.all(color: CustomColors.border),
              ),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: uniqueUnits.map((unit) {
                  final formattedUnit = _formatUnitLabel(unit);
                  return SizedBox(
                    width: context.w(180),
                    child: BuildTextField(
                      label: 'Price Per $formattedUnit (\$)',
                      controller: viewModel.getControllerForUnit(unit),
                      hintText: '0',
                      keyboardType: TextInputType.number,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ],
    );
  }
}