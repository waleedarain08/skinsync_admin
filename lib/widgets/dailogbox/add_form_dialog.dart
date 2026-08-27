import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/utils/validators.dart';
import 'package:skinsync_admin/view_models/forms_view_model.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'package:skinsync_admin/widgets/dailogbox/standard_dialog.dart';

class AddFormDialog extends StatefulWidget {
  final String type; // 'consent' or 'compliance'
  const AddFormDialog({super.key, required this.type});

  @override
  State<AddFormDialog> createState() => _AddFormDialogState();
}

class _AddFormDialogState extends State<AddFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  PlatformFile? _selectedFile;

  Future<void> _pickFile() async {
    final result = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = result;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StandardDialog(
      title: 'Add New ${widget.type == 'consent' ? 'Consent' : 'Compliance'} Form',
      width: context.w(500),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildTextField(
              label: 'Form Title',
              controller: _titleController,
              hintText: 'e.g. Standard Laser Consent',
              validator: Validators.empty,
            ),
            context.verticalSpace(24),
            Text('Form File (PDF)', style: context.fonts.black14w600),
            context.verticalSpace(8),
            InkWell(
              onTap: _pickFile,
              child: Container(
                padding: context.appEdgeInsets(all: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.border),
                  borderRadius: context.borderRadius(all: 12),
                  color: CustomColors.grey.withValues(alpha: 0.05),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.picture_as_pdf_rounded, color: CustomColors.red),
                    context.horizontalSpace(12),
                    Expanded(
                      child: Text(
                        _selectedFile?.name ?? 'Click to select PDF file',
                        style: _selectedFile != null
                            ? context.fonts.black14w600
                            : context.fonts.grey14w400,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (_selectedFile != null)
                      const Icon(Icons.check_circle_rounded, color: CustomColors.green),
                  ],
                ),
              ),
            ),
            if (_selectedFile == null) ...[
              context.verticalSpace(4),
              Text(
                'Please select a PDF file',
                style: context.fonts.red11w600,
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: const Text('Cancel'),
        ),
        Consumer(
          builder: (context, ref, _) {
            final state = ref.watch(formsViewModelProvider);
            return CustomPrimaryButton(
              onTap: () async {
                if (_formKey.currentState!.validate() && _selectedFile != null) {
                  final success = await ref
                      .read(formsViewModelProvider.notifier)
                      .uploadAndCreateForm(
                        title: _titleController.text,
                        type: widget.type,
                        file: _selectedFile!,
                      );
                  if (success && context.mounted) {
                    context.pop();
                  }
                }
              },
              label: 'Upload Form',
              isLoading: state.loading,
              width: context.w(150),
            );
          },
        ),
      ],
    );
  }
}
