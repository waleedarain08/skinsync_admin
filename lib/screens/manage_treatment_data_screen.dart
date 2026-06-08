import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/treatment_data_models.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/treatment_data_view_model.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/widgets/dailogbox/category_creation_dialog.dart';
import 'package:skinsync_admin/widgets/dailogbox/standard_dialog.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';

class ManageTreatmentDataScreen extends ConsumerWidget {
  const ManageTreatmentDataScreen({super.key});

  static const String routeName = '/manage-treatment-data';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(treatmentDataViewModelProvider);
    final viewModel = ref.read(treatmentDataViewModelProvider.notifier);

    return DefaultTabController(
      length: 3,
      child: GradientScaffold(
        appBar: AppBar(
          flexibleSpace: AppDecorations.appBarGradient,
          elevation: 0,
          title: Text("Manage Network Taxonomy", style: context.fonts.black20w600),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: CustomColors.black),
            onPressed: () => context.pop(),
          ),
          bottom: TabBar(
            labelColor: CustomColors.purple,
            unselectedLabelColor: CustomColors.grey,
            indicatorColor: CustomColors.purple,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: "Categories"),
              Tab(text: "Body Areas"),
              Tab(text: "Protocols"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildCategoriesTab(context, state, viewModel),
            _buildAreasTab(context, state, viewModel),
            _buildProtocolsTab(context, state, viewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesTab(BuildContext context, TreatmentDataState state, TreatmentDataViewModel viewModel) {
    return SingleChildScrollView(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTabHeader(
            context: context,
            title: "Treatment Categories",
            onAdd: () => _showCategoryCreationDialog(
              context: context,
              onConfirm: (name, icon, consentFile, sessions, preNotif, postNotif, downtime, roles) => viewModel.addCategory(
                name, 
                icon: icon, 
                consentFormName: consentFile?.name, 
                consentFormUrl: consentFile?.path,
                defaultSessions: sessions,
                preNotification: preNotif,
                postNotification: postNotif,
                downtimePresets: downtime,
                defaultRoles: roles,
              ),
            ),
          ),
          context.verticalSpace(24),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.categories.length,
            separatorBuilder: (context, index) => context.verticalSpace(16),
            itemBuilder: (context, index) {
              return _RecursiveCategoryTile(
                category: state.categories[index],
                viewModel: viewModel,
                level: 0,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAreasTab(BuildContext context, TreatmentDataState state, TreatmentDataViewModel viewModel) {
    return SingleChildScrollView(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTabHeader(
            context: context,
            title: "Anatomical Body Areas",
            onAdd: () => _showItemDialog(
              context: context,
              title: "Add New Area",
              onConfirm: (name, icon) => viewModel.addArea(name, icon: icon),
            ),
          ),
          context.verticalSpace(24),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.areas.length,
            separatorBuilder: (context, index) => context.verticalSpace(16),
            itemBuilder: (context, index) {
              final area = state.areas[index];
              return _buildHierarchicalItem(
                context: context,
                name: area.name,
                icon: area.icon,
                childrenCount: area.subAreas.length,
                children: area.subAreas.map((s) => _ChildItemData(name: s.name, icon: s.icon)).toList(),
                onEdit: (name, icon) => viewModel.editArea(area.name, name, icon: icon),
                onDelete: () => viewModel.deleteArea(area.name),
                onAddChild: (name, icon) => viewModel.addSubArea(area.name, name, icon: icon),
                onEditChild: (old, name, icon) => viewModel.editSubArea(area.name, old, name, icon: icon),
                onDeleteChild: (name) => viewModel.deleteSubArea(area.name, name),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProtocolsTab(BuildContext context, TreatmentDataState state, TreatmentDataViewModel viewModel) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: Colors.white.withValues(alpha: 0.5),
            child: TabBar(
              labelColor: CustomColors.purple,
              unselectedLabelColor: CustomColors.grey,
              indicatorColor: CustomColors.purple,
              tabs: const [
                Tab(text: "Checkboxes"),
                Tab(text: "Text Fields"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildProtocolList(context, state, viewModel, ProtocolType.checkbox),
                _buildProtocolList(context, state, viewModel, ProtocolType.text),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProtocolList(BuildContext context, TreatmentDataState state, TreatmentDataViewModel viewModel, ProtocolType type) {
    final filteredProtocols = state.protocols.where((p) => p.type == type).toList();
    final title = type == ProtocolType.checkbox ? "Checkbox Protocols" : "Text Field Protocols";

    return SingleChildScrollView(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTabHeader(
            context: context,
            title: title,
            onAdd: () => _showProtocolDialog(
              context: context,
              title: "Add ${type == ProtocolType.checkbox ? 'Checkbox' : 'Text'} Protocol",
              onConfirm: (val) => viewModel.addProtocol(val, type),
            ),
          ),
          context.verticalSpace(24),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredProtocols.length,
            separatorBuilder: (context, index) => context.verticalSpace(12),
            itemBuilder: (context, index) {
              final protocol = filteredProtocols[index];
              return BorderdContainerWidget(
                padding: context.appEdgeInsets(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    Icon(
                      type == ProtocolType.checkbox ? Icons.check_box_outlined : Icons.text_fields_rounded,
                      color: CustomColors.purple,
                      size: 20,
                    ),
                    context.horizontalSpace(16),
                    Expanded(
                      child: Text(protocol.title, style: context.fonts.black14w600),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      onPressed: () => _showProtocolDialog(
                        context: context,
                        title: "Edit Protocol",
                        initialValue: protocol.title,
                        onConfirm: (val) => viewModel.editProtocol(protocol.id, val),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20, color: CustomColors.red),
                      onPressed: () => _showDeleteConfirm(context, protocol.title, () => viewModel.deleteProtocol(protocol.id)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabHeader({required BuildContext context, required String title, required VoidCallback onAdd}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: context.fonts.black18w600),
        CustomPrimaryButton(
          onTap: onAdd,
          icon: Icons.add,
          label: "Add New",
          width: context.w(140),
        ),
      ],
    );
  }

  Widget _buildHierarchicalItem({
    required BuildContext context,
    required String name,
    String? icon,
    required int childrenCount,
    required List<_ChildItemData> children,
    required Function(String, String?) onEdit,
    required VoidCallback onDelete,
    required Function(String, String?) onAddChild,
    required Function(String, String, String?) onEditChild,
    required Function(String) onDeleteChild,
  }) {
    return BorderdContainerWidget(
      padding: EdgeInsets.zero,
      child: ExpansionTile(
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        leading: Container(
          width: context.w(40),
          height: context.w(40),
          decoration: BoxDecoration(color: CustomColors.whiteGrey, borderRadius: context.borderRadius(all: 8)),
          child: icon != null 
              ? Image.network(icon, errorBuilder: (context, error, stackTrace) => const Icon(Icons.category_outlined)) 
              : const Icon(Icons.category_outlined, color: CustomColors.purple),
        ),
        title: Text(name, style: context.fonts.black16w600),
        subtitle: Text("$childrenCount sub-items", style: context.fonts.grey12w400),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              onPressed: () => ManageTreatmentDataScreen._showItemDialog(
                context: context,
                title: "Edit Item",
                initialName: name,
                initialIcon: icon,
                onConfirm: onEdit,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20, color: CustomColors.red),
              onPressed: () => ManageTreatmentDataScreen._showDeleteConfirm(context, name, onDelete),
            ),
            const Icon(Icons.expand_more),
          ],
        ),
        children: [
          Padding(
            padding: context.appEdgeInsets(all: 16),
            child: Column(
              children: [
                ...children.map((child) => ListTile(
                  dense: true,
                  leading: Container(
                    width: context.w(32),
                    height: context.w(32),
                    decoration: BoxDecoration(color: CustomColors.whiteGrey, borderRadius: context.borderRadius(all: 6)),
                    child: child.icon != null 
                        ? Image.network(child.icon!, errorBuilder: (context, error, stackTrace) => const Icon(Icons.subdirectory_arrow_right, size: 16))
                        : const Icon(Icons.subdirectory_arrow_right, size: 16, color: CustomColors.grey),
                  ),
                  title: Text(child.name, style: context.fonts.black14w400),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        onPressed: () => ManageTreatmentDataScreen._showItemDialog(
                          context: context,
                          title: "Edit Sub-item",
                          initialName: child.name,
                          initialIcon: child.icon,
                          onConfirm: (newName, newIcon) => onEditChild(child.name, newName, newIcon),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18, color: CustomColors.red),
                        onPressed: () => onDeleteChild(child.name),
                      ),
                    ],
                  ),
                )),
                context.verticalSpace(8),
                TextButton.icon(
                  onPressed: () => ManageTreatmentDataScreen._showItemDialog(
                    context: context,
                    title: "Add Sub-item",
                    onConfirm: onAddChild,
                  ),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text("Add Sub-item"),
                  style: TextButton.styleFrom(foregroundColor: CustomColors.purple),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static void _showCategoryCreationDialog({
    required BuildContext context,
    String? parentName,
    String? initialName,
    String? initialIcon,
    String? initialConsentName,
    List<FollowUpConfig>? initialFollowUps,
    List<SessionConfig>? initialSessions,
    int? initialTotalSessions,
    NotificationConfig? initialPreNotification,
    NotificationConfig? initialPostNotification,
    DowntimePresets? initialDowntimePresets,
    List<String>? initialDefaultRoles,
    required Function(String, String, PlatformFile?, List<SessionConfig>?, NotificationConfig?, NotificationConfig?, DowntimePresets?, List<String>?) onConfirm,
  }) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => CategoryCreationDialog(
        parentName: parentName,
        initialName: initialName,
        initialIcon: initialIcon,
        initialConsentName: initialConsentName,
        initialFollowUps: initialFollowUps,
        initialSessions: initialSessions,
        initialTotalSessions: initialTotalSessions,
        initialPreNotification: initialPreNotification,
        initialPostNotification: initialPostNotification,
        initialDowntimePresets: initialDowntimePresets,
        initialDefaultRoles: initialDefaultRoles,
      ),
    );

    if (result != null) {
      onConfirm(
        result['name'], 
        result['icon'], 
        result['consentFile'], 
        result['sessions'],
        result['preNotification'],
        result['postNotification'],
        result['downtimePresets'],
        result['defaultRoles'],
      );
    }
  }

  static void _showItemDialog({
    required BuildContext context,
    required String title,
    String? initialName,
    String? initialIcon,
    bool showIconField = true,
    required Function(String, String?) onConfirm,
  }) {
    final nameController = TextEditingController(text: initialName);
    final iconController = TextEditingController(text: initialIcon);

    showDialog(
      context: context,
      builder: (context) => StandardDialog(
        title: title,
        width: context.w(450),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BuildTextField(
              label: "Name",
              controller: nameController,
              hintText: "Enter name...",
            ),
            if (showIconField) ...[
              context.verticalSpace(20),
              BuildTextField(
                label: "Icon URL (Optional)",
                controller: iconController,
                hintText: "https://...",
              ),
            ],
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          CustomPrimaryButton(
            onTap: () {
              if (nameController.text.trim().isNotEmpty) {
                onConfirm(nameController.text.trim(), iconController.text.trim().isEmpty ? null : iconController.text.trim());
                Navigator.pop(context);
              }
            },
            label: "Confirm",
            width: context.w(120),
          ),
        ],
      ),
    );
  }

  static void _showProtocolDialog({
    required BuildContext context,
    required String title,
    String? initialValue,
    required Function(String) onConfirm,
  }) {
    final controller = TextEditingController(text: initialValue);

    showDialog(
      context: context,
      builder: (context) => StandardDialog(
        title: title,
        width: context.w(450),
        content: BuildTextField(
          label: "Protocol Title",
          controller: controller,
          hintText: "Enter protocol title...",
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          CustomPrimaryButton(
            onTap: () {
              if (controller.text.trim().isNotEmpty) {
                onConfirm(controller.text.trim());
                Navigator.pop(context);
              }
            },
            label: "Confirm",
            width: context.w(120),
          ),
        ],
      ),
    );
  }

  static void _showDeleteConfirm(BuildContext context, String name, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => StandardDialog(
        title: "Confirm Delete",
        width: context.w(400),
        content: Text("Are you sure you want to delete '$name'? This action is irreversible. All child sub-items will also be removed.", style: context.fonts.black14w400),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          CustomPrimaryButton(
            onTap: () {
              onConfirm();
              Navigator.pop(context);
            },
            label: "Delete",
            width: context.w(120),
          ),
        ],
      ),
    );
  }
}

class _RecursiveCategoryTile extends StatelessWidget {
  final CategoryItem category;
  final TreatmentDataViewModel viewModel;
  final int level;

  const _RecursiveCategoryTile({
    required this.category,
    required this.viewModel,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return BorderdContainerWidget(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.only(left: level * 24.w),
      child: ExpansionTile(
        initiallyExpanded: level == 0,
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        leading: Container(
          width: context.w(40),
          height: context.w(40),
          decoration: BoxDecoration(
            color: CustomColors.whiteGrey,
            borderRadius: context.borderRadius(all: 8),
          ),
          child: category.icon != null 
              ? Image.network(category.icon!, errorBuilder: (context, error, stackTrace) => const Icon(Icons.category_outlined))
              : const Icon(Icons.category_outlined, color: CustomColors.purple),
        ),
        title: Text(category.name, style: context.fonts.black16w600),
        subtitle: Text("${category.children.length} sub-categories", style: context.fonts.grey12w400),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: "Add Child Category",
              icon: const Icon(Icons.add_circle_outline, size: 20, color: CustomColors.green),
              onPressed: () => ManageTreatmentDataScreen._showCategoryCreationDialog(
                context: context,
                parentName: category.name,
                onConfirm: (name, icon, consentFile, sessions, preNotif, postNotif, downtime, roles) => viewModel.addCategory(
                  name, 
                  icon: icon, 
                  parentId: category.id,
                  consentFormName: consentFile?.name,
                  consentFormUrl: consentFile?.path,
                  defaultSessions: sessions,
                  preNotification: preNotif,
                  postNotification: postNotif,
                  downtimePresets: downtime,
                  defaultRoles: roles,
                ),
              ),
            ),
            IconButton(
              tooltip: "Edit Category",
              icon: const Icon(Icons.edit_outlined, size: 20),
              onPressed: () => ManageTreatmentDataScreen._showCategoryCreationDialog(
                context: context,
                initialName: category.name,
                initialIcon: category.icon,
                initialConsentName: category.consentFormName,
                initialFollowUps: category.defaultFollowUps,
                initialSessions: category.defaultSessions,
                initialTotalSessions: category.totalSessions,
                initialPreNotification: category.preNotification,
                initialPostNotification: category.postNotification,
                initialDowntimePresets: category.downtimePresets,
                initialDefaultRoles: category.defaultRoles,
                onConfirm: (name, icon, consentFile, sessions, preNotif, postNotif, downtime, roles) => viewModel.editCategory(
                  category.id, 
                  name, 
                  icon: icon,
                  consentFormName: consentFile?.name ?? category.consentFormName,
                  consentFormUrl: consentFile?.path ?? category.consentFormUrl,
                  defaultSessions: sessions ?? category.defaultSessions,
                  totalSessions: sessions?.length,
                  preNotification: preNotif ?? category.preNotification,
                  postNotification: postNotif ?? category.postNotification,
                  downtimePresets: downtime ?? category.downtimePresets,
                  defaultRoles: roles ?? category.defaultRoles,
                ),
              ),
            ),
            IconButton(
              tooltip: "Delete Category",
              icon: const Icon(Icons.delete_outline, size: 20, color: CustomColors.red),
              onPressed: () => ManageTreatmentDataScreen._showDeleteConfirm(
                context, 
                category.name, 
                () => viewModel.deleteCategory(category.id)
              ),
            ),
            if (category.children.isNotEmpty) const Icon(Icons.expand_more),
          ],
        ),
        children: category.children.map((child) => _RecursiveCategoryTile(
          category: child,
          viewModel: viewModel,
          level: level + 1,
        )).toList(),
      ),
    );
  }
}

class _ChildItemData {
  final String name;
  final String? icon;
  _ChildItemData({required this.name, this.icon});
}
