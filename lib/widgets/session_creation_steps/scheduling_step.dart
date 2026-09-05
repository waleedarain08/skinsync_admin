import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/utils/validators.dart';
import 'package:skinsync_admin/view_models/session_view_model.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';
import 'package:skinsync_admin/widgets/session_creation_steps/authorized_roles_widget.dart';

class SchedulingStep extends ConsumerWidget {
  const SchedulingStep({super.key});

  Widget _sectionTitle(BuildContext context, String title, {double? fontSize}) {
    return Text(
      title,
      style: context.fonts.black18w600.copyWith(
        fontSize: fontSize != null ? context.sp(fontSize) : null,
      ),
    );
  }

  double _getProductMinQuantity(
    ProductUsageEntry entry,
    SessionViewModel viewModel,
  ) {
    return viewModel.getProductMinQuantity(entry);
  }

  double _getProductMaxQuantity(
    ProductUsageEntry entry,
    SessionViewModel viewModel,
  ) {
    return viewModel.getProductMaxQuantity(entry);
  }

  double _calculateProductUsageDuration(
    SessionViewModel viewModel,
    SessionState sessionState,
  ) {
    double total = 0.0;
    for (final entry in sessionState.productUsageEntries) {
      final minQty = _getProductMinQuantity(entry, viewModel);
      final perUnit =
          double.tryParse(entry.perUnitDurationController.text) ?? 0.0;
      total += minQty * perUnit;
    }
    return total;
  }

