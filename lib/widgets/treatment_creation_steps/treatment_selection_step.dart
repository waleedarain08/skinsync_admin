import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/utils/validators.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
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

  Widget _buildImageUploadTile(
    BuildContext context,
    String label,
    String? imageUrl,
    VoidCallback onTap,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.fonts.black14w600),
        context.verticalSpace(10),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: context.h(120),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: context.appBorderRadius(all: 12),
              border: Border.all(color: CustomColors.border, width: 2),
              image: imageUrl != null && imageUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imageUrl == null || imageUrl.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: context.appEdgeInsets(all: 8),
                        decoration: const BoxDecoration(
                          color: CustomColors.whiteGrey,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add_a_photo_outlined,
                          color: CustomColors.black,
                          size: 18,
                        ),
                      ),
                      context.verticalSpace(8),
                      Text('Tap to upload', style: context.fonts.grey11w400),
                    ],
                  )
                : null,
          ),
        ),
      ],
    );
  }

  void _showAddNewDialog(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final state = ref.watch(treatmentViewModelProvider);
            final viewModel = ref.read(treatmentViewModelProvider.notifier);

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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _sectionTitle(context, 'New Basic Information'),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                      const Divider(),
                      context.verticalSpace(16),
                      Row(
                        children: [
                          Expanded(
                            child: BuildTextField(
                              label: 'Global SKU (Treatment Identifier)',
                              controller: viewModel.globalSkuController,
                              hintText: 'e.g. TRT-XXXX-XXXX',
                              validator: viewModel.validateGlobalSku,
                              suffixIcon: TextButton(
                                onPressed: viewModel.generateSku,
                                child: Text(
                                  'Generate SKU',
                                  style: context.fonts.purple12w700,
                                ),
                              ),
                            ),
                          ),
                          context.horizontalSpace(16),
                          Expanded(
                            child: BuildTextField(
                              label: 'Patient Display Name',
                              controller: viewModel.displayNameController,
                              hintText: 'e.g. Wrinkle Relaxer',
                              validator: Validators.empty,
                            ),
                          ),
                        ],
                      ),
                      context.verticalSpace(16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildImageUploadTile(
                              context,
                              'Treatment Banner Image',
                              state.treatmentImageUrl,
                              () => viewModel.pickImage(false),
                            ),
                          ),
                          context.horizontalSpace(16),
                          Expanded(
                            child: _buildImageUploadTile(
                              context,
                              'Treatment Listing Icon',
                              state.treatmentIconUrl,
                              () => viewModel.pickImage(true),
                            ),
                          ),
                        ],
                      ),
                      context.verticalSpace(16),
                      BuildTextField(
                        label: 'Short Description',
                        controller: viewModel.shortDescriptionController,
                        hintText: 'Brief summary for listing...',
                        maxLines: 2,
                      ),
                      context.verticalSpace(16),
                      BuildTextField(
                        label: 'Full Description',
                        controller: viewModel.fullDescriptionController,
                        hintText: 'Detailed medical and process info...',
                        maxLines: 4,
                      ),
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
                                final result = await ref
                                    .read(treatmentViewModelProvider.notifier)
                                    .createBasicInfo();
                                if (result == true) {
                                  Navigator.of(context).pop();
                                }
                              },
                              label: 'Apply & Close',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
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
              onPressed: () => _showAddNewDialog(context, state, viewModel),
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
                // width: context.w(220),
                //height: context.h(130),
              );
            }).toList(),
          ),
        ],
        context.verticalSpace(32),
      ],
    );
  }
}
