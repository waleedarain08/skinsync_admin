import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';
import 'package:skinsync_admin/widgets/dailogbox/basic_info_dialog.dart';
import '../icon_image_container.dart';

class TreatmentSelectionStep extends ConsumerStatefulWidget {
  const TreatmentSelectionStep({super.key});

  @override
  ConsumerState<TreatmentSelectionStep> createState() =>
      _TreatmentSelectionStepState();
}

class _TreatmentSelectionStepState
    extends ConsumerState<TreatmentSelectionStep> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final categoryIdStr = ref
          .read(treatmentViewModelProvider.notifier)
          .categoryIdController
          .text;
      final categoryId = int.tryParse(categoryIdStr);
      if (categoryId != null) {
        ref
            .read(treatmentViewModelProvider.notifier)
            .getTreatments(categoryId: categoryId);
      }
    });
  }

  Widget _sectionTitle(BuildContext context, String title, {double? fontSize}) {
    return Text(
      title,
      style: context.fonts.black18w600.copyWith(
        fontSize: fontSize != null ? context.sp(fontSize) : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(treatmentViewModelProvider);
    final viewModel = ref.read(treatmentViewModelProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle(context, 'Basic Information Selection'),
                context.verticalSpace(4),
                Text(
                  'Select an existing treatment template or create a new custom one.',
                  style: context.fonts.grey14w400,
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () {
                viewModel.clearBasicInfoControllers();
                BasicInfoDialog.show(context);
              },
              icon: const Icon(Icons.add, color: Colors.white, size: 18),
              label: Text(
                'Add New Basic Info',
                style: context.fonts.white14w600,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.purple,
                padding: context.appEdgeInsets(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: context.appBorderRadius(all: 8),
                ),
              ),
            ),
          ],
        ),
        context.verticalSpace(24),

        if (state.createTreatments.isEmpty) ...[
          Container(
            width: double.infinity,
            padding: context.appEdgeInsets(all: 32),
            decoration: BoxDecoration(
              color: CustomColors.whiteGrey,
              borderRadius: context.appBorderRadius(all: 12),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.layers_clear_outlined,
                  color: CustomColors.grey,
                  size: 40,
                ),
                context.verticalSpace(12),
                Text(
                  'No existing treatments in this category.',
                  style: context.fonts.black14w600,
                ),
                Text(
                  'Click "Add New Basic Info" to configure a new treatment template.',
                  style: context.fonts.grey12w400,
                ),
              ],
            ),
          ),
        ] else ...[
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: state.createTreatments.map((t) {
              final bool isSelected = state.selectedTreatment?.id == t.id;
              return IconImageContainer(
                title: t.patientDisplayName ?? 'N/A',
                imageUrl: t.image,
                iconUrl: t.icon,
                isSelected: isSelected,
                showActions: false,
                onTap: () => viewModel.selectTreatment(t),
              );
            }).toList(),
          ),
        ],
        context.verticalSpace(32),
      ],
    );
  }
}
