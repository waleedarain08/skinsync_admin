import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'package:skinsync_admin/widgets/treatment_creation_steps/logic_step.dart';

class LogicStepDialog extends ConsumerWidget {
  final int? treatmentId;

  const LogicStepDialog({super.key, this.treatmentId});

  static Future<void> show(
    BuildContext context,
    WidgetRef ref, {
    int? treatmentId,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LogicStepDialog(treatmentId: treatmentId),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: context.appBorderRadius(all: 16),
      ),
      child: Container(
        width: context.w(700),
        padding: context.appEdgeInsets(all: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const LogicStep(),
              context.verticalSpace(24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  context.horizontalSpace(16),
                  SizedBox(
                    width: context.w(150),
                    child: CustomPrimaryButton(
                      onTap: () async {
                        if (treatmentId == null) {
                          return;
                        }
                        final result = await ref
                            .read(treatmentViewModelProvider.notifier)
                            .callBusinessLogic(
                              isUpdate: true,
                              updatetreatmentId: treatmentId!,
                            );
                        if (result == true) {
                          Navigator.of(context).pop();
                        }
                      },
                      label: 'Save',
                    ),
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
