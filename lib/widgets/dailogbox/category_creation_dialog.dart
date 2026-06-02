import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../../utils/theme.dart';
import '../build_textfield.dart';
import 'standard_dialog.dart';

class CategoryCreationDialog extends StatefulWidget {
  final String? parentName;
  const CategoryCreationDialog({super.key, this.parentName});

  @override
  State<CategoryCreationDialog> createState() => _CategoryCreationDialogState();
}

class _CategoryCreationDialogState extends State<CategoryCreationDialog> {
  final _nameController = TextEditingController();
  String _selectedIcon = "category"; // Default icon

  final List<Map<String, dynamic>> _icons = [
    {'name': 'Category', 'icon': Icons.category_outlined},
    {'name': 'Spa', 'icon': Icons.spa_outlined},
    {'name': 'Cut', 'icon': Icons.content_cut_rounded},
    {'name': 'Face', 'icon': Icons.face_retouching_natural_rounded},
    {'name': 'Medical', 'icon': Icons.medical_services_outlined},
    {'name': 'Wash', 'icon': Icons.dry_cleaning_outlined},
    {'name': 'Skin', 'icon': Icons.clean_hands_outlined},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StandardDialog(
      title: widget.parentName == null 
          ? "Create New Category" 
          : "Add Subcategory to ${widget.parentName}",
      width: context.w(480),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BuildTextField(
            label: "Category Name",
            controller: _nameController,
            hintText: "e.g. Skin Rejuvenation",
          ),
          context.verticalSpace(24),
          Text("Select Category Icon", style: context.fonts.black14w600),
          context.verticalSpace(12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _icons.map((item) {
              final isSelected = _selectedIcon == item['name'].toLowerCase();
              return InkWell(
                onTap: () => setState(() => _selectedIcon = item['name'].toLowerCase()),
                borderRadius: context.appBorderRadius(all: 10),
                child: Container(
                  width: context.w(54),
                  height: context.w(54),
                  decoration: BoxDecoration(
                    color: isSelected ? CustomColors.purple : CustomColors.softGrey,
                    borderRadius: context.appBorderRadius(all: 10),
                    border: Border.all(
                      color: isSelected ? CustomColors.purple : CustomColors.border,
                    ),
                  ),
                  child: Icon(
                    item['icon'],
                    color: isSelected ? Colors.white : CustomColors.grey,
                    size: context.sp(24),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        SizedBox(
          width: context.w(120),
          child: ElevatedButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty) {
                Navigator.pop(context, {
                  'name': _nameController.text,
                  'icon': _selectedIcon,
                });
              }
            },
            child: const Text("Create"),
          ),
        ),
      ],
    );
  }
}
