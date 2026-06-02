import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:skinsync_admin/models/treatment_data_models.dart';
import 'package:skinsync_admin/utils/theme.dart';

class NestedCategorySelector extends StatefulWidget {
  final List<CategoryItem> categories;
  final String? initialCategoryId;
  final Function(CategoryItem selected, String path) onSelected;

  const NestedCategorySelector({
    super.key,
    required this.categories,
    this.initialCategoryId,
    required this.onSelected,
  });

  @override
  State<NestedCategorySelector> createState() => _NestedCategorySelectorState();
}

class _NestedCategorySelectorState extends State<NestedCategorySelector> {
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.initialCategoryId;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.h(600),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: context.borderRadius(topRight: 24, topLeft: 24),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView.builder(
              padding: context.appEdgeInsets(all: 20),
              itemCount: widget.categories.length,
              itemBuilder: (context, index) {
                return _buildRecursiveCategory(widget.categories[index], "", 0);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: context.appEdgeInsets(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: CustomColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Select Treatment Category", style: CustomFonts.black18w600),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  Widget _buildRecursiveCategory(CategoryItem category, String parentPath, int level) {
    final bool isSelected = _selectedId == category.id;
    final String currentPath = parentPath.isEmpty ? category.name : "$parentPath > ${category.name}";
    final bool hasChildren = category.children.isNotEmpty;

    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() => _selectedId = category.id);
            widget.onSelected(category, currentPath);
            Navigator.pop(context);
          },
          child: Padding(
            padding: context.appEdgeInsets(vertical: 8),
            child: Row(
              children: [
                context.horizontalSpace(level * 24),
                if (hasChildren)
                  const Icon(Icons.subdirectory_arrow_right, size: 16, color: CustomColors.grey)
                else
                  const Icon(Icons.circle, size: 8, color: CustomColors.purple),
                context.horizontalSpace(12),
                Expanded(
                  child: Text(
                    category.name,
                    style: isSelected ? CustomFonts.purple14w600 : CustomFonts.black14w400,
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check_circle, color: CustomColors.green, size: 20),
              ],
            ),
          ),
        ),
        if (hasChildren)
          ...category.children.map((child) => _buildRecursiveCategory(child, currentPath, level + 1)),
      ],
    );
  }
}
