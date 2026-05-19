import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/subscription_plan_model.dart';
import 'package:skinsync_admin/utils/color_constant.dart';
import 'package:skinsync_admin/utils/custom_fonts.dart';
import 'package:skinsync_admin/utils/validators.dart';
import 'package:skinsync_admin/view_models/subscription_view_model.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';

class CreateSubscriptionPlanScreen extends ConsumerStatefulWidget {
  static const String routeName = '/create-subscription-plan';
  final SubscriptionPlanModel? planToEdit;

  const CreateSubscriptionPlanScreen({super.key, this.planToEdit});

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
  late final TextEditingController _freeMonthsController;
  final TextEditingController _customBenefitController = TextEditingController();

  bool _unlimitedDoctors = false;
  bool _unlimitedStaff = false;

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

  bool get isEditMode => widget.planToEdit != null;

  @override
  void initState() {
    super.initState();
    final plan = widget.planToEdit;
    
    _nameController = TextEditingController(text: plan?.name);
    _priceController = TextEditingController(text: plan?.basePrice?.toString());
    _doctorSeatsController = TextEditingController(text: plan?.doctorSeats.toString() ?? "0");
    _staffSeatsController = TextEditingController(text: plan?.staffSeats.toString() ?? "0");
    _standardCommissionController = TextEditingController(text: plan?.standardBookingCommissionPercent.toString() ?? "0");
    _dynamicCommissionController = TextEditingController(text: plan?.dynamicBookingCommissionPercent.toString() ?? "0");
    _techFeeController = TextEditingController(text: plan?.technologyFeePerTreatment.toString() ?? "0");
    
    int? freeMonths;
    if (plan?.benefits != null) {
      for (var benefit in plan!.benefits!) {
        if (benefit.freeMonths != null) {
          freeMonths = benefit.freeMonths;
          break;
        }
      }
    }
    _freeMonthsController = TextEditingController(text: (freeMonths ?? 1).toString());
    
    _unlimitedDoctors = plan?.unlimitedDoctors ?? false;
    _unlimitedStaff = plan?.unlimitedStaff ?? false;

    _initializeBenefits();
  }

  void _initializeBenefits() {
    final existingBenefits = widget.planToEdit?.benefits ?? [];
    
    // Start with predefined features
    _planBenefits = _predefinedFeatures.map((title) {
      final existing = existingBenefits.firstWhere(
        (b) => b.title == title,
        orElse: () => PlanBenefit(title: title, enabled: false),
      );
      return PlanBenefit(title: title, enabled: existing.enabled);
    }).toList();

    // Add custom features from existing plan
    for (var benefit in existingBenefits) {
      if (!_predefinedFeatures.contains(benefit.title) && benefit.freeMonths == null) {
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
    _freeMonthsController.dispose();
    _customBenefitController.dispose();
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
      final benefitsToSave = [
        PlanBenefit(
          title: "First time join offer",
          freeMonths: int.tryParse(_freeMonthsController.text),
          enabled: true,
        ),
        ..._planBenefits,
      ];

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
        benefits: benefitsToSave,
        isActive: widget.planToEdit?.isActive ?? true,
      );

      final success = await ref.read(subscriptionViewModelProvider.notifier).createSubscriptionPlan(plan);
      if (success && mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isEditMode ? "Plan updated successfully" : "Plan created successfully")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundLight,
      appBar: AppBar(
        title: Text(isEditMode ? "Edit Subscription Plan" : "Create Subscription Plan", style: CustomFonts.headlineSmall),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
                  _sectionHeader("Basic Information"),
                  _formContainer(
                    child: Row(
                      children: [
                        Expanded(
                          child: BuildTextField(
                            label: "Plan Name",
                            controller: _nameController,
                            hintText: "e.g. Premium Plan",
                            validator: Validators.empty,
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
                          ),
                        ),
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
                          title: Text(benefit.title ?? "", style: CustomFonts.bodyMedium),
                          value: benefit.enabled,
                          onChanged: (val) {
                            setState(() {
                              benefit.enabled = val ?? false;
                            });
                          },
                          activeColor: CustomColors.brandCyan,
                          checkColor: CustomColors.deepSlate,
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
                              child: ElevatedButton(
                                onPressed: _addCustomBenefit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: CustomColors.deepSlate,
                                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                                ),
                                child: const Text("Add Feature"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.h),
                  _sectionHeader("Incentives & Offers"),
                  _formContainer(
                    backgroundColor: CustomColors.surfaceGhost,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.info_outline, color: CustomColors.brandCyan),
                            SizedBox(width: 12.w),
                            const Expanded(
                              child: Text("First time if a clinic joins, \$0 charges will apply"),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        BuildTextField(
                          label: "Number of Months",
                          controller: _freeMonthsController,
                          hintText: "e.g. 3",
                          keyboardType: TextInputType.number,
                          validator: Validators.empty,
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
                          child: const Text("Cancel"),
                        ),
                      ),
                      SizedBox(width: 24.w),
                      SizedBox(
                        width: 240.w,
                        child: ElevatedButton(
                          onPressed: _submit,
                          child: Text(isEditMode ? "Update Plan" : "Create Plan"),
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

  Widget _sectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Text(title, style: CustomFonts.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
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
          activeColor: CustomColors.brandCyan,
        ),
        SizedBox(width: 8.w),
        Text(label, style: CustomFonts.bodySmall.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
