import 'dart:io' show File;

import 'package:camera/camera.dart' show XFile;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:skinsync_admin/models/form_template.dart';
import 'package:skinsync_admin/screens/form_builder/form_builder_screen.dart';
import 'package:skinsync_admin/view_models/forms_controller.dart';

import '../../services/locator.dart';
import '../../utils/theme.dart';

class FormsScreen extends StatefulWidget {
  static const String routeName = '/forms';
  const FormsScreen({super.key});

  @override
  State<FormsScreen> createState() => _FormsScreenState();
}

class _FormsScreenState extends State<FormsScreen> {
  final FormsController _controller = locator<FormsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forms"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: _controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _controller.forms.isEmpty
          ? _buildEmptyState()
          : _buildFormsList(),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.description_outlined,
            size: 80,
            color: CustomColors.lightGrey,
          ),
          SizedBox(height: 16.h),
          Text("No forms yet", style: CustomFonts.grey14w500),
          SizedBox(height: 8.h),
          Text(
            "Create a new form or upload a PDF",
            style: CustomFonts.grey12w400,
          ),
        ],
      ),
    );
  }

  Widget _buildFormsList() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: _controller.forms.length,
      itemBuilder: (context, index) {
        final form = _controller.forms[index];
        return _buildFormCard(form);
      },
    );
  }

  Widget _buildFormCard(FormTemplate form) {
    bool exists = true;
    if (!kIsWeb) {
      exists = File(form.filePath).existsSync();
    }

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: ListTile(
        leading: Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: CustomColors.lightPurple,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            exists ? Icons.picture_as_pdf : Icons.file_present,
            color: CustomColors.purple,
          ),
        ),
        title: Text(
          form.name,
          style: CustomFonts.black14w600,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          DateFormat('MMM dd, yyyy').format(form.createdAt),
          style: CustomFonts.grey12w400,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!exists)
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 20,
              ),
            PopupMenuButton<String>(
              onSelected: (value) => _handleMenuAction(value, form),
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'open', child: Text("Open")),
                const PopupMenuItem(value: 'fill', child: Text("Fill Out")),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text("Delete", style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
        ),
        onTap: () => _openPdf(form),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _createNewForm,
              icon: const Icon(Icons.add),
              label: const Text("Create New Form"),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _uploadPdf,
              icon: const Icon(Icons.upload_file),
              label: const Text("Upload PDF"),
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String action, FormTemplate form) {
    switch (action) {
      case 'open':
        _openPdf(form);
        break;
      case 'fill':
        _fillForm(form);
        break;
      case 'delete':
        _confirmDelete(form);
        break;
    }
  }

  Future<void> _openPdf(FormTemplate form) async {
    if (form.templateJson != null) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FormBuilderScreen(initialForm: form),
        ),
      );
      if (result == true) setState(() {});
      return;
    }

    if (kIsWeb) {
      _showError(
        "Opening existing PDFs from storage is limited on Web. Please download them on Mobile/Desktop.",
      );
      return;
    }

    final file = File(form.filePath);
    if (!await file.exists()) {
      _showError("File not found on disk.");
      return;
    }

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text(form.name)),
          body: PdfPreview(
            build: (format) => file.readAsBytesSync(),
            allowPrinting: true,
            allowSharing: true,
          ),
        ),
      ),
    );
  }

  void _fillForm(FormTemplate form) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Fill-out mode coming soon")));
    _openPdf(form);
  }

  void _confirmDelete(FormTemplate form) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Form"),
        content: Text(
          "Are you sure you want to delete '${form.name}'? This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await _controller.deleteForm(form.id);
              if (mounted) {
                Navigator.pop(context);
                setState(() {});
              }
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _createNewForm() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FormBuilderScreen()),
    );

    if (result == true) {
      setState(() {});
    }
  }

  Future<void> _uploadPdf() async {
    try {
      final result = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        XFile pickedFile;
        if (kIsWeb) {
          final bytes = await result.readAsBytes();
          pickedFile = XFile.fromData(bytes, name: result.name);
        } else {
          if (result.path == null) return;
          pickedFile = XFile(result.path!);
          final size = await File(pickedFile.path).length();
          if (size > 50 * 1024 * 1024) {
            _showError("File too large (> 50MB)");
            return;
          }
        }

        if (!mounted) return;
        final baseName = result.name.replaceAll('.pdf', '');
        final nameController = TextEditingController(
          text: _controller.getUniqueName(baseName),
        );

        final name = await showDialog<String>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Confirm Form Name"),
            content: TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Form Name"),
              autofocus: true,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, nameController.text),
                child: const Text("Save"),
              ),
            ],
          ),
        );

        if (name != null && name.isNotEmpty) {
          await _controller.uploadPdf(pickedFile, name);
          setState(() {});
        }
      }
    } catch (e) {
      _showError("Failed to upload PDF: $e");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
