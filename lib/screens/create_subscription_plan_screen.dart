import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/free_system_plan_model.dart';
import 'package:skinsync_admin/models/subscription_plan_model.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/utils/validators.dart';
import 'package:skinsync_admin/view_models/clinic_view_model.dart';
import 'package:skinsync_admin/view_models/subscription_view_model.dart';
import 'package:skinsync_admin/widgets/app_search_field.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';
import 'package:skinsync_admin/widgets/custom_outlined_button.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';

class CreateSubscriptionPlanScreen extends ConsumerStatefulWidget {
  static const String routeName = '/create-subscription-plan';
  final SubscriptionPlanModel? planToEdit;
  final FreeSystemPlanModel? freePlanToEdit;

  const CreateSubscriptionPlanScreen({super.key, this.planToEdit, this.freePlanToEdit});

  @override
  ConsumerState<CreateSubscriptionPlanScreen> createState() => _CreateSubscriptionPlanScreenState();
}

class _CreateSubscriptionPlanScreenState extends ConsumerState<CreateSubscriptionPlanScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _doctorSeatsController;
  late final TextEditingController _staffSeatsController;
  late final TextEditingController _standardCommissionController;
  late final TextEditingController _dynamicCommissionController;
  late final TextEditingController _techFeeController;
  late final TextEditingController _durationController;
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

  bool get isEditMode => widget.planToEdit != null || widget.freePlanToEdit != null;
  bool get isSystemPlan => widget.freePlanToEdit != null;

  @override
  void initState() {
    super.initState();
    
    if (widget.freePlanToEdit != null) {
      _initFromFreePlan(widget.freePlanToEdit!);
    } else {
      _initFromNormalPlan(widget.planToEdit);
    }

    _initializeBenefits();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(clinicViewModelProvider.notifier).initialize();
    });
  }

  void _initFromFreePlan(FreeSystemPlanModel plan) {
    _nameController = TextEditingController(text: plan.name);
    _priceController = TextEditingController(text: '0.00');
    _doctorSeatsController = TextEditingController(text: plan.doctorSeats.toString());
    _staffSeatsController = TextEditingController(text: plan.staffSeats.toString());
    _standardCommissionController = TextEditingController(text: plan.standardBookingCommissionPercent.toString());
    _dynamicCommissionController = TextEditingController(text: plan.dynamicBookingCommissionPercent.toString());
    _techFeeController = TextEditingController(text: plan.technologyFeePerTreatment.toString());
    _durationController = TextEditingController(text: plan.durationMonths.toString());
    
    _unlimitedDoctors = plan.unlimitedDoctors;
    _unlimitedStaff = plan.unlimitedStaff;
    _isActive = true;
    _visibilityType = 'All Clinics'; // System plans usually for all
    _selectedClinics = [];
  }

  void _initFromNormalPlan(SubscriptionPlanModel? plan) {
    _nameController = TextEditingController(text: plan?.name);
    _priceController = TextEditingController(text: plan?.basePrice?.toString());
    _doctorSeatsController = TextEditingController(text: plan?.doctorSeats.toString() ?? '0');
    _staffSeatsController = TextEditingController(text: plan?.staffSeats.toString() ?? '0');
    _standardCommissionController = TextEditingController(text: plan?.standardBookingCommissionPercent.toString() ?? '0');
    _dynamicCommissionController = TextEditingController(text: plan?.dynamicBookingCommissionPercent.toString() ?? '0');
    _techFeeController = TextEditingController(text: plan?.technologyFeePerTreatment.toString() ?? '0');
    _durationController = TextEditingController(text: '1');
    
    _unlimitedDoctors = plan?.unlimitedDoctors ?? false;
    _unlimitedStaff = plan?.unlimitedStaff ?? false;
    _isActive = plan?.isActive ?? true;

    _selectedClinics = plan?.assignedClinics ?? [];
    _visibilityType = _selectedClinics.isEmpty ? 'All Clinics' : 'Specific Clinics';
  }

  void _initializeBenefits() {
    final existingBenefits = widget.freePlanToEdit?.benefits ?? widget.planToEdit?.benefits ?? [];
    
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
    _durationController.dispose();
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
      if (isSystemPlan) {
        // Specialized update logic for system plan
        // final plan = FreeSystemPlanModel(...);
        // await ref.read(subscriptionViewModelProvider.notifier).updateFreeSystemPlan(plan);
        Navigator.pop(context);
      } else {
        final plan = SubscriptionPlanModel(
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

        final success = await ref.read(subscriptionViewModelProvider.notifier).createSubscriptionPlan(plan);
        if (success && mounted) {
          Navigator.pop(context);
        }
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isEditMode ? 'Plan updated successfully' : 'Plan created successfully')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        flexibleSpace: AppDecorations.appBarGradient,
        title: Text(isSystemPlan ? 'Edit System Default Plan' : (isEditMode ? 'Edit Subscription Plan' : 'Create Subscription Plan'), style: context.fonts.black18w600),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: CustomColors.black),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(horizontal: 24, vertical: 32),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.w(900)),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isSystemPlan) ...[
                    _sectionHeader('System Onboarding Settings'),
                    _formContainer(
                      backgroundColor: CustomColors.purple.withValues(alpha: 0.05),
                      child: Column(
                        children: [
                          Text('Configure the default free tier duration for newly onboarded clinics.', style: context.fonts.grey14w400),
                          context.verticalSpace(20),
                          BuildTextField(
                            label: 'Trial Duration (Months)',
                            controller: _durationController,
                            hintText: 'e.g. 2',
                            keyboardType: TextInputType.number,
                            validator: Validators.empty,
                          ),
                        ],
                      ),
                    ),
                    context.verticalSpace(32),
                  ] else ...[
                    _sectionHeader('Plan Visibility'),
                    _buildVisibilitySection(),
                    context.verticalSpace(32),
                  ],
                  
                  _sectionHeader('Basic Information'),
                  _formContainer(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: BuildTextField(
                                label: 'Plan Name',
                                controller: _nameController,
                                hintText: 'e.g. Premium Plan',
                                validator: Validators.empty,
                                readOnly: isSystemPlan,
                              ),
                            ),
                            context.horizontalSpace(24),
                            Expanded(
                              child: BuildTextField(
                                label: 'Base Price (\$)',
                                controller: _priceController,
                                hintText: '0.00',
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                validator: Validators.empty,
                                readOnly: isSystemPlan,
                              ),
                            ),
                          ],
                        ),
                        if (!isSystemPlan) ...[
                           context.verticalSpace(24),
                           Row(
                             children: [
                               Text('Plan Status: ', style: context.fonts.black14w600),
                               Switch.adaptive(
                                 value: _isActive, 
                                 onChanged: (val) => setState(() => _isActive = val),
                                 activeTrackColor: CustomColors.green,
                               ),
                               Text(_isActive ? 'Active' : 'Inactive', style: _isActive ? context.fonts.green13w500 : context.fonts.red13w500),
                             ],
                           ),
                        ],
                      ],
                    ),
                  ),
                  context.verticalSpace(32),
                  _sectionHeader('Plan Limits'),
                  _formContainer(
                    child: Column(
                      children: [
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
                                  if (val != null && val.isNotEmpty && val != '0') {
                                    setState(() => _unlimitedDoctors = false);
                                  }
                                },
                              ),
                            ),
                            context.horizontalSpace(24),
                            Expanded(
                              child: Padding(
                                padding: context.appEdgeInsets(bottom: 8),
                                child: _unlimitedToggle(
                                  'Unlimited', 
                                  _unlimitedDoctors, 
                                  (val) {
                                    setState(() {
                                      _unlimitedDoctors = val;
                                      if (val) _doctorSeatsController.text = '0';
                                    });
                                  }
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
                                  if (val != null && val.isNotEmpty && val != '0') {
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
                                  'Unlimited', 
                                  _unlimitedStaff, 
                                  (val) {
                                    setState(() {
                                      _unlimitedStaff = val;
                                      if (val) _staffSeatsController.text = '0';
                                    });
                                  }
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  context.verticalSpace(32),
                  _sectionHeader('Commission & Fees'),
                  _formContainer(
                    child: Column(
                      children: [
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
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: Validators.empty,
                        ),
                      ],
                    ),
                  ),
                  context.verticalSpace(32),
                  _sectionHeader('Plan Features & Benefits'),
                  _formContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ..._planBenefits.map((benefit) => CheckboxListTile(
                          title: Text(benefit.title ?? '', style: context.fonts.grey14w400),
                          value: benefit.enabled,
                          onChanged: (val) {
                            setState(() {
                              benefit.enabled = val ?? false;
                            });
                          },
                          activeColor: CustomColors.green,
                          checkColor: CustomColors.black,
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                        )),
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
                  context.verticalSpace(48),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomOutlinedButton(
                        onTap: () => context.pop(),
                        label: 'Cancel',
                        width: context.w(160),
                        textColor: CustomColors.grey,
                        color: CustomColors.border,
                      ),
                      context.horizontalSpace(24),
                      SizedBox(
                        width: context.w(240),
                        child: CustomPrimaryButton(
                          onTap: _submit,
                          label: isEditMode ? 'Update Plan' : 'Create Plan',
                        ),
                      ),
                    ],
                  ),
                  context.verticalSpace(60),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVisibilitySection() {
    return _formContainer(
      child: Column(
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
      ),
    );
  }

  Widget _buildClinicSelector() {
    final clinics = ref.watch(clinicViewModelProvider).clinics ?? [];
    final filteredClinics = clinics.where((c) {
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
            children: _selectedClinics.map((email) {
              final clinic = clinics.firstWhere((c) => c.email == email, orElse: () => clinics.first);
              return Chip(
                label: Text(clinic.name ?? email, style: context.fonts.black13w500),
                backgroundColor: CustomColors.green.withValues(alpha: 0.1),
                deleteIcon: const Icon(Icons.close, size: 14),
                onDeleted: () => setState(() => _selectedClinics.remove(email)),
                shape: RoundedRectangleBorder(borderRadius: context.borderRadius(all: 8), side: BorderSide.none),
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
          child: filteredClinics.isEmpty
              ? Center(child: Padding(padding: context.appEdgeInsets(all: 16), child: Text('No clinics found', style: context.fonts.grey14w400)))
              : Scrollbar(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: filteredClinics.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final clinic = filteredClinics[index];
                      final isSelected = _selectedClinics.contains(clinic.email);
                      return CheckboxListTile(
                        title: Text(clinic.name ?? 'N/A', style: context.fonts.grey14w600),
                        subtitle: Text(clinic.email ?? 'N/A', style: context.fonts.grey13w500),
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

  Widget _sectionHeader(String title) {
    return Padding(
      padding: context.appEdgeInsets(bottom: 16),
      child: Text(title, style: context.fonts.black16w700),
    );
  }

  Widget _formContainer({required Widget child, Color? backgroundColor}) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      backgroundColor: backgroundColor ?? Colors.white,
      child: child,
    );
  }

  Widget _unlimitedToggle(String label, bool value, Function(bool) onChanged) {
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
