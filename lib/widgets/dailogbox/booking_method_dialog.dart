import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/models/responses/booking_methods_list_response.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/area_view_model.dart';
import 'package:skinsync_admin/view_models/booking_config_view_model.dart';
import 'package:skinsync_admin/widgets/app_network_image.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';

class BookingMethodDialog extends ConsumerStatefulWidget {
  final BookingMethodModel? method;
  const BookingMethodDialog({super.key, this.method});

  @override
  ConsumerState<BookingMethodDialog> createState() => _BookingMethodDialogState();
}

class _BookingMethodDialogState extends ConsumerState<BookingMethodDialog> {
  late TextEditingController titleController;
  late TextEditingController keyController;
  late TextEditingController descController;
  String? iconUrl;

  @override
  void initState() {
    super.initState();
    final method = widget.method;
    titleController = TextEditingController(text: method?.title);
    keyController = TextEditingController(text: method?.key);
    descController = TextEditingController(text: method?.description);
    iconUrl = method?.icon;
  }

  @override
  void dispose() {
    titleController.dispose();
    keyController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isEdit = widget.method != null;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: context.appBorderRadius(all: 16)),
      title: Text(isEdit ? 'Edit Booking Method' : 'Add Booking Method', style: context.fonts.black18w600),
      content: SizedBox(
        width: context.w(500),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Title', style: context.fonts.black14w600),
              context.verticalSpace(8),
              TextFormField(
                controller: titleController,
                style: context.fonts.black14w400,
                decoration: AppDecorations.input(context, hint: 'Enter method title'),
              ),
              context.verticalSpace(20),
              
              if (!isEdit) ...[
                Text('Key', style: context.fonts.black14w600),
                context.verticalSpace(8),
                TextFormField(
                  controller: keyController,
                  style: context.fonts.black14w400,
                  decoration: AppDecorations.input(context, hint: 'e.g. online, walk_in'),
                ),
                context.verticalSpace(20),
              ],

              Text('Description', style: context.fonts.black14w600),
              context.verticalSpace(8),
              TextFormField(
                controller: descController,
                maxLines: 3,
                style: context.fonts.black14w400,
                decoration: AppDecorations.input(context, hint: 'Provide details...'),
              ),
              context.verticalSpace(20),

              Text('Icon', style: context.fonts.black14w600),
              context.verticalSpace(12),
              _buildAssetUploader(
                url: iconUrl,
                label: 'Icon',
                isIcon: true,
                onUpload: (url) => setState(() => iconUrl = url),
                onDelete: () => setState(() => iconUrl = null),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: context.fonts.grey14w600),
        ),
        CustomPrimaryButton(
          onTap: () async {
            bool success;
            if (isEdit) {
              success = await ref.read(bookingConfigViewModelProvider.notifier).updateBookingMethod(
                id: widget.method!.id,
                title: titleController.text.trim(),
                description: descController.text.trim(),
                icon: iconUrl,
              );
            } else {
              success = await ref.read(bookingConfigViewModelProvider.notifier).createBookingMethod(
                title: titleController.text.trim(),
                key: keyController.text.trim(),
                description: descController.text.trim(),
                icon: iconUrl,
              );
            }
            if (success && context.mounted) Navigator.pop(context);
          },
          label: 'Save Changes',
          width: context.w(140),
          height: context.h(40),
        ),
      ],
    );
  }

  Widget _buildAssetUploader({
    required String? url,
    required String label,
    required bool isIcon,
    required void Function(String) onUpload,
    required VoidCallback onDelete,
  }) {
    return url == null || url.isEmpty
        ? InkWell(
            onTap: () async {
              await ref.read(areaViewModelProvider.notifier).pickImage(isIcon);
              final uploaded = isIcon ? ref.read(areaViewModelProvider).areaIconUrl : ref.read(areaViewModelProvider).areaImageUrl;
              if (uploaded != null) onUpload(uploaded);
            },
            borderRadius: context.appBorderRadius(all: 12),
            child: Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: CustomColors.whiteGrey,
                borderRadius: context.appBorderRadius(all: 12),
                border: Border.all(color: CustomColors.border),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_photo_alternate_outlined, color: CustomColors.lightGrey, size: 24),
                  context.verticalSpace(4),
                  Text('Upload $label', style: context.fonts.grey11w400),
                ],
              ),
            ),
          )
        : Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: context.appBorderRadius(all: 12),
              border: Border.all(color: CustomColors.border),
            ),
            child: ClipRRect(
              borderRadius: context.appBorderRadius(all: 12),
              child: Stack(
                children: [
                  AppNetworkImage(imageUrl: url, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: InkWell(
                      onTap: onDelete,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.delete_outline_rounded, color: CustomColors.red, size: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
