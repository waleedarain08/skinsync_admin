import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/product_model.dart';
import 'package:skinsync_admin/utils/validators.dart';
import 'package:skinsync_admin/view_models/product_view_model.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'package:skinsync_admin/widgets/custom_dropdown_widget.dart';
import '../build_textfield.dart';
import 'standard_dialog.dart';

class ProductDialogBox extends StatefulWidget {
  const ProductDialogBox({super.key, this.product});
  final ProductModel? product;

  @override
  State<ProductDialogBox> createState() => _ProductDialogBoxState();
}

class _ProductDialogBoxState extends State<ProductDialogBox> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _skuController;
  late final TextEditingController _barcodeController;
  late final TextEditingController _descriptionController;

  String? _selectedBrand;
  String? _selectedPurpose;
  String? _selectedUnitType;
  bool _enforceLotTracking = true;

  final List<String> _brands = [
    "Allergan",
    "Bella Medical",
    "McKesson",
    "Regimen MD",
    "Candela",
    "Galderma",
    "Merz"
  ];

  final Map<String, String> _purposes = {
    "variable": "Variable",
    "required": "Required",
    "setup/supply": "Setup/Supply",
    "retail/sale": "Retail/Sale",
    "device": "Device"
  };

  final Map<String, String> _unitTypes = {
    "units": "Units",
    "syringe": "Syringe",
    "ml": "mL",
    "vial": "Vial",
    "box": "Box",
    "pieces": "Pieces"
  };

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name);
    _skuController = TextEditingController(text: widget.product?.sku ?? widget.product?.globalSku);
    _barcodeController = TextEditingController();
    _descriptionController = TextEditingController(text: widget.product?.description);

    _selectedBrand = widget.product?.brand ?? 'Allergan';
    _selectedPurpose = widget.product?.productPurpose ?? 'variable';
    _selectedUnitType = widget.product?.unitType ?? 'units';
    _enforceLotTracking = widget.product?.enforceLotTracking ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _barcodeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isEdit = widget.product != null;

    return StandardDialog(
      title: isEdit ? 'Edit Catalog Product' : 'Create New Catalog Product',
      width: 700.w,
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImagePicker(),
              SizedBox(height: 24.h),
              
              // SECTION 1: BASIC METADATA
              Text("SECTION 1: BASIC METADATA", style: context.fonts.purple12w700),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: BuildTextField(
                      label: 'Product Name',
                      controller: _nameController,
                      hintText: 'e.g. Botox Cosmetic 100 Unit Vial',
                      validator: Validators.empty,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: CustomDropdown<String>(
                      label: 'Brand / Manufacturer',
                      hintText: 'Select Brand',
                      value: _selectedBrand,
                      items: _brands.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedBrand = val;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: BuildTextField(
                      label: 'Global SKU (Unique key)',
                      controller: _skuController,
                      hintText: 'e.g. ALL-BTX-100U-V',
                      validator: Validators.empty,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: BuildTextField(
                      label: 'Barcode / UPC (Optional)',
                      controller: _barcodeController,
                      hintText: 'e.g. 0123456789',
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 32.h),
              
              // SECTION 2: PLATFORM USAGE & CLASSIFICATION
              Text("SECTION 2: PLATFORM USAGE & CLASSIFICATION", style: context.fonts.purple12w700),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: CustomDropdown<String>(
                      label: 'Product Purpose / Usage Type',
                      hintText: 'Select Purpose',
                      value: _selectedPurpose,
                      items: _purposes.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedPurpose = val;
                          if (val == 'variable') {
                            _enforceLotTracking = true;
                          }
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: CustomDropdown<String>(
                      label: 'Base Measurement Unit',
                      hintText: 'Select Unit',
                      value: _selectedUnitType,
                      items: _unitTypes.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedUnitType = val;
                        });
                      },
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 32.h),
              
              // SECTION 3: GLOBAL COMPLIANCE
              Text("SECTION 3: GLOBAL COMPLIANCE", style: context.fonts.purple12w700),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: CustomColors.whiteGrey,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: CustomColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Enforce Lot & Expiration Tracking at Clinic Level",
                            style: context.fonts.black14w600,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "Forces child clinics to log lot and expiration details upon receiving stock.",
                            style: context.fonts.grey12w400,
                          ),
                        ],
                      ),
                    ),
                    Switch.adaptive(
                      value: _enforceLotTracking,
                      activeColor: CustomColors.purple,
                      onChanged: (val) {
                        setState(() {
                          _enforceLotTracking = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 16.h),
              BuildTextField(
                maxLines: 3,
                label: 'Description / Usage Instructions',
                controller: _descriptionController,
                hintText: 'Global product details and reconstitution instructions...',
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => context.pop(), child: const Text("Cancel")),
        Consumer(
          builder: (context, ref, _) {
            final state = ref.watch(productViewModelProvider);
            return CustomPrimaryButton(
              onTap: () {
                if (!_formKey.currentState!.validate() || state.loading) return;
                final product = ProductModel(
                  id: widget.product?.id,
                  name: _nameController.text,
                  image: widget.product?.image ?? "https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop",
                  unit: _selectedUnitType ?? 'units',
                  description: _descriptionController.text,
                  sku: _skuController.text,
                  category: _selectedPurpose ?? 'variable',
                  quantity: 0,
                  status: "Active",
                  brand: _selectedBrand,
                  globalSku: _skuController.text,
                  productPurpose: _selectedPurpose,
                  unitType: _selectedUnitType,
                  enforceLotTracking: _enforceLotTracking,
                );
                
                final notifier = ref.read(productViewModelProvider.notifier);
                final Future<bool> action = isEdit ? notifier.updateProduct(product) : notifier.addProduct(product);
                
                action.then((success) {
                  if (success && context.mounted) context.pop();
                });
              },
              label: state.loading ? 'Saving...' : 'Save Catalog Product',
              width: 180.w,
            );
          },
        ),
      ],
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Product Image File (Primary Catalog Icon)", style: context.fonts.black14w600),
        SizedBox(height: 12.h),
        Container(
          height: 140.h,
          width: 140.h,
          decoration: BoxDecoration(
            color: CustomColors.whiteGrey,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: CustomColors.grey.withValues(alpha: 0.1)),
          ),
          child: const Center(child: Icon(Icons.add_a_photo_outlined, color: CustomColors.grey)),
        ),
      ],
    );
  }
}
