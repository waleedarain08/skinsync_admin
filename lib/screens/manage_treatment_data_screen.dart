import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/requests/create_category_request.dart';
import 'package:skinsync_admin/models/treatment_data_models.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/area_view_model.dart';
import 'package:skinsync_admin/view_models/category_view_model.dart';
import 'package:skinsync_admin/view_models/treatment_data_view_model.dart';
import 'package:skinsync_admin/widgets/app_network_image.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'package:skinsync_admin/widgets/dailogbox/area_creation_dialog.dart';
import 'package:skinsync_admin/widgets/dailogbox/category_creation_dialog.dart';
import 'package:skinsync_admin/widgets/dailogbox/standard_dialog.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';
import 'package:skinsync_admin/utils/string_utils.dart';

import '../models/responses/area_list_response.dart';

class ManageTreatmentDataScreen extends ConsumerStatefulWidget {
  const ManageTreatmentDataScreen({super.key});

  static const String routeName = '/manage-treatment-data';

  @override
  ConsumerState<ManageTreatmentDataScreen> createState() =>
      _ManageTreatmentDataScreenState();

  static Future<void> _showCategoryCreationDialog({
    required BuildContext context,
    String? parentName,
    int? parentId,
    int? categoryId,
    String? initialName,
    String? initialIcon,
    String? initialImage,
    String? initialConsentName,
    bool isUpdate = false,
    List<CategoryNotificationModel>? initialPreNotifications,
    List<CategoryNotificationModel>? initialPostNotifications,
    CategoryDowntimePresetModel? initialDowntimePresets,
    List<String>? initialDefaultRoles,
    required void Function(
      String name,
      String icon,
      String image,
      String? consentFormName,
      String? consentFormUrl,
      List<CategoryNotificationModel>? preNotif,
      List<CategoryNotificationModel>? postNotif,
      CategoryDowntimePresetModel? downtime,
      List<String>? roles,
    )
    onConfirm,
  }) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => CategoryCreationDialog(
        parentName: parentName,
        parentId: parentId,
        categoryId: categoryId,
        initialName: initialName,
        initialIcon: initialIcon,
        initialImage: initialImage,
        initialConsentName: initialConsentName,
        isUpdate: isUpdate,
        initialPreNotifications: initialPreNotifications,
        initialPostNotifications: initialPostNotifications,
        initialDowntimePresets: initialDowntimePresets,
        initialDefaultRoles: initialDefaultRoles,
      ),
    );

    if (result != null) {
      onConfirm(
        result['name'],
        result['icon'],
        result['image'],
        result['consentFormName'],
        result['consentFormUrl'],
        result['preNotifications'],
        result['postNotifications'],
        result['downtimePresets'],
        result['defaultRoles'],
      );
    }
  }

  static void _showProtocolDialog({
    required BuildContext context,
    required String title,
    String? initialValue,
    required void Function(String) onConfirm,
  }) {
    final controller = TextEditingController(text: initialValue);

    showDialog(
      context: context,
      builder: (context) => StandardDialog(
        title: title,
        width: context.w(450),
        content: BuildTextField(
          label: 'Protocol Title',
          controller: controller,
          hintText: 'Enter protocol title...',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          CustomPrimaryButton(
            onTap: () {
              if (controller.text.trim().isNotEmpty) {
                onConfirm(controller.text.trim());
                Navigator.pop(context);
              }
            },
            label: 'Confirm',
            width: context.w(120),
          ),
        ],
      ),
    );
  }

  static void _showEnhancedProtocolDialog({
    required BuildContext context,
    required ProtocolItem protocol,
    required void Function(ProtocolItem) onSave,
  }) {
    final titleController = TextEditingController(text: protocol.title);
    final List<Map<String, dynamic>> descGroups = protocol.descriptions
        .map(
          (d) => {
            'title': TextEditingController(text: d.title),
            'text': TextEditingController(text: d.text),
          },
        )
        .toList();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return StandardDialog(
              title: 'Edit Protocol',
              width: context.w(500),
              content: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: context.h(600)),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BuildTextField(
                        label: 'Protocol Title',
                        controller: titleController,
                        hintText: 'Enter protocol title...',
                      ),
                      context.verticalSpace(24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Protocol Descriptions',
                            style: context.fonts.black14w700,
                          ),
                          TextButton.icon(
                            onPressed: () {
                              setDialogState(() {
                                descGroups.add({
                                  'title': TextEditingController(),
                                  'text': TextEditingController(),
                                });
                              });
                            },
                            icon: const Icon(
                              Icons.add_circle_outline,
                              size: 18,
                            ),
                            label: const Text('Add Description'),
                          ),
                        ],
                      ),
                      context.verticalSpace(12),
                      if (descGroups.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "No descriptions added yet. Click 'Add Description' to add structured steps.",
                            style: context.fonts.grey13w500,
                          ),
                        )
                      else
                        ...descGroups.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final group = entry.value;
                          final titleCtrl =
                              group['title'] as TextEditingController;
                          final textCtrl =
                              group['text'] as TextEditingController;

                          return Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: CustomColors.whiteGrey,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: CustomColors.border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Description #${idx + 1}',
                                      style: context.fonts.black14w700,
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.arrow_upward,
                                            size: 16,
                                          ),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          onPressed: idx > 0
                                              ? () {
                                                  setDialogState(() {
                                                    final temp =
                                                        descGroups[idx];
                                                    descGroups[idx] =
                                                        descGroups[idx - 1];
                                                    descGroups[idx - 1] = temp;
                                                  });
                                                }
                                              : null,
                                        ),
                                        context.horizontalSpace(8),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.arrow_downward,
                                            size: 16,
                                          ),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          onPressed: idx < descGroups.length - 1
                                              ? () {
                                                  setDialogState(() {
                                                    final temp =
                                                        descGroups[idx];
                                                    descGroups[idx] =
                                                        descGroups[idx + 1];
                                                    descGroups[idx + 1] = temp;
                                                  });
                                                }
                                              : null,
                                        ),
                                        context.horizontalSpace(8),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete_outline,
                                            size: 16,
                                            color: CustomColors.red,
                                          ),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          onPressed: () {
                                            setDialogState(() {
                                              descGroups.removeAt(idx);
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                context.verticalSpace(12),
                                BuildTextField(
                                  label: 'Title (Optional)',
                                  controller: titleCtrl,
                                  hintText: 'e.g. Pre Care',
                                ),
                                context.verticalSpace(12),
                                BuildTextField(
                                  label: 'Description Text',
                                  controller: textCtrl,
                                  hintText: 'Enter description text...',
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                CustomPrimaryButton(
                  onTap: () {
                    if (titleController.text.trim().isNotEmpty) {
                      final List<ProtocolDescription> updatedDescs = [];
                      for (int i = 0; i < descGroups.length; i++) {
                        final titleCtrl =
                            descGroups[i]['title'] as TextEditingController;
                        final textCtrl =
                            descGroups[i]['text'] as TextEditingController;
                        updatedDescs.add(
                          ProtocolDescription(
                            title: titleCtrl.text.trim(),
                            text: textCtrl.text.trim(),
                            order: i + 1,
                          ),
                        );
                      }
                      final updatedProtocol = protocol.copyWith(
                        title: titleController.text.trim(),
                        descriptions: updatedDescs,
                      );
                      onSave(updatedProtocol);
                      Navigator.pop(context);
                    }
                  },
                  label: 'Save',
                  width: context.w(120),
                ),
              ],
            );
          },
        );
      },
    );
  }

  static void _showProtocolDetailDialog({
    required BuildContext context,
    required ProtocolItem protocol,
  }) {
    showDialog(
      context: context,
      builder: (context) => StandardDialog(
        title: 'Protocol Details',
        width: context.w(500),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(protocol.title.capitalize, style: context.fonts.black18w600),
            context.verticalSpace(8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: CustomColors.purple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                protocol.type == ProtocolType.checkbox
                    ? 'CHECKBOX PROTOCOL'
                    : 'TEXT PROTOCOL',
                style: context.fonts.sectionHeading,
              ),
            ),
            context.verticalSpace(20),
            const Divider(),
            context.verticalSpace(16),
            if (protocol.descriptions.isEmpty)
              Text(
                'No clinical descriptions configured for this protocol.',
                style: context.fonts.grey14w400,
              )
            else
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: context.h(400)),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: protocol.descriptions.map((desc) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: CustomColors.purple,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${desc.order}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                context.horizontalSpace(12),
                                if (desc.title != null &&
                                    desc.title!.isNotEmpty)
                                  Expanded(
                                    child: Text(
                                      desc.title!,
                                      style: context.fonts.black14w700,
                                    ),
                                  ),
                              ],
                            ),
                            context.verticalSpace(8),
                            Padding(
                              padding: const EdgeInsets.only(left: 34.0),
                              child: Text(
                                desc.text,
                                style: context.fonts.grey14w400,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
          ],
        ),
        actions: [
          CustomPrimaryButton(
            onTap: () => Navigator.pop(context),
            label: 'Close',
            width: context.w(120),
          ),
        ],
      ),
    );
  }

  static void _showDeleteConfirm(
    BuildContext context,
    String name,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (context) => StandardDialog(
        title: 'Confirm Delete',
        width: context.w(400),
        content: Text(
          "Are you sure you want to delete '$name'? This action is irreversible. All child sub-items will also be removed.",
          style: context.fonts.black14w400,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          CustomPrimaryButton(
            onTap: () {
              onConfirm();
              Navigator.pop(context);
            },
            label: 'Delete',
            width: context.w(120),
          ),
        ],
      ),
    );
  }
}

