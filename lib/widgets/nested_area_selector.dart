import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/models/responses/area_list_response.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/area_view_model.dart';
import 'package:skinsync_admin/view_models/treatment_data_view_model.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';
import 'package:skinsync_admin/widgets/app_network_image.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';
import 'package:skinsync_admin/widgets/custom_outlined_button.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'package:skinsync_admin/widgets/dailogbox/standard_dialog.dart';
import 'package:skinsync_admin/widgets/icon_image_container.dart';

typedef SubAreaSetter =
    void Function({
      required int parentAreaId,
      required String parentAreaName,
      required String name,
      String? sku,
      String? icon,
      String? image,
    });

class PreviewItem {
  final String label;
  final VoidCallback onRemove;
  final List<PreviewItem> children;

  PreviewItem({
    required this.label,
    required this.onRemove,
    this.children = const [],
  });
}

class SelectedSummaryCard extends StatelessWidget {
  final String title;
  final String sku;
  final bool summary;
  final String? icon;
  final String subLabel;
  final List<PreviewItem> items;
  final VoidCallback onRemove;

  const SelectedSummaryCard({
    super.key,
    required this.title,
    required this.sku,
    required this.summary,
    required this.icon,
    required this.subLabel,
    required this.items,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: context.w(300),
          padding: context.appEdgeInsets(all: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: context.appBorderRadius(all: 16),
            border: Border.all(color: CustomColors.border),
            boxShadow: AppShadows.xs(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: CustomColors.purple.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Icon(
                        _getIconData(icon),
                        size: 16,
                        color: CustomColors.purple,
                      ),
                    ),
                  ),
                  context.horizontalSpace(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: context.fonts.black14w600),
                        Text('SKU: $sku', style: context.fonts.grey12w400),
                      ],
                    ),
                  ),
                ],
              ),
              if (items.isNotEmpty) ...[
                context.verticalSpace(12),
                const Divider(),
                context.verticalSpace(8),
                Text(
                  subLabel,
                  style: context.fonts.black12w600.copyWith(
                    color: CustomColors.purple,
                  ),
                ),
                context.verticalSpace(6),
                ...items.map((item) => _buildItemRow(context, item, depth: 0)),
              ],
            ],
          ),
        ),
        if (!summary)
          Positioned(
            right: 2,
            top: 2,
            child: InkWell(
              onTap: onRemove,
              child: Icon(
                Icons.cancel,
                size: 18.sp,
                color: CustomColors.purple,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildItemRow(
    BuildContext context,
    PreviewItem item, {
    required int depth,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: depth * 16.0, bottom: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                size: 12,
                color: CustomColors.purple,
              ),
              context.horizontalSpace(6),
              Expanded(
                child: Text(item.label, style: context.fonts.black12w400),
              ),
              if (!summary)
                InkWell(
                  onTap: item.onRemove,
                  child: const Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Icon(
                      Icons.cancel,
                      size: 14,
                      color: CustomColors.purple,
                    ),
                  ),
                ),
            ],
          ),
          if (item.children.isNotEmpty)
            ...item.children.map(
              (c) => _buildItemRow(context, c, depth: depth + 1),
            ),
        ],
      ),
    );
  }

  IconData _getIconData(String? iconName) {
    switch (iconName?.toLowerCase()) {
      case 'face':
        return Icons.face_retouching_natural_rounded;
      case 'neck':
        return Icons.line_weight_rounded;
      case 'hands':
        return Icons.back_hand_outlined;
      case 'body':
        return Icons.accessibility_new_outlined;
      case 'scalp':
        return Icons.spa_outlined;
      default:
        return Icons.location_on_outlined;
    }
  }
}

class NestedAreaSelector extends ConsumerStatefulWidget {
  final List<AreaModel> areas;
  final List<AreaViewModelEntry> selectedAreas;
  final void Function(AreaModel area) onAreaToggle;
  final void Function(AreaModel area, AreaModel subArea) onSubAreaToggle;
  final void Function(AreaModel area, AreaModel subArea, AreaModel child)
  onSubAreaChildToggle;

  // Creation callbacks
  final void Function(String name, String sku, String icon, String image)
  onAddArea;
  final SubAreaSetter onAddSubArea;
  final void Function(
    String parentArea,
    String parentSubArea,
    String name,
    String sku,
    String? icon,
    String? image,
  )
  onAddSubAreaChild;

  const NestedAreaSelector({
    super.key,
    required this.areas,
    required this.selectedAreas,
    required this.onAreaToggle,
    required this.onSubAreaToggle,
    required this.onSubAreaChildToggle,
    required this.onAddArea,
    required this.onAddSubArea,
    required this.onAddSubAreaChild,
  });

