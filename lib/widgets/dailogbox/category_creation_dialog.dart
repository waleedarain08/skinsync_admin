import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../models/treatment_data_models.dart';
import '../../utils/theme.dart';
import '../build_textfield.dart';
import '../custom_dropdown_widget.dart';
import 'standard_dialog.dart';

class CategoryCreationDialog extends StatefulWidget {
  final String? parentName;
  final String? initialName;
  final String? initialIcon;
  final String? initialConsentName;
  final List<FollowUpConfig>? initialFollowUps;

  const CategoryCreationDialog({
    super.key, 
    this.parentName,
    this.initialName,
    this.initialIcon,
    this.initialConsentName,
    this.initialFollowUps,
  });

  @override
  State<CategoryCreationDialog> createState() => _CategoryCreationDialogState();
}

class _CategoryCreationDialogState extends State<CategoryCreationDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _totalFollowUpsController;
  late String _selectedIcon;
  PlatformFile? _consentFile;
  String? _existingConsentName;
  List<FollowUpConfig> _followUps = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _selectedIcon = widget.initialIcon ?? "category";
    _existingConsentName = widget.initialConsentName;
    _followUps = widget.initialFollowUps != null 
        ? List.from(widget.initialFollowUps!) 
        : [];
    _totalFollowUpsController = TextEditingController(
      text: _followUps.isEmpty ? "" : _followUps.length.toString()
    );
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
    _totalFollowUpsController.dispose();
    super.dispose();
  }

  void _updateFollowUpCount(String val) {
    final count = int.tryParse(val) ?? 0;
    setState(() {
      if (count > _followUps.length) {
        for (int i = _followUps.length; i < count; i++) {
          _followUps.add(FollowUpConfig(type: 'virtual'));
        }
      } else if (count < _followUps.length) {
        _followUps = _followUps.sublist(0, count);
      }
    });
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
      width: context.w(600),
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
            const Divider(),
            context.verticalSpace(24),
            Text("Default Patient Consent Form (Optional)", style: context.fonts.black16w600),
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
            context.verticalSpace(32),
            const Divider(),
            context.verticalSpace(24),
            Text("Default Follow-Up Journey", style: context.fonts.black16w600),
            context.verticalSpace(8),
            Text("Define the default follow-up sequence for treatments in this category.", style: context.fonts.grey12w400),
            context.verticalSpace(20),
            BuildTextField(
              label: "Total Follow-Ups",
              controller: _totalFollowUpsController,
              hintText: "0",
              keyboardType: TextInputType.number,
              onChanged: (val) => _updateFollowUpCount(val ?? ""),
            ),
            if (_followUps.isNotEmpty) ...[
              context.verticalSpace(24),
              ...List.generate(_followUps.length, (index) {
                return Padding(
                  padding: context.appEdgeInsets(bottom: 16),
                  child: _buildFollowUpCard(index),
                );
              }),
            ],
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
                  'followUps': _followUps,
                });
              }
            },
            child: Text(widget.initialName != null ? "Update" : "Create"),
          ),
        ),
      ],
    );
  }

  Widget _buildFollowUpCard(int index) {
    final config = _followUps[index];
    final intervalController = TextEditingController(text: config.intervalValue?.toString() ?? "");
    final durationController = TextEditingController(text: config.durationValue?.toString() ?? "");

    return Container(
      padding: context.appEdgeInsets(all: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: context.appBorderRadius(all: 12),
        border: Border.all(color: CustomColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Follow-Up ${index + 1}", style: context.fonts.purple12w700),
          context.verticalSpace(12),
          Row(
            children: [
              Expanded(
                child: CustomDropdown<String>(
                  label: "Type",
                  hintText: "Select",
                  value: config.type,
                  items: const [
                    DropdownMenuItem(value: 'virtual', child: Text("Virtual")),
                    DropdownMenuItem(value: 'in_person', child: Text("In-Person")),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => config.type = val);
                  },
                ),
              ),
              context.horizontalSpace(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Duration", style: context.fonts.black14w600),
                    context.verticalSpace(8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: durationController,
                            keyboardType: TextInputType.number,
                            decoration: AppDecorations.input(context, hint: "30"),
                            onChanged: (v) => config.durationValue = int.tryParse(v),
                          ),
                        ),
                        context.horizontalSpace(4),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: config.durationUnit,
                              isExpanded: true,
                              items: const [
                                DropdownMenuItem(value: 'minutes', child: Text("m")),
                                DropdownMenuItem(value: 'hours', child: Text("h")),
                              ],
                              onChanged: (v) {
                                if (v != null) setState(() => config.durationUnit = v);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          context.verticalSpace(12),
          Text("Interval (After Procedure)", style: context.fonts.black14w600),
          context.verticalSpace(8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: intervalController,
                  keyboardType: TextInputType.number,
                  decoration: AppDecorations.input(context, hint: "1"),
                  onChanged: (v) => config.intervalValue = int.tryParse(v),
                ),
              ),
              context.horizontalSpace(12),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: config.intervalUnit,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: 'days', child: Text("Days")),
                      DropdownMenuItem(value: 'weeks', child: Text("Weeks")),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => config.intervalUnit = v);
                    },
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
