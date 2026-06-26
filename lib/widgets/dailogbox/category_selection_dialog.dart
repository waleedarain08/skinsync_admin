import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import '../custom_outlined_button.dart';
import '../../models/responses/category_list_response.dart';
import '../../view_models/category_view_model.dart';
import 'standard_dialog.dart';

class CategorySelectionDialog extends ConsumerStatefulWidget {
  final List<int> initialCategoryIds;
  final ValueChanged<Map<String, dynamic>> onConfirmed;

  const CategorySelectionDialog({
    super.key,
    required this.initialCategoryIds,
    required this.onConfirmed,
  });

  @override
  ConsumerState<CategorySelectionDialog> createState() => _CategorySelectionDialogState();
}

class _CategorySelectionDialogState extends ConsumerState<CategorySelectionDialog> {
  final List<int> _selectedIds = [];
  final List<String> _selectedNames = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoryViewModelProvider.notifier).fetchCategories(showLoading: false);
    });

    _selectedIds.addAll(widget.initialCategoryIds);
    _rebuildNamesPath();
  }

  void _rebuildNamesPath() {
    _selectedNames.clear();
    final categories = ref.read(categoryViewModelProvider).categories;
    
    CategoryModel? findInList(List<CategoryModel> list, int id) {
      for (final cat in list) {
        if (cat.id == id) return cat;
        final child = findInList(cat.subCategories, id);
        if (child != null) return child;
      }
      return null;
    }

    for (final id in _selectedIds) {
      final node = findInList(categories, id);
      if (node != null) {
        _selectedNames.add(node.name);
      }
    }
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

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryViewModelProvider);
    final categories = categoryState.categories;

    final List<List<CategoryModel>> columns = [categories];
    for (int i = 0; i < _selectedIds.length; i++) {
      final selectedId = _selectedIds[i];
      final node = _findCategoryInTree(categories, selectedId);
      if (node != null && node.subCategories.isNotEmpty) {
        columns.add(node.subCategories);
      } else {
        break;
      }
    }

    final selectedPathText = _selectedNames.isNotEmpty
        ? _selectedNames.join(' → ')
        : 'None';

    return StandardDialog(
      title: 'Select Category',
      width: context.w(800),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selected Path:',
            style: context.fonts.black14w600,
          ),
          SizedBox(height: context.h(8)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(12)),
            width: double.infinity,
            decoration: BoxDecoration(
              color: CustomColors.whiteGrey,
              borderRadius: BorderRadius.circular(context.r(8)),
              border: Border.all(color: CustomColors.border),
            ),
            child: Text(
              selectedPathText,
              style: context.fonts.purple14w600,
            ),
          ),
          SizedBox(height: context.h(24)),
          SizedBox(
            height: context.h(300),
            child: columns.isEmpty || categories.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Scrollbar(
                    thumbVisibility: true,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: columns.length,
                      separatorBuilder: (context, index) => Container(
                        width: 1,
                        color: CustomColors.border,
                        margin: EdgeInsets.symmetric(horizontal: context.w(12)),
                      ),
                      itemBuilder: (context, columnIndex) {
                        final items = columns[columnIndex];
                        final activeId = _selectedIds.length > columnIndex
                            ? _selectedIds[columnIndex]
                            : null;

                        return SizedBox(
                          width: context.w(220),
                          child: ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, itemIndex) {
                              final item = items[itemIndex];
                              final isSelected = activeId == item.id;

                              return Container(
                                margin: EdgeInsets.only(bottom: context.h(8)),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? CustomColors.purple.withValues(alpha: 0.1)
                                      : Colors.white,
                                  borderRadius: context.appBorderRadius(all: 10),
                                  border: Border.all(
                                    color: isSelected
                                        ? CustomColors.purple
                                        : CustomColors.border,
                                    width: isSelected ? 1.5 : 1,
                                  ),
                                ),
                                child: ListTile(
                                  title: Text(
                                    item.name,
                                    style: isSelected
                                        ? context.fonts.purple14w600
                                        : context.fonts.black14w400,
                                  ),
                                  trailing: item.subCategories.isNotEmpty
                                      ? Icon(
                                          Icons.chevron_right_rounded,
                                          color: isSelected
                                              ? CustomColors.purple
                                              : CustomColors.lightGrey,
                                        )
                                      : null,
                                  onTap: () {
                                    setState(() {
                                      if (columnIndex < _selectedIds.length) {
                                        _selectedIds.removeRange(
                                            columnIndex, _selectedIds.length);
                                        _selectedNames.removeRange(
                                            columnIndex, _selectedNames.length);
                                      }
                                      _selectedIds.add(item.id);
                                      _selectedNames.add(item.name);
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      actions: [
        CustomOutlinedButton(
          onTap: () {
            widget.onConfirmed({
              'path': '',
              'ids': <int>[],
            });
            Navigator.pop(context);
          },
          label: 'Clear Category',
        ),
        const Spacer(),
        CustomOutlinedButton(
          onTap: () => Navigator.pop(context),
          label: 'Cancel',
        ),
        SizedBox(width: context.w(12)),
        CustomPrimaryButton(
          onTap: () {
            widget.onConfirmed({
              'path': _selectedNames.join(' > '),
              'ids': List<int>.from(_selectedIds),
            });
            Navigator.pop(context);
          },
          label: 'Select Category',
        ),
      ],
    );
  }
}
