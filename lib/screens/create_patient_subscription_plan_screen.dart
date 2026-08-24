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
  final TextEditingController _patientSearchController =
      TextEditingController();

  bool _unlimitedSimulations = false;
  bool _unlimitedPostsView = false;
  String _visibilityType = 'All Patients';
  List<String> _selectedPatients = [];
  String _patientSearchQuery = '';
  bool _isActive = true;
  bool _isDefault = false;

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
    _isDefault = plan?.isDefault ?? false;

    _selectedPatients = plan?.assignedPatients ?? [];
    _visibilityType = _selectedPatients.isEmpty
        ? 'All Patients'
        : 'Specific Patients';
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
        basePrice: double.tryParse(_priceController.text) ?? 0.0,
        simulationCount: _unlimitedSimulations
            ? 0
            : (int.tryParse(_simulationCountController.text) ?? 0),
        unlimitedSimulations: _unlimitedSimulations,
        postsViewCount: _unlimitedPostsView
            ? 0
            : (int.tryParse(_postsViewCountController.text) ?? 0),
        unlimitedPostsView: _unlimitedPostsView,
        assignedPatients: _visibilityType == 'All Patients'
            ? []
            : _selectedPatients,
        isActive: _isActive,
        isDefault: _isDefault,
      );

      final success = await ref
          .read(subscriptionViewModelProvider.notifier)
          .createPatientSubscriptionPlan(request);
      if ((success ?? false) && mounted) {
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                            // SECTION 1: BASIC INFORMATION
                            Text(
                              'SECTION 1: BASIC INFORMATION',
                              style: context.fonts.sectionHeading,
                            ),
                            SizedBox(height: 16.h),
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
                                context.horizontalSpace(24),
                                Expanded(
                                  child: BuildTextField(
                                    label: 'Monthly Price (\$)',
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
                                Transform.scale(
                                  scale: 0.7,
                                  child: Switch.adaptive(
                                    value: _isActive,
                                    onChanged: (val) =>
                                        setState(() => _isActive = val),
                                    activeTrackColor: CustomColors.purple,
                                  ),
                                ),
                                Text(
                                  _isActive ? 'Active' : 'Inactive',
                                  style: _isActive
                                      ? context.fonts.green13w500
                                      : context.fonts.red13w500,
                                ),
                                context.horizontalSpace(24),
                                // Default toggle
                                Text(
                                  'Default Plan: ',
                                  style: context.fonts.black14w600,
                                ),
                                Transform.scale(
                                  scale: 0.7,
                                  child: Switch.adaptive(
                                    value: _isDefault,
                                    onChanged: (val) =>
                                        setState(() => _isDefault = val),
                                    activeTrackColor: CustomColors.purple,
                                  ),
                                ),
                                Text(
                                  _isDefault ? 'Yes' : 'No',
                                  style: _isDefault
                                      ? context.fonts.purple13w600
                                      : context.fonts.grey13w500,
                                ),
                              ],
                            ),
                            SizedBox(height: 32.h),

                            // SECTION 2: PLAN LIMITS
                            Text(
                              'SECTION 2: PLAN LIMITS',
                              style: context.fonts.sectionHeading,
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (!_unlimitedSimulations)
                                  Expanded(
                                    flex: 2,
                                    child: BuildTextField(
                                      label: 'Simulation Count',
                                      controller: _simulationCountController,
                                      hintText: 'Quantity',
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                if (!_unlimitedSimulations)
                                  context.horizontalSpace(24),
                                Expanded(
                                  child: Padding(
                                    padding: context.appEdgeInsets(bottom: 8),
                                    child: _unlimitedToggle(
                                      label: 'Unlimited Simulations',
                                      value: _unlimitedSimulations,
                                      onChanged: (val) {
                                        setState(() {
                                          _unlimitedSimulations = val;
                                          if (val) {
                                            _simulationCountController.text =
                                                '0';
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
                                if (!_unlimitedPostsView)
                                  Expanded(
                                    flex: 2,
                                    child: BuildTextField(
                                      label: 'Posts View Count',
                                      controller: _postsViewCountController,
                                      hintText: 'Quantity',
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                if (!_unlimitedPostsView)
                                  context.horizontalSpace(24),
                                Expanded(
                                  child: Padding(
                                    padding: context.appEdgeInsets(bottom: 8),
                                    child: _unlimitedToggle(
                                      label: 'Unlimited Posts View',
                                      value: _unlimitedPostsView,
                                      onChanged: (val) {
                                        setState(() {
                                          _unlimitedPostsView = val;
                                          if (val) {
                                            _postsViewCountController.text =
                                                '0';
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      context.verticalSpace(24),

                      // SECTION 3: PLAN VISIBILITY
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
                            Text(
                              'SECTION 3: PLAN VISIBILITY',
                              style: context.fonts.sectionHeading,
                            ),
                            SizedBox(height: 16.h),
                            _buildVisibilitySectionContent(),
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
              items: ['All Patients', 'Specific Patients'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: context.fonts.grey14w400),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _visibilityType = val!;
                  if (_visibilityType == 'All Patients') _selectedPatients = [];
                });
              },
            ),
          ),
        ),
        if (_visibilityType == 'Specific Patients') ...[
          context.verticalSpace(24),
          Text('Assign to Patients', style: context.fonts.black14w600),
          context.verticalSpace(12),
          _buildPatientSelector(),
        ],
      ],
    );
  }

  Widget _buildPatientSelector() {
    final filteredPatients = _dummyPatients.where((p) {
      final query = _patientSearchQuery.toLowerCase();
      return p.toLowerCase().contains(query);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSearchField(
          controller: _patientSearchController,
          onChanged: (val) => setState(() => _patientSearchQuery = val),
          hintText: 'Search patients by name...',
        ),
        context.verticalSpace(16),
        if (_selectedPatients.isNotEmpty) ...[
          Wrap(
            spacing: context.w(8),
            runSpacing: context.h(8),
            children: _selectedPatients.map((name) {
              return Chip(
                label: Text(name, style: context.fonts.black13w500),
                backgroundColor: CustomColors.green.withValues(alpha: 0.1),
                deleteIcon: const Icon(Icons.close, size: 14),
                onDeleted: () => setState(() => _selectedPatients.remove(name)),
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
          child: filteredPatients.isEmpty
              ? Center(
                  child: Padding(
                    padding: context.appEdgeInsets(all: 16),
                    child: Text(
                      'No patients found',
                      style: context.fonts.grey14w400,
                    ),
                  ),
                )
              : Scrollbar(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: filteredPatients.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final patient = filteredPatients[index];
                      final isSelected = _selectedPatients.contains(patient);
                      return CheckboxListTile(
                        title: Text(patient, style: context.fonts.grey14w600),
                        value: isSelected,
                        onChanged: (val) {
                          setState(() {
                            if (val == true) {
                              _selectedPatients.add(patient);
                            } else {
                              _selectedPatients.remove(patient);
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
        Transform.scale(
          scale: 0.7,
          child: Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: CustomColors.purple,
          ),
        ),
        context.horizontalSpace(4),
        Text(label, style: context.fonts.grey13w600),
      ],
    );
  }
}
