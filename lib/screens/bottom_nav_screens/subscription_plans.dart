import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/free_system_plan_model.dart';
import '../../models/subscription_plan_model.dart';
import '../../utils/theme.dart';
import '../../view_models/subscription_view_model.dart';
import '../../widgets/app_badge.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/borderd_container_widget.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/custom_primary_button.dart';
import '../../widgets/dailogbox/standard_dialog.dart';
import '../../widgets/gradient_scaffold.dart';
import '../create_subscription_plan_screen.dart';

class SubscriptionPlansTab extends ConsumerStatefulWidget {
  static const String routeName = '/subscription-plans';
  const SubscriptionPlansTab({super.key});

  @override
  ConsumerState<SubscriptionPlansTab> createState() =>
      _SubscriptionPlansTabState();
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
        padding: context.appEdgeInsets(horizontal: 28, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            context.verticalSpace(32),
            Expanded(
              child: state.loading
                  ? const Center(child: AppLoader())
                  : _buildContent(context, state),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Subscription Models', style: context.fonts.black26w700),
            context.verticalSpace(6),
            Text(
              'Define tiers, commissions, and capacity limits for your clinic network.',
              style: context.fonts.grey13w500,
            ),
          ],
        ),
        CustomPrimaryButton(
          onTap: () => context.push(CreateSubscriptionPlanScreen.routeName),
          icon: Icons.add_rounded,
          label: 'Create New Tier',
          width: context.w(200),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, SubscriptionState state) {
    final freePlan = state.freeSystemPlan;
    final paidPlans = state.plans ?? [];

    return ListView(
      children: [
        if (freePlan != null) ...[
          Text('System Default Tier', style: context.fonts.purple14w600),
          context.verticalSpace(16),
          _buildFreePlanCard(context, freePlan),
          context.verticalSpace(40),
        ],
        Text('Custom Subscription Tiers', style: context.fonts.black14w600),
        context.verticalSpace(16),
        if (paidPlans.isEmpty)
          BorderdContainerWidget(
            padding: context.appEdgeInsets(all: 40),
            child: Center(
              child: Text(
                'No custom tiers configured.',
                style: context.fonts.grey13w500,
              ),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.sizeOf(context).width > 1200 ? 3 : 2,
              crossAxisSpacing: context.w(24),
              mainAxisSpacing: context.w(24),
              childAspectRatio: 0.65,
            ),
            itemCount: paidPlans.length,
            itemBuilder: (context, index) =>
                _buildPaidPlanCard(context, paidPlans[index]),
          ),
      ],
    );
  }

