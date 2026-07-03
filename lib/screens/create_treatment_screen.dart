import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/treatment_data_models.dart';
import '../utils/theme.dart';
import '../view_models/area_view_model.dart';
import '../view_models/category_view_model.dart';
import '../view_models/product_view_model.dart';
import '../view_models/treatment_data_view_model.dart';
import '../view_models/treatment_view_model.dart';
import '../widgets/custom_outlined_button.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/session_creation_steps/treatment_creation_steps.dart';

class CreateTreatmentScreen extends ConsumerStatefulWidget {
  const CreateTreatmentScreen({super.key});

  static const String routeName = '/create-treatment';

  @override
  ConsumerState<CreateTreatmentScreen> createState() =>
      _CreateTreatmentScreenState();
}

class _CreateTreatmentScreenState extends ConsumerState<CreateTreatmentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(categoryViewModelProvider.notifier).fetchCategories();
      ref.read(productViewModelProvider.notifier).fetchProducts();
      await ref.read(areaViewModelProvider.notifier).fetchAreas();
      final fetchedAreas = ref.read(areaViewModelProvider).areas;
      ref
          .read(treatmentDataViewModelProvider.notifier)
          .setAreasFromBackend(fetchedAreas);
    });
  }

  int _getStepIndex(int currentStep) {
    return currentStep;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(treatmentViewModelProvider);
    final viewModel = ref.read(treatmentViewModelProvider.notifier);
    final dataState = ref.watch(treatmentDataViewModelProvider);
    final categoryState = ref.watch(categoryViewModelProvider);

    final int stepIndex = _getStepIndex(state.currentStep);

    return GradientScaffold(
      appBar: AppBar(
        flexibleSpace: AppDecorations.appBarGradient,
        elevation: 0,
        centerTitle: true,
        title: Text('Treatment Builder', style: context.fonts.black18w600),
        leading: IconButton(
          icon: const Icon(Icons.close, color: CustomColors.black),
          onPressed: () {
            viewModel.resetForm();
            context.pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(
          horizontal: 24,
          vertical: 32,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: context.w(900),
            ),
            child: Column(
              children: [
                _buildUpperStepper(context, stepIndex),
                context.verticalSpace(36),
                _buildStepHeader(context, stepIndex),
                context.verticalSpace(32),
                Container(
                  padding: context.appEdgeInsets(all: 32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: context.appBorderRadius(all: 16),
                    border: Border.all(color: CustomColors.border),
                    boxShadow: AppShadows.card(context),
                  ),
                  child: _buildCurrentStepContent(
                    context,
                    state,
                    viewModel,
                    dataState,
                    categoryState,
                    ref,
                  ),
                ),
                context.verticalSpace(48),
                _buildActionButtons(
                  context,
                  state,
                  viewModel,
                  dataState,
                  categoryState,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUpperStepper(BuildContext context, int stepIndex) {
    final steps = [
      {'title': 'Categorization', 'icon': Icons.category_outlined},
      {'title': 'Basic Info', 'icon': Icons.description_outlined},
      {'title': 'Body Areas', 'icon': Icons.accessibility_new_outlined},
      {'title': 'Sessions Setup', 'icon': Icons.event_repeat_rounded},
      {'title': 'Business Logic', 'icon': Icons.settings_suggest_outlined},
    ];

    final bool isCompact = context.screenWidth < 1100;

    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: context.appEdgeInsets(horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(steps.length, (index) {
              final step = steps[index];
              final bool isActive = stepIndex == index;
              final bool isCompleted = stepIndex > index;

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Step circle with Icon/Number
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: context.w(36),
                    height: context.w(36),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? CustomColors.green
                          : (isActive ? CustomColors.purple : Colors.white),
                      border: Border.all(
                        color: isActive || isCompleted
                            ? Colors.transparent
                            : CustomColors.border,
                        width: 2,
                      ),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: CustomColors.purple.withValues(alpha: 0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(Icons.check, color: Colors.white, size: 18)
                          : Icon(
                              step['icon'] as IconData,
                              color: isActive ? Colors.white : CustomColors.grey,
                              size: 18,
                            ),
                    ),
                  ),
                  if (!isCompact || isActive) ...[
                    context.horizontalSpace(8),
                    // Step Title
                    Text(
                      step['title'] as String,
                      style: isActive
                          ? context.fonts.purple14w600
                          : (isCompleted
                              ? context.fonts.black14w600
                              : context.fonts.grey14w500),
                    ),
                  ],
                  // Connector line (except for the last step)
                  if (index < steps.length - 1) ...[
                    context.horizontalSpace(isCompact ? 8 : 16),
                    Container(
                      width: context.w(isCompact ? 24 : 40),
                      height: 2,
                      color: isCompleted ? CustomColors.green : CustomColors.border,
                    ),
                    context.horizontalSpace(isCompact ? 8 : 16),
                  ],
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildStepHeader(BuildContext context, int stepIndex) {
    final titles = [
      'Categorization',
      'Basic Information',
      'Body Areas',
      'Sessions Setup',
      'Business Logic',
    ];
    final descriptions = [
      'Organize treatments to help patients and staff find them easily.',
      'Core identification details including status.',
      'Define mandatory sub-areas.',
      'Manage total sessions and procedural frequency.',
      'Manage system-wide treatment behaviors and onboarding settings.',
    ];
    final icons = [
      Icons.category_outlined,
      Icons.description_outlined,
      Icons.accessibility_new_outlined,
      Icons.event_repeat_rounded,
      Icons.settings_suggest_outlined,
    ];

    if (stepIndex < 0 || stepIndex >= titles.length) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: context.appEdgeInsets(all: 12),
              decoration: BoxDecoration(
                color: CustomColors.purple.withValues(alpha: 0.1),
                borderRadius: context.appBorderRadius(all: 12),
              ),
              child: Icon(
                icons[stepIndex],
                color: CustomColors.purple,
                size: 24,
              ),
            ),
            context.horizontalSpace(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titles[stepIndex],
                    style: context.fonts.black20w600,
                  ),
                  Text(
                    descriptions[stepIndex],
                    style: context.fonts.grey14w400,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCurrentStepContent(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
    TreatmentDataState dataState,
    CategoryState categoryState,
    WidgetRef ref,
  ) {
    switch (state.currentStep) {
      case 0:
        return const CategoryStep();
      case 1:
        return const TreatmentSelectionStep();
      case 2:
        return const AreasStep();
      case 3:
        return const SessionsStep();
      case 4:
        return const LogicStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildActionButtons(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
    TreatmentDataState dataState,
    CategoryState categoryState,
  ) {
    return Row(
      children: [
        if (state.currentStep > 0) ...[
          Expanded(
            child: CustomOutlinedButton(
              onTap: () {
                viewModel.setStep(state.currentStep - 1);
              },
              label: 'Previous Step',
            ),
          ),
          context.horizontalSpace(16),
        ],
        Expanded(
          flex: 2,
          child: CustomPrimaryButton(
            onTap: () async {
              if (state.currentStep == 0) {
                final success = await _validateAndFetchCategory(
                  context,
                  state,
                  viewModel,
                  categoryState,
                );
                if (success) {
                  viewModel.setStep(1);
                }
                return;
              }

              if (!mounted) return;

              // ignore: use_build_context_synchronously
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              if (state.currentStep == 1) {
                // If they have selected an existing treatment, bypass validation
                if (state.selectedTreatment == null) {
                  if (!_validateStepDetails(scaffoldMessenger, viewModel, state)) return;
                }
                viewModel.setStep(2);
                return;
              }

              if (state.currentStep == 2) {
                if (!_validateSubAreas(scaffoldMessenger, state)) return;
                viewModel.setStep(3);
                return;
              }

              if (state.currentStep == 3) {
                final bool allSessionsDetailed = state.sessions.isNotEmpty &&
                    state.sessions.every((s) => s.isDetailedEntered);

                if (!allSessionsDetailed) {
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(
                      content: Text('Please enter details for all sessions before continuing.'),
                      backgroundColor: CustomColors.red,
                    ),
                  );
                  return;
                }

                // If all sessions are configured, let's proceed to Business Logic (Step 4)
                viewModel.setStep(4);
                return;
              }

              if (state.currentStep == 4) {
                viewModel.submitTreatment(
                  context,
                  categories: categoryState.categories,
                ).then((_) {
                  if (context.mounted) {
                    context.go('/treatment-management');
                  }
                });
              }
            },
            label: state.currentStep == 4 ? 'Finish & Create Treatment' : 'Next Step',
          ),
        ),
      ],
    );
  }

  Future<bool> _validateAndFetchCategory(
    BuildContext context,
    TreatmentState state,
    TreatmentViewModel viewModel,
    CategoryState categoryState,
  ) async {
    final categoryIdStr = viewModel.categoryIdController.text;
    if (categoryIdStr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category.'),
          backgroundColor: CustomColors.red,
        ),
      );
      return false;
    }

    final categoryId = int.tryParse(categoryIdStr);
    if (categoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category.'),
          backgroundColor: CustomColors.red,
        ),
      );
      return false;
    }

    CategoryModel? findCategory(List<CategoryModel> list, int id) {
      for (final cat in list) {
        if (cat.id == id) return cat;
        final nested = findCategory(cat.subCategories, id);
        if (nested != null) return nested;
      }
      return null;
    }

    final selectedNode = findCategory(categoryState.categories, categoryId);
    if (selectedNode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category.'),
          backgroundColor: CustomColors.red,
        ),
      );
      return false;
    }

    if (selectedNode.subCategories.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a subcategory.'),
          backgroundColor: CustomColors.red,
        ),
      );
      return false;
    }

    try {
      final success = await viewModel.fetchAndPopulateCategoryDefaults(
        categoryId,
      );
      if (!success) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Unable to load category configuration. Please try again.',
              ),
              backgroundColor: CustomColors.red,
            ),
          );
        }
        return false;
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Unable to load category configuration. Please try again.',
            ),
            backgroundColor: CustomColors.red,
          ),
        );
      }
      return false;
    }

    return true;
  }

  bool _validateStepDetails(
    ScaffoldMessengerState scaffoldMessenger,
    TreatmentViewModel viewModel,
    TreatmentState state,
  ) {
    final skuError = viewModel.validateGlobalSku(
      viewModel.globalSkuController.text.trim(),
    );
    if (skuError != null) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(skuError), backgroundColor: CustomColors.red),
      );
      return false;
    }
    if (viewModel.displayNameController.text.trim().isEmpty) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Please enter Patient Display Name'),
          backgroundColor: CustomColors.red,
        ),
      );
      return false;
    }
    if (state.treatmentImageUrl == null || state.treatmentImageUrl!.isEmpty) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Please upload a Treatment Banner Image'),
          backgroundColor: CustomColors.red,
        ),
      );
      return false;
    }
    if (state.treatmentIconUrl == null || state.treatmentIconUrl!.isEmpty) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Please upload a Treatment Listing Icon'),
          backgroundColor: CustomColors.red,
        ),
      );
      return false;
    }
    if (viewModel.shortDescriptionController.text.trim().isEmpty) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Please enter a Short Description'),
          backgroundColor: CustomColors.red,
        ),
      );
      return false;
    }
    if (viewModel.fullDescriptionController.text.trim().isEmpty) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Please enter a Full Description'),
          backgroundColor: CustomColors.red,
        ),
      );
      return false;
    }
    return true;
  }

  bool _validateSubAreas(ScaffoldMessengerState scaffoldMessenger, TreatmentState state) {
    for (final area in state.areas) {
      if (area.subAreas.isEmpty) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(
              "Please select at least one sub-area for '${area.areaController.text}'",
            ),
            backgroundColor: CustomColors.red,
          ),
        );
        return false;
      }
    }
    return true;
  }
}
