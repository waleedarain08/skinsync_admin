import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/subscription_plan_model.dart';
import 'package:skinsync_admin/models/free_system_plan_model.dart';
import 'package:skinsync_admin/screens/create_subscription_plan_screen.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/subscription_view_model.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'package:skinsync_admin/widgets/app_badge.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/widgets/dailogbox/standard_dialog.dart';

import 'package:skinsync_admin/widgets/gradient_scaffold.dart';

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

    return GradientScaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.pagePaddingH,
          vertical: AppSpacing.pagePaddingV,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: AppSpacing.xxl),
            Expanded(
              child: state.loading 
                ? const Center(child: CircularProgressIndicator())
                : _buildContent(state),
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
            Text("Subscription Models", style: CustomFonts.black26w700),
            SizedBox(height: 6.h),
            Text(
              "Define tiers, commissions, and capacity limits for your clinic network.",
              style: CustomFonts.grey13w500,
            ),
          ],
        ),
        CustomPrimaryButton(
          onTap: () => context.push(CreateSubscriptionPlanScreen.routeName),
          icon: Icons.add_rounded,
          label: 'Create New Tier',
          width: 200.w,
        ),
      ],
    );
  }

  Widget _buildContent(SubscriptionState state) {
    final freePlan = state.freeSystemPlan;
    final paidPlans = state.plans ?? [];

    return ListView(
      children: [
        if (freePlan != null) ...[
          Text("System Default Tier", style: CustomFonts.purple14w600),
          SizedBox(height: AppSpacing.md),
          _buildFreePlanCard(freePlan),
          SizedBox(height: AppSpacing.xxxl),
        ],
        Text("Custom Subscription Tiers", style: CustomFonts.black14w600),
        SizedBox(height: AppSpacing.md),
        if (paidPlans.isEmpty)
          BorderdContainerWidget(
            padding: EdgeInsets.all(AppSpacing.xxxl),
            child: Center(child: Text("No custom tiers configured.", style: CustomFonts.grey13w500)),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 1200 ? 3 : 2,
              crossAxisSpacing: AppSpacing.xl,
              mainAxisSpacing: AppSpacing.xl,
              childAspectRatio: 0.65,
            ),
            itemCount: paidPlans.length,
            itemBuilder: (context, index) => _buildPaidPlanCard(paidPlans[index]),
          ),
      ],
    );
  }

  Widget _buildFreePlanCard(FreeSystemPlanModel plan) {
    final activeBenefits = plan.benefits?.where((b) => b.enabled).toList() ?? [];

    return BorderdContainerWidget(
      enableHover: true,
      padding: EdgeInsets.all(AppSpacing.xl),
      backgroundColor: CustomColors.purple.withValues(alpha: 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(plan.name, style: CustomFonts.black18w600),
              const AppBadge(label: "SYSTEM DEFAULT", variant: AppBadgeVariant.info),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text("\$0.00", style: CustomFonts.purple32w700),
              SizedBox(width: 4.w),
              Text(" / ${plan.durationMonths} months introductory", style: CustomFonts.grey12w400),
            ],
          ),
          SizedBox(height: AppSpacing.xl),
          const Divider(),
          SizedBox(height: AppSpacing.xl),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("CAPACITY LIMITS", style: CustomFonts.green9w600),
                    SizedBox(height: 12.h),
                    _limitRow(Icons.person_pin_rounded, "Doctor Seats:", plan.unlimitedDoctors ? "Unlimited" : "${plan.doctorSeats}"),
                    SizedBox(height: 8.h),
                    _limitRow(Icons.people_alt_rounded, "Staff Seats:", plan.unlimitedStaff ? "Unlimited" : "${plan.staffSeats}"),
                  ],
                ),
              ),
              SizedBox(width: 48.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("COMMISSION & FEES", style: CustomFonts.green9w600),
                    SizedBox(height: 12.h),
                    _limitRow(Icons.percent_rounded, "Standard Comm:", "${plan.standardBookingCommissionPercent}%"),
                    SizedBox(height: 8.h),
                    _limitRow(Icons.terminal_rounded, "Technology Fee:", "\$${plan.technologyFeePerTreatment}"),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xl),
          Text("INCLUDED FEATURES", style: CustomFonts.green9w600),
          SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: 24.w,
            runSpacing: 10.h,
            children: activeBenefits.map((benefit) => SizedBox(
              width: 280.w,
              child: Row(
                children: [
                  const Icon(Icons.check_rounded, color: CustomColors.green, size: 16),
                  SizedBox(width: 8.w),
                  Expanded(child: Text(benefit.title ?? "", style: CustomFonts.grey13w500)),
                ],
              ),
            )).toList(),
          ),
          SizedBox(height: AppSpacing.xl),
          OutlinedButton.icon(
            onPressed: () {
              context.push(CreateSubscriptionPlanScreen.routeName, extra: plan);
            },
            icon: const Icon(Icons.tune_rounded, size: 18),
            label: const Text("Configure Default Model"),
          ),
        ],
      ),
    );
  }

  Widget _buildPaidPlanCard(SubscriptionPlanModel plan) {
    final activeBenefits = plan.benefits?.where((b) => b.enabled).toList() ?? [];

    return BorderdContainerWidget(
      enableHover: true,
      padding: EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(plan.name ?? "N/A", style: CustomFonts.black18w600),
              _statusBadge(plan.isActive),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text("\$${plan.basePrice?.toStringAsFixed(2) ?? '0.00'}", 
                style: CustomFonts.purple32w700),
              SizedBox(width: 4.w),
              Text("/ month", style: CustomFonts.grey12w400),
            ],
          ),
          SizedBox(height: AppSpacing.xl),
          const Divider(),
          SizedBox(height: AppSpacing.xl),
          Text("CAPACITY & FEES", style: CustomFonts.green9w600),
          SizedBox(height: 12.h),
          _limitRow(
            Icons.person_pin_rounded, 
            "Doctor Seats:", 
            plan.unlimitedDoctors ? "Unlimited" : "${plan.doctorSeats}"
          ),
          SizedBox(height: 8.h),
          _limitRow(
            Icons.people_alt_rounded, 
            "Staff Seats:", 
            plan.unlimitedStaff ? "Unlimited" : "${plan.staffSeats}"
          ),
          SizedBox(height: 8.h),
          _limitRow(Icons.percent_rounded, "Commission Rate:", "${plan.standardBookingCommissionPercent}%"),
          SizedBox(height: 8.h),
          _limitRow(Icons.terminal_rounded, "Tech Fee:", "\$${plan.technologyFeePerTreatment}"),
          SizedBox(height: AppSpacing.xl),
          Text("INCLUDED FEATURES", style: CustomFonts.green9w600),
          SizedBox(height: AppSpacing.md),
          Expanded(
            child: ListView.separated(
              itemCount: activeBenefits.length,
              separatorBuilder: (_, __) => SizedBox(height: 10.h),
              itemBuilder: (context, i) {
                final benefit = activeBenefits[i];
                return Row(
                  children: [
                    const Icon(Icons.check_rounded, color: CustomColors.green, size: 16),
                    SizedBox(width: 8.w),
                    Expanded(child: Text(benefit.title ?? "", style: CustomFonts.grey13w500)),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context.push(CreateSubscriptionPlanScreen.routeName, extra: plan);
                  },
                  child: const Text("Edit Tier"),
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              IconButton(
                onPressed: () => _confirmDelete(plan),
                icon: const Icon(Icons.delete_outline_rounded, color: CustomColors.red),
                style: IconButton.styleFrom(
                  backgroundColor: CustomColors.red.withValues(alpha: 0.05),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmDelete(SubscriptionPlanModel plan) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => StandardDialog(
        title: "Remove Tier",
        width: 400.w,
        content: Text("Are you sure you want to remove the '${plan.name}' tier from your catalog?", style: CustomFonts.grey14w400),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          CustomPrimaryButton(
            onTap: () => Navigator.pop(context, true),
            label: "Remove",
            width: 120.w,
          ),
        ],
      ),
    );
    if (confirm == true && plan.id != null) {
      ref.read(subscriptionViewModelProvider.notifier).deleteSubscriptionPlan(plan.id!);
    }
  }

  Widget _limitRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14.sp, color: CustomColors.lightGrey),
        SizedBox(width: 8.w),
        Text(label, style: CustomFonts.grey12w400),
        const Spacer(),
        Text(value, style: CustomFonts.black12w600),
      ],
    );
  }

  Widget _statusBadge(bool isActive) {
    return AppBadge(
      label: isActive ? "Active" : "Inactive",
      variant: isActive ? AppBadgeVariant.success : AppBadgeVariant.neutral,
    );
  }
}
