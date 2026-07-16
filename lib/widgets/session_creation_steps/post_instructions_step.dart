import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/session_view_model.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';
import 'package:skinsync_admin/widgets/session_creation_steps/instruction_attachments_widget.dart';

class PostInstructionsStep extends ConsumerWidget {
  const PostInstructionsStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionViewModelProvider);
    final viewModel = ref.read(sessionViewModelProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BuildTextField(
          label: 'Post-Treatment Instructions',
          controller: viewModel.postTreatmentInstructionsController,
          hintText: 'Aftercare and recovery guidelines...',
          maxLines: 8,
        ),
        context.verticalSpace(32),
        InstructionAttachmentsWidget(
          files: state.existingPostAttachments,
          onPick: () => viewModel.pickAttachments(false),
          onRemove: (idx) => viewModel.removeExistingAttachment(false, idx),
        ),
      ],
    );
  }
}
