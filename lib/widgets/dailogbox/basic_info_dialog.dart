import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/utils/validators.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';

class BasicInfoDialog extends ConsumerWidget {
  final int? treatmentId;
  final bool isEditMode;

  const BasicInfoDialog({super.key, this.treatmentId, this.isEditMode = false});

  static Future<void> show(
    BuildContext context, {
    int? treatmentId,
    bool isEditMode = false,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BasicInfoDialog(
          isEditMode: isEditMode,
          treatmentId: treatmentId,
        );
      },
    );
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                        if (isEditMode) {
                          if (treatmentId == null) {
                            return;
                          }
                          final result = await ref
                              .read(treatmentViewModelProvider.notifier)
                              .updateBasicInfo(id: treatmentId!);
                          if (result == true) {
                            Navigator.of(context).pop();
                          }
                        }

                        //     else{
                        // final result = await ref
                        //     .read(treatmentViewModelProvider.notifier)
                        //     .createBasicInfo();
                        //      if (result == true) {
                        //   Navigator.of(context).pop();
                        // }
                        //     }
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
  }
}
