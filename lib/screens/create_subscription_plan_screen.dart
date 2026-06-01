import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/subscription_plan_model.dart';
import 'package:skinsync_admin/models/free_system_plan_model.dart';
import 'package:skinsync_admin/view_models/clinic_view_model.dart';
import 'package:skinsync_admin/utils/color_constant.dart';
import 'package:skinsync_admin/utils/custom_fonts.dart';
import 'package:skinsync_admin/utils/validators.dart';
import 'package:skinsync_admin/view_models/subscription_view_model.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';
import 'package:skinsync_admin/widgets/app_search_field.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/utils/theme.dart';

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
  String _visibilityType = "All Clinics";
  List<String> _selectedClinics = [];
  String _clinicSearchQuery = "";
  bool _isActive = true;

  final List<String> _predefinedFeatures = [
    "AI consultation and treatment recommendation tools",
    "Before/after simulations",
    "Patient records and treatment history",
    "Payments dashboard",
    "Automated invoices",
    "Dynamic pricing system",
    "Multi-user clinic access",
    "Priority onboarding and support",
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
    _priceController = TextEditingController(text: "0.00");
    _doctorSeatsController = TextEditingController(text: plan.doctorSeats.toString());
    _staffSeatsController = TextEditingController(text: plan.staffSeats.toString());
    _standardCommissionController = TextEditingController(text: plan.standardBookingCommissionPercent.toString());
    _dynamicCommissionController = TextEditingController(text: plan.dynamicBookingCommissionPercent.toString());
    _techFeeController = TextEditingController(text: plan.technologyFeePerTreatment.toString());
    _durationController = TextEditingController(text: plan.durationMonths.toString());
    
    _unlimitedDoctors = plan.unlimitedDoctors;
    _unlimitedStaff = plan.unlimitedStaff;
    _isActive = true;
    _visibilityType = "All Clinics"; // System plans usually for all
    _selectedClinics = [];
  }

  void _initFromNormalPlan(SubscriptionPlanModel? plan) {
    _nameController = TextEditingController(text: plan?.name);
    _priceController = TextEditingController(text: plan?.basePrice?.toString());
    _doctorSeatsController = TextEditingController(text: plan?.doctorSeats.toString() ?? "0");
    _staffSeatsController = TextEditingController(text: plan?.staffSeats.toString() ?? "0");
    _standardCommissionController = TextEditingController(text: plan?.standardBookingCommissionPercent.toString() ?? "0");
    _dynamicCommissionController = TextEditingController(text: plan?.dynamicBookingCommissionPercent.toString() ?? "0");
    _techFeeController = TextEditingController(text: plan?.technologyFeePerTreatment.toString() ?? "0");
    _durationController = TextEditingController(text: "1");
    
    _unlimitedDoctors = plan?.unlimitedDoctors ?? false;
    _unlimitedStaff = plan?.unlimitedStaff ?? false;
    _isActive = plan?.isActive ?? true;

    _selectedClinics = plan?.assignedClinics ?? [];
    _visibilityType = _selectedClinics.isEmpty ? "All Clinics" : "Specific Clinics";
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

    for (var benefit in existingBenefits) {
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
        final plan = FreeSystemPlanModel(
          id: widget.freePlanToEdit?.id,
          name: _nameController.text,
          durationMonths: int.tryParse(_durationController.text) ?? 1,
          doctorSeats: _unlimitedDoctors ? 0 : (int.tryParse(_doctorSeatsController.text) ?? 0),
          unlimitedDoctors: _unlimitedDoctors,
          staffSeats: _unlimitedStaff ? 0 : (int.tryParse(_staffSeatsController.text) ?? 0),
          unlimitedStaff: _unlimitedStaff,
          standardBookingCommissionPercent: double.tryParse(_standardCommissionController.text) ?? 0.0,
          dynamicBookingCommissionPercent: double.tryParse(_dynamicCommissionController.text) ?? 0.0,
          technologyFeePerTreatment: double.tryParse(_techFeeController.text) ?? 0.0,
          benefits: _planBenefits,
        );
        // Specialized update logic for system plan
        // final success = await ref.read(subscriptionViewModelProvider.notifier).updateFreeSystemPlan(plan);
        // Mock success for design
        context.pop();
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
          assignedClinics: _visibilityType == "All Clinics" ? [] : _selectedClinics,
          isActive: _isActive,
        );

        final success = await ref.read(subscriptionViewModelProvider.notifier).createSubscriptionPlan(plan);
        if (success && mounted) {
          context.pop();
        }
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isEditMode ? "Plan updated successfully" : "Plan created successfully")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        flexibleSpace: AppDecorations.appBarGradient,
        title: Text(isSystemPlan ? "Edit System Default Plan" : (isEditMode ? "Edit Subscription Plan" : "Create Subscription Plan"), style: CustomFonts.black18w600),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: CustomColors.black),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 900.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isSystemPlan) ...[
                    _sectionHeader("System Onboarding Settings"),
                    _formContainer(
                      backgroundColor: CustomColors.purple.withValues(alpha: 0.05),
                      child: Column(
                        children: [
                          Text("Configure the default free tier duration for newly onboarded clinics.", style: CustomFonts.grey14w400),
                          SizedBox(height: 20.h),
                          BuildTextField(
                            label: "Trial Duration (Months)",
                            controller: _durationController,
                            hintText: "e.g. 2",
                            keyboardType: TextInputType.number,
                            validator: Validators.empty,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32.h),
                  ] else ...[
                    _sectionHeader("Plan Visibility"),
                    _buildVisibilitySection(),
                    SizedBox(height: 32.h),
                  ],
                  
                  _sectionHeader("Basic Information"),
                  _formContainer(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: BuildTextField(
                                label: "Plan Name",
                                controller: _nameController,
                                hintText: "e.g. Premium Plan",
                                validator: Validators.empty,
                                readOnly: isSystemPlan,
                              ),
                            ),
                            SizedBox(width: 24.w),
                            Expanded(
                              child: BuildTextField(
                                label: "Base Price (\$)",
                                controller: _priceController,
                                hintText: "0.00",
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                validator: Validators.empty,
                                readOnly: isSystemPlan,
                              ),
                            ),
                          ],
                        ),
                        if (!isSystemPlan) ...[
                           SizedBox(height: 24.h),
                           Row(
                             children: [
                               Text("Plan Status: ", style: CustomFonts.black14w600),
                               Switch.adaptive(
                                 value: _isActive, 
                                 onChanged: (val) => setState(() => _isActive = val),
                                 activeTrackColor: CustomColors.green,
                               ),
                               Text(_isActive ? "Active" : "Inactive", style: _isActive ? CustomFonts.green13w500 : CustomFonts.red13w500),
                             ],
                           ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: 32.h),
                  _sectionHeader("Plan Limits"),
                  _formContainer(
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              flex: 2,
                              child: BuildTextField(
                                label: "Doctor/Injector Seats",
                                controller: _doctorSeatsController,
                                hintText: "0",
                                keyboardType: TextInputType.number,
                                readOnly: _unlimitedDoctors,
                                onChanged: (val) {
                                  if (val != null && val.isNotEmpty && val != "0") {
                                    setState(() => _unlimitedDoctors = false);
                                  }
                                },
                              ),
                            ),
                            SizedBox(width: 24.w),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 8.h),
                                child: _unlimitedToggle(
                                  "Unlimited", 
                                  _unlimitedDoctors, 
                                  (val) {
                                    setState(() {
                                      _unlimitedDoctors = val;
                                      if (val) _doctorSeatsController.text = "0";
                                    });
                                  }
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              flex: 2,
                              child: BuildTextField(
                                label: "Staff Seats",
                                controller: _staffSeatsController,
                                hintText: "0",
                                keyboardType: TextInputType.number,
                                readOnly: _unlimitedStaff,
                                onChanged: (val) {
                                  if (val != null && val.isNotEmpty && val != "0") {
                                    setState(() => _unlimitedStaff = false);
                                  }
                                },
                              ),
                            ),
                            SizedBox(width: 24.w),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 8.h),
                                child: _unlimitedToggle(
                                  "Unlimited", 
                                  _unlimitedStaff, 
                                  (val) {
                                    setState(() {
                                      _unlimitedStaff = val;
                                      if (val) _staffSeatsController.text = "0";
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
                  SizedBox(height: 32.h),
                  _sectionHeader("Commission & Fees"),
                  _formContainer(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: BuildTextField(
                                label: "Standard Booking Commission (%)",
                                controller: _standardCommissionController,
                                hintText: "0",
                                keyboardType: TextInputType.number,
                                validator: Validators.empty,
                              ),
                            ),
                            SizedBox(width: 24.w),
                            Expanded(
                              child: BuildTextField(
                                label: "Dynamic Pricing Commission (%)",
                                controller: _dynamicCommissionController,
                                hintText: "0",
                                keyboardType: TextInputType.number,
                                validator: Validators.empty,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        BuildTextField(
                          label: "Technology Fee Per Booked Treatment (\$)",
                          controller: _techFeeController,
                          hintText: "0.00",
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: Validators.empty,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.h),
                  _sectionHeader("Plan Features & Benefits"),
                  _formContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ..._planBenefits.map((benefit) => CheckboxListTile(
                          title: Text(benefit.title ?? "", style: CustomFonts.grey14w400),
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
                        SizedBox(height: 24.h),
                        Row(
                          children: [
                            Expanded(
                              child: BuildTextField(
                                label: "Add Custom Feature",
                                controller: _customBenefitController,
                                hintText: "e.g. Free marketing kit",
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Padding(
                              padding: EdgeInsets.only(top: 28.h),
                              child: CustomPrimaryButton(
                                onTap: _addCustomBenefit,
                                label: "Add Feature",
                                width: 160.w,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 48.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 160.w,
                        child: OutlinedButton(
                          onPressed: () => context.pop(),
                          child: Text("Cancel", style: CustomFonts.grey14w400),
                        ),
                      ),
                      SizedBox(width: 24.w),
                      SizedBox(
                        width: 240.w,
                        child: CustomPrimaryButton(
                          onTap: _submit,
                          label: isEditMode ? "Update Plan" : "Create Plan",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 60.h),
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
          Text("Target Availability", style: CustomFonts.black14w600),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              border: Border.all(color: CustomColors.border),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _visibilityType,
                isExpanded: true,
                items: ["All Clinics", "Specific Clinics"].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: CustomFonts.grey14w400),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _visibilityType = val!;
                    if (_visibilityType == "All Clinics") _selectedClinics = [];
                  });
                },
              ),
            ),
          ),
          if (_visibilityType == "Specific Clinics") ...[
            SizedBox(height: 24.h),
            Text("Assign to Clinics", style: CustomFonts.black14w600),
            SizedBox(height: 12.h),
            _buildClinicSelector(),
          ],
        ],
      ),
    );
  }

  Widget _buildClinicSelector() {
    final clinics = ref.watch(clinicViewModelProvider).clinics ?? [];
    final filteredClinics = clinics.where((c) {
      final name = c.name?.toLowerCase() ?? "";
      final email = c.email?.toLowerCase() ?? "";
      final query = _clinicSearchQuery.toLowerCase();
      return name.contains(query) || email.contains(query);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSearchField(
          controller: _clinicSearchController,
          onChanged: (val) => setState(() => _clinicSearchQuery = val),
          hintText: "Search clinics by name or email...",
        ),
        SizedBox(height: 16.h),
        if (_selectedClinics.isNotEmpty) ...[
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: _selectedClinics.map((email) {
              final clinic = clinics.firstWhere((c) => c.email == email, orElse: () => clinics.first);
              return Chip(
                label: Text(clinic.name ?? email, style: CustomFonts.black13w500),
                backgroundColor: CustomColors.green.withValues(alpha: 0.1),
                deleteIcon: const Icon(Icons.close, size: 14),
                onDeleted: () => setState(() => _selectedClinics.remove(email)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r), side: BorderSide.none),
              );
            }).toList(),
          ),
          SizedBox(height: 16.h),
        ],
        Container(
          constraints: BoxConstraints(maxHeight: 250.h),
          decoration: BoxDecoration(
            border: Border.all(color: CustomColors.border),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: filteredClinics.isEmpty
              ? Center(child: Padding(padding: EdgeInsets.all(16.w), child: Text("No clinics found", style: CustomFonts.grey14w400)))
              : Scrollbar(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: filteredClinics.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final clinic = filteredClinics[index];
                      final isSelected = _selectedClinics.contains(clinic.email);
                      return CheckboxListTile(
                        title: Text(clinic.name ?? "N/A", style: CustomFonts.grey14w600),
                        subtitle: Text(clinic.email ?? "N/A", style: CustomFonts.grey13w500),
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
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
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
      padding: EdgeInsets.only(bottom: 16.h),
      child: Text(title, style: CustomFonts.black16w700),
    );
  }

  Widget _formContainer({required Widget child, Color? backgroundColor}) {
    return BorderdContainerWidget(
      padding: EdgeInsets.all(24.w),
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
        SizedBox(width: 8.w),
        Text(label, style: CustomFonts.grey13w600),
      ],
    );
  }
}
