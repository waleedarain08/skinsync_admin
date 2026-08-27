import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/requests/create_benefit_request.dart';
import 'package:skinsync_admin/utils/sku_utils.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/utils/validators.dart';
import 'package:skinsync_admin/view_models/subscription_view_model.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'package:skinsync_admin/widgets/dailogbox/standard_dialog.dart';

class AddBenefitDialog extends StatefulWidget {
  const AddBenefitDialog({super.key});

  @override
  State<AddBenefitDialog> createState() => _AddBenefitDialogState();
}

class _AddBenefitDialogState extends State<AddBenefitDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _skuController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _skuController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _generateSku(WidgetRef ref) {
    final state = ref.read(subscriptionViewModelProvider);
    final existingSkus = state.patientBenefits
            ?.map((b) => b.sku ?? '')
            .where((s) => s.isNotEmpty)
            .toList() ??
        [];

    setState(() {
      _skuController.text = SkuUtils.generateSku(existingSkus: existingSkus);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StandardDialog(
      title: 'Create New Benefit',
      width: context.w(500),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildTextField(
              label: 'Benefit Title',
              controller: _titleController,
              hintText: 'e.g. Priority Support',
              validator: Validators.empty,
            ),
            context.verticalSpace(24),
            Consumer(
              builder: (context, ref, _) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: BuildTextField(
                        label: 'Global SKU',
                        controller: _skuController,
                        hintText: 'XXX-0000-XXXX',
                        validator: (val) {
                          final state = ref.read(subscriptionViewModelProvider);
                          final existingSkus = state.patientBenefits
                                  ?.map((b) => b.sku ?? '')
                                  .where((s) => s.isNotEmpty)
                                  .toList() ??
                              [];
                          return SkuUtils.validateGlobalSku(val,
                              existingSkus: existingSkus);
                        },
                      ),
                    ),
                    context.horizontalSpace(12),
                    Padding(
                      padding: context.appEdgeInsets(bottom: 2),
                      child: IconButton.filled(
                        onPressed: () => _generateSku(ref),
                        icon: const Icon(Icons.auto_fix_high_rounded, size: 20),
                        style: IconButton.styleFrom(
                          backgroundColor:
                              CustomColors.purple.withValues(alpha: 0.1),
                          foregroundColor: CustomColors.purple,
                          shape: RoundedRectangleBorder(
                            borderRadius: context.borderRadius(all: 10),
                          ),
                          fixedSize: Size(context.w(48), context.h(48)),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            context.verticalSpace(24),
            BuildTextField(
              label: 'Description',
              controller: _descriptionController,
              hintText: 'Provide details about this benefit...',
              maxLines: 3,
              validator: Validators.empty,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: const Text('Cancel'),
        ),
        Consumer(
          builder: (context, ref, _) {
            final state = ref.watch(subscriptionViewModelProvider);
            return CustomPrimaryButton(
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  final request = CreateBenefitRequest(
                    sku: _skuController.text.trim(),
                    title: _titleController.text.trim(),
                    description: _descriptionController.text.trim(),
                  );
                  final response = await ref
                      .read(subscriptionViewModelProvider.notifier)
                      .createBenefit(request);
                  if (response != null && response.isSuccess && context.mounted) {
                    context.pop();
                  }
                }
              },
              label: 'Create Benefit',
              isLoading: state.loading,
              width: context.w(150),
            );
          },
        ),
      ],
    );
  }
}