  @override
  ConsumerState<NestedAreaSelector> createState() => _NestedAreaSelectorState();
}

class _NestedAreaSelectorState extends ConsumerState<NestedAreaSelector> {
  String? _focusedAreaName;
  String? _focusedSubAreaName;

  @override
  void initState() {
    super.initState();
    final cleanSelected = widget.selectedAreas
        .where((a) => a.areaController.text.trim().isNotEmpty)
        .toList();
    if (cleanSelected.isNotEmpty) {
      final selectedEntry = cleanSelected.first;
      _focusedAreaName = selectedEntry.areaController.text.trim();
      if (selectedEntry.subAreas.isNotEmpty) {
        _focusedSubAreaName = selectedEntry.subAreas.first.name.trim();
      }
    }
  }

  void _showAddNodeDialog({
    required BuildContext context,
    required String title,
    required void Function(
      String name,
      String sku,
      String iconUrl,
      String imageUrl,
    )
    onAdd,
  }) {
    final nameController = TextEditingController();
    final skuController = TextEditingController();
    String? iconUrl;
    String? imageUrl;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
//final areaState = ref.watch(areaViewModelProvider);
            return StandardDialog(
              title: title,
              width: context.w(450),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BuildTextField(
                    label: 'Name',
                    controller: nameController,
                    hintText: 'e.g. Left Forehead',
                  ),
                  context.verticalSpace(16),
                  BuildTextField(
                    label: 'Global SKU',
                    controller: skuController,
                    hintText: 'e.g. FORE-1111',
                    tooltip:
                        'Must follow pattern AAAA-1234 (4 letters, hyphen, 4 digits) and be unique.',
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
                            iconUrl == null || iconUrl!.isEmpty
                                ? InkWell(
                                    onTap: () async {
                                      await ref.read(areaViewModelProvider.notifier).pickImage(true);
                                      final uploaded = ref.read(areaViewModelProvider).areaIconUrl;
                                      if (uploaded != null) {
                                        setDialogState(() {
                                          iconUrl = uploaded;
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
                                            imageUrl: iconUrl!,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: InkWell(
                                              onTap: () {
                                                setDialogState(() {
                                                  iconUrl = '';
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
                            imageUrl == null || imageUrl!.isEmpty
                                ? InkWell(
                                    onTap: () async {
                                      await ref.read(areaViewModelProvider.notifier).pickImage(false);
                                      final uploaded = ref.read(areaViewModelProvider).areaImageUrl;
                                      if (uploaded != null) {
                                        setDialogState(() {
                                          imageUrl = uploaded;
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
                                            imageUrl: imageUrl!,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: InkWell(
                                              onTap: () {
                                                setDialogState(() {
                                                  imageUrl = '';
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
                // context.horizontalSpace(12),
                CustomPrimaryButton(
                  onTap: () async {
                    final name = nameController.text.trim();
                    final sku = skuController.text.trim().toUpperCase();

                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Name is required'),
                          backgroundColor: CustomColors.red,
                        ),
                      );
                      return;
                    }

                    final regex = RegExp(r'^[A-Z]{4}-[0-9]{4}$');
                    if (!regex.hasMatch(sku)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Invalid SKU format. Must be AAAA-1234.',
                          ),
                          backgroundColor: CustomColors.red,
                        ),
                      );
                      return;
                    }

                    // uniqueness check
                    final dataViewModel = ref.read(
                      treatmentDataViewModelProvider.notifier,
                    );
                    if (!dataViewModel.isAreaSkuUnique(sku)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'SKU must be globally unique across all levels.',
                          ),
                          backgroundColor: CustomColors.red,
                        ),
                      );
                      return;
                    }

                    if (iconUrl == null || imageUrl == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Area icon must be selected!'),
                          backgroundColor: CustomColors.red,
                        ),
                      );
                      return;
                    }
                    onAdd(name, sku, iconUrl!, imageUrl!);
                    Navigator.pop(context);
                  },
                  label: 'Add',
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildLiveSelectionPreview(BuildContext context) {
    final List<Widget> previewNodes = [];

    for (final area in widget.areas) {
      final isAreaSelected = widget.selectedAreas.any(
        (a) => a.areaController.text == area.name,
      );
      final areaEntry = widget.selectedAreas.firstWhere(
        (a) => a.areaController.text == area.name,
        orElse: AreaViewModelEntry.new,
      );

      final selectedSubAreas = area.subAreas.where((s) {
        return areaEntry.subAreas.any((sa) => sa.name == s.name);
      }).toList();

      if (isAreaSelected || selectedSubAreas.isNotEmpty) {
        final List<PreviewItem> subAreaItems = [];

        for (final s in selectedSubAreas) {
          final subAreaConfig = areaEntry.subAreas.firstWhere(
            (sa) => sa.name == s.name,
          );

          final selectedChildren = s.subAreas.where((c) {
            return subAreaConfig.children.any((sac) => sac.name == c.name);
          }).toList();

          final childItems = selectedChildren.map((c) {
            return PreviewItem(
              label: '${c.name} (${c.globalSku})',
              onRemove: () {
                widget.onSubAreaChildToggle(area, s, c);
              },
            );
          }).toList();

          subAreaItems.add(
            PreviewItem(
              label: '${s.name} (${s.globalSku})',
              onRemove: () {
                widget.onSubAreaToggle(area, s);
                if (_focusedAreaName == area.name &&
                    _focusedSubAreaName == s.name) {
                  setState(() {
                    _focusedSubAreaName = null;
                  });
                }
              },
              children: childItems,
            ),
          );
        }

        previewNodes.add(
          SelectedSummaryCard(
            title: area.name,
            sku: area.globalSku,
            icon: area.icon,
            subLabel: 'Selected Sub-Areas:',
            items: subAreaItems,
            summary: false,
            onRemove: () {
              widget.onAreaToggle(area);
              if (_focusedAreaName == area.name) {
                setState(() {
                  _focusedAreaName = null;
                  _focusedSubAreaName = null;
                });
              }
            },
          ),
        );
      }
    }

    if (previewNodes.isEmpty) {
      return Text('No areas selected', style: context.fonts.grey13w500);
    }

    return Wrap(spacing: 16, runSpacing: 16, children: previewNodes);
  }

  @override
  Widget build(BuildContext context) {
    if (_focusedAreaName != null &&
        !widget.areas.any((a) => a.name == _focusedAreaName)) {
      _focusedAreaName = null;
      _focusedSubAreaName = null;
    }

    final focusedArea = _focusedAreaName == null
        ? null
        : widget.areas.firstWhereOrNull((a) => a.name == _focusedAreaName);

    final areaEntry = focusedArea == null
        ? AreaViewModelEntry()
        : widget.selectedAreas.firstWhere(
            (a) => a.areaController.text == focusedArea.name,
            orElse: AreaViewModelEntry.new,
          );

    if (focusedArea != null &&
        _focusedSubAreaName != null &&
        !focusedArea.subAreas.any((s) => s.name == _focusedSubAreaName)) {
      _focusedSubAreaName = null;
    }

    final focusedSubArea = focusedArea?.subAreas.firstWhereOrNull(
      (s) => s.name == _focusedSubAreaName,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Main Body Areas', style: context.fonts.black14w600),
            IconButton(
              onPressed: () {
                _showAddNodeDialog(
                  context: context,
                  title: 'Create New Main Area',
                  onAdd: (name, sku, icon, image) =>
                      widget.onAddArea(name, sku, icon, image),
                );
              },
              icon: const Icon(
                Icons.add_circle_outline_rounded,
                size: 20,
                color: CustomColors.purple,
              ),
              tooltip: 'Add Root Area',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        context.verticalSpace(16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: widget.areas.map((area) {
            final isSelected = widget.selectedAreas.any(
              (a) => a.areaController.text == area.name,
            );
            final isFocused = _focusedAreaName == area.name;

            return IconImageContainer(
              title: area.name,
              imageUrl: area.image,
              iconUrl: area.icon,
              isSelected: isSelected || isFocused,
              onTap: () {
                if (!isSelected) {
                  widget.onAreaToggle(area);
                  ref
                      .read(treatmentViewModelProvider.notifier)
                      .setSelectedTreatmentAreaIds(area.id);
                }
                setState(() {
                  _focusedAreaName = area.name;
                  _focusedSubAreaName = null;
                });
              },
              onAddChild: () {
                _showAddNodeDialog(
                  context: context,
                  title: 'Create New Sub-Area in ${area.name}',
                  onAdd: (name, sku, icon, image) => widget.onAddSubArea(
                    parentAreaId: area.id,
                    parentAreaName: area.name,
                    name: name,
                    sku: sku,
                    icon: icon,
                    image: image,
                  ),
                );
              },
            );
          }).toList(),
        ),

        if (focusedArea != null && focusedArea.subAreas.isNotEmpty) ...[
          context.verticalSpace(32),
          const Divider(),
          context.verticalSpace(24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sub-Areas of ${focusedArea.name}',
                style: context.fonts.black14w600,
              ),
              IconButton(
                onPressed: () {
                  _showAddNodeDialog(
                    context: context,
                    title: 'Create New Sub-Area in ${focusedArea.name}',
                    onAdd: (name, sku, icon, image) => widget.onAddSubArea(
                      parentAreaId: focusedArea.id,
                      parentAreaName: focusedArea.name,
                      name: name,
                      sku: sku,
                      icon: icon,
                      image: image,
                    ),
                  );
                },
                icon: const Icon(
                  Icons.add_circle_outline_rounded,
                  size: 20,
                  color: CustomColors.purple,
                ),
                tooltip: 'Add Sub-Area',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          context.verticalSpace(16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: focusedArea.subAreas.map((subArea) {
              final isSelected = areaEntry.subAreas.any(
                (s) => s.name == subArea.name,
              );
              final isFocused = _focusedSubAreaName == subArea.name;

              return IconImageContainer(
                title: subArea.name,
                imageUrl: subArea.image,
                iconUrl: subArea.icon,
                isSelected: isSelected || isFocused,
                onTap: () {
                  if (!isSelected) {
                    widget.onSubAreaToggle(focusedArea, subArea);
                    ref
                        .read(treatmentViewModelProvider.notifier)
                        .setSelectedTreatmentAreaIds(subArea.id);
                  }
                  setState(() {
                    _focusedSubAreaName = subArea.name;
                  });
                },
                onAddChild: () {
                  _showAddNodeDialog(
                    context: context,
                    title: 'Create New Child Area in ${subArea.name}',
                    onAdd: (name, sku, icon, image) => widget.onAddSubAreaChild(
                      focusedArea.name,
                      subArea.name,
                      name,
                      sku,
                      icon,
                      image,
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ],

        if (focusedSubArea != null &&
            focusedSubArea.name.isNotEmpty &&
            focusedSubArea.subAreas.isNotEmpty) ...[
          context.verticalSpace(32),
          const Divider(),
          context.verticalSpace(24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Child Areas of ${focusedSubArea.name}',
                style: context.fonts.black14w600,
              ),
              IconButton(
                onPressed: () {
                  _showAddNodeDialog(
                    context: context,
                    title: 'Create New Child in ${focusedSubArea.name}',
                    onAdd: (name, sku, icon, image) => widget.onAddSubAreaChild(
                      focusedArea!.name,
                      focusedSubArea.name,
                      name,
                      sku,
                      icon,
                      image,
                    ),
                  );
                },
                icon: const Icon(
                  Icons.add_circle_outline_rounded,
                  size: 20,
                  color: CustomColors.purple,
                ),
                tooltip: 'Add Child Area',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          context.verticalSpace(16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: focusedSubArea.subAreas.map((child) {
              final subAreaConfig = areaEntry.subAreas.firstWhere(
                (s) => s.name == focusedSubArea.name,
                orElse: () => SubAreaConfig(
                  name: focusedSubArea.name,
                  id: focusedSubArea.id,
                ),
              );
              final isSelected = subAreaConfig.children.any(
                (c) => c.name == child.name,
              );

              return IconImageContainer(
                title: child.name,
                imageUrl: child.image,
                iconUrl: child.icon,
                isSelected: isSelected,
                onTap: () {
                  if (!isSelected) {
                    widget.onSubAreaChildToggle(
                      focusedArea!,
                      focusedSubArea,
                      child,
                    );
                    ref
                        .read(treatmentViewModelProvider.notifier)
                        .setSelectedTreatmentAreaIds(child.id);
                  }
                },
                onAddChild: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Deepest level reached. Cannot add further children.',
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ],

        context.verticalSpace(32),
        const Divider(),
        context.verticalSpace(24),
        Container(
          width: double.infinity,
          padding: context.appEdgeInsets(all: 20),
          decoration: BoxDecoration(
            color: CustomColors.softGrey.withValues(alpha: 0.1),
            borderRadius: context.appBorderRadius(all: 12),
            border: Border.all(color: CustomColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Selected Anatomical Structure Preview',
                    style: context.fonts.black16w700,
                  ),
                  const Icon(
                    Icons.analytics_outlined,
                    color: CustomColors.purple,
                    size: 20,
                  ),
                ],
              ),
              context.verticalSpace(16),
              _buildLiveSelectionPreview(context),
            ],
          ),
        ),
      ],
    );
  }
}
