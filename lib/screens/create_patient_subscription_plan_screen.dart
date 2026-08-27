import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/patient_subscription_plan_model.dart';
import 'package:skinsync_admin/models/requests/create_patient_subscription_plan_request.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/utils/validators.dart';
import 'package:skinsync_admin/view_models/patient_view_model.dart';
import 'package:skinsync_admin/view_models/subscription_view_model.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';
import 'package:skinsync_admin/widgets/custom_outlined_button.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';

import '../models/subscription_duration_model.dart';
import '../models/subscription_duration_option.dart';
import '../widgets/dailogbox/add_benefit_dialog.dart';
import '../widgets/dailogbox/subscription_duration_dialog.dart';

class CreatePatientSubscriptionPlanScreen extends ConsumerStatefulWidget {
  static const String routeName = '/create-patient-subscription-plan';
  final PatientSubscriptionPlanModel? planToEdit;

  const CreatePatientSubscriptionPlanScreen({super.key, this.planToEdit});

  @override
  ConsumerState<CreatePatientSubscriptionPlanScreen> createState() =>
      _CreatePatientSubscriptionPlanScreenState();
}

class _CreatePatientSubscriptionPlanScreenState
    extends ConsumerState<CreatePatientSubscriptionPlanScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _basePriceController;
  late final TextEditingController _simulationCountController;
  late final TextEditingController _postsViewCountController;

  bool _unlimitedSimulations = false;
  bool _unlimitedPostsView = false;
  String _visibilityType = 'All Patients';
  List<int> _selectedPatients = [];
  bool _isActive = true;
  bool _isDefault = false;
  bool _isLifetime = false;

  final List<DurationOptionController> _durationOptions = [];
  List<int> _selectedBenefitIds = [];

  bool get isEditMode => widget.planToEdit != null;

  @override
  void initState() {
    super.initState();
    _initFromModel(widget.planToEdit);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(subscriptionViewModelProvider.notifier)
          .getSubscriptionDurations(showLoading: true);
      
      _syncDurations();

      ref
          .read(subscriptionViewModelProvider.notifier)
          .getBenefits();
          
      if (_visibilityType == 'Specific Patients') {
        ref.read(patientProvider.notifier).getPatients(initialCall: true);
      }
    });
  }

  void _initFromModel(PatientSubscriptionPlanModel? plan) {
    _nameController = TextEditingController(text: plan?.name);
    _basePriceController = TextEditingController(
      text: plan?.isLifetime == true ? plan?.basePrice?.toString() : '',
    );
    _simulationCountController = TextEditingController(
      text: plan?.simulationCount.toString() ?? '0',
    );
    _postsViewCountController = TextEditingController(
      text: plan?.postsViewCount.toString() ?? '0',
    );

    _unlimitedSimulations = plan?.unlimitedSimulations ?? false;
    _unlimitedPostsView = plan?.unlimitedPostsView ?? false;
    _isActive = plan?.isActive ?? true;
    _isDefault = plan?.isDefault ?? false;
    _isLifetime = plan?.isLifetime ?? false;

    _selectedPatients = plan?.assignedPatients?.map((e) => e.patientId!).toList() ?? [];
    _visibilityType = _selectedPatients.isEmpty
        ? 'All Patients'
        : 'Specific Patients';

    _selectedBenefitIds = plan?.benefits?.map((e) => e.id).whereType<int>().toList() ?? [];

    if (plan?.durationOptions != null && plan!.durationOptions!.isNotEmpty) {
      // In Edit mode, we don't have global durations list yet, so we just use what's in the option
      for (final option in plan.durationOptions!) {
        _durationOptions.add(
          DurationOptionController.fromOption(option),
        );
      }
    } else if (!_isLifetime && _durationOptions.isEmpty) {
      // Create mode, will be setup after Load
    }
  }

  void _syncDurations() {
    final durations = ref.read(subscriptionViewModelProvider).durations ?? [];
    if (durations.isEmpty) return;

    setState(() {
      if (_durationOptions.isEmpty && !_isLifetime) {
        _durationOptions.add(DurationOptionController(
          selectedId: durations.first.id,
          durations: durations,
        ));
      } else {
        // Ensure all existing options have a valid selectedId if possible
        for (var option in _durationOptions) {
          if (option.selectedId == null || !durations.any((d) => d.id == option.selectedId)) {
             // If ID is missing from global list, but it's edit mode, maybe it was a bad parse
             // Or keep it as is if it has a value.
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _basePriceController.dispose();
    _simulationCountController.dispose();
    _postsViewCountController.dispose();
    for (final option in _durationOptions) {
      option.dispose();
    }
    super.dispose();
  }

  void _addDurationOption() {
    final durations = ref.read(subscriptionViewModelProvider).durations ?? [];
    if (durations.isEmpty) return;

    // Find next available duration id
    final usedIds = _durationOptions.map((e) => e.selectedId).toSet();
    int? nextId;
    for (final d in durations) {
      if (!usedIds.contains(d.id)) {
        nextId = d.id;
        break;
      }
    }

    setState(() {
      _durationOptions.add(DurationOptionController(
        selectedId: nextId ?? durations.first.id,
        durations: durations,
      ));
    });
  }

  void _removeDurationOption(int index) {
    setState(() {
      _durationOptions[index].dispose();
      _durationOptions.removeAt(index);
    });
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      if (!_isLifetime && _durationOptions.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('At least one duration option is required')),
        );
        return;
      }

      List<SubscriptionDurationOption>? durationOptions;
      double? basePrice;

      if (_isLifetime) {
        basePrice = double.tryParse(_basePriceController.text);
        durationOptions = [];
      } else {
        basePrice = null; 
        final allDurations =
            ref.read(subscriptionViewModelProvider).durations ?? [];
        durationOptions = _durationOptions.map((e) {
          final durationObj = allDurations.firstWhere(
            (d) => d.id == e.selectedId,
            orElse: () => allDurations.first,
          );
          return SubscriptionDurationOption(
            duration: durationObj,
            basePrice: double.tryParse(e.priceController.text) ?? 0.0,
          );
        }).toList();

        if (durationOptions.any((d) => (d.duration?.duration ?? 0) <= 0)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('All durations must be greater than 0 days')),
          );
          return;
        }

        if (Set<int?>.from(durationOptions.map((e) => e.duration?.id)).length !=
            durationOptions.length) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Duplicate duration options are not allowed')),
          );
          return;
        }
      }

      final request = CreatePatientSubscriptionPlanRequest(
        id: widget.planToEdit?.id,
        name: _nameController.text,
        basePrice: basePrice,
        simulationCount: _unlimitedSimulations
            ? 0
            : (int.tryParse(_simulationCountController.text) ?? 0),
        unlimitedSimulations: _unlimitedSimulations,
        postsViewCount: _unlimitedPostsView
            ? 0
            : (int.tryParse(_postsViewCountController.text) ?? 0),
        unlimitedPostsView: _unlimitedPostsView,
        assignedPatients: _visibilityType == 'All Patients'
            ? []
            : _selectedPatients,
        isActive: _isActive,
        isDefault: _isDefault,
        isLifetime: _isLifetime,
        durationOptions: durationOptions,
        benefitIds: _selectedBenefitIds,
      );

      final success = await ref
          .read(subscriptionViewModelProvider.notifier)
          .createPatientSubscriptionPlan(request);
      if ((success ?? false) && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditMode
                  ? 'Patient plan updated successfully'
                  : 'Patient plan created successfully',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(subscriptionViewModelProvider);

    return GradientScaffold(
      body: Padding(
        padding: context.appEdgeInsets(all: 32),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // HEADER ROW
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 20,
                        ),
                      ),
                      context.horizontalSpace(8),
                      Text(
                        isEditMode
                            ? 'Edit Patient Subscription'
                            : 'Create Patient Subscription',
                        style: context.fonts.level2Heading,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      CustomOutlinedButton(
                        onTap: () => context.pop(),
                        label: 'Cancel',
                      ),
                      context.horizontalSpace(16),
                      CustomPrimaryButton(
                        onTap: _submit,
                        label: state.loading ? 'Saving...' : 'Save Plan',
                        width: 180.w,
                      ),
                    ],
                  ),
                ],
              ),
              context.verticalSpace(32),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Form Content in a clean styled container
                      Container(
                        padding: context.appEdgeInsets(all: 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: context.appBorderRadius(all: 16),
                          boxShadow: AppShadows.xs(context),
                          border: Border.all(color: CustomColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // SECTION 1: BASIC INFORMATION
                            Text(
                              'SECTION 1: BASIC INFORMATION',
                              style: context.fonts.sectionHeading,
                            ),
                            context.verticalSpace(4),
                            Text(
                              'Define the general identity and status of this patient subscription plan.',
                              style: context.fonts.grey13w500,
                            ),
                            SizedBox(height: 24.h),
                            Row(
                              children: [
                                Expanded(
                                  child: BuildTextField(
                                    label: 'Plan Name',
                                    controller: _nameController,
                                    hintText: 'e.g. Standard Patient Tier',
                                    validator: Validators.empty,
                                  ),
                                ),
                              ],
                            ),
                            context.verticalSpace(24),
                            Row(
                              children: [
                                Text(
                                  'Plan Status: ',
                                  style: context.fonts.black14w600,
                                ),
                                Transform.scale(
                                  scale: 0.7,
                                  child: Switch.adaptive(
                                    value: _isActive,
                                    onChanged: (val) =>
                                        setState(() => _isActive = val),
                                    activeTrackColor: CustomColors.purple,
                                  ),
                                ),
                                Text(
                                  _isActive ? 'Active' : 'Inactive',
                                  style: _isActive
                                      ? context.fonts.green13w500
                                      : context.fonts.red13w500,
                                ),
                                context.horizontalSpace(24),
                                const Spacer(),
                                // Default toggle
                                Text(
                                  'Default Plan: ',
                                  style: context.fonts.black14w600,
                                ),
                                Transform.scale(
                                  scale: 0.7,
                                  child: Switch.adaptive(
                                    value: _isDefault,
                                    onChanged: (val) =>
                                        setState(() => _isDefault = val),
                                    activeTrackColor: CustomColors.purple,
                                  ),
                                ),
                                Text(
                                  _isDefault ? 'Yes' : 'No',
                                  style: _isDefault
                                      ? context.fonts.purple13w600
                                      : context.fonts.grey13w500,
                                ),
                              ],
                            ),
                            SizedBox(height: 32.h),

                            // DURATION & PRICING
                            Text(
                              'DURATION & PRICING',
                              style: context.fonts.sectionHeading,
                            ),
                            context.verticalSpace(4),
                            Text(
                              'Choose between lifetime access or multiple recurring billing cycles.',
                              style: context.fonts.grey13w500,
                            ),
                            SizedBox(height: 24.h),
                            Row(
                              children: [
                                Text(
                                  'Lifetime Access: ',
                                  style: context.fonts.black14w600,
                                ),
                                Transform.scale(
                                  scale: 0.7,
                                  child: Switch.adaptive(
                                    value: _isLifetime,
                                    onChanged: (val) {
                                      setState(() {
                                        _isLifetime = val;
                                        if (val) {
                                          _durationOptions.clear();
                                        } else if (_durationOptions.isEmpty) {
                                          _durationOptions.add(DurationOptionController(durations: state.durations ?? []));
                                        }
                                      });
                                    },
                                    activeTrackColor: CustomColors.purple,
                                  ),
                                ),
                                Text(
                                  _isLifetime ? 'Enabled' : 'Disabled',
                                  style: _isLifetime
                                      ? context.fonts.purple13w600
                                      : context.fonts.grey13w500,
                                ),
                              ],
                            ),
                            if (_isLifetime) ...[
                              context.verticalSpace(16),
                              BuildTextField(
                                label: 'Base Price (\$)',
                                controller: _basePriceController,
                                hintText: '0.00',
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                validator: Validators.empty,
                              ),
                            ] else ...[
                              context.verticalSpace(24),
                              Row(
                                children: [
                                  Text(
                                    'Duration Options',
                                    style: context.fonts.black14w600,
                                  ),
                                  const Spacer(),
                                  CustomOutlinedButton(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => const SubscriptionDurationDialog(),
                                      );
                                    },
                                    label: 'Create Duration',
                                    icon: Icons.add,
                                    width: 160.w,
                                  ),
                                ],
                              ),
                              context.verticalSpace(16),
                              ...List.generate(_durationOptions.length, (index) {
                                final option = _durationOptions[index];
                                final otherUsedIds = _durationOptions
                                    .where((e) => e != option)
                                    .map((e) => e.selectedId)
                                    .toSet();

                                return Padding(
                                  padding: context.appEdgeInsets(bottom: 16),
                                  child: BorderdContainerWidget(
                                    padding: context.appEdgeInsets(all: 16),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Duration Option',
                                                    style: context.fonts.black13w600,
                                                  ),
                                                  context.verticalSpace(8),
                                                  Container(
                                                    height: AppTheme.inputHeight,
                                                    padding: context.appEdgeInsets(horizontal: 12),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(color: CustomColors.border),
                                                      borderRadius: context.borderRadius(all: 12),
                                                    ),
                                                    child: DropdownButtonHideUnderline(
                                                      child: DropdownButton<int>(
                                                        value: state.durations?.any((d) => d.id == option.selectedId) == true 
                                                            ? option.selectedId 
                                                            : null,
                                                        isExpanded: true,
                                                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                                                        items: [
                                                          ...({
                                                            for (var d in (state.durations ?? []))
                                                              if (d.id != null &&
                                                                  (d.id == option.selectedId ||
                                                                      !otherUsedIds.contains(d.id)))
                                                                d.id!: d
                                                          })
                                                              .values
                                                              .map((d) => DropdownMenuItem<int>(
                                                                    value: d.id,
                                                                    child: Text(d.name ?? '',
                                                                        style: context.fonts.black14w400),
                                                                  )),
                                                        ],
                                                        onChanged: (val) {
                                                          setState(() {
                                                            option.selectedId = val;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            context.horizontalSpace(16),
                                            Expanded(
                                              flex: 2,
                                              child: BuildTextField(
                                                label: 'Price (\$)',
                                                controller: option.priceController,
                                                hintText: '0.00',
                                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                              ),
                                            ),
                                            context.horizontalSpace(16),
                                            IconButton(
                                              onPressed: () => _removeDurationOption(index),
                                              icon: const Icon(Icons.delete_outline_rounded, color: CustomColors.red),
                                              padding: EdgeInsets.zero,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                              context.verticalSpace(8),
                              if ((state.durations?.length ?? 0) > _durationOptions.length)
                                CustomOutlinedButton(
                                  onTap: _addDurationOption,
                                  label: 'Add Duration',
                                  width: context.w(160),
                                  icon: Icons.add,
                                ),
                            ],
                            SizedBox(height: 32.h),

                            // SECTION 2: PLAN LIMITS
                            Text(
                              'SECTION 2: PLAN LIMITS',
                              style: context.fonts.sectionHeading,
                            ),
                            context.verticalSpace(4),
                            Text(
                              'Set usage limits for simulations and post views for patients.',
                              style: context.fonts.grey13w500,
                            ),
                            SizedBox(height: 24.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (!_unlimitedSimulations)
                                  Expanded(
                                    flex: 2,
                                    child: BuildTextField(
                                      label: 'Simulation Count',
                                      controller: _simulationCountController,
                                      hintText: 'Quantity',
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                if (!_unlimitedSimulations)
                                  context.horizontalSpace(24),
                                Expanded(
                                  child: Padding(
                                    padding: context.appEdgeInsets(bottom: 8),
                                    child: _unlimitedToggle(
                                      label: 'Unlimited Simulations',
                                      value: _unlimitedSimulations,
                                      onChanged: (val) {
                                        setState(() {
                                          _unlimitedSimulations = val;
                                          if (val) {
                                            _simulationCountController.text =
                                                '0';
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            context.verticalSpace(24),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (!_unlimitedPostsView)
                                  Expanded(
                                    flex: 2,
                                    child: BuildTextField(
                                      label: 'Posts View Count',
                                      controller: _postsViewCountController,
                                      hintText: 'Quantity',
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                if (!_unlimitedPostsView)
                                  context.horizontalSpace(24),
                                Expanded(
                                  child: Padding(
                                    padding: context.appEdgeInsets(bottom: 8),
                                    child: _unlimitedToggle(
                                      label: 'Unlimited Posts View',
                                      value: _unlimitedPostsView,
                                      onChanged: (val) {
                                        setState(() {
                                          _unlimitedPostsView = val;
                                          if (val) {
                                            _postsViewCountController.text =
                                                '0';
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 32.h),

                            // SECTION 3: PLAN FEATURES & BENEFITS
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'SECTION 3: PLAN FEATURES & BENEFITS',
                                      style: context.fonts.sectionHeading,
                                    ),
                                    context.verticalSpace(4),
                                    Text(
                                      'Manage the list of services and features included in this tier.',
                                      style: context.fonts.grey13w500,
                                    ),
                                  ],
                                ),
                                CustomOutlinedButton(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => const AddBenefitDialog(),
                                    );
                                  },
                                  label: 'Create Benefit',
                                  icon: Icons.add,
                                  width: 160.w,
                                ),
                              ],
                            ),
                            SizedBox(height: 24.h),
                            if (state.patientBenefits != null && state.patientBenefits!.isNotEmpty)
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: context.w(16),
                                  mainAxisSpacing: context.h(16),
                                  childAspectRatio: 2.2,
                                ),
                                itemCount: state.patientBenefits!.length,
                                itemBuilder: (context, index) {
                                  final benefit = state.patientBenefits![index];
                                  final isSelected = _selectedBenefitIds.contains(benefit.id);
                                  
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (isSelected) {
                                          _selectedBenefitIds.remove(benefit.id);
                                        } else {
                                          if (benefit.id != null) _selectedBenefitIds.add(benefit.id!);
                                        }
                                      });
                                    },
                                    borderRadius: context.borderRadius(all: 12),
                                    child: BorderdContainerWidget(
                                      backgroundColor: isSelected 
                                          ? CustomColors.green.withValues(alpha: 0.05) 
                                          : Colors.white,
                                      borderColor: isSelected ? CustomColors.green : CustomColors.border,
                                      borderWidth: isSelected ? 1.5 : 1,
                                      padding: context.appEdgeInsets(all: 16),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: context.appEdgeInsets(top: 2),
                                            child: Icon(
                                              isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                                              color: isSelected ? CustomColors.green : CustomColors.grey,
                                              size: 20,
                                            ),
                                          ),
                                          context.horizontalSpace(12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  benefit.title ?? '',
                                                  style: context.fonts.black14w600,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                context.verticalSpace(4),
                                                Text(
                                                  'SKU: ${benefit.sku ?? "N/A"}',
                                                  style: context.fonts.purple10w600,
                                                ),
                                                context.verticalSpace(4),
                                                Expanded(
                                                  child: Text(
                                                    benefit.description ?? '',
                                                    style: context.fonts.grey11w400,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            else
                              Center(
                                child: Padding(
                                  padding: context.appEdgeInsets(all: 16),
                                  child: Text(
                                    'No benefits available to select.',
                                    style: context.fonts.grey13w500,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _unlimitedToggle({
    required String label,
    required bool value,
    required void Function(bool) onChanged,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.scale(
          scale: 0.7,
          child: Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: CustomColors.purple,
          ),
        ),
        context.horizontalSpace(4),
        Text(label, style: context.fonts.grey13w600),
      ],
    );
  }
}

class DurationOptionController {
  final TextEditingController priceController;
  int? selectedId;

  DurationOptionController({
    this.selectedId,
    double initialPrice = 0.00,
    List<SubscriptionDuration> durations = const [],
  })  : priceController = TextEditingController(text: initialPrice.toString()) {
    if (selectedId == null && durations.isNotEmpty) {
      selectedId = durations.first.id;
    }
  }

  factory DurationOptionController.fromOption(
      SubscriptionDurationOption option) {
    return DurationOptionController(
      selectedId: option.duration?.id,
      initialPrice: option.basePrice ?? 0.0,
    );
  }

  void dispose() {
    priceController.dispose();
  }
}
