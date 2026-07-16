import 'package:flutter/material.dart';
import 'package:skinsync_admin/models/common_models.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/widgets/app_network_image.dart';

class InstructionAttachmentsWidget extends StatelessWidget {
  final List<Attachment> files;
  final VoidCallback onPick;
  final void Function(int) onRemove;

  const InstructionAttachmentsWidget({
    super.key,
    required this.files,
    required this.onPick,
    required this.onRemove,
  });

  Widget _buildUploadedAttachmentPreview(
    BuildContext context,
    Attachment file,
  ) {
    if (file.type == 'image') {
      return AppNetworkImage(
        imageUrl: file.url,
        borderRadius: context.appBorderRadius(all: 6),
        fit: BoxFit.cover,
      );
    }
    if (file.type == 'pdf') {
      return const Icon(
        Icons.picture_as_pdf_rounded,
        color: CustomColors.red,
        size: 32,
      );
    }
    if (file.type == 'video') {
      return const Icon(
        Icons.video_collection_rounded,
        color: CustomColors.purple,
        size: 32,
      );
    }
    return const Icon(
      Icons.insert_drive_file_outlined,
      color: CustomColors.grey,
      size: 32,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Supporting Media (Optional)',
              style: context.fonts.black14w600,
            ),
            TextButton.icon(
              onPressed: onPick,
              icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
              label: const Text('Add Files'),
              style: TextButton.styleFrom(foregroundColor: CustomColors.purple),
            ),
          ],
        ),
        context.verticalSpace(12),
        if (files.isEmpty)
          InkWell(
            onTap: onPick,
            child: Container(
              width: double.infinity,
              padding: context.appEdgeInsets(vertical: 20),
              decoration: BoxDecoration(
                color: CustomColors.whiteGrey,
                borderRadius: context.appBorderRadius(all: 12),
                border: Border.all(
                  color: CustomColors.border,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.cloud_upload_outlined,
                    color: CustomColors.grey,
                    size: 24,
                  ),
                  context.verticalSpace(8),
                  Text(
                    'Upload PDFs, Images, or Videos',
                    style: context.fonts.grey13w500,
                  ),
                ],
              ),
            ),
          )
        else
          Wrap(
            spacing: context.w(12),
            runSpacing: context.h(12),
            children: List.generate(files.length, (index) {
              final file = files[index];
              return Container(
                width: context.w(160),
                padding: context.appEdgeInsets(all: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: context.appBorderRadius(all: 10),
                  border: Border.all(color: CustomColors.border),
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: context.h(80),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: CustomColors.whiteGrey,
                            borderRadius: context.appBorderRadius(all: 6),
                          ),
                          child: _buildUploadedAttachmentPreview(context, file),
                        ),
                        Positioned(
                          top: 2,
                          right: 2,
                          child: InkWell(
                            onTap: () => onRemove(index),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                size: 14,
                                color: CustomColors.red,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    context.verticalSpace(8),
                    Text(
                      file.name,
                      style: context.fonts.grey10w400,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }),
          ),
      ],
    );
  }
}
