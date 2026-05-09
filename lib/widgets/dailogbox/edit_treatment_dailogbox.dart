import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../models/treatment_model.dart';
import '../../utils/color_constant.dart';
import '../../utils/custom_fonts.dart';
import '../../utils/responsive.dart';
import '../../view_models/treatment_view_model.dart';
import '../build_textfield.dart';

class EditTreatmentDialog extends ConsumerStatefulWidget {
  const EditTreatmentDialog({super.key});

  @override
  ConsumerState<EditTreatmentDialog> createState() => EditTreatmentDialogState();
}

class EditTreatmentDialogState extends ConsumerState<EditTreatmentDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TreatmentModel? _selectedTreatment;
  late TextEditingController _treatmentPriceController;
  final List<TextEditingController> _areaPriceControllers = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final provider = ref.read(treatmentViewModelProvider);
    final fromProvider = provider.treatments.firstWhere(
      (e) => e.id == provider.selectedTreatmentId,
      orElse: () => TreatmentModel(name: 'N/A'),
    );

    _selectedTreatment = fromProvider.copyWith();
    _treatmentPriceController = TextEditingController(text: _selectedTreatment?.price?.toString() ?? '');
    
    if (_selectedTreatment?.sideAreas != null) {
      for (var area in _selectedTreatment!.sideAreas!) {
        _areaPriceControllers.add(TextEditingController(text: area.perSyringePrice?.toString() ?? ''));
      }
    }
  }

  @override
  void dispose() {
    _treatmentPriceController.dispose();
    for (var controller in _areaPriceControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: CustomColors.whiteColor,
      insetPadding: EdgeInsets.symmetric(
        horizontal: Responsive.when(defaultValue: 120.w, mobile: () => 16.w, tablet: () => 24.w),
        vertical: 40.h,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(32.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Edit Treatment Details', style: CustomFonts.black22w600),
                  IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.close)),
                ],
              ),
              SizedBox(height: 32.h),
              _buildSectionTitle("Treatment Info"),
              SizedBox(height: 20.h),
              BuildTextField(
                label: 'Base Price',
                controller: _treatmentPriceController,
                hintText: 'e.g. 500',
                prefixIcon: const Icon(Icons.attach_money, color: CustomColors.primaryGold),
                keyboardType: TextInputType.number,
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              if (_selectedTreatment?.sideAreas?.isNotEmpty ?? false) ...[
                SizedBox(height: 32.h),
                _buildSectionTitle("Side Areas & Pricing"),
                SizedBox(height: 20.h),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _selectedTreatment!.sideAreas!.length,
                  separatorBuilder: (_, __) => SizedBox(height: 16.h),
                  itemBuilder: (context, index) {
                    final area = _selectedTreatment!.sideAreas![index];
                    return Row(
                      children: [
                        Expanded(flex: 2, child: Text(area.name ?? 'N/A', style: CustomFonts.black14w600)),
                        SizedBox(width: 16.w),
                        Expanded(
                          flex: 3,
                          child: BuildTextField(
                            label: 'Price per Syringe',
                            controller: _areaPriceControllers[index],
                            hintText: 'e.g. 200',
                            prefixIcon: const Icon(Icons.add_shopping_cart, size: 18, color: CustomColors.primaryGold),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
              SizedBox(height: 40.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => context.pop(),
                    style: OutlinedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h)),
                    child: const Text('Cancel'),
                  ),
                  SizedBox(width: 16.w),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // TODO: Implement update logic
                        context.pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.deepNavy,
                      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                    ),
                    child: const Text('Update Treatment'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: CustomFonts.black16w600.copyWith(color: CustomColors.primaryGold)),
        const Divider(),
      ],
    );
  }
}
