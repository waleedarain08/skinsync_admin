import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/utils/validators.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';

class TreatmentSelectionStep extends ConsumerWidget {
  const TreatmentSelectionStep({super.key});

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
            height: context.h(160),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: context.appBorderRadius(all: 16),
              border: Border.all(color: CustomColors.border, width: 2),
              image: imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imageUrl == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: context.appEdgeInsets(all: 12),
                        decoration: const BoxDecoration(
                          color: CustomColors.whiteGrey,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add_a_photo_outlined,
                          color: CustomColors.black,
                        ),
                      ),
                      context.verticalSpace(12),
                      Text('Tap to upload', style: context.fonts.grey13w500),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Basic Information'),
        context.verticalSpace(24),
        Row(
          children: [
            Expanded(
              child: BuildTextField(
                label: 'Global SKU (Treatment Identifier)',
                controller: viewModel.globalSkuController,
                hintText: 'e.g. TRT-XXXX-XXXX',
                validator: (val) => viewModel.validateGlobalSku(val),
                tooltip:
                    'Global SKU is a unique identifier used across all clinics and systems.',
                suffixIcon: TextButton(
                  onPressed: () => viewModel.generateSku(),
                  child: Text(
                    'Generate SKU',
                    style: context.fonts.purple12w700,
                  ),
                ),
              ),
            ),
            context.horizontalSpace(24),
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
        context.verticalSpace(32),
        _sectionTitle(context, 'Visuals'),
        context.verticalSpace(24),
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
            context.horizontalSpace(24),
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
        context.verticalSpace(32),
        _sectionTitle(context, 'Descriptions'),
        context.verticalSpace(24),
        BuildTextField(
          label: 'Short Description',
          controller: viewModel.shortDescriptionController,
          hintText: 'Brief summary for listing...',
          maxLines: 2,
        ),
        context.verticalSpace(24),
        BuildTextField(
          label: 'Full Description',
          controller: viewModel.fullDescriptionController,
          hintText: 'Detailed medical and process information...',
          maxLines: 5,
        ),
      ],
    );
  }
}