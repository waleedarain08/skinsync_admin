import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/patient_subscription_plan_model.dart';
import 'package:skinsync_admin/models/requests/create_patient_subscription_plan_request.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/utils/validators.dart';
import 'package:skinsync_admin/view_models/subscription_view_model.dart';
import 'package:skinsync_admin/widgets/app_search_field.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';
import 'package:skinsync_admin/widgets/custom_outlined_button.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';

class CreatePatientSubscriptionPlanScreen extends ConsumerStatefulWidget {
  static const String routeName = '/create-patient-subscription-plan';
  final PatientSubscriptionPlanModel? planToEdit;

  const CreatePatientSubscriptionPlanScreen({super.key, this.planToEdit});

  @override
  ConsumerState<CreatePatientSubscriptionPlanScreen> createState() =>
      _CreatePatientSubscriptionPlanScreenState();
}

class _CreatePatientSubscriptionPlanScreenState
    extends ConsumerState<CreatePatientSubscriptionPlanScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _simulationCountController;
  late final TextEditingController _postsViewCountController;
  final TextEditingController _patientSearchController = TextEditingController();

  bool _unlimitedSimulations = false;
  bool _unlimitedPostsView = false;
  String _visibilityType = 'All Patients';
  List<String> _selectedPatients = [];
  bool _isActive = true;

  // Dummy patient data for selection
  final List<String> _dummyPatients = [
    'Sarah Johnson',
    'Michael Smith',
    'Emily Davis',
    'James Wilson',
    'Jessica Brown',
    'Robert Miller',
    'Linda Taylor',
    'William Moore',
  ];

  bool get isEditMode => widget.planToEdit != null;

  @override
  void initState() {
    super.initState();
    _initFromModel(widget.planToEdit);
  }

  void _initFromModel(PatientSubscriptionPlanModel? plan) {
    _nameController = TextEditingController(text: plan?.name);
    _priceController = TextEditingController(text: plan?.basePrice?.toString());
    _simulationCountController = TextEditingController(
      text: plan?.simulationCount.toString() ?? '0',
    );
    _postsViewCountController = TextEditingController(
      text: plan?.postsViewCount.toString() ?? '0',
    );

    _unlimitedSimulations = plan?.unlimitedSimulations ?? false;
    _unlimitedPostsView = plan?.unlimitedPostsView ?? false;
    _isActive = plan?.isActive ?? true;

    _selectedPatients = plan?.assignedPatients ?? [];
    _visibilityType =
        _selectedPatients.isEmpty ? 'All Patients' : 'Specific Patients';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _simulationCountController.dispose();
    _postsViewCountController.dispose();
    _patientSearchController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final request = CreatePatientSubscriptionPlanRequest(
        id: widget.planToEdit?.id,
        name: _nameController.text,
        basePrice: double.tryParse(_priceController.text),
        simulationCount:
            _unlimitedSimulations
                ? 0
                : (int.tryParse(_simulationCountController.text) ?? 0),
        unlimitedSimulations: _unlimitedSimulations,
        postsViewCount:
            _unlimitedPostsView
                ? 0
                : (int.tryParse(_postsViewCountController.text) ?? 0),
        unlimitedPostsView: _unlimitedPostsView,
        assignedPatients:
            _visibilityType == 'All Patients' ? [] : _selectedPatients,
        isActive: _isActive,
      );

      final success = await ref
          .read(subscriptionViewModelProvider.notifier)
          .createPatientSubscriptionPlan(request);
      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditMode
                  ? 'Patient plan updated successfully'
                  : 'Patient plan created successfully',
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
                      context.horizontalSpace(8),
                      Text(
                        isEditMode
                            ? 'Edit Patient Subscription'
                            : 'Create Patient Subscription',
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
                      context.horizontalSpace(16),
                      CustomPrimaryButton(
                        onTap: _submit,
                        label: state.loading ? 'Saving...' : 'Save Plan',
                        width: 180.w,
                      ),
                    ],
                  ),
                ],
              ),
              context.verticalSpace(32),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildMainForm(),
                      context.verticalSpace(24),
                      _buildVisibilitySection(),
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

  Widget _buildMainForm() {
    return Container(
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
          Text('SECTION 1: PLAN DETAILS', style: context.fonts.sectionHeading),
          context.verticalSpace(24),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: BuildTextField(
                  label: 'Plan Name',
                  controller: _nameController,
                  hintText: 'e.g. Standard Patient Tier',
                  validator: Validators.empty,
                ),
              ),
              context.horizontalSpace(16),
              Expanded(
                child: BuildTextField(
                  label: 'Monthly Price (\$)',
                  controller: _priceController,
                  hintText: '0.00',
                  validator: Validators.empty,
                ),
              ),
            ],
          ),
          context.verticalSpace(32),
          Text('SECTION 2: PLAN LIMITS', style: context.fonts.sectionHeading),
          context.verticalSpace(24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BuildTextField(
                      label: 'Simulation Count',
                      controller: _simulationCountController,
                      hintText: 'Quantity',
                      readOnly: _unlimitedSimulations,
                    ),
                    context.verticalSpace(12),
                    _unlimitedToggle(
                      label: 'Unlimited Simulations',
                      value: _unlimitedSimulations,
                      onChanged: (val) {
                        setState(() => _unlimitedSimulations = val);
                      },
                    ),
                  ],
                ),
              ),
              context.horizontalSpace(24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BuildTextField(
                      label: 'Posts View Count',
                      controller: _postsViewCountController,
                      hintText: 'Quantity',
                      readOnly: _unlimitedPostsView,
                    ),
                    context.verticalSpace(12),
                    _unlimitedToggle(
                      label: 'Unlimited Posts View',
                      value: _unlimitedPostsView,
                      onChanged: (val) {
                        setState(() => _unlimitedPostsView = val);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          context.verticalSpace(32),
          Row(
            children: [
              Text('Plan Status', style: context.fonts.black14w600),
              const Spacer(),
              Switch.adaptive(
                value: _isActive,
                onChanged: (val) => setState(() => _isActive = val),
                activeTrackColor: CustomColors.green,
              ),
              context.horizontalSpace(8),
              Text(
                _isActive ? 'Active' : 'Inactive',
                style: context.fonts.grey13w600,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVisibilitySection() {
    return Container(
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
          Text('PLAN VISIBILITY', style: context.fonts.sectionHeading),
          context.verticalSpace(16),
          Row(
            children: [
              _visibilityOption('All Patients'),
              context.horizontalSpace(24),
              _visibilityOption('Specific Patients'),
            ],
          ),
          if (_visibilityType == 'Specific Patients') ...[
            context.verticalSpace(24),
            AppSearchField(
              controller: _patientSearchController,
              hintText: 'Search patients by name...',
              onChanged: (v) => setState(() {}),
            ),
            context.verticalSpace(16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children:
                  _dummyPatients
                      .where(
                        (p) => p.toLowerCase().contains(
                          _patientSearchController.text.toLowerCase(),
                        ),
                      )
                      .map((p) => _patientChip(p))
                      .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _visibilityOption(String title) {
    return InkWell(
      onTap: () => setState(() => _visibilityType = title),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<String>(
            value: title,
            groupValue: _visibilityType,
            onChanged: (v) => setState(() => _visibilityType = v!),
            activeColor: CustomColors.purple,
          ),
          Text(title, style: context.fonts.black14w600),
        ],
      ),
    );
  }

  Widget _patientChip(String patient) {
    final isSelected = _selectedPatients.contains(patient);
    return FilterChip(
      label: Text(patient),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _selectedPatients.add(patient);
          } else {
            _selectedPatients.remove(patient);
          }
        });
      },
      selectedColor: CustomColors.purple.withValues(alpha: 0.1),
      checkmarkColor: CustomColors.purple,
      labelStyle: TextStyle(
        color: isSelected ? CustomColors.purple : CustomColors.black,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
      ),
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
