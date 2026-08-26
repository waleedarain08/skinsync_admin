import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/clinic_subscription_plan_model.dart';
import 'package:skinsync_admin/models/requests/create_clinic_subscription_plan_request.dart';
import 'package:skinsync_admin/models/subscription_plan_benefit_model.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/utils/validators.dart';
import 'package:skinsync_admin/view_models/clinic_view_model.dart';
import 'package:skinsync_admin/view_models/subscription_view_model.dart';
import 'package:skinsync_admin/widgets/app_search_field.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';
import 'package:skinsync_admin/widgets/custom_outlined_button.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';

import '../models/subscription_duration_option.dart';

class CreateClinicsSubscriptionPlanScreen extends ConsumerStatefulWidget {
  static const String routeName = '/create-clinics-subscription-plan';
  final ClinicSubscriptionPlanModel? planToEdit;

  const CreateClinicsSubscriptionPlanScreen({super.key, this.planToEdit});

  @override
  ConsumerState<CreateClinicsSubscriptionPlanScreen> createState() =>
      _CreateClinicsSubscriptionPlanScreenState();
}

class _CreateClinicsSubscriptionPlanScreenState
    extends ConsumerState<CreateClinicsSubscriptionPlanScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _lifetimePriceController;
  late final TextEditingController _doctorSeatsController;
  late final TextEditingController _staffSeatsController;
  late final TextEditingController _standardCommissionController;
  late final TextEditingController _dynamicCommissionController;
  late final TextEditingController _techFeeController;
  final TextEditingController _customBenefitController =
      TextEditingController();
  final TextEditingController _clinicSearchController = TextEditingController();

  bool _unlimitedDoctors = false;
  bool _unlimitedStaff = false;
  String _visibilityType = 'All Clinics';
  List<int> _selectedClinics = [];
  String _clinicSearchQuery = '';
  bool _isActive = true;
  bool _isDefault = false;
  bool _isLifetime = false;

  final List<String> _predefinedFeatures = [
    'AI consultation and treatment recommendation tools',
    'Before/after simulations',
    'Patient records and treatment history',
    'Payments dashboard',
    'Automated invoices',
    'Dynamic pricing system',
    'Multi-user clinic access',
    'Priority onboarding and support',
  ];

  List<PlanBenefit> _planBenefits = [];
  final List<DurationOptionController> _durationOptions = [];

  bool get isEditMode => widget.planToEdit != null;

  @override
  void initState() {
    super.initState();

    _initFromNormalPlan(widget.planToEdit);
    _initializeBenefits();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(clinicViewModelProvider.notifier).initialize();
    });
  }

  void _initFromNormalPlan(ClinicSubscriptionPlanModel? plan) {
    _nameController = TextEditingController(text: plan?.name);
    _lifetimePriceController = TextEditingController(
      text: plan?.isLifetime == true ? plan?.basePrice?.toString() : '',
    );
    _doctorSeatsController = TextEditingController(
      text: plan?.doctorSeats.toString() ?? '0',
    );
    _staffSeatsController = TextEditingController(
      text: plan?.staffSeats.toString() ?? '0',
    );
    _standardCommissionController = TextEditingController(
      text: plan?.standardBookingCommissionPercent.toString() ?? '0',
    );
    _dynamicCommissionController = TextEditingController(
      text: plan?.dynamicBookingCommissionPercent.toString() ?? '0',
    );
    _techFeeController = TextEditingController(
      text: plan?.technologyFeePerTreatment.toString() ?? '0',
    );

    _unlimitedDoctors = plan?.unlimitedDoctors ?? false;
    _unlimitedStaff = plan?.unlimitedStaff ?? false;
    _isActive = plan?.isActive ?? true;
    _isDefault = plan?.isDefault ?? false;
    _isLifetime = plan?.isLifetime ?? false;

    _selectedClinics = plan?.assignedClinics ?? [];
    _visibilityType =
        _selectedClinics.isEmpty ? 'All Clinics' : 'Specific Clinics';

    if (plan?.durationOptions != null && plan!.durationOptions!.isNotEmpty) {
      for (final option in plan.durationOptions!) {
        _durationOptions.add(
          DurationOptionController.fromOption(option),
        );
      }
    } else if (!_isLifetime) {
      _durationOptions.add(DurationOptionController());
    }
  }

  void _initializeBenefits() {
    final existingBenefits = widget.planToEdit?.benefits ?? [];

    _planBenefits = _predefinedFeatures.map((title) {
      final existing = existingBenefits.firstWhere(
        (b) => b.title == title,
        orElse: () => PlanBenefit(title: title, enabled: false),
      );
      return PlanBenefit(title: title, enabled: existing.enabled);
    }).toList();

    for (final benefit in existingBenefits) {
      if (!_predefinedFeatures.contains(benefit.title)) {
        _planBenefits.add(
          PlanBenefit(title: benefit.title, enabled: benefit.enabled),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lifetimePriceController.dispose();
    _doctorSeatsController.dispose();
    _staffSeatsController.dispose();
    _standardCommissionController.dispose();
    _dynamicCommissionController.dispose();
    _techFeeController.dispose();
    _customBenefitController.dispose();
    _clinicSearchController.dispose();
    for (var option in _durationOptions) {
      option.dispose();
    }
    super.dispose();
  }

  void _addCustomBenefit() {
    final text = _customBenefitController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _planBenefits.add(PlanBenefit(title: text, enabled: true));
        _customBenefitController.clear();
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
        basePrice = double.tryParse(_lifetimePriceController.text) ?? 0.0;
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
        // Use first option price as base price for compatibility if needed, 
        // but backend should ideally use duration_options
        basePrice = durationOptions.isNotEmpty ? durationOptions.first.price : 0.0;
      }

      final request = CreateClinicSubscriptionPlanRequest(
        id: widget.planToEdit?.id,
        name: _nameController.text,
        basePrice: basePrice,
        doctorSeats:
            _unlimitedDoctors
                ? 0
                : (int.tryParse(_doctorSeatsController.text) ?? 0),
        unlimitedDoctors: _unlimitedDoctors,
        staffSeats:
            _unlimitedStaff ? 0 : (int.tryParse(_staffSeatsController.text) ?? 0),
        unlimitedStaff: _unlimitedStaff,
        standardBookingCommissionPercent:
            double.tryParse(_standardCommissionController.text) ?? 0.0,
        dynamicBookingCommissionPercent:
            double.tryParse(_dynamicCommissionController.text) ?? 0.0,
        technologyFeePerTreatment:
            double.tryParse(_techFeeController.text) ?? 0.0,
        benefits: _planBenefits,
        assignedClinics:
            _visibilityType == 'All Clinics' ? [] : _selectedClinics,
        isActive: _isActive,
        isDefault: _isDefault,
        isLifetime: _isLifetime,
        durationOptions: durationOptions,
      );

      final success = await ref
          .read(subscriptionViewModelProvider.notifier)
          .createClinicSubscriptionPlan(request);
      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditMode
                  ? 'Plan updated successfully'
                  : 'Plan created successfully',
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
                      SizedBox(width: 8.w),
                      Text(
                        isEditMode
                            ? 'Edit Subscription Plan'
                            : 'Create Subscription Plan',
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
                      SizedBox(width: 16.w),
                      CustomPrimaryButton(
                        onTap: _submit,
                        label: state.loading ? 'Saving...' : 'Save Plan',
                        width: 180.w,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 32.h),

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
                              'Define the general identity and status of this subscription plan.',
                              style: context.fonts.grey13w500,
                            ),
                            SizedBox(height: 24.h),
                            Row(
                              children: [
                                Expanded(
                                  child: BuildTextField(
                                    label: 'Plan Name',
                                    controller: _nameController,
                                    hintText: 'e.g. Premium Plan',
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
                                context.horizontalSpace(32),
                                const Spacer(),

                                Text(
                                  'Set as Default: ',
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
                                  _isDefault ? 'Default' : 'Not Default',
                                  style: _isDefault
                                      ? context.fonts.green13w500
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
                              ],
                            ),
                            context.verticalSpace(16),
                            if (_isLifetime)
                              BuildTextField(
                                label: 'Lifetime Price (\$)',
                                controller: _lifetimePriceController,
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
                                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                                        items: DurationOptionController.presets.keys.map((String key) {
                                                          return DropdownMenuItem<String>(
                                                            value: key,
                                                            child: Text(key, style: context.fonts.black14w400),
                                                          );
                                                        }).toList(),
                                                        onChanged: (val) {
                                                          setState(() {
                                                            option.setPreset(val!);
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
                                        if (option.presetKey == 'Custom') ...[
                                          context.verticalSpace(16),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: BuildTextField(
                                                  label: 'Custom Name',
                                                  controller: option.nameController,
                                                  hintText: 'e.g. 2 Months',
                                                ),
                                              ),
                                              context.horizontalSpace(16),
                                              Expanded(
                                                child: BuildTextField(
                                                  label: 'Days',
                                                  controller: option.daysController,
                                                  hintText: '60',
                                                  keyboardType: TextInputType.number,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
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
                              'Specify capacity limits for doctors, staff, and usage metrics.',
                              style: context.fonts.grey13w500,
                            ),
                            SizedBox(height: 24.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (!_unlimitedDoctors)
                                  Expanded(
                                    flex: 2,
                                    child: BuildTextField(
                                      label: 'Doctor/Injector Seats',
                                      controller: _doctorSeatsController,
                                      hintText: '0',
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                if (!_unlimitedDoctors)
                                  context.horizontalSpace(24),
                                Expanded(
                                  child: Padding(
                                    padding: context.appEdgeInsets(bottom: 8),
                                    child: _unlimitedToggle(
                                      label: 'Unlimited Doctors',
                                      value: _unlimitedDoctors,
                                      onChanged: (val) {
                                        setState(() {
                                          _unlimitedDoctors = val;
                                          if (val) {
                                            _doctorSeatsController.text = '0';
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
                                if (!_unlimitedStaff)
                                  Expanded(
                                    flex: 2,
                                    child: BuildTextField(
                                      label: 'Staff Seats',
                                      controller: _staffSeatsController,
                                      hintText: '0',
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                if (!_unlimitedStaff)
                                  context.horizontalSpace(24),
                                Expanded(
                                  child: Padding(
                                    padding: context.appEdgeInsets(bottom: 8),
                                    child: _unlimitedToggle(
                                      label: 'Unlimited Staff',
                                      value: _unlimitedStaff,
                                      onChanged: (val) {
                                        setState(() {
                                          _unlimitedStaff = val;
                                          if (val) {
                                            _staffSeatsController.text = '0';
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 32.h),

                            // SECTION 3: COMMISSION & FEES
                            Text(
                              'SECTION 3: COMMISSION & FEES',
                              style: context.fonts.sectionHeading,
                            ),
                            context.verticalSpace(4),
                            Text(
                              'Set the revenue share percentages and technical fees for this plan.',
                              style: context.fonts.grey13w500,
                            ),
                            SizedBox(height: 24.h),
                            Row(
                              children: [
                                Expanded(
                                  child: BuildTextField(
                                    label: 'Standard Booking Commission (%)',
                                    controller: _standardCommissionController,
                                    hintText: '0',
                                    keyboardType: TextInputType.number,
                                    validator: Validators.empty,
                                  ),
                                ),
                                context.horizontalSpace(24),
                                Expanded(
                                  child: BuildTextField(
                                    label: 'Dynamic Pricing Commission (%)',
                                    controller: _dynamicCommissionController,
                                    hintText: '0',
                                    keyboardType: TextInputType.number,
                                    validator: Validators.empty,
                                  ),
                                ),
                              ],
                            ),
                            context.verticalSpace(24),
                            BuildTextField(
                              label: 'Technology Fee Per Booked Treatment (\$)',
                              controller: _techFeeController,
                              hintText: '0.00',
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              validator: Validators.empty,
                            ),
                            SizedBox(height: 32.h),

                            // SECTION 4: PLAN FEATURES & BENEFITS
                            Text(
                              'SECTION 4: PLAN FEATURES & BENEFITS',
                              style: context.fonts.sectionHeading,
                            ),
                            context.verticalSpace(4),
                            Text(
                              'Manage the list of services and features included in this tier.',
                              style: context.fonts.grey13w500,
                            ),
                            SizedBox(height: 24.h),
                            ..._planBenefits.map(
                              (benefit) => CheckboxListTile(
                                title: Text(
                                  benefit.title ?? '',
                                  style: context.fonts.grey14w400,
                                ),
                                value: benefit.enabled,
                                onChanged: (val) {
                                  setState(() {
                                    benefit.enabled = val ?? false;
                                  });
                                },
                                activeColor: CustomColors.green,
                                checkColor: CustomColors.black,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                              ),
                            ),
                            context.verticalSpace(24),
                            Row(
                              children: [
                                Expanded(
                                  child: BuildTextField(
                                    label: 'Add Custom Feature',
                                    controller: _customBenefitController,
                                    hintText: 'e.g. Free marketing kit',
                                  ),
                                ),
                                context.horizontalSpace(16),
                                Padding(
                                  padding: context.appEdgeInsets(top: 28),
                                  child: CustomPrimaryButton(
                                    onTap: _addCustomBenefit,
                                    label: 'Add Feature',
                                    width: context.w(160),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      context.verticalSpace(24),

                      // SECTION 5: PLAN VISIBILITY
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
                            Text(
                              'SECTION 5: PLAN VISIBILITY',
                              style: context.fonts.sectionHeading,
                            ),
                            context.verticalSpace(4),
                            Text(
                              'Define which clinics are eligible to view and select this subscription.',
                              style: context.fonts.grey13w500,
                            ),
                            SizedBox(height: 24.h),
                            _buildVisibilitySectionContent(),
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

  Widget _buildVisibilitySectionContent() {
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
              items: ['All Clinics', 'Specific Clinics'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: context.fonts.black14w400),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _visibilityType = val!;
                  if (_visibilityType == 'All Clinics') _selectedClinics = [];
                });
              },
            ),
          ),
        ),
        if (_visibilityType == 'Specific Clinics') ...[
          context.verticalSpace(24),
          Text('Assign to Clinics', style: context.fonts.black14w600),
          context.verticalSpace(12),
          _buildClinicSelector(),
        ],
      ],
    );
  }

  Widget _buildClinicSelector() {
    final clinics = ref.watch(clinicViewModelProvider).clinics ?? [];
    final filteredClinics =
        clinics.where((c) {
          final name = c.name?.toLowerCase() ?? '';
          final email = c.email?.toLowerCase() ?? '';
          final query = _clinicSearchQuery.toLowerCase();
          return name.contains(query) || email.contains(query);
        }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSearchField(
          controller: _clinicSearchController,
          onChanged: (val) => setState(() => _clinicSearchQuery = val),
          hintText: 'Search clinics by name or email...',
        ),
        context.verticalSpace(16),
        if (_selectedClinics.isNotEmpty) ...[
          Wrap(
            spacing: context.w(8),
            runSpacing: context.h(8),
            children:
                _selectedClinics.map((id) {
                  final clinic = clinics.firstWhere(
                    (c) => c.id == id,
                    orElse: () => clinics.first,
                  );
                  return Chip(
                    label: Text(
                      clinic.name ?? 'ID: $id',
                      style: context.fonts.black13w500,
                    ),
                    backgroundColor: CustomColors.green.withValues(alpha: 0.1),
                    deleteIcon: const Icon(Icons.close, size: 14),
                    onDeleted:
                        () => setState(() => _selectedClinics.remove(id)),
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
          child:
              filteredClinics.isEmpty
                  ? Center(
                    child: Padding(
                      padding: context.appEdgeInsets(all: 16),
                      child: Text(
                        'No clinics found',
                        style: context.fonts.grey14w400,
                      ),
                    ),
                  )
                  : Scrollbar(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: filteredClinics.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final clinic = filteredClinics[index];
                        final isSelected = _selectedClinics.contains(
                          clinic.id,
                        );
                        return CheckboxListTile(
                          title: Text(
                            clinic.name ?? 'N/A',
                            style: context.fonts.grey14w600,
                          ),
                          subtitle: Text(
                            clinic.email ?? 'N/A',
                            style: context.fonts.grey13w500,
                          ),
                          value: isSelected,
                          onChanged: (val) {
                            setState(() {
                              if (val == true) {
                                if (clinic.id != null) _selectedClinics.add(clinic.id!);
                              } else {
                                _selectedClinics.remove(clinic.id);
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

  static const Map<String, int> presets = {
    '1 Month': 30,
    '3 Months': 90,
    '6 Months': 180,
    '1 Year': 365,
    'Custom': 0,
  };

  DurationOptionController({
    String? name,
    int? days,
    double initialPrice = 0.00,
  })  : nameController = TextEditingController(text: name),
        daysController = TextEditingController(text: days?.toString()),
        priceController = TextEditingController(text: initialPrice.toString()),
        presetKey = _determinePresetKey(name, days);

  factory DurationOptionController.fromOption(SubscriptionDurationOption option) {
    return DurationOptionController(
      name: option.name,
      days: option.duration,
      initialPrice: option.price,
    );
  }

  static String _determinePresetKey(String? name, int? days) {
    if (name == null || days == null) return '1 Month';
    for (var entry in presets.entries) {
      if (entry.key == name && entry.value == days) return entry.key;
    }
    return 'Custom';
  }

  void setPreset(String key) {
    presetKey = key;
    if (key != 'Custom') {
      nameController.text = key;
      daysController.text = presets[key].toString();
    }
  }

  String getName() => nameController.text;
  int getDays() => int.tryParse(daysController.text) ?? 0;

  void dispose() {
    nameController.dispose();
    daysController.dispose();
    priceController.dispose();
  }
}
