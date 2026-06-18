import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/models/requests/create_category_request.dart';

import '../models/responses/category_detail_response.dart';
import '../models/responses/category_list_response.dart';
import '../utils/theme.dart';
import '../view_models/category_view_model.dart';
import 'dailogbox/category_creation_dialog.dart';

class NestedCategorySelector extends ConsumerStatefulWidget {
  const NestedCategorySelector({
    super.key,
    required this.categories,
    this.initialCategoryId,
    required this.onSelected,
  });
  final List<CategoryModel> categories;
  final String? initialCategoryId;
  final void Function(CategoryModel category, String path) onSelected;

  @override
  ConsumerState<NestedCategorySelector> createState() =>
      _NestedCategorySelectorState();
}

class _NestedCategorySelectorState
    extends ConsumerState<NestedCategorySelector> {
  List<int> _selectedPath = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialCategoryId != null) {
      final id = int.tryParse(widget.initialCategoryId!);
      if (id != null) {
        _selectedPath = _findPathToCategory(
          widget.categories,
          id,
          [],
        );
      }
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

  void _onLevelSelect(int level, CategoryModel category) {
    setState(() {
      if (level < _selectedPath.length) {
        _selectedPath = _selectedPath.sublist(0, level);
      }
      _selectedPath.add(category.id);
    });

    // Calculate full name path
    String pathName = '';
    for (int i = 0; i < _selectedPath.length; i++) {
      final node = _findCategoryInTree(widget.categories, _selectedPath[i]);
      if (node != null) {
        pathName += (i == 0 ? '' : ' > ') + node.name;
      }
    }
    widget.onSelected(category, pathName);
  }

  @override
  Widget build(BuildContext context) {
    final categoryViewModel = ref.read(categoryViewModelProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Level 0
        _buildCategoryLevel(
          context,
          title: 'Main Category',
          items: widget.categories,
          selectedId: _selectedPath.isNotEmpty ? _selectedPath[0] : null,
              onSelect: (item) => _onLevelSelect(0, item),
              onAddChild: (parent) => _showAddChildDialog(
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
          onAddRoot: () => _showCreationDialog(context, null, (result) {
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
        ),

        // Nested Levels
        ...List.generate(_selectedPath.length, (index) {
          final parentId = _selectedPath[index];
          final parentNode = _findCategoryInTree(widget.categories, parentId);

          if (parentNode == null || parentNode.subCategories.isEmpty) {
            return const SizedBox.shrink();
          }

          return Padding(
            padding: context.appEdgeInsets(top: 24),
            child: _buildCategoryLevel(
              context,
              title: 'Subcategory of ${parentNode.name}',
              items: parentNode.subCategories,
              selectedId: _selectedPath.length > index + 1
                  ? _selectedPath[index + 1]
                  : null,
              onSelect: (item) => _onLevelSelect(index + 1, item),
              onAddChild: (parent) => _showAddChildDialog(
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
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCategoryLevel(
    BuildContext context, {
    required String title,
    required List<CategoryModel> items,
    required int? selectedId,
    required void Function(CategoryModel) onSelect,
    required void Function(CategoryModel) onAddChild,
    VoidCallback? onAddRoot,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title, style: context.fonts.black14w600),
            if (onAddRoot != null) ...[
              context.horizontalSpace(12),
              IconButton(
                onPressed: onAddRoot,
                icon: const Icon(
                  Icons.add_circle_outline_rounded,
                  size: 20,
                  color: CustomColors.purple,
                ),
                tooltip: 'Add Root Category',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ],
        ),
        context.verticalSpace(16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: items.map((category) {
            final isSelected = category.id == selectedId;
            return _CategoryCard(
              category: category,
              isSelected: isSelected,
              onTap: () => onSelect(category),
              onAddChild: () => onAddChild(category),
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
          .map(
            (session) => CategorySessionModel(
              sessionNumber: session.sessionNumber,
              followUps: session.followUps
                  .map(
                    (followUp) => CategoryFollowUpModel(
                      type: followUp.type,
                      durationValue: followUp.durationValue,
                      durationUnit:
                          unitValues.reverse[followUp.durationUnit] ??
                              'minutes',
                      intervalValue: followUp.intervalValue,
                      intervalUnit: followUp.intervalUnit,
                      isImageRequired: followUp.isImageRequired,
                      notes: followUp.notes,
                    ),
                  )
                  .toList(),
            ),
          )
          .toList(),
      initialTotalSessions: detail.totalSessions,
      initialPreNotifications: detail.preNotifications
          .map(
            (notification) => CategoryNotificationModel(
              title: notification.title,
              message: notification.message,
              timing: notification.timing,
              timingUnit: unitValues.reverse[notification.timingUnit],
              type: typeValues.reverse[notification.type],
            ),
          )
          .toList(),
      initialPostNotifications: detail.postNotifications
          .map(
            (notification) => CategoryNotificationModel(
              title: notification.title,
              message: notification.message,
              timing: notification.timing,
              timingUnit: unitValues.reverse[notification.timingUnit],
              type: typeValues.reverse[notification.type],
            ),
          )
          .toList(),
      initialDowntimePresets: CategoryDowntimePresetModel(
        none: detail.downtimePresets.none,
        low: detail.downtimePresets.low,
        moderate: detail.downtimePresets.moderate,
        high: detail.downtimePresets.high,
      ),
      initialDefaultRoles: detail.defaultRoles
          .map((role) => defaultRoleValues.reverse[role] ?? '')
          .where((role) => role.isNotEmpty)
          .toList(),
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

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.isSelected,
    required this.onTap,
    required this.onAddChild,
  });
  final CategoryModel category;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onAddChild;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: context.appBorderRadius(all: 16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: context.w(180),
        padding: context.appEdgeInsets(all: 16),
        decoration: BoxDecoration(
          color: isSelected ? CustomColors.purple : Colors.white,
          borderRadius: context.appBorderRadius(all: 16),
          border: Border.all(
            color: isSelected ? CustomColors.purple : CustomColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: CustomColors.purple.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : AppShadows.xs(context),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  _getIconData(category.icon),
                  size: context.sp(22),
                  color: isSelected ? Colors.white : CustomColors.purple,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => CategoryCreationDialog(
                            categoryId: category.id,
                            isViewMode: true,
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.2)
                              : CustomColors.softGrey,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.visibility_outlined,
                          size: 14,
                          color: isSelected ? Colors.white : CustomColors.grey,
                        ),
                      ),
                    ),
                    context.horizontalSpace(6),
                    InkWell(
                      onTap: onAddChild,
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.2)
                              : CustomColors.softGrey,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add,
                          size: 14,
                          color: isSelected ? Colors.white : CustomColors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            context.verticalSpace(16),
            Text(
              category.name,
              style: isSelected
                  ? context.fonts.white14w600
                  : context.fonts.black14w600,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String? iconName) {
    switch (iconName) {
      case 'face':
        return Icons.face_retouching_natural_rounded;
      case 'spa':
        return Icons.spa_outlined;
      case 'cut':
        return Icons.content_cut_rounded;
      case 'medical':
        return Icons.medical_services_outlined;
      case 'wash':
        return Icons.dry_cleaning_outlined;
      case 'skin':
        return Icons.clean_hands_outlined;
      default:
        return Icons.category_outlined;
    }
  }
}
