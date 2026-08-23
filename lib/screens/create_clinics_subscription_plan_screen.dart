import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/requests/create_subscription_plan_request.dart';
import 'package:skinsync_admin/models/subscription_plan_model.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/utils/validators.dart';
import 'package:skinsync_admin/view_models/clinic_view_model.dart';
import 'package:skinsync_admin/view_models/subscription_view_model.dart';
import 'package:skinsync_admin/widgets/app_search_field.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';
import 'package:skinsync_admin/widgets/custom_outlined_button.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';

class CreateClinicsSubscriptionPlanScreen extends ConsumerStatefulWidget {
  static const String routeName = '/create-clinics-subscription-plan';
  final SubscriptionPlanModel? planToEdit;

  const CreateClinicsSubscriptionPlanScreen({super.key, this.planToEdit});

  @override
  ConsumerState<CreateClinicsSubscriptionPlanScreen> createState() => _CreateClinicsSubscriptionPlanScreenState();
}

class _CreateClinicsSubscriptionPlanScreenState extends ConsumerState<CreateClinicsSubscriptionPlanScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _doctorSeatsController;
  late final TextEditingController _staffSeatsController;
  late final TextEditingController _standardCommissionController;
  late final TextEditingController _dynamicCommissionController;
  late final TextEditingController _techFeeController;
  final TextEditingController _customBenefitController = TextEditingController();
  final TextEditingController _clinicSearchController = TextEditingController();

  bool _unlimitedDoctors = false;
  bool _unlimitedStaff = false;
  String _visibilityType = 'All Clinics';
  List<String> _selectedClinics = [];
  String _clinicSearchQuery = '';
  bool _isActive = true;

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

  void _initFromNormalPlan(SubscriptionPlanModel? plan) {
    _nameController = TextEditingController(text: plan?.name);
    _priceController = TextEditingController(text: plan?.basePrice?.toString());
    _doctorSeatsController = TextEditingController(text: plan?.doctorSeats.toString() ?? '0');
    _staffSeatsController = TextEditingController(text: plan?.staffSeats.toString() ?? '0');
    _standardCommissionController = TextEditingController(text: plan?.standardBookingCommissionPercent.toString() ?? '0');
    _dynamicCommissionController = TextEditingController(text: plan?.dynamicBookingCommissionPercent.toString() ?? '0');
    _techFeeController = TextEditingController(text: plan?.technologyFeePerTreatment.toString() ?? '0');
    
    _unlimitedDoctors = plan?.unlimitedDoctors ?? false;
    _unlimitedStaff = plan?.unlimitedStaff ?? false;
    _isActive = plan?.isActive ?? true;

    _selectedClinics = plan?.assignedClinics ?? [];
    _visibilityType = _selectedClinics.isEmpty ? 'All Clinics' : 'Specific Clinics';
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
        _planBenefits.add(PlanBenefit(title: benefit.title, enabled: benefit.enabled));
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _doctorSeatsController.dispose();
    _staffSeatsController.dispose();
    _standardCommissionController.dispose();
    _dynamicCommissionController.dispose();
    _techFeeController.dispose();
    _customBenefitController.dispose();
    _clinicSearchController.dispose();
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

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final request = CreateSubscriptionPlanRequest(
        id: widget.planToEdit?.id,
        name: _nameController.text,
        basePrice: double.tryParse(_priceController.text),
        doctorSeats: _unlimitedDoctors ? 0 : (int.tryParse(_doctorSeatsController.text) ?? 0),
        unlimitedDoctors: _unlimitedDoctors,
        staffSeats: _unlimitedStaff ? 0 : (int.tryParse(_staffSeatsController.text) ?? 0),
        unlimitedStaff: _unlimitedStaff,
        standardBookingCommissionPercent: double.tryParse(_standardCommissionController.text) ?? 0.0,
        dynamicBookingCommissionPercent: double.tryParse(_dynamicCommissionController.text) ?? 0.0,
        technologyFeePerTreatment: double.tryParse(_techFeeController.text) ?? 0.0,
        benefits: _planBenefits,
        assignedClinics: _visibilityType == 'All Clinics' ? [] : _selectedClinics,
        isActive: _isActive,
      );

      final success = await ref.read(subscriptionViewModelProvider.notifier).createClinicSubscriptionPlan(request);
      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isEditMode ? 'Plan updated successfully' : 'Plan created successfully')),
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
                        label: state.loading
                            ? 'Saving...'
                            : (isEditMode ? 'Update Plan' : 'Create Plan'),
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
                      SizedBox(height: 32.h),

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
                            // SECTION 1: VISIBILITY
                            Text(
                              'SECTION 1: PLAN VISIBILITY',
                              style: context.fonts.sectionHeading,
                            ),
                            SizedBox(height: 16.h),
                            _buildVisibilitySectionContent(),
                            SizedBox(height: 32.h),

                            // SECTION 2: BASIC INFORMATION
                            Text(
                              'SECTION 2: BASIC INFORMATION',
                              style: context.fonts.sectionHeading,
                            ),
                            SizedBox(height: 16.h),
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
                                context.horizontalSpace(24),
                                Expanded(
                                  child: BuildTextField(
                                    label: 'Base Price (\$)',
                                    controller: _priceController,
                                    hintText: '0.00',
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
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
                                Switch.adaptive(
                                  value: _isActive,
                                  onChanged: (val) =>
                                      setState(() => _isActive = val),
                                  activeTrackColor: CustomColors.green,
                                ),
                                Text(
                                  _isActive ? 'Active' : 'Inactive',
                                  style: _isActive
                                      ? context.fonts.green13w500
                                      : context.fonts.red13w500,
                                ),
                              ],
                            ),
                            SizedBox(height: 32.h),

                            // SECTION 3: PLAN LIMITS
                            Text(
                              'SECTION 3: PLAN LIMITS',
                              style: context.fonts.sectionHeading,
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: BuildTextField(
                                    label: 'Doctor/Injector Seats',
                                    controller: _doctorSeatsController,
                                    hintText: '0',
                                    keyboardType: TextInputType.number,
                                    readOnly: _unlimitedDoctors,
                                    onChanged: (val) {
                                      if (val != null &&
                                          val.isNotEmpty &&
                                          val != '0') {
                                        setState(
                                          () => _unlimitedDoctors = false,
                                        );
                                      }
                                    },
                                  ),
                                ),
                                context.horizontalSpace(24),
                                Expanded(
                                  child: Padding(
                                    padding: context.appEdgeInsets(bottom: 8),
                                    child: _unlimitedToggle(
                                      label: 'Unlimited',
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
                                Expanded(
                                  flex: 2,
                                  child: BuildTextField(
                                    label: 'Staff Seats',
                                    controller: _staffSeatsController,
                                    hintText: '0',
                                    keyboardType: TextInputType.number,
                                    readOnly: _unlimitedStaff,
                                    onChanged: (val) {
                                      if (val != null &&
                                          val.isNotEmpty &&
                                          val != '0') {
                                        setState(() => _unlimitedStaff = false);
                                      }
                                    },
                                  ),
                                ),
                                context.horizontalSpace(24),
                                Expanded(
                                  child: Padding(
                                    padding: context.appEdgeInsets(bottom: 8),
                                    child: _unlimitedToggle(
                                      label: 'Unlimited',
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

                            // SECTION 4: COMMISSION & FEES
                            Text(
                              'SECTION 4: COMMISSION & FEES',
                              style: context.fonts.sectionHeading,
                            ),
                            SizedBox(height: 16.h),
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

                            // SECTION 5: FEATURES & BENEFITS
                            Text(
                              'SECTION 5: PLAN FEATURES & BENEFITS',
                              style: context.fonts.sectionHeading,
                            ),
                            SizedBox(height: 16.h),
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
          padding: context.appEdgeInsets(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: CustomColors.border),
            borderRadius: context.borderRadius(all: 12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _visibilityType,
              isExpanded: true,
              items: ['All Clinics', 'Specific Clinics'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: context.fonts.grey14w400),
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
                _selectedClinics.map((email) {
                  final clinic = clinics.firstWhere(
                    (c) => c.email == email,
                    orElse: () => clinics.first,
                  );
                  return Chip(
                    label: Text(
                      clinic.name ?? email,
                      style: context.fonts.black13w500,
                    ),
                    backgroundColor: CustomColors.green.withValues(alpha: 0.1),
                    deleteIcon: const Icon(Icons.close, size: 14),
                    onDeleted:
                        () => setState(() => _selectedClinics.remove(email)),
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
                          clinic.email,
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
                                _selectedClinics.add(clinic.email!);
                              } else {
                                _selectedClinics.remove(clinic.email);
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
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeTrackColor: CustomColors.green,
        ),
        context.horizontalSpace(8),
        Text(label, style: context.fonts.grey13w600),
      ],
    );
  }
}
