import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/models/responses/area_list_response.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';
import 'package:skinsync_admin/widgets/app_network_image.dart';
import 'package:skinsync_admin/widgets/dailogbox/area_creation_dialog.dart';

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
  Future<void> _showAddNodeDialog({
    required BuildContext context,
    required String title,
    required void Function(
      String name,
      String sku,
      String iconUrl,
      String imageUrl,
    )
    onAdd,
  }) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AreaCreationDialog(title: title),
    );

    if (result != null) {
      onAdd(
        result['name'] as String,
        result['sku'] as String,
        result['icon'] as String,
        result['image'] as String,
      );
    }
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Anatomical Body Areas', style: context.fonts.black16w600),
            TextButton.icon(
              onPressed: () {
                _showAddNodeDialog(
                  context: context,
                  title: 'Create New Main Area',
                  onAdd: (name, sku, icon, image) =>
                      widget.onAddArea(name, sku, icon, image),
                );
              },
              icon: const Icon(Icons.add_circle_outline, size: 18),
              label: const Text('Add Root Area'),
              style: TextButton.styleFrom(
                foregroundColor: CustomColors.purple,
              ),
            ),
          ],
        ),
        context.verticalSpace(16),
        if (widget.areas.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Center(
              child: Text(
                'No anatomical areas available. Please add a root area.',
                style: context.fonts.grey14w400,
              ),
            ),
          )
        else
          Column(
            children: widget.areas.map((area) {
              return _RecursiveAreaTile(
                area: area,
                selectedAreas: widget.selectedAreas,
                onAreaToggle: widget.onAreaToggle,
                onSubAreaToggle: widget.onSubAreaToggle,
                onSubAreaChildToggle: widget.onSubAreaChildToggle,
                onAddSubArea: widget.onAddSubArea,
                onAddSubAreaChild: widget.onAddSubAreaChild,
                showAddNodeDialog: _showAddNodeDialog,
              );
            }).toList(),
          ),
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

class _RecursiveAreaTile extends StatelessWidget {
  final AreaModel area;
  final AreaModel? parentArea;
  final AreaModel? parentSubArea;
  final int depth;
  final List<AreaViewModelEntry> selectedAreas;
  final void Function(AreaModel area) onAreaToggle;
  final void Function(AreaModel area, AreaModel subArea) onSubAreaToggle;
  final void Function(AreaModel area, AreaModel subArea, AreaModel child)
  onSubAreaChildToggle;
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
  final Future<void> Function({
    required BuildContext context,
    required String title,
    required void Function(
      String name,
      String sku,
      String iconUrl,
      String imageUrl,
    )
    onAdd,
  }) showAddNodeDialog;

  const _RecursiveAreaTile({
    required this.area,
    this.parentArea,
    this.parentSubArea,
    this.depth = 0,
    required this.selectedAreas,
    required this.onAreaToggle,
    required this.onSubAreaToggle,
    required this.onSubAreaChildToggle,
    required this.onAddSubArea,
    required this.onAddSubAreaChild,
    required this.showAddNodeDialog,
  });

  bool _checkSelection() {
    if (depth == 0) {
      return selectedAreas.any((a) => a.areaController.text == area.name);
    } else if (depth == 1) {
      final areaEntry = selectedAreas.firstWhereOrNull(
        (a) => a.areaController.text == parentArea!.name,
      );
      return areaEntry != null &&
          areaEntry.subAreas.any((s) => s.name == area.name);
    } else {
      final areaEntry = selectedAreas.firstWhereOrNull(
        (a) => a.areaController.text == parentArea!.name,
      );
      final subAreaConfig = areaEntry?.subAreas.firstWhereOrNull(
        (s) => s.name == parentSubArea!.name,
      );
      return subAreaConfig != null &&
          subAreaConfig.children.any((c) => c.name == area.name);
    }
  }

  void _handleTap() {
    if (depth == 0) {
      onAreaToggle(area);
    } else if (depth == 1) {
      onSubAreaToggle(parentArea!, area);
    } else {
      onSubAreaChildToggle(parentArea!, parentSubArea!, area);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = _checkSelection();
    final hasChildren = area.subAreas.isNotEmpty;

    final leadingWidget = Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: CustomColors.whiteGrey,
        borderRadius: BorderRadius.circular(6),
      ),
      child: area.icon.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: AppNetworkImage(
                imageUrl: area.icon,
                width: 36,
                height: 36,
                fit: BoxFit.cover,
              ),
            )
          : const Icon(
              Icons.blur_circular,
              color: CustomColors.purple,
              size: 18,
            ),
    );

    final titleWidget = Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                area.name,
                style: context.fonts.black14w600.copyWith(
                  color: isSelected ? CustomColors.purple : CustomColors.black,
                ),
              ),
              Text(
                'SKU: ${area.globalSku}',
                style: context.fonts.grey11w400,
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
            color: isSelected ? CustomColors.purple : CustomColors.grey,
            size: 20,
          ),
          onPressed: _handleTap,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );

    final trailingWidget = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.add_circle_outline, size: 20, color: CustomColors.purple),
          onPressed: () {
            showAddNodeDialog(
              context: context,
              title: 'Create New Sub-Area in ${area.name}',
              onAdd: (name, sku, icon, image) => onAddSubArea(
                parentAreaId: area.id,
                parentAreaName: area.name,
                name: name,
                sku: sku,
                icon: icon,
                image: image,
              ),
            );
          },
          tooltip: 'Add Sub-Area',
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        if (hasChildren) ...[
          const SizedBox(width: 8),
          const Icon(Icons.expand_more),
        ],
      ],
    );

    return Container(
      margin: EdgeInsets.only(left: depth * 16.0, bottom: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? CustomColors.purple : CustomColors.border,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: Colors.white,
          child: hasChildren
              ? ExpansionTile(
                  initiallyExpanded: isSelected,
                  onExpansionChanged: (expanded) {
                    _handleTap();
                  },
                  shape: const RoundedRectangleBorder(side: BorderSide.none),
                  leading: leadingWidget,
                  title: titleWidget,
                  trailing: trailingWidget,
                  childrenPadding: const EdgeInsets.all(12),
                  children: area.subAreas.map((sub) {
                    return _RecursiveAreaTile(
                      area: sub,
                      parentArea: depth == 0 ? area : parentArea,
                      parentSubArea: depth == 1 ? area : parentSubArea,
                      depth: depth + 1,
                      selectedAreas: selectedAreas,
                      onAreaToggle: onAreaToggle,
                      onSubAreaToggle: onSubAreaToggle,
                      onSubAreaChildToggle: onSubAreaChildToggle,
                      onAddSubArea: onAddSubArea,
                      onAddSubAreaChild: onAddSubAreaChild,
                      showAddNodeDialog: showAddNodeDialog,
                    );
                  }).toList(),
                )
              : ListTile(
                  onTap: _handleTap,
                  leading: leadingWidget,
                  title: titleWidget,
                  trailing: trailingWidget,
                ),
        ),
      ),
    );
  }
}
