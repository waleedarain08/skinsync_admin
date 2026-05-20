import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/subscription_plan_model.dart';
import 'package:skinsync_admin/screens/create_subscription_plan_screen.dart';
import 'package:skinsync_admin/utils/color_constant.dart';
import 'package:skinsync_admin/utils/custom_fonts.dart';
import 'package:skinsync_admin/view_models/subscription_view_model.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';

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
              "Manage pricing tiers, commissions, and capacity limits for your clinic network.",
              style: CustomFonts.bodyMedium.copyWith(color: CustomColors.textSecondary),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => context.push(CreateSubscriptionPlanScreen.routeName),
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

    // Ensure system plans are at the top
    final sortedPlans = [...plans];
    sortedPlans.sort((a, b) {
      if (a.isSystemPlan && !b.isSystemPlan) return -1;
      if (!a.isSystemPlan && b.isSystemPlan) return 1;
      return 0;
    });

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 1200 ? 3 : 2,
        crossAxisSpacing: 24.w,
        mainAxisSpacing: 24.h,
        childAspectRatio: 0.6,
      ),
      itemCount: sortedPlans.length,
      itemBuilder: (context, index) => _buildPlanCard(sortedPlans[index]),
    );
  }

  Widget _buildPlanCard(SubscriptionPlanModel plan) {
    final activeBenefits = plan.benefits?.where((b) => b.enabled).toList() ?? [];

    return BorderdContainerWidget(
      padding: EdgeInsets.all(32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(plan.name ?? "N/A", style: CustomFonts.headlineSmall),
              if (plan.isSystemPlan)
                _systemBadge()
              else
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
          if (plan.isSystemPlan && plan.durationMonths != null) ...[
             SizedBox(height: 8.h),
             Text("Default Duration: ${plan.durationMonths} Months", style: CustomFonts.bodySmall.copyWith(color: CustomColors.brandPurple, fontWeight: FontWeight.bold)),
          ],
          SizedBox(height: 24.h),
          const Divider(),
          SizedBox(height: 24.h),
          Text("CAPACITY LIMITS", style: CustomFonts.bodySmall.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          SizedBox(height: 12.h),
          _limitRow(
            Icons.person_pin_rounded, 
            "Doctor/Injector Seats:", 
            plan.unlimitedDoctors ? "Unlimited" : "${plan.doctorSeats}"
          ),
          SizedBox(height: 8.h),
          _limitRow(
            Icons.people_alt_rounded, 
            "Staff Member Seats:", 
            plan.unlimitedStaff ? "Unlimited" : "${plan.staffSeats}"
          ),
          SizedBox(height: 24.h),
          Text("COMMISSION & FEES", style: CustomFonts.bodySmall.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          SizedBox(height: 12.h),
          _limitRow(Icons.percent_rounded, "Standard Commission:", "${plan.standardBookingCommissionPercent}%"),
          SizedBox(height: 8.h),
          _limitRow(Icons.auto_graph_rounded, "Dynamic Commission:", "${plan.dynamicBookingCommissionPercent}%"),
          SizedBox(height: 8.h),
          _limitRow(Icons.terminal_rounded, "Tech Fee / Treatment:", "\$${plan.technologyFeePerTreatment}"),
          SizedBox(height: 24.h),
          Text("PLAN BENEFITS", style: CustomFonts.bodySmall.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          SizedBox(height: 16.h),
          Expanded(
            child: ListView.separated(
              itemCount: activeBenefits.length,
              separatorBuilder: (_, _) => SizedBox(height: 12.h),
              itemBuilder: (context, i) {
                final benefit = activeBenefits[i];
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
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context.push(CreateSubscriptionPlanScreen.routeName, extra: plan);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                  ),
                  child: const Text("Edit Plan Details"),
                ),
              ),
              if (!plan.isSystemPlan) ...[
                SizedBox(width: 12.w),
                IconButton(
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Delete Plan"),
                        content: Text("Are you sure you want to delete the '${plan.name}' plan?"),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
                          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete", style: TextStyle(color: CustomColors.error))),
                        ],
                      ),
                    );
                    if (confirm == true && plan.id != null) {
                      await ref.read(subscriptionViewModelProvider.notifier).deleteSubscriptionPlan(plan.id!);
                    }
                  },
                  icon: const Icon(Icons.delete_outline, color: CustomColors.error),
                  style: IconButton.styleFrom(
                    backgroundColor: CustomColors.error.withOpacity(0.1),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _limitRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: CustomColors.textSecondary),
        SizedBox(width: 8.w),
        Text(label, style: CustomFonts.bodySmall),
        const Spacer(),
        Text(value, style: CustomFonts.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: CustomColors.deepSlate)),
      ],
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

  Widget _systemBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: CustomColors.brandPurple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: CustomColors.brandPurple.withOpacity(0.3)),
      ),
      child: Text(
        "SYSTEM PLAN",
        style: TextStyle(
          color: CustomColors.brandPurple,
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
