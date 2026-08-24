import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/clinic_subscription_plan_model.dart';
import '../../models/patient_subscription_plan_model.dart';
import '../../utils/theme.dart';
import '../../view_models/subscription_view_model.dart';
import '../../widgets/app_badge.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/borderd_container_widget.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/custom_primary_button.dart';
import '../../widgets/dailogbox/standard_dialog.dart';
import '../../widgets/gradient_scaffold.dart';
import '../create_clinics_subscription_plan_screen.dart';
import '../create_patient_subscription_plan_screen.dart';

class SubscriptionPlansTab extends ConsumerStatefulWidget {
  static const String routeName = '/subscription-plans';
  const SubscriptionPlansTab({super.key});

  @override
  ConsumerState<SubscriptionPlansTab> createState() =>
      _SubscriptionPlansTabState();
}

class _SubscriptionPlansTabState extends ConsumerState<SubscriptionPlansTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(subscriptionViewModelProvider.notifier).initialize();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: CustomColors.purple,
              unselectedLabelColor: CustomColors.grey,
              indicatorColor: CustomColors.purple,
              indicatorWeight: 3,
              labelStyle: context.fonts.black16w600,
              tabs: const [
                Tab(text: 'Clinic Subscription Plans'),
                Tab(text: 'Patient Subscription Plans'),
              ],
            ),
            context.verticalSpace(24),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  state.loading
                      ? const Center(child: AppLoader())
                      : _buildClinicPlansContent(context, state),
                  state.loading
                      ? const Center(child: AppLoader())
                      : _buildPatientPlansContent(context, state),
                ],
              ),
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
            Text('Subscription Models', style: context.fonts.level1Heading),
            context.verticalSpace(6),
            Text(
              _tabController.index == 0
                  ? 'Define tiers, commissions, and capacity limits for your clinic network.'
                  : 'Manage subscription plans and benefits for individual patients.',
              style: context.fonts.grey13w500,
            ),
          ],
        ),
        CustomPrimaryButton(
          onTap: () {
            if (_tabController.index == 0) {
              context.push(CreateClinicsSubscriptionPlanScreen.routeName);
            } else {
              context.push(CreatePatientSubscriptionPlanScreen.routeName);
            }
          },
          icon: Icons.add_rounded,
          label: 'Create New Tier',
          width: context.w(200),
        ),
      ],
    );
  }

  Widget _buildClinicPlansContent(BuildContext context, SubscriptionState state) {
    final plans = state.plans ?? [];

    return ListView(
      children: [
        Text('Available Clinic Tiers', style: context.fonts.black14w600),
        context.verticalSpace(16),
        if (plans.isEmpty)
          BorderdContainerWidget(
            padding: context.appEdgeInsets(all: 40),
            child: Center(
              child: Text(
                'No clinic tiers configured.',
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
            itemCount: plans.length,
            itemBuilder: (context, index) =>
                _buildClinicPlanCard(context, plans[index]),
          ),
      ],
    );
  }

  Widget _buildPatientPlansContent(BuildContext context, SubscriptionState state) {
    final plans = state.patientPlans ?? [];

    return ListView(
      children: [
        Text('Available Patient Tiers', style: context.fonts.black14w600),
        context.verticalSpace(16),
        if (plans.isEmpty)
          BorderdContainerWidget(
            padding: context.appEdgeInsets(all: 40),
            child: Center(
              child: Text(
                'No patient tiers configured.',
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
              childAspectRatio: 0.8,
            ),
            itemCount: plans.length,
            itemBuilder: (context, index) =>
                _buildPatientPlanCard(context, plans[index]),
          ),
      ],
    );
  }

  Widget _buildClinicPlanCard(
    BuildContext context,
    ClinicSubscriptionPlanModel plan,
  ) {
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
          Text('CAPACITY & FEES', style: context.fonts.sectionHeading),
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
          Text('INCLUDED FEATURES', style: context.fonts.sectionHeading),
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
                      CreateClinicsSubscriptionPlanScreen.routeName,
                      extra: plan,
                    );
                  },
                  label: 'Edit Tier',
                ),
              ),
              context.horizontalSpace(12),
              IconButton(
                onPressed: () => _confirmDeleteClinicPlan(context, plan),
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

  Widget _buildPatientPlanCard(
    BuildContext context,
    PatientSubscriptionPlanModel plan,
  ) {
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
              Row(
                children: [
                  _statusBadge(plan.isActive),
                  if (plan.isDefault == true) ...[
                    context.horizontalSpace(8),
                    const AppBadge(label: 'Default', variant: AppBadgeVariant.info),
                  ],
                ],
              ),
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
          Text('USAGE LIMITS', style: context.fonts.sectionHeading),
          context.verticalSpace(12),
          _limitRow(
            context,
            Icons.auto_awesome_rounded,
            'Simulations:',
            plan.unlimitedSimulations ? 'Unlimited' : '${plan.simulationCount}',
          ),
          context.verticalSpace(8),
          _limitRow(
            context,
            Icons.visibility_outlined,
            'Posts View:',
            plan.unlimitedPostsView ? 'Unlimited' : '${plan.postsViewCount}',
          ),
          const Spacer(),
          context.verticalSpace(24),
          Row(
            children: [
              Expanded(
                child: CustomOutlinedButton(
                  onTap: () {
                    context.push(
                      CreatePatientSubscriptionPlanScreen.routeName,
                      extra: plan,
                    );
                  },
                  label: 'Edit Tier',
                ),
              ),
              context.horizontalSpace(12),
              IconButton(
                onPressed: () => _confirmDeletePatientPlan(context, plan),
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

  Future<void> _confirmDeleteClinicPlan(
    BuildContext context,
    ClinicSubscriptionPlanModel plan,
  ) async {
    final confirm = await _showDeleteDialog(context, plan.name ?? '');
    if (confirm == true && plan.id != null) {
      await ref
          .read(subscriptionViewModelProvider.notifier)
          .deleteSubscriptionPlan(plan.id!);
    }
  }

  Future<void> _confirmDeletePatientPlan(
    BuildContext context,
    PatientSubscriptionPlanModel plan,
  ) async {
    final confirm = await _showDeleteDialog(context, plan.name ?? '');
    if (confirm == true && plan.id != null) {
      await ref
          .read(subscriptionViewModelProvider.notifier)
          .deletePatientSubscriptionPlan(plan.id!);
    }
  }

  Future<bool?> _showDeleteDialog(BuildContext context, String name) {
    return showDialog<bool>(
      context: context,
      builder: (context) => StandardDialog(
        title: 'Remove Tier',
        width: context.w(400),
        content: Text(
          "Are you sure you want to remove the '$name' tier from your catalog?",
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


