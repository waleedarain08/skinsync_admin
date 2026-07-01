import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/models/requests/create_category_request.dart';
import 'package:skinsync_admin/models/responses/category_detail_response.dart';
import 'package:skinsync_admin/models/responses/category_list_response.dart';

import '../utils/theme.dart';
import '../view_models/category_view_model.dart';
import 'dailogbox/category_creation_dialog.dart';
import 'icon_image_container.dart';

class NestedCategorySelector extends ConsumerStatefulWidget {
  const NestedCategorySelector({
    super.key,
    required this.categories,
    this.initialCategoryId,
    required this.onSelected,
  });
  final List<CategoryModel> categories;
  final String? initialCategoryId;
  final void Function(CategoryModel? category, String path) onSelected;

  @override
  ConsumerState<NestedCategorySelector> createState() =>
      _NestedCategorySelectorState();
}

class _NestedCategorySelectorState extends ConsumerState<NestedCategorySelector> {
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    if (widget.initialCategoryId != null) {
      _selectedCategoryId = int.tryParse(widget.initialCategoryId!);
    }
  }

  @override
  void didUpdateWidget(NestedCategorySelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCategoryId != oldWidget.initialCategoryId && widget.initialCategoryId != null) {
      _selectedCategoryId = int.tryParse(widget.initialCategoryId!);
    }
  }

  List<int> _findPathToCategory(
    List<CategoryModel> items,
    int id,
    List<int> currentPath,
  ) {
    for (final item in items) {
      if (item.id == id) return [...currentPath, item.id];
      if (item.subCategories.isNotEmpty) {
        final path = _findPathToCategory(item.subCategories, id, [
          ...currentPath,
          item.id,
        ]);
        if (path.isNotEmpty) return path;
      }
    }
    return [];
  }

  String _getPathName(List<int> path) {
    String pathName = '';
    for (int i = 0; i < path.length; i++) {
      final node = _findCategoryInTree(widget.categories, path[i]);
      if (node != null) {
        pathName += (i == 0 ? '' : ' > ') + node.name;
      }
    }
    return pathName;
  }

  void _onCategorySelected(CategoryModel category) {
    setState(() {
      _selectedCategoryId = category.id;
    });

    final path = _findPathToCategory(widget.categories, category.id, []);
    final pathName = _getPathName(path);
    widget.onSelected(category, pathName);
  }

  @override
  Widget build(BuildContext context) {
    final categoryViewModel = ref.read(categoryViewModelProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Browse Categories', style: context.fonts.black16w600),
            TextButton.icon(
              onPressed: () => _showCreationDialog(context, null, (result) {
                categoryViewModel.addCategory(
                  result['name'],
                  icon: result['icon'],
                  consentFormName: result['consentFormName'],
                  consentFormUrl: result['consentFormUrl'],
                  defaultSessions: result['sessions'],
                  totalSessions: result['totalSessions'],
                  preNotifications: result['preNotifications'],
                  postNotifications: result['postNotifications'],
                  downtimePresets: result['downtimePresets'],
                  defaultRoles: result['defaultRoles'],
                );
              }),
              icon: const Icon(Icons.add_circle_outline, size: 18),
              label: const Text('Add Root Category'),
              style: TextButton.styleFrom(
                foregroundColor: CustomColors.purple,
              ),
            ),
          ],
        ),
        context.verticalSpace(16),
        if (widget.categories.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Center(
              child: Text(
                'No categories available. Please add a root category.',
                style: context.fonts.grey14w400,
              ),
            ),
          )
        else
          Column(
            children: widget.categories.map((category) {
              return _RecursiveCategoryTile(
                category: category,
                selectedCategoryId: _selectedCategoryId,
                onSelected: _onCategorySelected,
                onAddSubcategory: (parent) => _showAddChildDialog(
                  context,
                  parent,
                  (result) {
                    categoryViewModel.addCategory(
                      result['name'],
                      icon: result['icon'],
                      parentId: parent.id,
                      consentFormName: result['consentFormName'],
                      consentFormUrl: result['consentFormUrl'],
                      defaultSessions: result['sessions'],
                      totalSessions: result['totalSessions'],
                      preNotifications: result['preNotifications'],
                      postNotifications: result['postNotifications'],
                      downtimePresets: result['downtimePresets'],
                      defaultRoles: result['defaultRoles'],
                    );
                  },
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Future<void> _showCreationDialog(
    BuildContext context,
    String? parentName,
    void Function(Map<String, dynamic>) onSave,
  ) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => CategoryCreationDialog(parentName: parentName),
    );

    if (result != null) {
      onSave(result);
    }
  }

  Future<void> _showAddChildDialog(
    BuildContext context,
    CategoryModel parent,
    void Function(Map<String, dynamic>) onSave,
  ) async {
    final categoryViewModel = ref.read(categoryViewModelProvider.notifier);
    final detail = await categoryViewModel.getCategoryDetail(parent.id);

    if (!context.mounted) return;

    if (detail == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load category details.')),
      );
      return;
    }

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => _buildCategoryDialogFromDetail(
        detail,
        parentName: parent.name,
      ),
    );

    if (result != null) {
      onSave(result);
    }
  }

  CategoryCreationDialog _buildCategoryDialogFromDetail(
    CategoryDetailDto detail, {
    String? parentName,
    bool isViewMode = false,
  }) {
    return CategoryCreationDialog(
      parentName: parentName,
      isViewMode: isViewMode,
      initialName: isViewMode ? detail.name : null,
      initialIcon: detail.icon,
      initialImage: detail.image,
      initialConsentName: detail.consentFormName,
      initialConsentFormUrl: detail.consentFormUrl,
      initialSessions: detail.defaultSessions
              ?.map(
                (session) => CategorySessionModel(
                  sessionNumber: session.sessionNumber,
                  followUps: session.followUps
                      .map(
                        (followUp) => CategoryFollowUpModel(
                          type: followUp.type ?? '',
                          durationValue: followUp.durationValue ?? 0,
                          durationUnit:
                              unitValues.reverse[followUp.durationUnit] ??
                              'minutes',
                          intervalValue: followUp.intervalValue ?? 0,
                          intervalUnit: followUp.intervalUnit ?? '',
                          isImageRequired:
                              followUp.isImageRequired ?? false,
                          notes: followUp.notes ?? '',
                        ),
                      )
                      .toList(),
                ),
              )
              .toList() ??
          [],
      initialTotalSessions: detail.totalSessions,
      initialPreNotifications: detail.preNotifications
              ?.map(
                (notification) => CategoryNotificationModel(
                  title: notification.title,
                  message: notification.message,
                  timing: notification.timing,
                  timingUnit: unitValues.reverse[notification.timingUnit],
                  type: typeValues.reverse[notification.type],
                ),
              )
              .toList() ??
          [],
      initialPostNotifications: detail.postNotifications
              ?.map(
                (notification) => CategoryNotificationModel(
                  title: notification.title,
                  message: notification.message,
                  timing: notification.timing,
                  timingUnit: unitValues.reverse[notification.timingUnit],
                  type: typeValues.reverse[notification.type],
                ),
              )
              .toList() ??
          [],
      initialDowntimePresets: CategoryDowntimePresetModel(
        none: detail.downtimePresets?.none ?? 0,
        low: detail.downtimePresets?.low ?? 0,
        moderate: detail.downtimePresets?.moderate ?? 0,
        high: detail.downtimePresets?.high ?? 0,
      ),
      initialDefaultRoles: detail.defaultRoles
              ?.map((role) => defaultRoleValues.reverse[role] ?? '')
              .where((role) => role.isNotEmpty)
              .toList() ??
          [],
    );
  }

  CategoryModel? _findCategoryInTree(List<CategoryModel> items, int id) {
    for (final item in items) {
      if (item.id == id) return item;
      if (item.subCategories.isNotEmpty) {
        final found = _findCategoryInTree(item.subCategories, id);
        if (found != null) return found;
      }
    }
    return null;
  }
}