  String _formatUnitLabel(String unit) {
    if (unit.isEmpty) return 'Unit';
    return unit[0].toUpperCase() + unit.substring(1);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SessionState state = ref.watch(sessionViewModelProvider);
    final viewModel = ref.read(sessionViewModelProvider.notifier);
    final treatmentState = ref.watch(treatmentViewModelProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                        'Use Fixed Duration',
                        style: context.fonts.black14w600,
                      ),
                      context.verticalSpace(4),
                      Text(
                        'Specify a flat fixed duration instead of dynamically calculating from product usage.',
                        style: context.fonts.grey12w400,
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: state.isFixedDuration,
                  onChanged: viewModel.toggleIsFixedDuration,
                  activeThumbColor: CustomColors.white,
                ),
              ],
            ),
          ),
        ),
        context.verticalSpace(32),
        if (state.isFixedDuration) ...[
          _sectionTitle(context, 'Fixed Duration'),
          context.verticalSpace(24),
          Row(
            children: [
              Expanded(
                child: BuildTextField(
                  label: 'Fixed Duration (Minutes)',
                  controller: viewModel.fixedDurationController,
                  hintText: 'e.g. 45',
                  keyboardType: TextInputType.number,
                  validator: Validators.empty,
                  onChanged: (val) {
                    viewModel.updateFixedDuration(val ?? '0');
                  },
                ),
              ),
            ],
          ),
        ] else ...[
          _sectionTitle(context, 'Base Duration'),
          context.verticalSpace(24),
          Row(
            children: [
              Expanded(
                child: BuildTextField(
                  label: 'Base Duration (Minutes)',
                  controller: viewModel.treatmentDurationController,
                  hintText: 'e.g. 60',
                  keyboardType: TextInputType.number,
                  validator: Validators.empty,
                  onChanged: (val) {
                    // Trigger state refresh for live updates
                    viewModel.updateProductPerUnitDuration(0, '');
                  },
                ),
              ),
            ],
          ),
          context.verticalSpace(32),
          _sectionTitle(context, 'Product Usage Duration'),
          context.verticalSpace(16),
          if (state.productUsageEntries.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'No products selected in the Inventory Products step.',
                style: context.fonts.grey14w400,
              ),
            )
          else
            ...state.productUsageEntries.asMap().entries.map((item) {
              final idx = item.key;
              final entry = item.value;
              final allSubAreas = treatmentState.areas.expand((a) => a.subAreas).toList();
              final minQty = _getProductMinQuantity(entry, viewModel);
              final maxQty = _getProductMaxQuantity(entry, viewModel);

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: context.appEdgeInsets(all: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: context.appBorderRadius(all: 12),
                  border: Border.all(color: CustomColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entry.productName, style: context.fonts.black14w700),
                    context.verticalSpace(8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Unit of Measure: ${entry.unit}',
                          style: context.fonts.grey13w500,
                        ),
                        Text(
                          'Min Qty: ${minQty.toStringAsFixed(minQty % 1 == 0 ? 0 : 1)} | Max Qty: ${maxQty.toStringAsFixed(maxQty % 1 == 0 ? 0 : 1)}',
                          style: context.fonts.grey13w500,
                        ),
                      ],
                    ),
                    context.verticalSpace(12),
                    BuildTextField(
                      label:
                          'Per ${_formatUnitLabel(entry.unit)} Duration (minutes)',
                      controller: entry.perUnitDurationController,
                      hintText: '0.0',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: (val) {
                        viewModel.updateProductPerUnitDuration(idx, val ?? '');
                      },
                    ),
                  ],
                ),
              );
            }),
          context.verticalSpace(32),
          Row(
            children: [
              Expanded(
                child: BuildTextField(
                  label: 'Preparation Time (Minutes)',
                  controller: viewModel.prepTimeController,
                  hintText: 'e.g. 10',
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    // Trigger state refresh for live updates
                    viewModel.updateProductPerUnitDuration(0, '');
                  },
                ),
              ),
              context.horizontalSpace(24),
              Expanded(
                child: BuildTextField(
                  label: 'Finish / Cleanup Time (Minutes)',
                  controller: viewModel.cleanupTimeController,
                  hintText: 'e.g. 5',
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    // Trigger state refresh for live updates
                    viewModel.updateProductPerUnitDuration(0, '');
                  },
                ),
              ),
            ],
          ),
          context.verticalSpace(32),
          _sectionTitle(context, 'Total Duration'),
          context.verticalSpace(16),
          Builder(
            builder: (context) {
              final baseDuration =
                  double.tryParse(viewModel.treatmentDurationController.text) ??
                  0.0;
              final productDuration = _calculateProductUsageDuration(viewModel, state);
              final prepTime =
                  double.tryParse(viewModel.prepTimeController.text) ?? 0.0;
              final cleanupTime =
                  double.tryParse(viewModel.cleanupTimeController.text) ?? 0.0;
              final totalDuration =
                  baseDuration + productDuration + prepTime + cleanupTime;

              return Container(
                padding: context.appEdgeInsets(all: 16),
                decoration: BoxDecoration(
                  color: CustomColors.purple.withValues(alpha: 0.05),
                  borderRadius: context.appBorderRadius(all: 10),
                  border: Border.all(
                    color: CustomColors.purple.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Base Duration:', style: context.fonts.black14w600),
                        Text(
                          '${baseDuration.toStringAsFixed(baseDuration % 1 == 0 ? 0 : 1)} Minutes',
                          style: context.fonts.black14w600,
                        ),
                      ],
                    ),
                    context.verticalSpace(8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Product Usage Duration:',
                          style: context.fonts.black14w400,
                        ),
                        Text(
                          '${productDuration.toStringAsFixed(productDuration % 1 == 0 ? 0 : 1)} Minutes',
                          style: context.fonts.purple14w700,
                        ),
                      ],
                    ),
                    context.verticalSpace(8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Preparation Time:',
                          style: context.fonts.black14w400,
                        ),
                        Text(
                          '${prepTime.toStringAsFixed(prepTime % 1 == 0 ? 0 : 1)} Minutes',
                          style: context.fonts.black14w600,
                        ),
                      ],
                    ),
                    context.verticalSpace(8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Cleanup Time:', style: context.fonts.black14w400),
                        Text(
                          '${cleanupTime.toStringAsFixed(cleanupTime % 1 == 0 ? 0 : 1)} Minutes',
                          style: context.fonts.black14w600,
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Divider(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Calculated Total Duration:',
                          style: context.fonts.purple14w700,
                        ),
                        Text(
                          '${totalDuration.toStringAsFixed(totalDuration % 1 == 0 ? 0 : 1)} Minutes',
                          style: context.fonts.purple16w700,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        context.verticalSpace(32),
        _sectionTitle(context, 'Override & Booking Controls'),
        context.verticalSpace(24),
        Row(
          children: [
            SizedBox(
              width: context.w(24),
              height: context.w(24),
              child: Checkbox(
                value: state.allowClinicOverride,
                onChanged: viewModel.toggleAllowClinicOverride,
                activeColor: CustomColors.purple,
              ),
            ),
            context.horizontalSpace(12),
            Text(
              'Allow Clinic Duration Override',
              style: context.fonts.black14w600,
            ),
          ],
        ),
        context.verticalSpace(16),
        Row(
          children: [
            SizedBox(
              width: context.w(24),
              height: context.w(24),
              child: Checkbox(
                value: state.allowProviderOverride,
                onChanged: viewModel.toggleAllowProviderOverride,
                activeColor: CustomColors.purple,
              ),
            ),
            context.horizontalSpace(12),
            Text(
              'Allow Provider Duration Override',
              style: context.fonts.black14w600,
            ),
          ],
        ),
        context.verticalSpace(16),
        Row(
          children: [
            SizedBox(
              width: context.w(24),
              height: context.w(24),
              child: Checkbox(
                value: state.onlineBookable,
                onChanged: viewModel.toggleOnlineBookable,
                activeColor: CustomColors.purple,
              ),
            ),
            context.horizontalSpace(12),
            Text('Online Bookable', style: context.fonts.black14w600),
          ],
        ),
        context.verticalSpace(16),
        Row(
          children: [
            SizedBox(
              width: context.w(24),
              height: context.w(24),
              child: Checkbox(
                value: state.manualApprovalRequired,
                onChanged: viewModel.toggleManualApprovalRequired,
                activeColor: CustomColors.purple,
              ),
            ),
            context.horizontalSpace(12),
            Text('Manual Approval Required', style: context.fonts.black14w600),
          ],
        ),
        context.verticalSpace(32),
        _sectionTitle(context, 'Booking Advance Notice Rules'),
        context.verticalSpace(24),
        Row(
          children: [
            Expanded(
              child: BuildTextField(
                label: 'Minimum Booking Notice (Hours)',
                controller: viewModel.minimumBookingNoticeController,
                hintText: 'e.g. 24',
                keyboardType: TextInputType.number,
                tooltip: 'The minimum number of hours before an appointment that a patient can book this treatment.',
              ),
            ),
            context.horizontalSpace(24),
            Expanded(
              child: BuildTextField(
                label: 'Maximum Days in Advance',
                controller: viewModel.maximumDaysInAdvanceController,
                hintText: 'e.g. 90',
                keyboardType: TextInputType.number,
                tooltip: 'The maximum number of days in advance that a patient can book this treatment.',
              ),
            ),
          ],
        ),
        context.verticalSpace(32),
        const Divider(),
        context.verticalSpace(24),
        AuthorizedRolesWidget(
          title: 'Authorized Roles to Change Schedule',
          description: 'Select which provider roles are authorized to override or modify treatment scheduling and duration controls.',
          selectedRoles: state.schedulingRoles,
          onRoleToggled: viewModel.toggleSchedulingRole,
        ),
      ],
    );
  }
}