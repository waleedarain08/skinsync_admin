import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/session_view_model.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';

class PostPhotosStep extends ConsumerWidget {
  const PostPhotosStep({super.key});

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
              activeTrackColor: CustomColors.purple,
              onChanged: viewModel.toggleRequirePostTreatmentPhotos,
            ),
          ],
        ),
        if (state.requirePostTreatmentPhotos) ...[
          context.verticalSpace(24),
          const Divider(),
          context.verticalSpace(24),
          Text(
            'Photo Milestone Requirements',
            style: context.fonts.black16w600,
          ),
          context.verticalSpace(8),
          Text(
            'Define how many photos are required at specific day milestones after treatment.',
            style: context.fonts.grey12w400,
          ),
          context.verticalSpace(20),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.postTreatmentPhotoConfigs.length,
            separatorBuilder: (_, __) => context.verticalSpace(16),
            itemBuilder: (context, index) {
              final config = state.postTreatmentPhotoConfigs[index];
              return Container(
                padding: context.appEdgeInsets(all: 16),
                decoration: BoxDecoration(
                  color: CustomColors.whiteGrey.withValues(alpha: 0.5),
                  borderRadius: context.appBorderRadius(all: 10),
                  border: Border.all(color: CustomColors.border),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 2,
                      child: BuildTextField(
                        label: 'Days After Treatment',
                        controller: config.daysController,
                        hintText: 'e.g. 3',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    context.horizontalSpace(16),
                    Expanded(
                      flex: 2,
                      child: BuildTextField(
                        label: 'Required Photos',
                        controller: config.countController,
                        hintText: 'e.g. 2',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    if (state.postTreatmentPhotoConfigs.length > 1) ...[
                      context.horizontalSpace(16),
                      IconButton(
                        onPressed: () => viewModel.removePostTreatmentPhotoConfig(index),
                        icon: const Icon(
                          Icons.delete_outline,
                          color: CustomColors.red,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
          context.verticalSpace(16),
          Center(
            child: TextButton.icon(
              onPressed: viewModel.addPostTreatmentPhotoConfig,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Photo Requirement Milestone'),
              style: TextButton.styleFrom(
                foregroundColor: CustomColors.purple,
              ),
            ),
          ),
        ],
      ],
    );
  }
}