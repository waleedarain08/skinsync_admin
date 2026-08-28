import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/models/requests/create_subscription_duration_request.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/utils/validators.dart';
import 'package:skinsync_admin/view_models/subscription_view_model.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'package:skinsync_admin/widgets/custom_outlined_button.dart';

class SubscriptionDurationDialog extends ConsumerStatefulWidget {
  const SubscriptionDurationDialog({super.key});

  @override
  ConsumerState<SubscriptionDurationDialog> createState() => _SubscriptionDurationDialogState();
}

class _SubscriptionDurationDialogState extends ConsumerState<SubscriptionDurationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _durationController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final request = CreateSubscriptionDurationRequest(
        name: _nameController.text.trim(),
        duration: int.tryParse(_durationController.text.trim()) ?? 0,
      );

      final response = await ref
          .read(subscriptionViewModelProvider.notifier)
          .createSubscriptionDuration(request);

      if ((response?.isSuccess ?? false) && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Duration created successfully')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: context.borderRadius(all: 16)),
      child: Container(
        width: 400.w,
        padding: context.appEdgeInsets(all: 24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create Subscription Duration', style: context.fonts.level2Heading),
              context.verticalSpace(24),
              BuildTextField(
                label: 'Duration Name',
                controller: _nameController,
                hintText: 'e.g. Quarterly',
                validator: Validators.empty,
              ),
              context.verticalSpace(16),
              BuildTextField(
                label: 'Duration in Days',
                controller: _durationController,
                hintText: 'e.g. 90',
                keyboardType: TextInputType.number,
                validator: Validators.empty,
              ),
              context.verticalSpace(32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomOutlinedButton(
                    onTap: () => Navigator.pop(context),
                    label: 'Cancel',
                  ),
                  context.horizontalSpace(16),
                  CustomPrimaryButton(
                    onTap: _submit,
                    label: 'Save Duration',
                    width: 140.w,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
