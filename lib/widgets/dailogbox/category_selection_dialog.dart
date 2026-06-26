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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoryViewModelProvider.notifier).fetchCategories(showLoading: false);
    });

    _selectedIds.addAll(widget.initialCategoryIds);
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

    // Dynamically calculate selected names locally (pure computation, no side-effects in build)
    final List<String> selectedNames = [];
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
        selectedNames.add(node.name);
      }
    }

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

    final selectedPathText = selectedNames.isNotEmpty
        ? selectedNames.join(' → ')
        : 'None';

    // Build columns of categories horizontally
    final List<Widget> columnWidgets = [];
    for (int columnIndex = 0; columnIndex < columns.length; columnIndex++) {
      final items = columns[columnIndex];
      final activeId = _selectedIds.length > columnIndex
          ? _selectedIds[columnIndex]
          : null;

      if (columnIndex > 0) {
        columnWidgets.add(
          Container(
            width: context.w(1),
            height: context.h(300),
            color: CustomColors.border,
            margin: context.appEdgeInsets(horizontal: 12),
          ),
        );
      }

      columnWidgets.add(
        SizedBox(
          width: context.w(220),
          height: context.h(300),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.map((item) {
                final isSelected = activeId == item.id;
                return Container(
                  margin: context.appEdgeInsets(bottom: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? CustomColors.purple.withValues(alpha: 0.1)
                        : Colors.white,
                    borderRadius: context.appBorderRadius(all: 10),
                    border: Border.all(
                      color: isSelected
                          ? CustomColors.purple
                          : CustomColors.border,
                      width: isSelected ? context.w(1.5) : context.w(1),
                    ),
                  ),
                  child: ListTile(
                    dense: true,
                    contentPadding: context.appEdgeInsets(horizontal: 12, vertical: 4),
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
                            size: context.sp(20),
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        if (columnIndex < _selectedIds.length) {
                          _selectedIds.removeRange(
                              columnIndex, _selectedIds.length);
                        }
                        _selectedIds.add(item.id);
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      );
    }

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
            padding: context.appEdgeInsets(horizontal: 16, vertical: 12),
            width: double.infinity,
            decoration: BoxDecoration(
              color: CustomColors.whiteGrey,
              borderRadius: context.appBorderRadius(all: 8),
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
            child: categories.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: columnWidgets,
                      ),
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
        //const Spacer(),
        CustomOutlinedButton(
          onTap: () => Navigator.pop(context),
          label: 'Cancel',
        ),
        SizedBox(width: context.w(12)),
        CustomPrimaryButton(
          onTap: () {
            widget.onConfirmed({
              'path': selectedNames.join(' > '),
              'ids': List<int>.from(_selectedIds),
            });
            Navigator.pop(context);
          },
          label: 'Select Category',
          width: context.w(150),
        ),
      ],
    );
  }
}