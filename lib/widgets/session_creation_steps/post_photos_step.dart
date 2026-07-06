import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/session_view_model.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';

class PostPhotosStep extends ConsumerWidget {
  const PostPhotosStep({super.key});

  Widget _counterButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: CustomColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: CustomColors.purple),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionViewModelProvider);
    final viewModel = ref.read(sessionViewModelProvider.notifier);

    return Column(
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
                    'Require Post Treatment Photos',
                    style: context.fonts.black16w600,
                  ),
                  Text(
                    state.requirePostTreatmentPhotos
                        ? 'Provider must capture photos to complete treatment.'
                        : 'Post treatment photos are optional for this treatment.',
                    style: context.fonts.grey12w400,
                  ),
                ],
              ),
            ),
            Switch.adaptive(
              value: state.requirePostTreatmentPhotos,
              activeColor: CustomColors.purple,
              onChanged: viewModel.toggleRequirePostTreatmentPhotos,
            ),
          ],
        ),
        if (state.requirePostTreatmentPhotos) ...[
          context.verticalSpace(32),
          const Divider(),
          context.verticalSpace(32),
          Text('Required Number of Photos', style: context.fonts.black16w600),
          context.verticalSpace(8),
          Text(
            'Specify how many photos the provider is expected to upload.',
            style: context.fonts.grey12w400,
          ),
          context.verticalSpace(20),
          Row(
            children: [
              _counterButton(
                icon: Icons.remove,
                onTap: () {
                  final current =
                      int.tryParse(
                        viewModel.postTreatmentPhotoCountController.text,
                      ) ??
                      0;
                  if (current > 1) {
                    final newVal = (current - 1).toString();
                    viewModel.postTreatmentPhotoCountController.text = newVal;
                    viewModel.updateRequiredPostTreatmentPhotoCount(newVal);
                  }
                },
              ),
              Container(
                width: context.w(100),
                margin: context.appEdgeInsets(horizontal: 16),
                child: BuildTextField(
                  label: '',
                  controller: viewModel.postTreatmentPhotoCountController,
                  hintText: '0',
                  keyboardType: TextInputType.number,
                  onChanged: (val) => viewModel
                      .updateRequiredPostTreatmentPhotoCount(val ?? '0'),
                ),
              ),
              _counterButton(
                icon: Icons.add,
                onTap: () {
                  final current =
                      int.tryParse(
                        viewModel.postTreatmentPhotoCountController.text,
                      ) ??
                      0;
                  final newVal = (current + 1).toString();
                  viewModel.postTreatmentPhotoCountController.text = newVal;
                  viewModel.updateRequiredPostTreatmentPhotoCount(newVal);
                },
              ),
            ],
          ),
        ],
      ],
    );
  }
}