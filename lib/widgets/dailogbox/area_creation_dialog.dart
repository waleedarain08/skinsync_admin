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
  });

  final String title;
  final String? initialName;
  final String? initialSku;
  final String? initialIconUrl;
  final String? initialImageUrl;

  @override
  ConsumerState<AreaCreationDialog> createState() => _AreaCreationDialogState();
}

class _AreaCreationDialogState extends ConsumerState<AreaCreationDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _skuController;
  String? _iconUrl;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _skuController = TextEditingController(text: widget.initialSku);
    _iconUrl = widget.initialIconUrl;
    _imageUrl = widget.initialImageUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StandardDialog(
      title: widget.title,
      width: context.w(450),
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
          context.verticalSpace(20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Area Icon', style: context.fonts.black14w600),
                    context.verticalSpace(12),
                    _iconUrl == null || _iconUrl!.isEmpty
                        ? InkWell(
                            onTap: () async {
                              await ref.read(areaViewModelProvider.notifier).pickImage(true);
                              final uploaded = ref.read(areaViewModelProvider).areaIconUrl;
                              if (uploaded != null) {
                                setState(() {
                                  _iconUrl = uploaded;
                                });
                              }
                            },
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
                                    'Upload Icon',
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
                                    imageUrl: _iconUrl!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _iconUrl = '';
                                        });
                                      },
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
              ),
              context.horizontalSpace(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Banner Image', style: context.fonts.black14w600),
                    context.verticalSpace(12),
                    _imageUrl == null || _imageUrl!.isEmpty
                        ? InkWell(
                            onTap: () async {
                              await ref.read(areaViewModelProvider.notifier).pickImage(false);
                              final uploaded = ref.read(areaViewModelProvider).areaImageUrl;
                              if (uploaded != null) {
                                setState(() {
                                  _imageUrl = uploaded;
                                });
                              }
                            },
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
                                    'Upload Image',
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
                                    imageUrl: _imageUrl!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _imageUrl = '';
                                        });
                                      },
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

            // uniqueness check - Only check if SKU has changed
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

            if (_iconUrl == null || _iconUrl!.isEmpty || _imageUrl == null || _imageUrl!.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Both Area Icon and Banner Image must be selected!'),
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
            });
          },
          label: widget.initialSku == null ? 'Add' : 'Update',
        ),
      ],
    );
  }
}
