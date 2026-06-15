import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/product_model.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/utils/validators.dart';
import 'package:skinsync_admin/view_models/master_data_view_model.dart';
import 'package:skinsync_admin/view_models/product_view_model.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';

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
  late final TextEditingController _unitsPerPackageController;

  String? _selectedBrand;
  String? _selectedManufacturer;
  String? _selectedPurpose;
  String? _selectedUnit;
  String? _selectedPackageType;
  bool _enforceLotTracking = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name);
    _skuController = TextEditingController(text: widget.product?.sku ?? widget.product?.globalSku);
    _barcodeController = TextEditingController();
    _descriptionController = TextEditingController(text: widget.product?.description);
    _unitsPerPackageController = TextEditingController(
      text: widget.product?.unitsPerPackage?.toString() ?? '1',
    );

    _selectedBrand = widget.product?.brand;
    _selectedManufacturer = widget.product?.manufacturer;
    _selectedPurpose = widget.product?.productPurpose;
    _selectedUnit = widget.product?.unit;
    _selectedPackageType = widget.product?.packageType;
    _enforceLotTracking = widget.product?.enforceLotTracking ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _barcodeController.dispose();
    _descriptionController.dispose();
    _unitsPerPackageController.dispose();
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
              Text('SECTION 1: BASIC METADATA', style: context.fonts.purple12w700),
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
                    child: Consumer(
                      builder: (context, ref, _) {
                        final brands = ref.watch(masterDataViewModelProvider).brands;
                        return _buildSelectOrCreateDropdown(
                          label: 'Brand',
                          hint: 'Select Brand',
                          value: _selectedBrand,
                          items: brands,
                          onChanged: (val) => setState(() => _selectedBrand = val),
                          onCreate: () => _showCreateMasterItemDialog(
                            context,
                            ref,
                            'Brand',
                            (name) {
                              ref.read(masterDataViewModelProvider.notifier).addBrand(name);
                              setState(() => _selectedBrand = name);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, _) {
                        final manufacturers = ref.watch(masterDataViewModelProvider).manufacturers;
                        return _buildSelectOrCreateDropdown(
                          label: 'Manufacturer',
                          hint: 'Select Manufacturer',
                          value: _selectedManufacturer,
                          items: manufacturers,
                          onChanged: (val) => setState(() => _selectedManufacturer = val),
                          onCreate: () => _showCreateMasterItemDialog(
                            context,
                            ref,
                            'Manufacturer',
                            (name) {
                              ref.read(masterDataViewModelProvider.notifier).addManufacturer(name);
                              setState(() => _selectedManufacturer = name);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: BuildTextField(
                      label: 'Global SKU (Unique key)',
                      controller: _skuController,
                      hintText: 'e.g. ALL-BTX-100U-V',
                      validator: Validators.empty,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              BuildTextField(
                label: 'Barcode / UPC (Optional)',
                controller: _barcodeController,
                hintText: 'e.g. 0123456789',
              ),
              
              SizedBox(height: 32.h),
              
              // SECTION 2: PLATFORM USAGE & CLASSIFICATION
              Text('SECTION 2: PLATFORM USAGE & CLASSIFICATION', style: context.fonts.purple12w700),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, _) {
                        final usageTypes = ref.watch(masterDataViewModelProvider).usageTypes;
                        return _buildSelectOrCreateDropdown(
                          label: 'Product Purpose / Usage Type',
                          hint: 'Select Purpose',
                          value: _selectedPurpose,
                          items: usageTypes,
                          onChanged: (val) {
                            setState(() {
                              _selectedPurpose = val;
                              if (val?.toLowerCase() == 'variable') {
                                _enforceLotTracking = true;
                              }
                            });
                          },
                          onCreate: () => _showCreateMasterItemDialog(
                            context,
                            ref,
                            'Usage Type',
                            (name) {
                              ref.read(masterDataViewModelProvider.notifier).addUsageType(name);
                              setState(() => _selectedPurpose = name);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, _) {
                        final units = ref.watch(masterDataViewModelProvider).units;
                        return _buildSelectOrCreateDropdown(
                          label: 'Base Measurement Unit',
                          hint: 'Select Unit',
                          value: _selectedUnit,
                          items: units,
                          onChanged: (val) => setState(() => _selectedUnit = val),
                          onCreate: () => _showCreateMasterItemDialog(
                            context,
                            ref,
                            'Unit',
                            (name) {
                              ref.read(masterDataViewModelProvider.notifier).addUnit(name);
                              setState(() => _selectedUnit = name);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 32.h),

              // SECTION 3: PACKAGING DETAILS
              Text('SECTION 3: PACKAGING DETAILS', style: context.fonts.purple12w700),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, _) {
                        final packageTypes = ref.watch(masterDataViewModelProvider).packageTypes;
                        return _buildSelectOrCreateDropdown(
                          label: 'Package Type',
                          hint: 'Select Package Type',
                          value: _selectedPackageType,
                          items: packageTypes,
                          onChanged: (val) => setState(() => _selectedPackageType = val),
                          onCreate: () => _showCreateMasterItemDialog(
                            context,
                            ref,
                            'Package Type',
                            (name) {
                              ref.read(masterDataViewModelProvider.notifier).addPackageType(name);
                              setState(() => _selectedPackageType = name);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: BuildTextField(
                      label: 'Units Per Package',
                      controller: _unitsPerPackageController,
                      hintText: 'e.g. 22',
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Required';
                        final numVal = int.tryParse(val);
                        if (numVal == null || numVal <= 0) return 'Must be > 0';
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 32.h),
              
              // SECTION 4: GLOBAL COMPLIANCE
              Text('SECTION 4: GLOBAL COMPLIANCE', style: context.fonts.purple12w700),
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
                            'Enforce Lot & Expiration Tracking at Clinic Level',
                            style: context.fonts.black14w600,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Forces child clinics to log lot and expiration details upon receiving stock.',
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
        TextButton(onPressed: () => context.pop(), child: const Text('Cancel')),
        Consumer(
          builder: (context, ref, _) {
            final state = ref.watch(productViewModelProvider);
            return CustomPrimaryButton(
              onTap: () {
                if (!_formKey.currentState!.validate() || state.loading) return;
                final product = ProductModel(
                  id: widget.product?.id,
                  name: _nameController.text,
                  image: widget.product?.image ?? 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop',
                  unit: _selectedUnit ?? 'units',
                  description: _descriptionController.text,
                  sku: _skuController.text,
                  category: _selectedPurpose ?? 'variable',
                  quantity: 0,
                  status: 'Active',
                  brand: _selectedBrand,
                  manufacturer: _selectedManufacturer,
                  globalSku: _skuController.text,
                  productPurpose: _selectedPurpose,
                  unitType: _selectedUnit,
                  enforceLotTracking: _enforceLotTracking,
                  packageType: _selectedPackageType,
                  unitsPerPackage: int.tryParse(_unitsPerPackageController.text),
                );
                
                final notifier = ref.read(productViewModelProvider.notifier);
                if (isEdit) {
                  notifier.updateProduct(product).then((success) {
                    if (success && context.mounted) context.pop();
                  });
                } else {
                  notifier.addProduct(product).then((newProduct) {
                    if (newProduct != null && context.mounted) context.pop(newProduct);
                  });
                }
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
        Text('Product Image File (Primary Catalog Icon)', style: context.fonts.black14w600),
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

  Widget _buildSelectOrCreateDropdown({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required VoidCallback onCreate,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: context.fonts.black14w600),
            IconButton(
              onPressed: onCreate,
              icon: const Icon(Icons.add_circle_outline_rounded, color: CustomColors.purple, size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
          style: context.fonts.black14w400,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: CustomColors.lightGrey, size: context.sp(20)),
          decoration: AppDecorations.input(context, hint: hint),
          dropdownColor: CustomColors.white,
          borderRadius: context.appBorderRadius(all: 12),
          validator: (val) => val == null || val.isEmpty ? 'Required' : null,
        ),
      ],
    );
  }

  void _showCreateMasterItemDialog(
    BuildContext context,
    WidgetRef ref,
    String entityName,
    void Function(String) onSave,
  ) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => StandardDialog(
        title: 'Create New $entityName',
        width: 400.w,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BuildTextField(
              label: '$entityName Name',
              controller: controller,
              hintText: 'Enter $entityName name...',
              validator: Validators.empty,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          CustomPrimaryButton(
            onTap: () {
              if (controller.text.trim().isNotEmpty) {
                onSave(controller.text.trim());
                Navigator.pop(context);
              }
            },
            label: 'Save',
            width: 100.w,
          ),
        ],
      ),
    );
  }
}
