import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/treatment_model.dart';
import '../models/treatment_data_models.dart';
import '../utils/theme.dart';
import '../view_models/treatment_data_view_model.dart';
import 'dailogbox/category_creation_dialog.dart';

class NestedCategorySelector extends ConsumerStatefulWidget {
  final List<CategoryItem> categories;
  final String? initialCategoryId;
  final Function(CategoryItem category, String path) onSelected;

  const NestedCategorySelector({
    super.key,
    required this.categories,
    this.initialCategoryId,
    required this.onSelected,
  });

  @override
  ConsumerState<NestedCategorySelector> createState() => _NestedCategorySelectorState();
}

class _NestedCategorySelectorState extends ConsumerState<NestedCategorySelector> {
  List<String> _selectedPath = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialCategoryId != null) {
      _selectedPath = _findPathToCategory(widget.categories, widget.initialCategoryId!, []);
    }
  }

  List<String> _findPathToCategory(List<CategoryItem> items, String id, List<String> currentPath) {
    for (var item in items) {
      if (item.id == id) return [...currentPath, item.id];
      if (item.children.isNotEmpty) {
        final path = _findPathToCategory(item.children, id, [...currentPath, item.id]);
        if (path.isNotEmpty) return path;
      }
    }
    return [];
  }

  void _onLevelSelect(int level, CategoryItem category) {
    setState(() {
      if (level < _selectedPath.length) {
        _selectedPath = _selectedPath.sublist(0, level);
      }
      _selectedPath.add(category.id);
    });
    
    // Calculate full name path
    String pathName = "";
    for (int i = 0; i < _selectedPath.length; i++) {
      final node = _findCategoryInTree(widget.categories, _selectedPath[i]);
      if (node != null) {
        pathName += (i == 0 ? "" : " > ") + node.name;
      }
    }
    widget.onSelected(category, pathName);
  }

  @override
  Widget build(BuildContext context) {
    final dataViewModel = ref.read(treatmentDataViewModelProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Level 0
        _buildCategoryLevel(
          context,
          title: "Main Category",
          items: widget.categories,
          selectedId: _selectedPath.isNotEmpty ? _selectedPath[0] : null,
          onSelect: (item) => _onLevelSelect(0, item),
          onAddChild: (parent) => _showCreationDialog(context, parent.name, (name, icon, consentFile, followUps) {
            dataViewModel.addCategory(name, icon: icon, parentId: parent.id, consentFormName: consentFile?.name, consentFormUrl: consentFile?.path, defaultFollowUps: followUps);
          }),
          onAddRoot: () => _showCreationDialog(context, null, (name, icon, consentFile, followUps) {
            dataViewModel.addCategory(name, icon: icon, consentFormName: consentFile?.name, consentFormUrl: consentFile?.path, defaultFollowUps: followUps);
          }),
        ),

        // Nested Levels
        ...List.generate(_selectedPath.length, (index) {
          final parentId = _selectedPath[index];
          final parentNode = _findCategoryInTree(widget.categories, parentId);
          
          if (parentNode == null || parentNode.children.isEmpty) return const SizedBox.shrink();
          
          return Padding(
            padding: context.appEdgeInsets(top: 24),
            child: _buildCategoryLevel(
              context,
              title: "Subcategory of ${parentNode.name}",
              items: parentNode.children,
              selectedId: _selectedPath.length > index + 1 ? _selectedPath[index + 1] : null,
              onSelect: (item) => _onLevelSelect(index + 1, item),
            onAddChild: (parent) => _showCreationDialog(context, parent.name, (name, icon, consentFile, followUps) {
                dataViewModel.addCategory(name, icon: icon, parentId: parent.id, consentFormName: consentFile?.name, consentFormUrl: consentFile?.path, defaultFollowUps: followUps);
              }),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCategoryLevel(
    BuildContext context, {
    required String title,
    required List<CategoryItem> items,
    required String? selectedId,
    required Function(CategoryItem) onSelect,
    required Function(CategoryItem) onAddChild,
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
                icon: const Icon(Icons.add_circle_outline_rounded, size: 20, color: CustomColors.purple),
                tooltip: "Add Root Category",
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

  void _showCreationDialog(BuildContext context, String? parentName, Function(String, String, PlatformFile?, List<FollowUpConfig>?) onSave) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => CategoryCreationDialog(parentName: parentName),
    );

    if (result != null) {
      onSave(result['name'], result['icon'], result['consentFile'], result['followUps']);
    }
  }

  CategoryItem? _findCategoryInTree(List<CategoryItem> items, String id) {
    for (var item in items) {
      if (item.id == id) return item;
      if (item.children.isNotEmpty) {
        final found = _findCategoryInTree(item.children, id);
        if (found != null) return found;
      }
    }
    return null;
  }
}

class _CategoryCard extends StatelessWidget {
  final CategoryItem category;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onAddChild;

  const _CategoryCard({
    required this.category,
    required this.isSelected,
    required this.onTap,
    required this.onAddChild,
  });

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
              ? [BoxShadow(color: CustomColors.purple.withValues(alpha: 0.2), blurRadius: 12, offset: const Offset(0, 4))]
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
                InkWell(
                  onTap: onAddChild,
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white.withValues(alpha: 0.2) : CustomColors.softGrey,
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
      case 'face': return Icons.face_retouching_natural_rounded;
      case 'spa': return Icons.spa_outlined;
      case 'cut': return Icons.content_cut_rounded;
      case 'medical': return Icons.medical_services_outlined;
      case 'wash': return Icons.dry_cleaning_outlined;
      case 'skin': return Icons.clean_hands_outlined;
      default: return Icons.category_outlined;
    }
  }
}
