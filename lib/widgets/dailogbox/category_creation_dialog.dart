import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../utils/theme.dart';
import '../build_textfield.dart';
import 'standard_dialog.dart';

class CategoryCreationDialog extends StatefulWidget {
  final String? parentName;
  final String? initialName;
  final String? initialIcon;
  final String? initialConsentName;

  const CategoryCreationDialog({
    super.key, 
    this.parentName,
    this.initialName,
    this.initialIcon,
    this.initialConsentName,
  });

  @override
  State<CategoryCreationDialog> createState() => _CategoryCreationDialogState();
}

class _CategoryCreationDialogState extends State<CategoryCreationDialog> {
  late final TextEditingController _nameController;
  late String _selectedIcon;
  PlatformFile? _consentFile;
  String? _existingConsentName;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _selectedIcon = widget.initialIcon ?? "category";
    _existingConsentName = widget.initialConsentName;
  }

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

  Future<void> _pickConsent() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _consentFile = result.files.first;
        _existingConsentName = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StandardDialog(
      title: widget.initialName != null 
          ? "Edit Category" 
          : (widget.parentName == null ? "Create New Category" : "Add Subcategory to ${widget.parentName}"),
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
          context.verticalSpace(24),
          Text("Patient Consent Form (Optional)", style: context.fonts.black14w600),
          context.verticalSpace(12),
          InkWell(
            onTap: _pickConsent,
            child: Container(
              padding: context.appEdgeInsets(all: 16),
              decoration: BoxDecoration(
                color: CustomColors.whiteGrey,
                borderRadius: context.appBorderRadius(all: 12),
                border: Border.all(color: CustomColors.border, style: BorderStyle.solid),
              ),
              child: Row(
                children: [
                  const Icon(Icons.picture_as_pdf_rounded, color: CustomColors.red, size: 24),
                  context.horizontalSpace(16),
                  Expanded(
                    child: Text(
                      _consentFile?.name ?? _existingConsentName ?? "Upload Default PDF",
                      style: (_consentFile != null || _existingConsentName != null) 
                          ? context.fonts.black14w600 
                          : context.fonts.grey14w400,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.cloud_upload_outlined, color: CustomColors.grey, size: 20),
                ],
              ),
            ),
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
                  'consentFile': _consentFile,
                });
              }
            },
            child: Text(widget.initialName != null ? "Update" : "Create"),
          ),
        ),
      ],
    );
  }
}