class _ManageTreatmentDataScreenState
    extends ConsumerState<ManageTreatmentDataScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(categoryViewModelProvider.notifier).fetchCategories();
      await ref.read(areaViewModelProvider.notifier).fetchAreas();
      final fetchedAreas = ref.read(areaViewModelProvider).areas;
      ref
          .read(treatmentDataViewModelProvider.notifier)
          .setAreasFromBackend(fetchedAreas);
    });
  }

  @override
  Widget build(BuildContext context) {
    final dataState = ref.watch(treatmentDataViewModelProvider);
    final categoryState = ref.watch(categoryViewModelProvider);
    final dataViewModel = ref.read(treatmentDataViewModelProvider.notifier);
    final categoryViewModel = ref.read(categoryViewModelProvider.notifier);

    return DefaultTabController(
      length: 3,
      child: GradientScaffold(
        appBar: AppBar(
          flexibleSpace: AppDecorations.appBarGradient,
          elevation: 0,
          title: Text(
            'Manage Network Taxonomy',
            style: context.fonts.level2Heading,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: CustomColors.black),
            onPressed: () => context.pop(),
          ),
          bottom: const TabBar(
            labelColor: CustomColors.purple,
            unselectedLabelColor: CustomColors.grey,
            indicatorColor: CustomColors.purple,
            indicatorWeight: 3,
            tabs: [
              Tab(text: 'Categories'),
              Tab(text: 'Body Areas'),
              Tab(text: 'Protocols'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildCategoriesTab(context, categoryState, categoryViewModel),
            _buildAreasTab(context, dataState, dataViewModel),
            _buildProtocolsTab(context, dataState, dataViewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesTab(
    BuildContext context,
    CategoryState state,
    CategoryViewModel viewModel,
  ) {
    return SingleChildScrollView(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTabHeader(
            context: context,
            title: 'Treatment Categories',
            onAdd: () => ManageTreatmentDataScreen._showCategoryCreationDialog(
              context: context,
              onConfirm:
                  (
                    String name,
                    String icon,
                    String image,
                    String? consentFormName,
                    String? consentFormUrl,
                    List<CategoryNotificationModel>? preNotif,
                    List<CategoryNotificationModel>? postNotif,
                    CategoryDowntimePresetModel? downtime,
                    List<String>? roles,
                  ) {
                    // Done on backend directly
                  },
            ),
          ),
          context.verticalSpace(24),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.categories.length,
            separatorBuilder: (context, index) =>
                SizedBox(height: context.h(16)),
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

  Widget _buildAreasTab(
    BuildContext context,
    TreatmentDataState state,
    TreatmentDataViewModel viewModel,
  ) {
    return SingleChildScrollView(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTabHeader(
            context: context,
            title: 'Anatomical Body Areas',
            onAdd: () async {
              final result = await showDialog<Map<String, dynamic>>(
                context: context,
                builder: (context) =>
                    const AreaCreationDialog(title: 'Add New Area'),
              );
              if (result != null) {
                await viewModel.addArea(
                  result['name'] as String,
                  sku: result['sku'] as String,
                  icon: result['icon'] as String,
                  image: result['image'] as String,
                  description: result['description'] as String? ?? '',
                  infoImageUrl:
                      result['infoImageUrl'] as String? ?? '',
                );
              }
            },
          ),
          context.verticalSpace(24),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.areas.length,
            separatorBuilder: (context, index) => context.verticalSpace(16),
            itemBuilder: (context, index) {
              final area = state.areas[index];
              return _RecursiveAreaTile(
                area: area,
                viewModel: viewModel,
                level: 0,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProtocolsTab(
    BuildContext context,
    TreatmentDataState state,
    TreatmentDataViewModel viewModel,
  ) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          ColoredBox(
            color: Colors.white.withValues(alpha: 0.5),
            child: const TabBar(
              labelColor: CustomColors.purple,
              unselectedLabelColor: CustomColors.grey,
              indicatorColor: CustomColors.purple,
              tabs: [
                Tab(text: 'Checkboxes'),
                Tab(text: 'Text Fields'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildProtocolList(
                  context,
                  state,
                  viewModel,
                  ProtocolType.checkbox,
                ),
                _buildProtocolList(
                  context,
                  state,
                  viewModel,
                  ProtocolType.text,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProtocolList(
    BuildContext context,
    TreatmentDataState state,
    TreatmentDataViewModel viewModel,
    ProtocolType type,
  ) {
    final filteredProtocols = state.protocols
        .where((p) => p.type == type)
        .toList();
    final title = type == ProtocolType.checkbox
        ? 'Checkbox Protocols'
        : 'Text Field Protocols';

    return SingleChildScrollView(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTabHeader(
            context: context,
            title: title,
            onAdd: () => ManageTreatmentDataScreen._showProtocolDialog(
              context: context,
              title:
                  'Add ${type == ProtocolType.checkbox ? 'Checkbox' : 'Text'} Protocol',
              onConfirm: (String val) => viewModel.addProtocol(val, type),
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
                      type == ProtocolType.checkbox
                          ? Icons.check_box_outlined
                          : Icons.text_fields_rounded,
                      color: CustomColors.purple,
                      size: 20,
                    ),
                    context.horizontalSpace(16),
                    Expanded(
                      child: Text(
                        protocol.title,
                        style: context.fonts.black14w600,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.info_outline_rounded, size: 20),
                      onPressed: () =>
                          ManageTreatmentDataScreen._showProtocolDetailDialog(
                            context: context,
                            protocol: protocol,
                          ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      onPressed: () =>
                          ManageTreatmentDataScreen._showEnhancedProtocolDialog(
                            context: context,
                            protocol: protocol,
                            onSave: (updated) =>
                                viewModel.saveProtocol(updated),
                          ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        size: 20,
                        color: CustomColors.red,
                      ),
                      onPressed: () =>
                          ManageTreatmentDataScreen._showDeleteConfirm(
                            context,
                            protocol.title,
                            () => viewModel.deleteProtocol(protocol.id),
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

  Widget _buildTabHeader({
    required BuildContext context,
    required String title,
    required VoidCallback onAdd,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title.capitalize, style: context.fonts.black18w600),
        CustomPrimaryButton(
          onTap: onAdd,
          icon: Icons.add,
          label: 'Add New',
          width: context.w(140),
        ),
      ],
    );
  }
}

class _RecursiveCategoryTile extends StatelessWidget {
  const _RecursiveCategoryTile({
    required this.category,
    required this.viewModel,
    required this.level,
  });
  final CategoryModel category;
  final CategoryViewModel viewModel;
  final int level;

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
          child: AppNetworkImage(
            imageUrl: category.icon,
            fit: BoxFit.cover,
            errorIcon: Icons.category_outlined,
            errorIconColor: CustomColors.purple,
          ),
        ),
        title: Text(category.name.capitalize, style: context.fonts.black16w600),
        subtitle: Text(
          '${category.subCategories.length} sub-categories',
          style: context.fonts.grey12w400,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'View Category Details',
              icon: const Icon(
                Icons.visibility_outlined,
                size: 20,
                color: CustomColors.purple,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => CategoryCreationDialog(
                    categoryId: category.id,
                    isViewMode: true,
                  ),
                );
              },
            ),
            IconButton(
              tooltip: 'Add Child Category',
              icon: const Icon(
                Icons.add_circle_outline,
                size: 20,
                color: CustomColors.green,
              ),
              onPressed: () =>
                  ManageTreatmentDataScreen._showCategoryCreationDialog(
                    context: context,
                    parentName: category.name,
                    parentId: category.id, // Explicitly pass parentId
                    onConfirm:
                        (
                          String name,
                          String icon,
                          String image,
                          String? consentFormName,
                          String? consentFormUrl,
                          List<CategoryNotificationModel>? preNotif,
                          List<CategoryNotificationModel>? postNotif,
                          CategoryDowntimePresetModel? downtime,
                          List<String>? roles,
                        ) {
                          // Done on backend directly
                        },
                  ),
            ),
            IconButton(
              tooltip: 'Edit Category',
              icon: const Icon(Icons.edit_outlined, size: 20),
              onPressed: () =>
                  ManageTreatmentDataScreen._showCategoryCreationDialog(
                    context: context,
                    categoryId:
                        category.id, // Explicitly pass categoryId to edit
                    initialName: category.name,
                    initialIcon: category.icon,
                    initialImage: category.image,
                    isUpdate: true,

                    onConfirm:
                        (
                          String name,
                          String icon,
                          String image,
                          String? consentFormName,
                          String? consentFormUrl,
                          List<CategoryNotificationModel>? preNotif,
                          List<CategoryNotificationModel>? postNotif,
                          CategoryDowntimePresetModel? downtime,
                          List<String>? roles,
                        ) => viewModel.editCategory(
                          category.id,
                          name,
                          icon: icon,
                          image: image,
                          consentFormUrl: consentFormUrl,
                          consentFormName: consentFormName,
                          preNotifications: preNotif,
                          postNotifications: postNotif,
                          downtimePresets: downtime,
                          defaultRoles: roles,
                        ),
                  ),
            ),
            IconButton(
              tooltip: 'Delete Category',
              icon: const Icon(
                Icons.delete_outline,
                size: 20,
                color: CustomColors.red,
              ),
              onPressed: () => ManageTreatmentDataScreen._showDeleteConfirm(
                context,
                category.name,
                () async => await viewModel.deleteCategory(category.id),
              ),
            ),
            if (category.subCategories.isNotEmpty)
              const Icon(Icons.expand_more),
          ],
        ),
        children: category.subCategories
            .map(
              (child) => Padding(
                padding: EdgeInsets.only(right: 16.w, bottom: 16.h),
                child: _RecursiveCategoryTile(
                  category: child,
                  viewModel: viewModel,
                  level: level + 1,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _RecursiveAreaTile extends StatelessWidget {
  const _RecursiveAreaTile({
    required this.area,
    required this.viewModel,
    required this.level,
  });

  final AreaModel area;
  final TreatmentDataViewModel viewModel;
  final int level;

  @override
  Widget build(BuildContext context) {
    return BorderdContainerWidget(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.only(left: level * 24.w, bottom: 16.h),
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
          child: AppNetworkImage(
            imageUrl: area.icon,
            fit: BoxFit.cover,
            errorIcon: Icons.location_searching,
            errorIconColor: CustomColors.purple,
          ),
        ),
        title: Text(area.name.capitalize, style: context.fonts.black16w600),
        subtitle: Text(
          '${area.subAreasCount} sub-areas',
          style: context.fonts.grey12w400,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Add Sub-Area',
              icon: const Icon(
                Icons.add_circle_outline,
                size: 20,
                color: CustomColors.green,
              ),
              onPressed: () async {
                final result = await showDialog<Map<String, dynamic>>(
                  context: context,
                  builder: (context) =>
                      const AreaCreationDialog(title: 'Add Sub-item'),
                );
                if (result != null) {
                  await viewModel.addSubArea(
                    parentAreaId: area.id,
                    parentAreaName: area.name,
                    name: result['name'] as String,
                    sku: result['sku'] as String,
                    icon: result['icon'] as String,
                    image: result['image'] as String,
                    description: result['description'] as String? ?? '',
                    infoImageUrl:
                        result['infoImageUrl'] as String? ?? '',
                  );
                }
              },
            ),
            IconButton(
              tooltip: 'Edit Area',
              icon: const Icon(Icons.edit_outlined, size: 20),
              onPressed: () async {
                final result = await showDialog<Map<String, dynamic>>(
                  context: context,
                  builder: (context) => AreaCreationDialog(
                    title: 'Edit Area',
                    initialName: area.name,
                    initialIconUrl: area.icon,
                    initialImageUrl: area.image,
                    initialSku: area.globalSku,
                    initialInfoImageUrl: area.infoImage,
                    initialDescription: area.description,
                  ),
                );
                if (result != null) {
                  if (level == 0) {
                    await viewModel.editArea(
                      id: area.id,
                      name: result['name'] as String,
                      sku: result['sku'] as String,
                      icon: result['icon'] as String,
                      image: result['image'] as String,
                      description: result['description'] as String? ?? '',
                      infoImageUrl:
                          result['infoImageUrl'] as String? ?? '',
                    );
                  } else {
                    await viewModel.editSubArea(
                      id: area.id,
                      name: result['name'] as String,
                      sku: result['sku'] as String,
                      icon: result['icon'] as String,
                      image: result['image'] as String,
                      description: result['description'] as String? ?? '',
                      infoImageUrl:
                          result['infoImageUrl'] as String? ?? '',
                    );
                  }
                }

                //   ManageTreatmentDataScreen._showItemDialog(
                //   context: context,
                //   title: ,
                //   initialName:,
                //   initialIcon: ,
                //   initialImage: ,
                //   onConfirm: (newName, newIcon, newImage) {
                //     if (level == 0) {
                //       viewModel.editArea(area.name, newName, icon: newIcon, image: newImage);
                //     } else {
                //       viewModel.editSubArea(area.name, area.name, newName, icon: newIcon, image: newImage);
                //     }
                //   },
                // );
              },
            ),
            IconButton(
              tooltip: 'Delete Area',
              icon: const Icon(
                Icons.delete_outline,
                size: 20,
                color: CustomColors.red,
              ),
              onPressed: () => ManageTreatmentDataScreen._showDeleteConfirm(
                context,
                area.name,
                () {
                  if (level == 0) {
                    viewModel.deleteArea(name: area.name, id: area.id);
                  } else {
                    viewModel.deleteSubArea(id: area.id);
                  }
                },
              ),
            ),
            if (area.subAreas.isNotEmpty) const Icon(Icons.expand_more),
          ],
        ),
        children: area.subAreas
            .map(
              (child) => Padding(
                padding: EdgeInsets.only(right: 16.w, bottom: 16.h),
                child: _RecursiveAreaTile(
                  area: child,
                  viewModel: viewModel,
                  level: level + 1,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
