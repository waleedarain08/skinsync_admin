import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/utils/color_constant.dart';
import 'package:skinsync_admin/utils/custom_fonts.dart';
import 'package:skinsync_admin/view_models/treatment_data_view_model.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';
import 'package:skinsync_admin/widgets/dailogbox/standard_dialog.dart';

class ManageTreatmentDataScreen extends ConsumerWidget {
  const ManageTreatmentDataScreen({super.key});

  static const String routeName = '/manage-treatment-data';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(treatmentDataViewModelProvider);
    final viewModel = ref.read(treatmentDataViewModelProvider.notifier);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: CustomColors.backgroundLight,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text("Manage Network Taxonomy", style: CustomFonts.textMain20w600),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: CustomColors.textMain),
            onPressed: () => context.pop(),
          ),
          bottom: TabBar(
            labelColor: CustomColors.brandPrimary,
            unselectedLabelColor: CustomColors.textMuted,
            indicatorColor: CustomColors.brandPrimary,
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
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTabHeader(
            title: "Treatment Categories",
            onAdd: () => _showItemDialog(
              context: context,
              title: "Add New Category",
              onConfirm: (name, icon) => viewModel.addCategory(name, icon: icon),
            ),
          ),
          SizedBox(height: 24.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.categories.length,
            separatorBuilder: (_, _) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              final category = state.categories[index];
              return _buildHierarchicalItem(
                context: context,
                name: category.name,
                icon: category.icon,
                childrenCount: category.subcategories.length,
                children: category.subcategories.map((s) => _ChildItemData(name: s.name, icon: s.icon)).toList(),
                onEdit: (name, icon) => viewModel.editCategory(category.name, name, icon: icon),
                onDelete: () => viewModel.deleteCategory(category.name),
                onAddChild: (name, icon) => viewModel.addSubcategory(category.name, name, icon: icon),
                onEditChild: (old, name, icon) => viewModel.editSubcategory(category.name, old, name, icon: icon),
                onDeleteChild: (name) => viewModel.deleteSubcategory(category.name, name),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAreasTab(BuildContext context, TreatmentDataState state, TreatmentDataViewModel viewModel) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
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
          SizedBox(height: 24.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.areas.length,
            separatorBuilder: (_, _) => SizedBox(height: 16.h),
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
      padding: EdgeInsets.all(24.w),
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
          SizedBox(height: 24.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: state.materials.map((item) => Chip(
              label: Text(item),
              onDeleted: () => _showDeleteConfirm(context, item, () => viewModel.deleteMaterial(item)),
              deleteIcon: const Icon(Icons.close, size: 16),
              labelStyle: CustomFonts.textMain14w600.copyWith(color: CustomColors.brandPrimary),
              backgroundColor: CustomColors.brandPrimary.withOpacity(0.05),
              side: BorderSide(color: CustomColors.brandPrimary.withOpacity(0.1)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCombinationsTab(BuildContext context, TreatmentDataState state, TreatmentDataViewModel viewModel, WidgetRef ref) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
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
          SizedBox(height: 24.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.combinationGroups.length,
            separatorBuilder: (_, _) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              final group = state.combinationGroups[index];
              return BorderdContainerWidget(
                padding: EdgeInsets.zero,
                child: ExpansionTile(
                  shape: const RoundedRectangleBorder(side: BorderSide.none),
                  leading: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: CustomColors.brandPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: const Icon(Icons.auto_awesome_motion_rounded, color: CustomColors.brandPurple),
                  ),
                  title: Text(group.name, style: CustomFonts.textMain16w600),
                  subtitle: Text("${group.treatmentNames.length} combined treatments", style: CustomFonts.textMuted12w400),
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
                        icon: const Icon(Icons.delete_outline, size: 20, color: CustomColors.error),
                        onPressed: () => _showDeleteConfirm(context, group.name, () => viewModel.deleteCombinationGroup(group.id)),
                      ),
                      const Icon(Icons.expand_more),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 12.w,
                            runSpacing: 12.h,
                            children: group.treatmentNames.map((t) => Chip(
                              label: Text(t),
                              backgroundColor: CustomColors.surfaceGhost,
                              side: BorderSide(color: Colors.grey[200]!),
                              labelStyle: CustomFonts.textMain12w600,
                            )).toList(),
                          ),
                          SizedBox(height: 8.h),
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
        Text(title, style: CustomFonts.textMain18w600),
        ElevatedButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add, size: 18),
          label: const Text("Add New"),
          style: ElevatedButton.styleFrom(
            backgroundColor: CustomColors.deepNavy,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          ),
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
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(color: CustomColors.surfaceGhost, borderRadius: BorderRadius.circular(8.r)),
          child: icon != null 
              ? Image.network(icon, errorBuilder: (_, _, _) => const Icon(Icons.category_outlined)) 
              : const Icon(Icons.category_outlined, color: CustomColors.brandPrimary),
        ),
        title: Text(name, style: CustomFonts.textMain16w600),
        subtitle: Text("$childrenCount sub-items", style: CustomFonts.textMuted12w400),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              onPressed: () => _showItemDialog(
                context: context,
                title: "Edit Item",
                initialName: name,
                initialIcon: icon,
                onConfirm: onEdit,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20, color: CustomColors.error),
              onPressed: () => _showDeleteConfirm(context, name, onDelete),
            ),
            const Icon(Icons.expand_more),
          ],
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                ...children.map((child) => ListTile(
                  dense: true,
                  leading: Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(color: CustomColors.surfaceGhost, borderRadius: BorderRadius.circular(6.r)),
                    child: child.icon != null 
                        ? Image.network(child.icon!, errorBuilder: (_, _, _) => const Icon(Icons.subdirectory_arrow_right, size: 16)) 
                        : const Icon(Icons.subdirectory_arrow_right, size: 16, color: CustomColors.textMuted),
                  ),
                  title: Text(child.name, style: CustomFonts.textMain14w400),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        onPressed: () => _showItemDialog(
                          context: context,
                          title: "Edit Sub-item",
                          initialName: child.name,
                          initialIcon: child.icon,
                          onConfirm: (newName, newIcon) => onEditChild(child.name, newName, newIcon),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18, color: CustomColors.error),
                        onPressed: () => onDeleteChild(child.name),
                      ),
                    ],
                  ),
                )),
                SizedBox(height: 8.h),
                TextButton.icon(
                  onPressed: () => _showItemDialog(
                    context: context,
                    title: "Add Sub-item",
                    onConfirm: onAddChild,
                  ),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text("Add Sub-item"),
                  style: TextButton.styleFrom(foregroundColor: CustomColors.brandPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showItemDialog({
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
        width: 450.w,
        content: Column(
          children: [
            BuildTextField(
              label: "Name",
              controller: nameController,
              hintText: "Enter name...",
            ),
            if (showIconField) ...[
              SizedBox(height: 20.h),
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
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                onConfirm(nameController.text.trim(), iconController.text.trim().isEmpty ? null : iconController.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text("Confirm"),
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
          width: 500.w,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BuildTextField(
                label: "Group Name",
                controller: nameController,
                hintText: "e.g. Skin Glow Package",
              ),
              SizedBox(height: 24.h),
              Text("Add Treatments", style: CustomFonts.textMain14w600),
              SizedBox(height: 10.h),
              SearchAnchor(
                viewHintText: "Search treatments...",
                builder: (context, controller) => TextFormField(
                  controller: searchController,
                  readOnly: true,
                  onTap: () => controller.openView(),
                  decoration: InputDecoration(
                    hintText: "Select treatment to add",
                    suffixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: CustomColors.surfaceGhost,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
                  ),
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
                SizedBox(height: 16.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: selectedTreatments.map((t) => Chip(
                    label: Text(t, style: TextStyle(fontSize: 11.sp)),
                    onDeleted: () => setState(() => selectedTreatments.remove(t)),
                    backgroundColor: CustomColors.brandPrimary.withOpacity(0.05),
                    deleteIconColor: CustomColors.brandPrimary,
                  )).toList(),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  onConfirm(nameController.text.trim(), selectedTreatments);
                  Navigator.pop(context);
                }
              },
              child: const Text("Save Group"),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context, String name, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => StandardDialog(
        title: "Confirm Delete",
        width: 400.w,
        content: Text("Are you sure you want to delete '$name'? This action is irreversible.", style: CustomFonts.textMain14w400),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: CustomColors.error),
            onPressed: () {
              onConfirm();
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}

class _ChildItemData {
  final String name;
  final String? icon;
  _ChildItemData({required this.name, this.icon});
}
