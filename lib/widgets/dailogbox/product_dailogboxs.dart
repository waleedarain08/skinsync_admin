import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/product_model.dart';
import 'package:skinsync_admin/utils/validators.dart';
import 'package:skinsync_admin/view_models/product_view_model.dart';
import '../../utils/color_constant.dart';
import '../../utils/custom_fonts.dart';
import '../../utils/responsive.dart';
import '../build_textfield.dart';

class ProductDialogBox extends StatefulWidget {
  const ProductDialogBox({super.key, this.product});
  final ProductModel? product;

  @override
  State<ProductDialogBox> createState() => _ProductDialogBoxState();
}

class _ProductDialogBoxState extends State<ProductDialogBox> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _unitController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _skuController;
  late final TextEditingController _categoryController;
  late final TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name);
    _unitController = TextEditingController(text: widget.product?.unit);
    _descriptionController = TextEditingController(text: widget.product?.description);
    _skuController = TextEditingController(text: widget.product?.sku);
    _categoryController = TextEditingController(text: widget.product?.category);
    _quantityController = TextEditingController(text: widget.product?.quantity?.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _unitController.dispose();
    _descriptionController.dispose();
    _skuController.dispose();
    _categoryController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isEdit = widget.product != null;

    return Dialog(
      backgroundColor: CustomColors.whiteColor,
      insetPadding: EdgeInsets.symmetric(
        horizontal: Responsive.when(defaultValue: 120.w, mobile: () => 16.w, tablet: () => 20.w),
        vertical: 50.h,
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
                  Text(isEdit ? 'Edit Product' : 'Add New Product', style: CustomFonts.black22w600),
                  IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.close)),
                ],
              ),
              SizedBox(height: 32.h),
              _buildImagePicker(),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: BuildTextField(
                      label: 'Product Name',
                      controller: _nameController,
                      hintText: 'e.g. Advanced Night Repair',
                      validator: Validators.empty,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: BuildTextField(
                      label: 'SKU',
                      controller: _skuController,
                      hintText: 'SKU-XXXX',
                      validator: Validators.empty,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: BuildTextField(
                      label: 'Category',
                      controller: _categoryController,
                      hintText: 'e.g. Skincare',
                      validator: Validators.empty,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: BuildTextField(
                      label: 'Initial Quantity',
                      controller: _quantityController,
                      hintText: '0',
                      validator: Validators.empty,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: BuildTextField(
                      label: 'Unit (e.g. ml, oz)',
                      controller: _unitController,
                      hintText: 'ml',
                      validator: Validators.empty,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              BuildTextField(
                maxLines: 4,
                label: 'Description',
                controller: _descriptionController,
                hintText: 'Product details and usage instructions...',
                validator: Validators.empty,
              ),
              SizedBox(height: 40.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => context.pop(),
                    style: OutlinedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h)),
                    child: const Text('Cancel'),
                  ),
                  SizedBox(width: 16.w),
                  Consumer(
                    builder: (context, ref, _) {
                      final state = ref.watch(productViewModelProvider);
                      return ElevatedButton(
                        onPressed: () {
                          if (!_formKey.currentState!.validate() || state.loading) return;
                          final product = ProductModel(
                            id: widget.product?.id,
                            name: _nameController.text,
                            image: "https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop",
                            unit: _unitController.text,
                            description: _descriptionController.text,
                            sku: _skuController.text,
                            category: _categoryController.text,
                            quantity: int.tryParse(_quantityController.text) ?? 0,
                            status: "Active",
                          );
                          
                          final notifier = ref.read(productViewModelProvider.notifier);
                          final Future<bool> action = isEdit ? notifier.updateProduct(product) : notifier.addProduct(product);
                          
                          action.then((success) {
                            if (success && context.mounted) context.pop();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.deepNavy,
                          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                        ),
                        child: Text(state.loading ? 'Saving...' : 'Save Product'),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Product Image", style: CustomFonts.black14w500),
        SizedBox(height: 12.h),
        Container(
          height: 160.h,
          width: 160.h,
          decoration: BoxDecoration(
            color: CustomColors.softChampagne,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: CustomColors.greyColor, style: BorderStyle.solid),
          ),
          child: const Center(child: Icon(Icons.add_a_photo_outlined, color: CustomColors.textLight)),
        ),
      ],
    );
  }
}
