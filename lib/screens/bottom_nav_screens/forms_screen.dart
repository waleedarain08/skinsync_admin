<<<<<<< HEAD
import 'dart:io' show File;
=======
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/models/form_model.dart';
import 'package:skinsync_admin/utils/enums.dart';
import 'package:skinsync_admin/utils/string_utils.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/forms_view_model.dart';
import 'package:skinsync_admin/widgets/app_loader.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/widgets/dailogbox/add_form_dialog.dart';
import 'package:skinsync_admin/widgets/dailogbox/standard_dialog.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';
import 'package:skinsync_admin/widgets/pagination_footer.dart';
import 'package:skinsync_admin/widgets/status_toggle_switch.dart';
import 'package:url_launcher/url_launcher.dart';
>>>>>>> 9fb278253e53b676eb6569ea354a6e4b635f2778

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
<<<<<<< HEAD
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forms"),
=======
    final state = ref.watch(formsViewModelProvider);

    return GradientScaffold(
      body: Padding(
        padding: context.appEdgeInsets(horizontal: 28, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            context.verticalSpace(32),
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: CustomColors.purple,
              unselectedLabelColor: CustomColors.grey,
              indicatorColor: CustomColors.purple,
              indicatorWeight: 3,
              labelStyle: context.fonts.black16w600,
              tabs: const [
                Tab(text: 'Consent Forms'),
                Tab(text: 'Compliance Forms'),
              ],
            ),
            context.verticalSpace(24),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildFormsGrid(
                    context,
                    state.consentForms ?? [],
                    'consent',
                    state.loading,
                    state.consentPage,
                    state.consentTotalPages,
                  ),
                  _buildFormsGrid(
                    context,
                    state.complianceForms ?? [],
                    'compliance',
                    state.loading,
                    state.compliancePage,
                    state.complianceTotalPages,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Forms Management', style: context.fonts.level1Heading),
        context.verticalSpace(6),
        Text(
          'Manage and upload legal consent and clinical compliance documentation.',
          style: context.fonts.grey13w500,
        ),
      ],
    );
  }

  Widget _buildFormsGrid(
    BuildContext context,
    List<FormModel> forms,
    String type,
    bool isLoading,
    int currentPage,
    int totalPages,
  ) {
    if (isLoading && forms.isEmpty) {
      return const Center(child: AppLoader());
    }

    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.sizeOf(context).width > 1200 ? 4 : 3,
              crossAxisSpacing: context.w(24),
              mainAxisSpacing: context.w(24),
              // LOWER value = GREATER height. (Change from 1.2 to 0.95)
              childAspectRatio: 0.95,
            ),
            itemCount: forms.length + 1, // +1 for the "Add New" card
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildAddFormCard(context, type);
              }
              return _buildFormCard(context, forms[index - 1], type);
            },
          ),
        ),
        if (totalPages > 1)
          Padding(
            padding: context.appEdgeInsets(top: 24),
            child: PaginationFooter(
              currentPage: currentPage,
              totalPages: totalPages,
              onPageChanged: (page) {
                ref
                    .read(formsViewModelProvider.notifier)
                    .getForms(type, page: page);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildAddFormCard(BuildContext context, String type) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AddFormDialog(type: type),
        );
      },
      borderRadius: context.borderRadius(all: 16),
      child: BorderdContainerWidget(
        padding: context.appEdgeInsets(all: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: context.appEdgeInsets(all: 16),
              decoration: BoxDecoration(
                color: CustomColors.purple.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_rounded,
                color: CustomColors.purple,
                size: 32,
              ),
            ),
            context.verticalSpace(16),
            Text(
              'Add New ${type == 'consent' ? 'Consent' : 'Compliance'}',
              style: context.fonts.purple14w600,
            ),
            context.verticalSpace(4),
            Text('Upload PDF file', style: context.fonts.grey12w400),
          ],
        ),
      ),
    );
  }

  Widget _buildFormCard(BuildContext context, FormModel form, String type) {
    return BorderdContainerWidget(
      enableHover: true,
      padding: context.appEdgeInsets(all: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top Row: PDF Icon + Actions (Edit & Delete)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: context.appEdgeInsets(all: 10),
                decoration: BoxDecoration(
                  color: CustomColors.red.withValues(alpha: 0.1),
                  borderRadius: context.borderRadius(all: 8),
                ),
                child: const Icon(
                  Icons.picture_as_pdf_rounded,
                  color: CustomColors.red,
                  size: 24,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Update / Edit Button
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AddFormDialog(
                          type: type,
                          form: form, // Pass form instance to prefill
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: CustomColors.purple,
                      size: 20,
                    ),
                    tooltip: 'Edit Form',
                  ),
                  // Delete Button
                  IconButton(
                    onPressed: () => _confirmDelete(context, form, type),
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: CustomColors.red,
                      size: 20,
                    ),
                    tooltip: 'Delete Form',
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (form.title ?? 'Untitled Form').capitalize,
                style: context.fonts.black14w600,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              context.verticalSpace(4),
              Text(
                'SKU: ${form.globalSku ?? "N/A"}',
                style: context.fonts.grey11w600,
              ),
              context.verticalSpace(8),
            ],
          ),
          const Spacer(),

          Align(
            alignment: Alignment.centerRight,
            child: StatusToggleSwitch(
              status: form.status?.toLowerCase() ?? 'inactive',
              onChanged: (String newStatusStr) async {
                if (form.id == null) return;

                final newStatus = newStatusStr.toLowerCase() == 'active'
                    ? Status.active
                    : Status.inactive;

                final success = await ref
                    .read(formsViewModelProvider.notifier)
                    .updateFormStatus(form.id!, newStatus);

                if (success) {
                  ref.read(formsViewModelProvider.notifier).getForms(type);
                }
              },
              width: context.w(100),
              height: context.h(32),
            ),
          ),
          const Spacer(),

          TextButton.icon(
            onPressed: () {
              if (form.url != null && form.url!.isNotEmpty) {
                launchUrl(Uri.parse(form.url!));
              }
            },
            icon: const Icon(Icons.visibility_outlined, size: 16),
            label: const Text('View PDF'),
            style: TextButton.styleFrom(
              foregroundColor: CustomColors.purple,
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    FormModel form,
    String type,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => StandardDialog(
        title: 'Delete Form',
        width: context.w(400),
        content: Text(
          "Are you sure you want to delete '${form.title}'?",
          style: context.fonts.grey14w400,
        ),
>>>>>>> 9fb278253e53b676eb6569ea354a6e4b635f2778
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
