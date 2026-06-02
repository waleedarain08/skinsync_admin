import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/treatment_data_models.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/treatment_data_view_model.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';
import 'package:skinsync_admin/widgets/app_search_field.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
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
      length: 4,
      child: GradientScaffold(
        appBar: AppBar(
          flexibleSpace: AppDecorations.appBarGradient,
          elevation: 0,
          title: Text("Manage Network Taxonomy", style: CustomFonts.black20w600),
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
              Tab(text: "Materials"),
              Tab(text: "Combinations"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildCategoriesTab(context, state, viewModel),
            _buildAreasTab(context, state, viewModel),
            _buildMaterialsTab(context, state, viewModel),
            _buildCombinationsTab(context, state, viewModel, ref),
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
            title: "Treatment Categories",
            onAdd: () => _showItemDialog(
              context: context,
              title: "Add Root Category",
              onConfirm: (name, icon) => viewModel.addCategory(name, icon: icon),
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

  Widget _buildMaterialsTab(BuildContext context, TreatmentDataState state, TreatmentDataViewModel viewModel) {
    return SingleChildScrollView(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTabHeader(
            title: "Consumable Materials",
            onAdd: () => _showItemDialog(
              context: context,
              title: "Add New Material",
              showIconField: false,
              onConfirm: (name, _) => viewModel.addMaterial(name),
            ),
          ),
          context.verticalSpace(24),
          Wrap(
            spacing: context.w(12),
            runSpacing: context.h(12),
            children: state.materials.map((item) => Chip(
              label: Text(item),
              onDeleted: () => _showDeleteConfirm(context, item, () => viewModel.deleteMaterial(item)),
              deleteIcon: const Icon(Icons.close, size: 16),
              labelStyle: CustomFonts.purple14w600,
              backgroundColor: CustomColors.purple.withValues(alpha: 0.05),
              side: BorderSide(color: CustomColors.purple.withValues(alpha: 0.1)),
              shape: RoundedRectangleBorder(borderRadius: context.borderRadius(all: 8)),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCombinationsTab(BuildContext context, TreatmentDataState state, TreatmentDataViewModel viewModel, WidgetRef ref) {
    return SingleChildScrollView(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTabHeader(
            title: "Treatment Combination Groups",
            onAdd: () => _showCombinationDialog(
              context: context,
              ref: ref,
              title: "Create Combination Group",
              onConfirm: (name, treatments) => viewModel.addCombinationGroup(name, treatments),
            ),
          ),
          context.verticalSpace(24),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.combinationGroups.length,
            separatorBuilder: (context, index) => context.verticalSpace(16),
            itemBuilder: (context, index) {
              final group = state.combinationGroups[index];
              return BorderdContainerWidget(
                padding: EdgeInsets.zero,
                child: ExpansionTile(
                  shape: const RoundedRectangleBorder(side: BorderSide.none),
                  leading: Container(
                    width: context.w(40),
                    height: context.w(40),
                    decoration: BoxDecoration(
                      color: CustomColors.purple.withValues(alpha: 0.1),
                      borderRadius: context.borderRadius(all: 8),
                    ),
                    child: const Icon(Icons.auto_awesome_motion_rounded, color: CustomColors.purple),
                  ),
                  title: Text(group.name, style: CustomFonts.black16w600),
                  subtitle: Text("${group.treatmentNames.length} combined treatments", style: CustomFonts.grey12w400),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 20),
                        onPressed: () => _showCombinationDialog(
                          context: context,
                          ref: ref,
                          title: "Edit Combination Group",
                          initialName: group.name,
                          initialTreatments: group.treatmentNames,
                          onConfirm: (name, treatments) => viewModel.editCombinationGroup(group.id, name, treatments),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 20, color: CustomColors.red),
                        onPressed: () => _showDeleteConfirm(context, group.name, () => viewModel.deleteCombinationGroup(group.id)),
                      ),
                      const Icon(Icons.expand_more),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: context.appEdgeInsets(all: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: context.w(12),
                            runSpacing: context.h(12),
                            children: group.treatmentNames.map((t) => Chip(
                              label: Text(t),
                              backgroundColor: CustomColors.whiteGrey,
                              side: BorderSide(color: Colors.grey[200]!),
                              labelStyle: CustomFonts.black12w600,
                            )).toList(),
                          ),
                          context.verticalSpace(8),
                        ],
                      ),
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

  Widget _buildTabHeader({required String title, required VoidCallback onAdd}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: CustomFonts.black18w600),
        CustomPrimaryButton(
          onTap: onAdd,
          icon: Icons.add,
          label: "Add New",
          width: 140.w,
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
        title: Text(name, style: CustomFonts.black16w600),
        subtitle: Text("$childrenCount sub-items", style: CustomFonts.grey12w400),
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
                  title: Text(child.name, style: CustomFonts.black14w400),
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

  void _showCombinationDialog({
    required BuildContext context,
    required WidgetRef ref,
    required String title,
    String? initialName,
    List<String>? initialTreatments,
    required Function(String, List<String>) onConfirm,
  }) {
    final nameController = TextEditingController(text: initialName);
    final List<String> selectedTreatments = List.from(initialTreatments ?? []);
    final treatmentsState = ref.read(treatmentViewModelProvider);
    final searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => StandardDialog(
          title: title,
          width: context.w(500),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BuildTextField(
                label: "Group Name",
                controller: nameController,
                hintText: "e.g. Skin Glow Package",
              ),
              context.verticalSpace(24),
              Text("Add Treatments", style: CustomFonts.black14w600),
              context.verticalSpace(10),
              SearchAnchor(
                viewHintText: "Search treatments...",
                builder: (context, controller) => AppSearchField(
                  controller: searchController,
                  readOnly: true,
                  onTap: () => controller.openView(),
                  hintText: "Select treatment to add",
                  suffixIcon: const Icon(Icons.search),
                  maxWidth: double.infinity,
                ),
                suggestionsBuilder: (context, controller) {
                  final query = controller.text.toLowerCase();
                  return treatmentsState.treatments
                      .where((t) => t.name!.toLowerCase().contains(query))
                      .map((t) => ListTile(
                        title: Text(t.name!),
                        onTap: () {
                          if (!selectedTreatments.contains(t.name)) {
                            setState(() => selectedTreatments.add(t.name!));
                          }
                          controller.closeView(t.name!);
                        },
                      ))
                      .toList();
                },
              ),
              if (selectedTreatments.isNotEmpty) ...[
                context.verticalSpace(16),
                Wrap(
                  spacing: context.w(8),
                  runSpacing: context.h(8),
                  children: selectedTreatments.map((t) => Chip(
                    label: Text(t, style: CustomFonts.black11w400),
                    onDeleted: () => setState(() => selectedTreatments.remove(t)),
                    backgroundColor: CustomColors.purple.withValues(alpha: 0.05),
                    deleteIconColor: CustomColors.purple,
                  )).toList(),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            CustomPrimaryButton(
              onTap: () {
                if (nameController.text.trim().isNotEmpty) {
                  onConfirm(nameController.text.trim(), selectedTreatments);
                  Navigator.pop(context);
                }
              },
              label: "Save Group",
              width: context.w(140),
            ),
          ],
        ),
      ),
    );
  }

  static void _showDeleteConfirm(BuildContext context, String name, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => StandardDialog(
        title: "Confirm Delete",
        width: context.w(400),
        content: Text("Are you sure you want to delete '$name'? This action is irreversible. All child sub-items will also be removed.", style: CustomFonts.black14w400),
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
        title: Text(category.name, style: CustomFonts.black16w600),
        subtitle: Text("${category.children.length} sub-categories", style: CustomFonts.grey12w400),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: "Add Child Category",
              icon: const Icon(Icons.add_circle_outline, size: 20, color: CustomColors.green),
              onPressed: () => ManageTreatmentDataScreen._showItemDialog(
                context: context,
                title: "Add Child under '${category.name}'",
                onConfirm: (name, icon) => viewModel.addCategory(name, icon: icon, parentId: category.id),
              ),
            ),
            IconButton(
              tooltip: "Edit Category",
              icon: const Icon(Icons.edit_outlined, size: 20),
              onPressed: () => ManageTreatmentDataScreen._showItemDialog(
                context: context,
                title: "Edit Category",
                initialName: category.name,
                initialIcon: category.icon,
                onConfirm: (name, icon) => viewModel.editCategory(category.id, name, icon: icon),
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
