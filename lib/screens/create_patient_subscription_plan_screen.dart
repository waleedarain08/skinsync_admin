import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/patient_subscription_plan_model.dart';
import 'package:skinsync_admin/models/requests/create_patient_subscription_plan_request.dart';
import 'package:skinsync_admin/models/subscription_plan_benefit_model.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/utils/validators.dart';
import 'package:skinsync_admin/view_models/patient_view_model.dart';
import 'package:skinsync_admin/view_models/subscription_view_model.dart';
import 'package:skinsync_admin/widgets/app_search_field.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';
import 'package:skinsync_admin/widgets/custom_outlined_button.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';

import '../models/responses/patient_list_response.dart';
import '../models/subscription_duration_model.dart';
import '../models/subscription_duration_option.dart';
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
  final TextEditingController _customBenefitController =
      TextEditingController();
  final TextEditingController _customDescriptionController =
      TextEditingController();
  final TextEditingController _patientSearchController =
      TextEditingController();

  bool _unlimitedSimulations = false;
  bool _unlimitedPostsView = false;
  String _visibilityType = 'All Patients';
  List<int> _selectedPatients = [];
  String _patientSearchQuery = '';
  bool _isActive = true;
  bool _isDefault = false;
  bool _isLifetime = false;

  final List<DurationOptionController> _durationOptions = [];

  final List<PlanBenefit> _predefinedFeatures = [
    PlanBenefit(
        title: 'AI skin analysis and consultation',
        description:
            'Advanced AI-powered analysis for skin conditions and personalized consultation.',
        enabled: false),
    PlanBenefit(
        title: 'Personalized treatment tracking',
        description:
            'Track your treatment progress with customized plans and reminders.',
        enabled: false),
    PlanBenefit(
        title: 'Before/after simulation access',
        description:
            'Visualize potential results with high-quality before and after simulations.',
        enabled: false),
    PlanBenefit(
        title: 'Secure medical records storage',
        description:
            'Safe and encrypted storage for all your medical history and treatment records.',
        enabled: false),
    PlanBenefit(
        title: 'Direct booking with specialists',
        description:
            'Skip the queue and book appointments directly with top skin specialists.',
        enabled: false),
    PlanBenefit(
        title: 'Priority treatment scheduling',
        description:
            'Get priority access to treatment slots and faster scheduling.',
        enabled: false),
    PlanBenefit(
        title: 'Exclusive discounts on treatments',
        description:
            'Access special member-only pricing and discounts on various skin treatments.',
        enabled: false),
    PlanBenefit(
        title: 'Access to community educational content',
        description:
            'Educational materials and community forum access for skin care tips.',
        enabled: false),
  ];

  List<PlanBenefit> _planBenefits = [];

  bool get isEditMode => widget.planToEdit != null;

  @override
  void initState() {
    super.initState();
    _initFromModel(widget.planToEdit);
    _initializeBenefits();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(subscriptionViewModelProvider.notifier)
          .getSubscriptionDurations(showLoading: true);
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

    if (plan?.durationOptions != null && plan!.durationOptions!.isNotEmpty) {
      final durations = ref.read(subscriptionViewModelProvider).durations ?? [];
      for (final option in plan.durationOptions!) {
        _durationOptions.add(
          DurationOptionController.fromOption(option, durations),
        );
      }
    } else if (!_isLifetime) {
      _durationOptions.add(DurationOptionController());
    }
  }

  void _initializeBenefits() {
    final existingBenefits = widget.planToEdit?.benefits ?? [];

    _planBenefits = _predefinedFeatures.map((benefit) {
      final existing = existingBenefits.firstWhere(
        (b) => b.title == benefit.title,
        orElse: () => benefit,
      );
      return PlanBenefit(
          title: benefit.title,
          description: (existing.description != null && existing.description!.isNotEmpty) 
              ? existing.description 
              : benefit.description,
          enabled: existing.enabled);
    }).toList();

    for (final benefit in existingBenefits) {
      if (!_predefinedFeatures.any((b) => b.title == benefit.title)) {
        _planBenefits.add(
          PlanBenefit(
              title: benefit.title,
              description: benefit.description,
              enabled: benefit.enabled),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _basePriceController.dispose();
    _simulationCountController.dispose();
    _postsViewCountController.dispose();
    _customBenefitController.dispose();
    _customDescriptionController.dispose();
    _patientSearchController.dispose();
    for (var option in _durationOptions) {
      option.dispose();
    }
    super.dispose();
  }

  void _addCustomBenefit() {
    final title = _customBenefitController.text.trim();
    final description = _customDescriptionController.text.trim();
    if (title.isNotEmpty) {
      setState(() {
        _planBenefits.add(
            PlanBenefit(title: title, description: description, enabled: true));
        _customBenefitController.clear();
        _customDescriptionController.clear();
      });
    }
  }

  void _addDurationOption() {
    setState(() {
      _durationOptions.add(DurationOptionController());
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
        basePrice = double.tryParse(_basePriceController.text) ?? 0.0;
      } else {
        durationOptions = _durationOptions.map((e) {
          return SubscriptionDurationOption(
            name: e.getName(),
            duration: e.getDays(),
            price: double.tryParse(e.priceController.text) ?? 0.0,
          );
        }).toList();

        if (durationOptions.any((d) => d.duration <= 0)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('All durations must be greater than 0 days')),
          );
          return;
        }

        if (Set.from(durationOptions.map((e) => e.duration)).length != durationOptions.length) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Duplicate duration options are not allowed')),
          );
          return;
        }
        basePrice = durationOptions.isNotEmpty ? durationOptions.first.price : 0.0;
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
        benefits: _planBenefits,
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
                                          _durationOptions.add(DurationOptionController());
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
                            if (_isLifetime)
                              BuildTextField(
                                label: 'Base Price (\$)',
                                controller: _basePriceController,
                                hintText: '0.00',
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                validator: Validators.empty,
                              )
                            else ...[
                              ...List.generate(_durationOptions.length, (index) {
                                final option = _durationOptions[index];
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
                                                      child: DropdownButton<String>(
                                                        value: option.presetKey,
                                                        isExpanded: true,
                                                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                                                        items: [
                                                          ...state.durations?.map((d) => DropdownMenuItem<String>(
                                                            value: d.name ?? '',
                                                            child: Text(d.name ?? '', style: context.fonts.black14w400),
                                                          )) ?? [],
                                                        ],
                                                        onChanged: (val) {
                                                          setState(() {
                                                            option.setPreset(val!, state.durations ?? []);
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
                           // SizedBox(height: 32.h),

                            // SECTION 3: PLAN FEATURES & BENEFITS
                            // Text(
                            //   'SECTION 3: PLAN FEATURES & BENEFITS',
                            //   style: context.fonts.sectionHeading,
                            // ),
                            // context.verticalSpace(4),
                            // Text(
                            //   'Manage the list of services and features included in this tier.',
                            //   style: context.fonts.grey13w500,
                            // ),
                            // SizedBox(height: 24.h),
                            // ..._planBenefits.map(
                            //   (benefit) => CheckboxListTile(
                            //     title: Text(
                            //       benefit.title ?? '',
                            //       style: context.fonts.black14w600,
                            //     ),
                            //     subtitle: benefit.description != null &&
                            //             benefit.description!.isNotEmpty
                            //         ? Text(
                            //             benefit.description!,
                            //             style: context.fonts.grey13w500,
                            //             maxLines: 2,
                            //             overflow: TextOverflow.ellipsis,
                            //           )
                            //         : null,
                            //     value: benefit.enabled,
                            //     onChanged: (val) {
                            //       setState(() {
                            //         benefit.enabled = val ?? false;
                            //       });
                            //     },
                            //     activeColor: CustomColors.green,
                            //     checkColor: CustomColors.black,
                            //     controlAffinity:
                            //         ListTileControlAffinity.leading,
                            //     contentPadding: EdgeInsets.zero,
                            //     dense: false,
                            //   ),
                            // ),
                            // context.verticalSpace(24),
                            // Row(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     Expanded(
                            //       child: Column(
                            //         children: [
                            //           BuildTextField(
                            //             label: 'Feature Title',
                            //             controller: _customBenefitController,
                            //             hintText: 'e.g. Free marketing kit',
                            //           ),
                            //           context.verticalSpace(16),
                            //           BuildTextField(
                            //             label: 'Feature Description (Optional)',
                            //             controller:
                            //                 _customDescriptionController,
                            //             hintText: 'Provide more details...',
                            //             maxLines: 2,
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //     context.horizontalSpace(16),
                            //     Padding(
                            //       padding: context.appEdgeInsets(top: 28),
                            //       child: CustomPrimaryButton(
                            //         onTap: _addCustomBenefit,
                            //         label: 'Add Feature',
                            //         width: context.w(160),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                         
                          ],
                        ),
                      ),
                    //  context.verticalSpace(24),

                      // // SECTION 4: PLAN VISIBILITY
                      // Container(
                      //   padding: context.appEdgeInsets(all: 24),
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: context.appBorderRadius(all: 16),
                      //     boxShadow: AppShadows.xs(context),
                      //     border: Border.all(color: CustomColors.border),
                      //   ),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Text(
                      //         'SECTION 4: PLAN VISIBILITY',
                      //         style: context.fonts.sectionHeading,
                      //       ),
                      //       context.verticalSpace(4),
                      //       Text(
                      //         'Control which patients are eligible for this specific subscription tier.',
                      //         style: context.fonts.grey13w500,
                      //       ),
                      //       SizedBox(height: 24.h),
                      //       _buildVisibilitySectionContent(),
                      //     ],
                      //   ),
                      // ),
                  
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

 Widget _buildVisibilitySectionContent() {
  return Consumer(
    builder: (context, ref, _) {
      ref.watch(patientProvider); // keeps the provider alive for as long as this widget is mounted, regardless of _visibilityType
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Target Availability', style: context.fonts.black14w600),
          context.verticalSpace(12),
          Container(
           height: AppTheme.inputHeight,
          padding: context.appEdgeInsets(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: CustomColors.border),
            borderRadius: context.borderRadius(all: 12),
          ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _visibilityType,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                items: ['All Patients', 'Specific Patients'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: context.fonts.black14w400),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _visibilityType = val!;
                    if (_visibilityType == 'All Patients') {
                      _selectedPatients = [];
                    } else if (_visibilityType == 'Specific Patients') {
                      // safe now — watcher already exists from the top of this builder
                      ref.read(patientProvider.notifier).getPatients(initialCall: true);
                    }
                  });
                },
              ),
            ),
          ),
          if (_visibilityType == 'Specific Patients') ...[
            context.verticalSpace(24),
            Text('Assign to Patients', style: context.fonts.black14w600),
            context.verticalSpace(12),
            _buildPatientSelector(),
          ],
        ],
      );
    },
  );
}
  Widget _buildPatientSelector() {
    final patientState = ref.watch(patientProvider);
    final filteredPatients = patientState.patients.where((p) {
      final query = _patientSearchQuery.toLowerCase();
      return (p.patientName?.toLowerCase().contains(query) ?? false) || 
             (p.email?.toLowerCase().contains(query) ?? false);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSearchField(
          controller: _patientSearchController,
          onChanged: (val) => setState(() => _patientSearchQuery = val),
          hintText: 'Search patients by name or email...',
        ),
        context.verticalSpace(16),
        if (_selectedPatients.isNotEmpty) ...[
          Wrap(
            spacing: context.w(8),
            runSpacing: context.h(8),
            children: _selectedPatients.map((id) {
              final patient = patientState.patients.firstWhere(
                (p) => p.id == id,
                orElse: () => PatientData(id: id, patientName: 'ID: $id'),
              );
              return Chip(
                label: Text(patient.patientName ?? 'N/A', style: context.fonts.black13w500),
                backgroundColor: CustomColors.green.withValues(alpha: 0.1),
                deleteIcon: const Icon(Icons.close, size: 14),
                onDeleted: () => setState(() => _selectedPatients.remove(id)),
                shape: RoundedRectangleBorder(
                  borderRadius: context.borderRadius(all: 8),
                  side: BorderSide.none,
                ),
              );
            }).toList(),
          ),
          context.verticalSpace(16),
        ],
        Container(
          constraints: BoxConstraints(maxHeight: context.h(250)),
          decoration: BoxDecoration(
            border: Border.all(color: CustomColors.border),
            borderRadius: context.borderRadius(all: 12),
          ),
          child: patientState.loading 
              ? const Center(child: CircularProgressIndicator())
              : filteredPatients.isEmpty
              ? Center(
                  child: Padding(
                    padding: context.appEdgeInsets(all: 16),
                    child: Text(
                      'No patients found',
                      style: context.fonts.grey14w400,
                    ),
                  ),
                )
              : Scrollbar(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: filteredPatients.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final patient = filteredPatients[index];
                      final isSelected = _selectedPatients.contains(patient.id);
                      return CheckboxListTile(
                        title: Text(patient.patientName ?? 'N/A', style: context.fonts.grey14w600),
                        subtitle: Text(patient.email ?? '', style: context.fonts.grey12w400),
                        value: isSelected,
                        onChanged: (val) {
                          setState(() {
                            if (val == true) {
                              if (patient.id != null) _selectedPatients.add(patient.id!);
                            } else {
                              _selectedPatients.remove(patient.id);
                            }
                          });
                        },
                        activeColor: CustomColors.green,
                        checkColor: CustomColors.black,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: context.appEdgeInsets(horizontal: 16),
                      );
                    },
                  ),
                ),
        ),
      ],
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
  final TextEditingController nameController;
  final TextEditingController daysController;
  final TextEditingController priceController;
  String presetKey;

  DurationOptionController({
    String? name,
    int? days,
    double initialPrice = 0.00,
    List<SubscriptionDuration> durations = const [],
  })  : nameController = TextEditingController(text: name),
        daysController = TextEditingController(text: days?.toString()),
        priceController = TextEditingController(text: initialPrice.toString()),
        presetKey = determinePresetKey(name, days, durations);

  factory DurationOptionController.fromOption(
      SubscriptionDurationOption option, List<SubscriptionDuration> durations) {
    return DurationOptionController(
      name: option.name,
      days: option.duration,
      initialPrice: option.price,
      durations: durations,
    );
  }

  static String determinePresetKey(
      String? name, int? days, List<SubscriptionDuration> durations) {
    if (name == null || days == null) {
      return durations.isNotEmpty ? (durations.first.name ?? '') : '';
    }
    for (var d in durations) {
      if (d.name == name && d.duration == days) return d.name!;
    }
    return durations.isNotEmpty ? (durations.first.name ?? '') : '';
  }

  void setPreset(String key, List<SubscriptionDuration> durations) {
    presetKey = key;
    final match = durations.firstWhere((d) => d.name == key,
        orElse: () => durations.first);
    nameController.text = match.name ?? '';
    daysController.text = (match.duration ?? 0).toString();
  }

  String getName() => nameController.text;
  int getDays() => int.tryParse(daysController.text) ?? 0;

  void dispose() {
    nameController.dispose();
    daysController.dispose();
    priceController.dispose();
  }
}
