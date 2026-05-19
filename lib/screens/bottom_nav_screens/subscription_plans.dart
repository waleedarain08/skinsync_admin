import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/subscription_plan_model.dart';
import 'package:skinsync_admin/utils/color_constant.dart';
import 'package:skinsync_admin/utils/custom_fonts.dart';
import 'package:skinsync_admin/view_models/subscription_view_model.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/widgets/dailogbox/standard_dialog.dart';
import 'package:skinsync_admin/utils/validators.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';

class SubscriptionPlansTab extends ConsumerStatefulWidget {
  static const String routeName = '/subscription-plans';
  const SubscriptionPlansTab({super.key});

  @override
  ConsumerState<SubscriptionPlansTab> createState() => _SubscriptionPlansTabState();
}

class _SubscriptionPlansTabState extends ConsumerState<SubscriptionPlansTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(subscriptionViewModelProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(subscriptionViewModelProvider);

    return Scaffold(
      backgroundColor: CustomColors.backgroundLight,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 32.h),
            Expanded(
              child: state.loading 
                ? const Center(child: CircularProgressIndicator())
                : _buildPlansGrid(state.plans ?? []),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Subscription Plans", style: CustomFonts.headlineLarge),
            SizedBox(height: 8.h),
            Text(
              "Manage pricing tiers and benefits for your clinic network.",
              style: CustomFonts.bodyMedium.copyWith(color: CustomColors.textSecondary),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _showCreatePlanDialog(),
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text('Create New Plan', style: CustomFonts.white14w600),
          style: ElevatedButton.styleFrom(
            backgroundColor: CustomColors.deepSlate,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          ),
        ),
      ],
    );
  }

  Widget _buildPlansGrid(List<SubscriptionPlanModel> plans) {
    if (plans.isEmpty) {
      return Center(
        child: Text("No subscription plans found.", style: CustomFonts.bodyLarge),
      );
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 1200 ? 3 : 2,
        crossAxisSpacing: 24.w,
        mainAxisSpacing: 24.h,
        childAspectRatio: 0.85,
      ),
      itemCount: plans.length,
      itemBuilder: (context, index) => _buildPlanCard(plans[index]),
    );
  }

  Widget _buildPlanCard(SubscriptionPlanModel plan) {
    return BorderdContainerWidget(
      padding: EdgeInsets.all(32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(plan.name ?? "N/A", style: CustomFonts.headlineSmall),
              _statusBadge(plan.isActive),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text("\$${plan.basePrice?.toStringAsFixed(2) ?? '0.00'}", 
                style: CustomFonts.headlineLarge.copyWith(color: CustomColors.deepSlate)),
              Text(" / month", style: CustomFonts.bodySmall),
            ],
          ),
          SizedBox(height: 32.h),
          const Divider(),
          SizedBox(height: 24.h),
          Text("PLAN BENEFITS", style: CustomFonts.bodySmall.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          SizedBox(height: 16.h),
          Expanded(
            child: ListView.separated(
              itemCount: plan.benefits?.length ?? 0,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (context, i) {
                final benefit = plan.benefits![i];
                return Row(
                  children: [
                    const Icon(Icons.check_circle_outline, color: CustomColors.success, size: 18),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        benefit.freeMonths != null 
                          ? "First ${benefit.freeMonths} months free for new clinics"
                          : benefit.title ?? "",
                        style: CustomFonts.bodyMedium,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
              ),
              child: const Text("Edit Plan Details"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(bool isActive) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isActive ? CustomColors.success.withOpacity(0.1) : CustomColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        isActive ? "Active" : "Inactive",
        style: TextStyle(
          color: isActive ? CustomColors.success : CustomColors.error,
          fontSize: 11.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showCreatePlanDialog() {
    showDialog(
      context: context,
      builder: (context) => const CreatePlanDialog(),
    );
  }
}

class CreatePlanDialog extends StatefulWidget {
  const CreatePlanDialog({super.key});

  @override
  State<CreatePlanDialog> createState() => _CreatePlanDialogState();
}

class _CreatePlanDialogState extends State<CreatePlanDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _freeMonthsController = TextEditingController(text: "1");

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _freeMonthsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StandardDialog(
      title: "Create New Subscription Plan",
      width: 600.w,
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildTextField(
              label: "Plan Name",
              controller: _nameController,
              hintText: "e.g. Premium Plan",
              validator: Validators.empty,
            ),
            SizedBox(height: 24.h),
            BuildTextField(
              label: "Base Price (\$)",
              controller: _priceController,
              hintText: "0.00",
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: Validators.empty,
            ),
            SizedBox(height: 32.h),
            Text("Plan Benefits / Included Points", style: CustomFonts.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: CustomColors.backgroundLight,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: CustomColors.borderLight),
              ),
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
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        Consumer(
          builder: (context, ref, _) {
            return ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final plan = SubscriptionPlanModel(
                    name: _nameController.text,
                    basePrice: double.tryParse(_priceController.text),
                    benefits: [
                      PlanBenefit(
                        title: "First time join offer",
                        freeMonths: int.tryParse(_freeMonthsController.text),
                      ),
                    ],
                  );
                  final success = await ref.read(subscriptionViewModelProvider.notifier).createSubscriptionPlan(plan);
                  if (success && context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Subscription plan created successfully")),
                    );
                  }
                }
              },
              child: const Text("Create Plan"),
            );
          },
        ),
      ],
    );
  }
}
