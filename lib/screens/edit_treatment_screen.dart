import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../utils/theme.dart';
import '../utils/validators.dart';
import '../view_models/area_view_model.dart';
import '../view_models/category_view_model.dart';
import '../view_models/product_view_model.dart';
import '../view_models/treatment_data_view_model.dart';
import '../view_models/treatment_view_model.dart';
import '../widgets/app_search_field.dart';
import '../widgets/borderd_container_widget.dart';
import '../widgets/build_textfield.dart';
import '../widgets/custom_dropdown_widget.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/nested_category_selector.dart';

class EditTreatmentScreen extends ConsumerStatefulWidget {
  const EditTreatmentScreen({super.key});

  static const String routeName = '/edit-treatment';

  @override
  ConsumerState<EditTreatmentScreen> createState() => _EditTreatmentScreenState();
}

class _EditTreatmentScreenState extends ConsumerState<EditTreatmentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(categoryViewModelProvider.notifier).fetchCategories();
      ref.read(productViewModelProvider.notifier).fetchProducts();
      await ref.read(areaViewModelProvider.notifier).fetchAreas();
      final fetchedAreas = ref.read(areaViewModelProvider).areas;
      ref.read(treatmentDataViewModelProvider.notifier).setAreasFromBackend(fetchedAreas);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(treatmentViewModelProvider);
    final viewModel = ref.read(treatmentViewModelProvider.notifier);
    final dataState = ref.watch(treatmentDataViewModelProvider);
    final categoryState = ref.watch(categoryViewModelProvider);

    if (state.selectedTreatment == null) {
      return GradientScaffold(
        body: Center(
          child: Text(
            'No Treatment Selected',
            style: context.fonts.black16w400,
          ),
        ),
      );
    }

    return GradientScaffold(
      appBar: AppBar(
        flexibleSpace: AppDecorations.appBarGradient,
        elevation: 0,
        centerTitle: true,
        title: Text('Edit Treatment', style: context.fonts.black18w600),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: CustomColors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(horizontal: 24, vertical: 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              children: [
                _buildCategorizationSection(
                  context,
                  state,
                  viewModel,
                  categoryState,
                ),
                context.verticalSpace(32),
                _buildBasicInfoSection(context, state, viewModel),
                context.verticalSpace(32),
                _buildAreasSection(context, state, viewModel, dataState),
                context.verticalSpace(32),
                _buildMaterialsSection(context, state, viewModel, dataState),
                context.verticalSpace(32),
                _buildSchedulingSection(context, state, viewModel),
                context.verticalSpace(32),
                _buildPricingSection(context, state, viewModel),
                context.verticalSpace(32),
                _buildPreTreatmentSection(context, state, viewModel),
                context.verticalSpace(32),
                _buildPostTreatmentSection(context, state, viewModel),
                context.verticalSpace(32),
                _buildPostTreatmentPhotosSection(context, state, viewModel),
                context.verticalSpace(32),
                _buildNotificationsSection(
                  context,
                  state,
                  viewModel,
                  categoryState,
                ),
                context.verticalSpace(32),
                _buildDowntimeSection(context, state, viewModel, categoryState),
                context.verticalSpace(32),
                _buildRolesSection(context, state, viewModel, categoryState),
                context.verticalSpace(32),
                _buildSessionsSection(context, state, viewModel, categoryState),
                context.verticalSpace(32),
                _buildFollowUpEditSection(context, state, viewModel, ref),
                context.verticalSpace(32),
                _buildConsentSection(context, state, viewModel, ref),
                context.verticalSpace(32),
                _buildProtocolsSection(
                  context,
                  state,
                  viewModel,
                  dataState,
                  ref,
                ),
                context.verticalSpace(32),
                _buildLogicSection(context, state, viewModel),
                context.verticalSpace(48),
                SizedBox(
                  width: double.infinity,
                  child: CustomPrimaryButton(
                    onTap: () {
                      viewModel
                          .submitTreatment(
                            context,
                            categories: categoryState.categories,
                            isEdit: true,
                          )
                          .then((_) {
                            if (context.mounted) context.pop();
                          });
                    },
                    label: 'Save Changes',
                  ),
                ),
                context.verticalSpace(48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPostTreatmentPhotosSection(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
  ) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Post Treatment Photos', style: context.fonts.black18w600),
          context.verticalSpace(8),
          Text(
            'Configure how many post-treatment photos should be captured for this treatment.',
            style: context.fonts.grey14w400,
          ),
          context.verticalSpace(24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Require Post Treatment Photos',
                      style: context.fonts.black14w600,
                    ),
                    context.verticalSpace(4),
                    Text(
                      'If enabled, practitioners will be prompted to take photos after the procedure.',
                      style: context.fonts.grey12w400,
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: state.requirePostTreatmentPhotos,
                onChanged: (val) => viewModel.updateTreatmentState(
                  requirePostTreatmentPhotos: val,
                ),
                activeColor: CustomColors.purple,
              ),
            ],
          ),
          if (state.requirePostTreatmentPhotos) ...[
            context.verticalSpace(24),
            BuildTextField(
              label: 'Number of Required Photos',
              hintText: 'e.g. 3',
              controller: viewModel.postTreatmentPhotoCountController,
              keyboardType: TextInputType.number,
              onChanged: (val) {
                viewModel.updateRequiredPostTreatmentPhotoCount(val ?? '0');
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategorizationSection(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
    CategoryState categoryState,
  ) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Categorization', style: context.fonts.black18w600),
          context.verticalSpace(8),
          Text(
            'Organize treatments to help patients find them easily.',
            style: context.fonts.grey14w400,
          ),
          context.verticalSpace(24),
          NestedCategorySelector(
            categories: categoryState.categories,
            initialCategoryId: viewModel.categoryIdController.text,
            onSelected: (cat, path) => viewModel.onCategorySelected(cat, path),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
  ) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Basic Information', style: context.fonts.black18w600),
          context.verticalSpace(24),
          BuildTextField(
            label: 'Treatment Name',
            controller: viewModel.displayNameController,
            hintText: 'e.g. Lip Filler',
            validator: Validators.empty,
          ),
          context.verticalSpace(24),
          BuildTextField(
            label: 'Description',
            controller: viewModel.fullDescriptionController,
            hintText: 'Describe the treatment...',
            maxLines: 3,
          ),
          context.verticalSpace(24),
          Row(
            children: [
              Expanded(
                child: CustomDropdown<String>(
                  label: 'Status',
                  hintText: 'Select Status',
                  value: state.status,
                  items: const [
                    DropdownMenuItem(value: 'active', child: Text('Active')),
                    DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                    DropdownMenuItem(value: 'deactive', child: Text('Deactive')),
                    DropdownMenuItem(value: 'draft', child: Text('Draft')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      viewModel.updateTreatmentState(status: val);
                    }
                  },
                ),
              ),
              context.horizontalSpace(16),
              Expanded(
                child: CustomDropdown<String>(
                  label: 'Gender Target',
                  hintText: 'Select Gender',
                  value: state.gender,
                  items: const [
                    DropdownMenuItem(value: 'both', child: Text('Both')),
                    DropdownMenuItem(value: 'female', child: Text('Female')),
                    DropdownMenuItem(value: 'male', child: Text('Male')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      viewModel.updateTreatmentState(gender: val);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAreasSection(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
    TreatmentDataState dataState,
  ) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Body Areas', style: context.fonts.black18w600),
          context.verticalSpace(24),
          ...state.areas.asMap().entries.map((entry) {
            final index = entry.key;
            final areaEntry = entry.value;
            return Padding(
              padding: context.appEdgeInsets(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Area Assignment #${index + 1}',
                        style: context.fonts.purple14w700,
                      ),
                      if (state.areas.length > 1)
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: CustomColors.red),
                          onPressed: () => viewModel.removeArea(index),
                        ),
                    ],
                  ),
                  context.verticalSpace(16),
                  _buildSearchField(
                    context,
                    label: 'Anatomical Area',
                    hint: 'e.g. Face',
                    controller: areaEntry.areaController,
                    suggestions: dataState.areas.map((a) => a.name).toList(),
                    onSelected: (val) => viewModel.onAreaSelected(index, val),
                  ),
                  context.verticalSpace(16),
                  _buildSearchField(
                    context,
                    label: 'Sub Areas',
                    hint: 'e.g. Forehead',
                    controller: areaEntry.subAreaController,
                    suggestions: dataState.areas.isEmpty 
                        ? [] 
                        : dataState.areas
                            .firstWhere((a) => a.name == areaEntry.areaController.text,
                                orElse: () => dataState.areas.first)
                            .subAreas
                            .map((s) => s.name)
                            .toList(),
                    onSelected: (val) => viewModel.addSubArea(index, val),
                  ),
                  if (areaEntry.subAreas.isNotEmpty) ...[
                    context.verticalSpace(16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: areaEntry.subAreas.map((sub) {
                        return Chip(
                          label: Text(sub.name, style: context.fonts.black12w400),
                          onDeleted: () => viewModel.removeSubArea(index, sub.name),
                          backgroundColor: CustomColors.whiteGrey,
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            );
          }),
          TextButton.icon(
            onPressed: viewModel.addArea,
            icon: const Icon(Icons.add),
            label: const Text('Add Another Area'),
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialsSection(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
    TreatmentDataState dataState,
  ) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Inventory Products', style: context.fonts.black18w600),
          context.verticalSpace(24),
          // TODO: Product search logic
          context.verticalSpace(24),
          if (state.productUsageEntries.isEmpty)
            Center(
              child: Text(
                'No products assigned to this treatment.',
                style: context.fonts.grey14w400,
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.productUsageEntries.length,
              separatorBuilder: (_, __) => context.verticalSpace(16),
              itemBuilder: (context, index) {
                final material = state.productUsageEntries[index];
                return _buildMaterialCard(context, index, material, state, viewModel);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildMaterialCard(
    BuildContext context,
    int index,
    ProductUsageEntry material,
    TreatmentState state,
    TreatmentViewModel viewModel,
  ) {
    return Container(
      padding: context.appEdgeInsets(all: 16),
      decoration: BoxDecoration(
        color: CustomColors.whiteGrey,
        borderRadius: context.appBorderRadius(all: 12),
        border: Border.all(color: CustomColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(material.productName, style: context.fonts.black14w700),
              IconButton(
                icon: const Icon(Icons.close, size: 18, color: CustomColors.red),
                onPressed: () => viewModel.removeProductUsage(material.productId),
              ),
            ],
          ),
          context.verticalSpace(16),
          Row(
            children: [
              Expanded(
                child: CustomDropdown<String>(
                  label: 'Usage Type',
                  hintText: 'Select',
                  value: material.usageType,
                  items: const [
                    DropdownMenuItem(value: 'Required', child: Text('Required')),
                    DropdownMenuItem(value: 'Optional', child: Text('Optional')),
                    DropdownMenuItem(value: 'Variable', child: Text('Variable')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      viewModel.updateProductUsageEntry(index, usageType: val);
                    }
                  },
                ),
              ),
              context.horizontalSpace(16),
              Expanded(
                child: BuildTextField(
                  label: 'Unit',
                  controller: TextEditingController(text: material.unit),
                  hintText: 'Units',
                  readOnly: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSchedulingSection(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
  ) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Scheduling', style: context.fonts.black18w600),
          context.verticalSpace(24),
          Row(
            children: [
              Expanded(
                child: BuildTextField(
                  label: 'Total Duration (mins)',
                  controller: viewModel.treatmentDurationController,
                  hintText: '60',
                  keyboardType: TextInputType.number,
                ),
              ),
              context.horizontalSpace(16),
              Expanded(
                child: BuildTextField(
                  label: 'Room Prep Time (mins)',
                  controller: viewModel.prepTimeController,
                  hintText: '15',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPricingSection(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
  ) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pricing Setup', style: context.fonts.black18w600),
          context.verticalSpace(24),
          BuildTextField(
            label: 'Base Price (\$)',
            controller: viewModel.basePriceController,
            hintText: '0.00',
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  Widget _buildPreTreatmentSection(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
  ) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pre-Treatment Instructions', style: context.fonts.black18w600),
          context.verticalSpace(24),
          BuildTextField(
            label: 'Instructions',
            controller: viewModel.preTreatmentInstructionsController,
            hintText: 'Enter instructions for patients...',
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildPostTreatmentSection(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
  ) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Post-Treatment Instructions', style: context.fonts.black18w600),
          context.verticalSpace(24),
          BuildTextField(
            label: 'Instructions',
            controller: viewModel.postTreatmentInstructionsController,
            hintText: 'Enter aftercare instructions...',
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsSection(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
    CategoryState categoryState,
  ) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Phase Notifications', style: context.fonts.black18w600),
          context.verticalSpace(24),
          const Center(child: Text('Notification management in progress...')),
        ],
      ),
    );
  }

  Widget _buildDowntimeSection(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
    CategoryState categoryState,
  ) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Downtime Level', style: context.fonts.black18w600),
          context.verticalSpace(24),
          CustomDropdown<String>(
            label: 'Level',
            hintText: 'Select',
            value: state.downtimeLevel,
            items: const [
              DropdownMenuItem(value: 'None', child: Text('None')),
              DropdownMenuItem(value: 'Low', child: Text('Low')),
              DropdownMenuItem(value: 'Moderate', child: Text('Moderate')),
              DropdownMenuItem(value: 'High', child: Text('High')),
            ],
            onChanged: (val) {
              if (val != null) {
                viewModel.setDowntimeLevel(val);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRolesSection(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
    CategoryState categoryState,
  ) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Allowed Provider Roles', style: context.fonts.black18w600),
          context.verticalSpace(24),
          const Wrap(
            spacing: 8,
            children: [
              Chip(label: Text('Injector')),
              Chip(label: Text('Aesthetician')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSessionsSection(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
    CategoryState categoryState,
  ) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sessions Setup', style: context.fonts.black18w600),
          context.verticalSpace(24),
          BuildTextField(
            label: 'Total Sessions',
            controller: viewModel.totalSessionsController,
            hintText: '1',
            keyboardType: TextInputType.number,
            onChanged: (val) => viewModel.setTotalSessions(val ?? '1'),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowUpEditSection(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
    WidgetRef ref,
  ) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Follow-Up Configuration', style: context.fonts.black18w600),
          context.verticalSpace(24),
          const Center(child: Text('Follow-up configuration in progress...')),
        ],
      ),
    );
  }

  Widget _buildConsentSection(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
    WidgetRef ref,
  ) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Patient Consent Form', style: context.fonts.black18w600),
          context.verticalSpace(24),
          const Center(child: Text('Consent form management in progress...')),
        ],
      ),
    );
  }

  Widget _buildProtocolsSection(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
    TreatmentDataState dataState,
    WidgetRef ref,
  ) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Clinical Protocols', style: context.fonts.black18w600),
          context.verticalSpace(24),
          const Center(child: Text('Protocol management in progress...')),
        ],
      ),
    );
  }

  Widget _buildLogicSection(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
  ) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Business Logic', style: context.fonts.black18w600),
          context.verticalSpace(24),
          const Center(child: Text('Onboarding settings in progress...')),
        ],
      ),
    );
  }

  Widget _buildSearchField(
    BuildContext context, {
    required String label,
    required String hint,
    required TextEditingController controller,
    required List<String> suggestions,
    required void Function(String) onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.fonts.black14w600),
        context.verticalSpace(10),
        AppSearchField(
          controller: controller,
          hintText: hint,
          onChanged: (val) {
            // Simple suggestion logic
          },
        ),
      ],
    );
  }
}
