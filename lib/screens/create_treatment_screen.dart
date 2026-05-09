import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/treatment_model.dart';
import 'package:skinsync_admin/utils/assets.dart';
import 'package:skinsync_admin/utils/color_constant.dart';
import 'package:skinsync_admin/utils/custom_fonts.dart';
import 'package:skinsync_admin/utils/validators.dart';
import 'package:skinsync_admin/widgets/build_textfield.dart';

class CreateTreatmentScreen extends ConsumerStatefulWidget {
  const CreateTreatmentScreen({super.key});

  static const String routeName = '/create-treatment';

  @override
  ConsumerState<CreateTreatmentScreen> createState() => _CreateTreatmentScreenState();
}

class _CreateTreatmentScreenState extends ConsumerState<CreateTreatmentScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final ValueNotifier<TreatmentModel> _treatment;
  late final TextEditingController _treatmentNameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _treatment = ValueNotifier(TreatmentModel(sideAreas: []));
    _treatmentNameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
  }

  @override
  void dispose() {
    _treatmentNameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _treatment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundLight,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 800.w),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  SizedBox(height: 24.h),
                  _buildFormContainer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.arrow_back, size: 24.sp, color: Colors.black),
          ),
        ),
        SizedBox(width: 16.w),
        Text(
          'Create Treatment',
          style: CustomFonts.textMain24w700,
        ),
      ],
    );
  }

  Widget _buildFormContainer() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Treatment Details',
              style: CustomFonts.textMain18w600,
            ),
            SizedBox(height: 32.h),
            BuildTextField(
              prefixIcon: Icon(
                Icons.medication,
                color: CustomColors.blueColor,
                size: 20.sp,
              ),
              controller: _treatmentNameController,
              validator: Validators.empty,
              label: 'Treatment Name',
              hintText: 'e.g. Botox',
            ),
            SizedBox(height: 24.h),
            BuildTextField(
              prefixIcon: Icon(
                Icons.description,
                color: CustomColors.blueColor,
                size: 20.sp,
              ),
              controller: _descriptionController,
              label: 'Description',
              hintText: 'Enter treatment description',
              maxLines: 3,
            ),
            SizedBox(height: 24.h),
            BuildTextField(
              prefixIcon: Icon(
                Icons.attach_money,
                color: CustomColors.blueColor,
                size: 20.sp,
              ),
              controller: _priceController,
              label: 'Price',
              hintText: 'Enter price',
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 32.h),
            Divider(color: Colors.grey[200]),
            SizedBox(height: 32.h),
            _buildSideAreasSection(),
            SizedBox(height: 40.h),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildSideAreasSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Side Areas', style: CustomFonts.black18w600),
            ElevatedButton.icon(
              onPressed: _showAddSideAreaDialog,
              icon: const Icon(Icons.add, color: Colors.white),
              label: Text('Add Side Area', style: CustomFonts.white14w500),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        ValueListenableBuilder(
          valueListenable: _treatment,
          builder: (context, treatment, _) {
            final sideAreas = treatment.sideAreas ?? [];
            if (sideAreas.isEmpty) {
              return Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Center(
                  child: Text(
                    'No side areas added yet',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ),
              );
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                mainAxisExtent: 260.h,
              ),
              itemCount: sideAreas.length,
              itemBuilder: (context, index) {
                final area = sideAreas[index];
                return _buildSideAreaCard(area, index);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildSideAreaCard(SideAreaModel area, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 180.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                  image: DecorationImage(
                    image: AssetImage(PngAssets.image),
                    fit: BoxFit.cover,
                    opacity: 0.6,
                  ),
                ),
              ),
              Positioned(
                top: 8.r,
                right: 8.r,
                child: GestureDetector(
                  onTap: () {
                    final updatedSideAreas = List<SideAreaModel>.from(_treatment.value.sideAreas!);
                    updatedSideAreas.removeAt(index);
                    _treatment.value = _treatment.value.copyWith(sideAreas: updatedSideAreas);
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 14.r,
                    child: Icon(Icons.close, size: 16.r, color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Text(
              area.name ?? 'N/A',
              style: CustomFonts.black14w500,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                // TODO: Implement treatment creation logic via ViewModel
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Treatment creation triggered')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: EdgeInsets.symmetric(vertical: 20.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text('Create Treatment', style: CustomFonts.white14w500),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: OutlinedButton(
            onPressed: () => context.pop(),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              side: BorderSide(color: Colors.grey[300]!),
            ),
            child: Text('Cancel', style: CustomFonts.black18w500),
          ),
        ),
      ],
    );
  }

  void _showAddSideAreaDialog() {
    final sideAreaFormKey = GlobalKey<FormState>();
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: CustomColors.whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        child: Container(
          width: 400.w,
          padding: EdgeInsets.all(24.w),
          child: Form(
            key: sideAreaFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Add Side Area', style: CustomFonts.black22w600),
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                Text("Area Image", style: CustomFonts.black14w500),
                SizedBox(height: 8.h),
                Container(
                  height: 150.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: const Center(child: Icon(Icons.image_outlined, size: 40)),
                ),
                SizedBox(height: 24.h),
                BuildTextField(
                  prefixIcon: Icon(
                    Icons.face,
                    color: CustomColors.blueColor,
                    size: 20.sp,
                  ),
                  controller: nameController,
                  validator: Validators.empty,
                  label: 'Side Area Name',
                  hintText: 'e.g. Chin',
                ),
                SizedBox(height: 32.h),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (sideAreaFormKey.currentState!.validate()) {
                            final updatedSideAreas = [
                              ...?_treatment.value.sideAreas,
                              SideAreaModel(
                                id: Random().nextInt(10000),
                                name: nameController.text,
                              ),
                            ];
                            _treatment.value = _treatment.value.copyWith(
                              sideAreas: updatedSideAreas,
                            );
                            context.pop();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                        ),
                        child: Text('Add', style: CustomFonts.white14w500),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => context.pop(),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                        ),
                        child: Text('Cancel', style: CustomFonts.black14w500),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

