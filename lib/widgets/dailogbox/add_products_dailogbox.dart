import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/utils/validators.dart';
import 'package:skinsync_admin/view_models/clinic_view_model.dart';
import 'package:skinsync_admin/view_models/product_view_model.dart';
import '../../models/requests/add_product_req_model.dart';
import '../../models/requests/register_clinic_request_model.dart';
import '../../utils/color_constant.dart';
import '../../utils/custom_fonts.dart';
import '../build_textfield.dart';

class AddProductsDailogbox extends StatefulWidget {
  const AddProductsDailogbox({super.key});

  @override
  State<AddProductsDailogbox> createState() => _AddProductsDailogboxState();
}

class _AddProductsDailogboxState extends State<AddProductsDailogbox> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _unitController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: CustomColors.whiteColor,
      insetPadding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 50.h),
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
                  Text('Add Product', style: CustomFonts.black22w600),
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
              Text("Image", style: CustomFonts.black14w500),
              SizedBox(height: 10.h),
              Container(
                // width: 200.w,
                height: 200.h,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(child: Icon(Icons.image_outlined)),
              ),

              SizedBox(height: 8.h),
              BuildTextField(
                prefixIcon: Icon(
                  Icons.medical_information,
                  color: CustomColors.blueColor,
                  size: 20.sp,
                ),
                validator: Validators.empty,

                label: 'Product Name',
                controller: _nameController,
                hintText: 'Enter Product name',
              ),
              SizedBox(height: 8.h),
              BuildTextField(
                maxLines: 5,
                // prefixIcon: Icon(
                //   Icons.email,
                //   color: CustomColors.blueColor,
                //   size: 20.sp,
                // ),
                validator: Validators.empty,
                label: 'Description',
                controller: _descriptionController,
                hintText: 'Enter product description',
              ),
              SizedBox(height: 8.h),
              BuildTextField(
                prefixIcon: Icon(
                  Icons.email,
                  color: CustomColors.blueColor,
                  size: 20.sp,
                ),
                validator: Validators.empty,

                label: 'Total Units',
                controller: _unitController,
                hintText: 'Enter available Units',
              ),
              SizedBox(height: 8.h),

              Row(
                children: [
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, _) {
                        return ElevatedButton(
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            ref
                                .read(productViewModelProvider.notifier)
                                .addProduct(
                                  AddProductReqModel(
                                    name: _nameController.text,
                                    // clinicPhone: _clinicPhoneController.text,
                                    units: _unitController.text,
                                    // clinicAddress:
                                    //     _clinicAddressController.text,
                                    // ownerName: _clinicOwnerNameController.text,
                                    // ownerEmail:
                                    //     _clinicOwnerEmailController.text,
                                  ),
                                )
                                .then((value) {
                                  if (value && context.mounted) {
                                    context.pop();
                                  }
                                });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                          ),
                          child: Text(
                            ref.watch(clinicViewModelProvider).loading
                                ? 'Creating...'
                                : 'Create',
                            style: CustomFonts.white14w500,
                          ),
                        );
                      },
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
