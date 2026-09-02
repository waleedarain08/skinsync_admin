import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/utils/sku_utils.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/area_view_model.dart';
import 'package:skinsync_admin/view_models/treatment_data_view_model.dart';
import 'package:skinsync_admin/widgets/app_network_image.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';
import 'package:skinsync_admin/widgets/custom_outlined_button.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'standard_dialog.dart';

class AreaCreationDialog extends ConsumerStatefulWidget {
  const AreaCreationDialog({
    super.key,
    required this.title,
    this.initialName,
    this.initialSku,
    this.initialIconUrl,
    this.initialImageUrl,
    this.initialInfoImageUrl,
    this.initialDescription,
  });

  final String title;
  final String? initialName;
  final String? initialSku;
  final String? initialIconUrl;
  final String? initialImageUrl;
  final String? initialInfoImageUrl;
  final String? initialDescription;

  @override
  ConsumerState<AreaCreationDialog> createState() => _AreaCreationDialogState();
}

class _AreaCreationDialogState extends ConsumerState<AreaCreationDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _skuController;
  late final TextEditingController _descriptionController;
  String? _iconUrl;
  String? _imageUrl;
  String? _infoImageUrl;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _skuController = TextEditingController(text: widget.initialSku);
    _iconUrl = widget.initialIconUrl;
    _imageUrl = widget.initialImageUrl;
    _infoImageUrl = widget.initialInfoImageUrl;
    _descriptionController = TextEditingController(text: widget.initialDescription);

  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Widget _buildImageUploader({
    required String title,
    required String? imageUrl,
    required VoidCallback onTapUpload,
    required VoidCallback onDelete,
  }) {
    final bool hasImage = imageUrl != null && imageUrl.isNotEmpty;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.fonts.black14w600),
          context.verticalSpace(12),
          !hasImage
              ? InkWell(
                  onTap: onTapUpload,
                  borderRadius: context.appBorderRadius(all: 12),
                  child: Container(
                    height: 110,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: CustomColors.whiteGrey,
                      borderRadius: context.appBorderRadius(all: 12),
                      border: Border.all(color: CustomColors.border),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add_photo_alternate_outlined,
                          color: CustomColors.lightGrey,
                          size: 24,
                        ),
                        context.verticalSpace(4),
                        Text(
                          'Upload',
                          style: context.fonts.grey11w400,
                        ),
                      ],
                    ),
                  ),
                )
              : Container(
                  height: 110,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: context.appBorderRadius(all: 12),
                    border: Border.all(color: CustomColors.border),
                  ),
                  child: ClipRRect(
                    borderRadius: context.appBorderRadius(all: 12),
                    child: Stack(
                      children: [
                        AppNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: InkWell(
                            onTap: onDelete,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.delete_outline_rounded,
                                color: CustomColors.red,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StandardDialog(
      title: widget.title,
      width: context.w(550), // Expanded dialog width to comfortably fit 3 columns
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BuildTextField(
            label: 'Name',
            controller: _nameController,
            hintText: 'e.g. Left Forehead',
          ),
          context.verticalSpace(16),
          BuildTextField(
            label: 'Global SKU',
            controller: _skuController,
            hintText: 'e.g. BTX-0001-UPRF',
            tooltip: 'Must follow pattern XXX-XXXX-XXXX (like BTX-0001-UPRF) and be unique.',
          ),
          context.verticalSpace(16),
          BuildTextField(
            label: 'Description',
            controller: _descriptionController,
            hintText: 'e.g. Area description goes here',
          ),
          
          context.verticalSpace(20),
          Row(
            children: [
              // 1. Icon Image Box
              _buildImageUploader(
                title: 'Area Icon',
                imageUrl: _iconUrl,
                onTapUpload: () async {
                  await ref.read(areaViewModelProvider.notifier).pickAreaMedia(AreaImageType.icon);
                  final uploaded = ref.read(areaViewModelProvider).areaIconUrl;
                  if (uploaded != null) {
                    setState(() {
                      _iconUrl = uploaded;
                    });
                  }
                },
                onDelete: () {
                  setState(() {
                    _iconUrl = '';
                  });
                },
              ),
              context.horizontalSpace(12),

              // 2. Banner Image Box
              _buildImageUploader(
                title: 'Banner Image',
                imageUrl: _imageUrl,
                onTapUpload: () async {
                  await ref.read(areaViewModelProvider.notifier).pickAreaMedia(AreaImageType.banner);
                  final uploaded = ref.read(areaViewModelProvider).areaImageUrl;
                  if (uploaded != null) {
                    setState(() {
                      _imageUrl = uploaded;
                    });
                  }
                },
                onDelete: () {
                  setState(() {
                    _imageUrl = '';
                  });
                },
              ),
              context.horizontalSpace(12),

              // 3. Info Image Box
              _buildImageUploader(
                title: 'Info Image',
                imageUrl: _infoImageUrl,
                onTapUpload: () async {
                  await ref.read(areaViewModelProvider.notifier).pickAreaMedia(AreaImageType.infoImage);
                  final uploaded = ref.read(areaViewModelProvider).infoImageUrl;
                  if (uploaded != null) {
                    setState(() {
                      _infoImageUrl = uploaded;
                    });
                  }
                },
                onDelete: () {
                  setState(() {
                    _infoImageUrl = '';
                  });
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        CustomOutlinedButton(
          onTap: () => Navigator.pop(context),
          label: 'Cancel',
        ),
        CustomPrimaryButton(
          onTap: () async {
            final name = _nameController.text.trim();
            final sku = _skuController.text.trim().toUpperCase();

            if (name.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Name is required'),
                  backgroundColor: CustomColors.red,
                ),
              );
              return;
            }

            final validationError = SkuUtils.validateGlobalSku(sku);
            if (validationError != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(validationError),
                  backgroundColor: CustomColors.red,
                ),
              );
              return;
            }

            final dataViewModel = ref.read(
              treatmentDataViewModelProvider.notifier,
            );
            if (sku != widget.initialSku && !dataViewModel.isAreaSkuUnique(sku)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('SKU must be globally unique across all levels.'),
                  backgroundColor: CustomColors.red,
                ),
              );
              return;
            }

            if (_iconUrl == null ||
                _iconUrl!.isEmpty ||
                _imageUrl == null ||
                _imageUrl!.isEmpty ||
                _infoImageUrl == null ||
                _infoImageUrl!.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Area Icon, Banner Image, and Info Image must all be selected!'),
                  backgroundColor: CustomColors.red,
                ),
              );
              return;
            }

            Navigator.pop(context, {
              'name': name,
              'sku': sku,
              'icon': _iconUrl,
              'image': _imageUrl,
              'infoImageUrl': _infoImageUrl,
              'description': _descriptionController.text.trim(),
            });
          },
          label: widget.initialSku == null ? 'Add' : 'Update',
        ),
      ],
    );
  }
}