class _RecursiveCategoryTile extends StatelessWidget {
  final CategoryModel category;
  final int? selectedCategoryId;
  final ValueChanged<CategoryModel> onSelected;
  final ValueChanged<CategoryModel> onAddSubcategory;
  final int depth;

  const _RecursiveCategoryTile({
    required this.category,
    required this.selectedCategoryId,
    required this.onSelected,
    required this.onAddSubcategory,
    this.depth = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = category.id == selectedCategoryId;
    final hasSubcategories = category.subCategories.isNotEmpty;

    final leadingWidget = Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: CustomColors.whiteGrey,
        borderRadius: BorderRadius.circular(6),
      ),
      child: category.icon.isNotEmpty
          ? IconImageContainer(
              iconUrl: category.icon,
              width: 36,
              height: 36,
            )
          : const Icon(
              Icons.category_outlined,
              color: CustomColors.purple,
              size: 18,
            ),
    );

    final titleWidget = Row(
      children: [
        Expanded(
          child: Text(
            category.name,
            style: context.fonts.black14w600.copyWith(
              color: isSelected ? CustomColors.purple : CustomColors.black,
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
            color: isSelected ? CustomColors.purple : CustomColors.grey,
            size: 20,
          ),
          onPressed: () => onSelected(category),
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
          onPressed: () => onAddSubcategory(category),
          tooltip: 'Add Subcategory',
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        if (hasSubcategories) ...[
          const SizedBox(width: 8),
          const Icon(Icons.expand_more),
        ],
      ],
    );

    return Container(
      margin: EdgeInsets.only(left: depth * 16.0, bottom: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? CustomColors.purple : CustomColors.border,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: hasSubcategories
            ? ExpansionTile(
                initiallyExpanded: isSelected,
                onExpansionChanged: (expanded) {
                  onSelected(category);
                },
                shape: const RoundedRectangleBorder(side: BorderSide.none),
                leading: leadingWidget,
                title: titleWidget,
                trailing: trailingWidget,
                childrenPadding: const EdgeInsets.all(12),
                children: category.subCategories.map((sub) {
                  return _RecursiveCategoryTile(
                    category: sub,
                    selectedCategoryId: selectedCategoryId,
                    onSelected: onSelected,
                    onAddSubcategory: onAddSubcategory,
                    depth: depth + 1,
                  );
                }).toList(),
              )
            : ListTile(
                onTap: () => onSelected(category),
                leading: leadingWidget,
                title: titleWidget,
                trailing: trailingWidget,
              ),
      ),
    );
  }
}