  Widget _buildFreePlanCard(BuildContext context, FreeSystemPlanModel plan) {
    final activeBenefits =
        plan.benefits?.where((b) => b.enabled).toList() ?? [];

    return BorderdContainerWidget(
      enableHover: true,
      padding: context.appEdgeInsets(all: 24),
      backgroundColor: CustomColors.purple.withValues(alpha: 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(plan.name, style: context.fonts.black18w600),
              const AppBadge(
                label: 'SYSTEM DEFAULT',
                variant: AppBadgeVariant.info,
              ),
            ],
          ),
          context.verticalSpace(16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '\$0.00',
                style: context.fonts.black32w700.copyWith(
                  color: CustomColors.purple,
                  fontSize: context.sp(32),
                ),
              ),
              context.horizontalSpace(4),
              Text(
                ' / ${plan.durationMonths} months introductory',
                style: context.fonts.grey12w400,
              ),
            ],
          ),
          context.verticalSpace(24),
          const Divider(),
          context.verticalSpace(24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CAPACITY LIMITS', style: context.fonts.green9w600),
                    context.verticalSpace(12),
                    _limitRow(
                      context,
                      Icons.person_pin_rounded,
                      'Doctor Seats:',
                      plan.unlimitedDoctors
                          ? 'Unlimited'
                          : '${plan.doctorSeats}',
                    ),
                    context.verticalSpace(8),
                    _limitRow(
                      context,
                      Icons.people_alt_rounded,
                      'Staff Seats:',
                      plan.unlimitedStaff ? 'Unlimited' : '${plan.staffSeats}',
                    ),
                  ],
                ),
              ),
              context.horizontalSpace(48),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('COMMISSION & FEES', style: context.fonts.green9w600),
                    context.verticalSpace(12),
                    _limitRow(
                      context,
                      Icons.percent_rounded,
                      'Standard Comm:',
                      '${plan.standardBookingCommissionPercent}%',
                    ),
                    context.verticalSpace(8),
                    _limitRow(
                      context,
                      Icons.terminal_rounded,
                      'Technology Fee:',
                      '\$${plan.technologyFeePerTreatment}',
                    ),
                  ],
                ),
              ),
            ],
          ),
          context.verticalSpace(24),
          Text('INCLUDED FEATURES', style: context.fonts.green9w600),
          context.verticalSpace(16),
          Wrap(
            spacing: context.w(24),
            runSpacing: context.h(10),
            children: activeBenefits
                .map(
                  (benefit) => SizedBox(
                    width: context.w(280),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_rounded,
                          color: CustomColors.green,
                          size: 16,
                        ),
                        context.horizontalSpace(8),
                        Expanded(
                          child: Text(
                            benefit.title ?? '',
                            style: context.fonts.grey13w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          context.verticalSpace(24),
          CustomOutlinedButton(
            onTap: () {
              context.push(CreateSubscriptionPlanScreen.routeName, extra: plan);
            },
            icon: Icons.tune_rounded,
            label: 'Configure Default Model',
          ),
        ],
      ),
    );
  }

  Widget _buildPaidPlanCard(BuildContext context, SubscriptionPlanModel plan) {
    final activeBenefits =
        plan.benefits?.where((b) => b.enabled).toList() ?? [];

    return BorderdContainerWidget(
      enableHover: true,
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(plan.name ?? 'N/A', style: context.fonts.black18w600),
              _statusBadge(plan.isActive),
            ],
          ),
          context.verticalSpace(16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                "\$${plan.basePrice?.toStringAsFixed(2) ?? '0.00'}",
                style: context.fonts.black32w700.copyWith(
                  color: CustomColors.purple,
                  fontSize: context.sp(32),
                ),
              ),
              context.horizontalSpace(4),
              Text('/ month', style: context.fonts.grey12w400),
            ],
          ),
          context.verticalSpace(24),
          const Divider(),
          context.verticalSpace(24),
          Text('CAPACITY & FEES', style: context.fonts.green9w600),
          context.verticalSpace(12),
          _limitRow(
            context,
            Icons.person_pin_rounded,
            'Doctor Seats:',
            plan.unlimitedDoctors ? 'Unlimited' : '${plan.doctorSeats}',
          ),
          context.verticalSpace(8),
          _limitRow(
            context,
            Icons.people_alt_rounded,
            'Staff Seats:',
            plan.unlimitedStaff ? 'Unlimited' : '${plan.staffSeats}',
          ),
          context.verticalSpace(8),
          _limitRow(
            context,
            Icons.percent_rounded,
            'Commission Rate:',
            '${plan.standardBookingCommissionPercent}%',
          ),
          context.verticalSpace(8),
          _limitRow(
            context,
            Icons.terminal_rounded,
            'Tech Fee:',
            '\$${plan.technologyFeePerTreatment}',
          ),
          context.verticalSpace(24),
          Text('INCLUDED FEATURES', style: context.fonts.green9w600),
          context.verticalSpace(16),
          Expanded(
            child: ListView.separated(
              itemCount: activeBenefits.length,
              separatorBuilder: (_, _) => context.verticalSpace(10),
              itemBuilder: (context, i) {
                final benefit = activeBenefits[i];
                return Row(
                  children: [
                    const Icon(
                      Icons.check_rounded,
                      color: CustomColors.green,
                      size: 16,
                    ),
                    context.horizontalSpace(8),
                    Expanded(
                      child: Text(
                        benefit.title ?? '',
                        style: context.fonts.grey13w500,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          context.verticalSpace(24),
          Row(
            children: [
              Expanded(
                child: CustomOutlinedButton(
                  onTap: () {
                    context.push(
                      CreateSubscriptionPlanScreen.routeName,
                      extra: plan,
                    );
                  },
                  label: 'Edit Tier',
                ),
              ),
              context.horizontalSpace(12),
              IconButton(
                onPressed: () => _confirmDelete(context, plan),
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: CustomColors.red,
                ),
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

  Future<void> _confirmDelete(BuildContext context, SubscriptionPlanModel plan) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => StandardDialog(
        title: 'Remove Tier',
        width: context.w(400),
        content: Text(
          "Are you sure you want to remove the '${plan.name}' tier from your catalog?",
          style: context.fonts.grey14w400,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          CustomPrimaryButton(
            onTap: () => Navigator.pop(context, true),
            label: 'Remove',
            width: context.w(120),
          ),
        ],
      ),
    );
    if (confirm == true && plan.id != null) {
      ref
          .read(subscriptionViewModelProvider.notifier)
          .deleteSubscriptionPlan(plan.id!);
    }
  }

  Widget _limitRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(icon, size: context.sp(14), color: CustomColors.lightGrey),
        context.horizontalSpace(8),
        Text(label, style: context.fonts.grey12w400),
        const Spacer(),
        Text(value, style: context.fonts.black12w600),
      ],
    );
  }

  Widget _statusBadge(bool isActive) {
    return AppBadge(
      label: isActive ? 'Active' : 'Inactive',
      variant: isActive ? AppBadgeVariant.success : AppBadgeVariant.neutral,
    );
  }
}
