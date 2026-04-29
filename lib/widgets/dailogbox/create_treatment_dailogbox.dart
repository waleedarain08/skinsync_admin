import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/utils/assets.dart';
import 'package:skinsync_admin/utils/responsive.dart';
import 'package:skinsync_admin/utils/validators.dart';
import '../../models/treatment_model.dart';
import '../../utils/color_constant.dart';
import '../../utils/custom_fonts.dart';
import '../build_textfield.dart';

class CreateTreatmentDialog extends StatefulWidget {
  const CreateTreatmentDialog({super.key});

  @override
  State<CreateTreatmentDialog> createState() => _CreateTreatmentDialogState();
}

class _CreateTreatmentDialogState extends State<CreateTreatmentDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final ValueNotifier<TreatmentModel> _treatment;
  late final TextEditingController _treatmentNameController;

  @override
  void initState() {
    super.initState();
    _treatment = ValueNotifier(TreatmentModel(sideAreas: []));
    _treatmentNameController = TextEditingController();
  }

  @override
  void dispose() {
    _treatmentNameController.dispose();
    _treatment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: CustomColors.whiteColor,
      insetPadding: EdgeInsets.symmetric(
        horizontal: Responsive.when(
          defaultValue: 300.w,
          desktop: () => 300,
          mobile: () => 10.w,
          tablet: () => 80.w,
        ),
        vertical: 50.h,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Text('Create Treatment', style: CustomFonts.black22w600),
                  IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: Icon(Icons.close, color: Colors.black),
                  ),
                ],
              ),
              // SizedBox(height: 24.h),
              // Text('Treatment Details', style: CustomFonts.black22w600),
              SizedBox(height: 40.h),

              // Text("Select Treatment", style: CustomFonts.black14w500),
              // SizedBox(height: 8.h),
              // _loadingTreatments
              //     ? Container(
              //         height: 48.h,
              //         decoration: BoxDecoration(
              //           color: Colors.grey[300],
              //           borderRadius: BorderRadius.circular(8.r),
              //         ),
              //       ).withShimmer()
              //     :
              // DropdownButtonHideUnderline(
              //     child: DropdownButton2<TreatmentModel>(
              //       isExpanded: true,
              //       hint: Text(
              //         "Select Treatment",
              //         style: TextStyle(color: Colors.grey[400]),
              //       ),
              //       value: _selectedTreatment,
              //       items: _adminTreatments
              //           .map(
              //             (item) => DropdownMenuItem(
              //               value: item,
              //               child: Text(item.name ?? "N/A"),
              //             ),
              //           )
              //           .toList(),
              //       onChanged: (value) {
              //         if (value == null || value == _selectedTreatment) {
              //           return;
              //         }

              //         setState(() {
              //           _selectedTreatment = value;
              //         });
              //         if (value.isArea == true) {
              //           setState(() {
              //             _loadingAreas = true;
              //           });
              //           // ref
              //           //     .read(treatmentViewModelProvider.notifier)
              //           //     .getTreatmentsSideAreas(treatmentId: value.id!)
              //           //     .then((areas) {
              //           //       setState(() {
              //           //         _sideAreas = areas;
              //           //         _loadingAreas = false;
              //           //         _selectedAreas = [];
              //           //         _areaPriceControllers.clear();
              //           //       });
              //           //     });
              //         }
              //       },
              //       buttonStyleData: ButtonStyleData(
              //         height: 48.h,
              //         padding: EdgeInsets.symmetric(horizontal: 16.w),
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(8.r),
              //           border: Border.all(color: Colors.grey[300]!),
              //         ),
              //       ),
              //     ),
              //   ),
              Padding(
                padding: EdgeInsets.only(bottom: 30.h),
                child: BuildTextField(
                  prefixIcon: Icon(
                    Icons.medication,
                    color: CustomColors.blueColor,
                    size: 20.sp,
                  ),
                  controller: _treatmentNameController,
                  validator: Validators.empty,
                  label: 'Treatment Name',
                  hintText: 'Botox',
                ),
              ),
              SizedBox(height: 30.h),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    final sideAreaFormKey = GlobalKey<FormState>();
                    final nameController = TextEditingController();
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        backgroundColor: CustomColors.whiteColor,

                        constraints: BoxConstraints(
                          minHeight: 20.w,
                          // maxHeight: 40.sh,
                          minWidth: 200,
                          maxWidth: 300,
                        ),
                        insetPadding: EdgeInsets.symmetric(
                          horizontal: 50.w,
                          vertical: 50.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(24.w),
                          child: Form(
                            key: sideAreaFormKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: .spaceBetween,
                                  children: [
                                    Text(
                                      'Side Area',
                                      style: CustomFonts.black22w600,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        context.pop();
                                      },
                                      icon: Icon(
                                        Icons.close,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 40.h),
                                Text("Image", style: CustomFonts.black14w500),
                                SizedBox(height: 10.h),
                                Container(
                                  // width: 200.w,
                                  height: 200.h,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Icon(Icons.image_outlined),
                                  ),
                                ),
                                SizedBox(height: 40.h),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 30.h),
                                  child: BuildTextField(
                                    prefixIcon: Icon(
                                      Icons.face_4_outlined,
                                      color: CustomColors.blueColor,
                                      size: 20.sp,
                                    ),
                                    controller: nameController,
                                    validator: Validators.empty,
                                    label: 'Side Area Name',
                                    hintText: 'Chin',
                                  ),
                                ),

                                SizedBox(height: 32.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (!sideAreaFormKey.currentState!
                                              .validate()) {
                                            return;
                                          }
                                          final updatedSideAreas = [
                                            ...?_treatment.value.sideAreas,
                                            SideAreaModel(
                                              id: 1,
                                              name: nameController.text,
                                            ),
                                          ];
                                          _treatment.value = _treatment.value
                                              .copyWith(
                                                sideAreas: updatedSideAreas,
                                              );
                                          context.pop();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 20.h,
                                          ),
                                        ),
                                        child: Text(
                                          'Add',
                                          style: CustomFonts.white14w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () => Navigator.of(
                                          context,
                                        ).pop(), // close dialog
                                        child: Text(
                                          'Cancel',
                                          style: CustomFonts.black18w500,
                                        ),
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
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Icon(Icons.add, color: Colors.white, size: 20.r),
                      ),
                      SizedBox(width: 10.w),
                      Text('Add Side Areas', style: CustomFonts.white14w500),
                    ],
                  ),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: _treatment,
                builder: (context, treatment, _) {
                  final sideAreas = treatment.sideAreas ?? [];
                  if (sideAreas.isEmpty) {
                    return SizedBox(height: 20.h);
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 32.h),
                      child: Row(
                        children: List.generate(sideAreas.length, (i) {
                          return Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20.w),
                                height: 200.h,
                                width: 200.w,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(PngAssets.image),
                                    fit: BoxFit.cover,
                                    opacity: 0.5,
                                  ),
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              Text(
                                sideAreas[i].name!,
                                style: CustomFonts.black14w500,
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  );
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // // 2️⃣ If treatments or side areas are loading
                        // if (_loadingAreas || _loadingTreatments) {
                        //   EasyLoading.showError('Please wait while we load');
                        //   return;
                        // }

                        // 3️⃣ Validate form (prices)
                        final isValid =
                            _formKey.currentState?.validate() ?? false;
                        if (!isValid) {
                          return;
                        }
                        // ref
                        //     .read(treatmentViewModelProvider.notifier)
                        //     .addClinicTreatment(
                        //       treatment: AddTreatmentReqModel(
                        //         treatmentId: _selectedTreatment!.id!,
                        //         treatmentPrice:
                        //             double.tryParse(
                        //               _treatmentPriceControllers.text,
                        //             ) ??
                        //             0,
                        //         sideareas: _selectedAreas,
                        //       ),
                        //     )
                        // .then((value) {
                        //   if (value && context.mounted) {
                        //     context.pop();
                        //   }
                        // });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                      ),
                      child: Text('Create', style: CustomFonts.white14w500),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          Navigator.of(context).pop(), // close dialog
                      child: Text('Cancel', style: CustomFonts.black18w500),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
