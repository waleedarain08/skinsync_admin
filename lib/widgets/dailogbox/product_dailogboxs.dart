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
  
  // New Controllers from Master Checklist
  late final TextEditingController _boxQuantityController;
  late final TextEditingController _itemQuantityPerBoxController;
  late final TextEditingController _billableQuantityPerItemController;
  late final TextEditingController _totalBillableQuantityController;
  late final TextEditingController _clinicCostController;
  late final TextEditingController _retailPricePerUnitController;
  late final TextEditingController _supplierController;
  late final TextEditingController _lotNumberController;
  late final TextEditingController _expirationDateController;

  String? _selectedBrand;
  String? _selectedManufacturer;
  String? _selectedPurpose;
  String? _selectedUnit;
  String? _selectedPackageType;
  String? _selectedCategory;
  String? _selectedSubcategory;
  String? _selectedBillableUnit;
  bool _enforceLotTracking = true;
  bool _activeStatus = true;
  DateTime? _expirationDate;

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

    _boxQuantityController = TextEditingController(text: widget.product?.boxQuantity?.toString() ?? '0');
    _itemQuantityPerBoxController = TextEditingController(text: widget.product?.itemQuantityPerBox?.toString() ?? '0');
    _billableQuantityPerItemController = TextEditingController(text: widget.product?.billableQuantityPerItem?.toString() ?? '0');
    _totalBillableQuantityController = TextEditingController(text: widget.product?.totalBillableQuantity?.toString() ?? '0');
    _clinicCostController = TextEditingController(text: widget.product?.clinicCost?.toString() ?? '0');
    _retailPricePerUnitController = TextEditingController(text: widget.product?.retailPricePerUnit?.toString() ?? '0');
    _supplierController = TextEditingController(text: widget.product?.supplier);
    _lotNumberController = TextEditingController(text: widget.product?.lotNumber);
    
    if (widget.product?.expirationDate != null) {
      _expirationDate = widget.product!.expirationDate;
      _expirationDateController = TextEditingController(
        text: '${_expirationDate!.year}-${_expirationDate!.month}-${_expirationDate!.day}',
      );
    } else {
      _expirationDateController = TextEditingController();
    }

    _selectedBrand = widget.product?.brand;
    _selectedManufacturer = widget.product?.manufacturer;
    _selectedPurpose = widget.product?.productPurpose;
    _selectedUnit = widget.product?.unit;
    _selectedPackageType = widget.product?.packageType;
    _selectedCategory = widget.product?.category;
    _selectedSubcategory = widget.product?.subcategory;
    _selectedBillableUnit = widget.product?.billableUnit;
    _enforceLotTracking = widget.product?.enforceLotTracking ?? true;
    _activeStatus = widget.product?.status?.toLowerCase() != 'inactive';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _barcodeController.dispose();
    _descriptionController.dispose();
    _unitsPerPackageController.dispose();
    _boxQuantityController.dispose();
    _itemQuantityPerBoxController.dispose();
    _billableQuantityPerItemController.dispose();
    _totalBillableQuantityController.dispose();
    _clinicCostController.dispose();
    _retailPricePerUnitController.dispose();
    _supplierController.dispose();
    _lotNumberController.dispose();
    _expirationDateController.dispose();
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
              
              // SECTION 1: BASIC INFORMATION
              Text('SECTION 1: BASIC INFORMATION', style: context.fonts.purple12w700),
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
                        final categories = ref.watch(masterDataViewModelProvider).categories;
                        return _buildSelectOrCreateDropdown(
                          label: 'Category',
                          hint: 'Select Category',
                          value: _selectedCategory,
                          items: categories,
                          onChanged: (val) => setState(() => _selectedCategory = val),
                          onCreate: () => _showCreateMasterItemDialog(
                            context,
                            ref,
                            'Category',
                            (name) {
                              ref.read(masterDataViewModelProvider.notifier).addCategory(name);
                              setState(() => _selectedCategory = name);
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
                        final subcategories = ref.watch(masterDataViewModelProvider).subcategories;
                        return _buildSelectOrCreateDropdown(
                          label: 'Subcategory',
                          hint: 'Select Subcategory',
                          value: _selectedSubcategory,
                          items: subcategories,
                          onChanged: (val) => setState(() => _selectedSubcategory = val),
                          onCreate: () => _showCreateMasterItemDialog(
                            context,
                            ref,
                            'Subcategory',
                            (name) {
                              ref.read(masterDataViewModelProvider.notifier).addSubcategory(name);
                              setState(() => _selectedSubcategory = name);
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

              // SECTION 2: PACKAGING
              Text('SECTION 2: PACKAGING', style: context.fonts.purple12w700),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, _) {
                        final units = ref.watch(masterDataViewModelProvider).units;
                        return _buildSelectOrCreateDropdown(
                          label: 'Unit Type',
                          hint: 'Select Unit Type',
                          value: _selectedUnit,
                          items: units,
                          onChanged: (val) => setState(() => _selectedUnit = val),
                          onCreate: () => _showCreateMasterItemDialog(
                            context,
                            ref,
                            'Unit Type',
                            (name) {
                              ref.read(masterDataViewModelProvider.notifier).addUnit(name);
                              setState(() => _selectedUnit = name);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: BuildTextField(
                      label: 'Box Quantity',
                      controller: _boxQuantityController,
                      hintText: 'e.g. 10',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: BuildTextField(
                      label: 'Item Quantity Per Box',
                      controller: _itemQuantityPerBoxController,
                      hintText: 'e.g. 1',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 16.w),
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
                ],
              ),

              SizedBox(height: 32.h),

              // SECTION 3: BILLING / CONSUMPTION
              Text('SECTION 3: BILLING / CONSUMPTION', style: context.fonts.purple12w700),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, _) {
                        final units = ref.watch(masterDataViewModelProvider).units;
                        return _buildSelectOrCreateDropdown(
                          label: 'Billable Unit',
                          hint: 'Select Billable Unit',
                          value: _selectedBillableUnit,
                          items: units,
                          onChanged: (val) => setState(() => _selectedBillableUnit = val),
                          onCreate: () => _showCreateMasterItemDialog(
                            context,
                            ref,
                            'Billable Unit',
                            (name) {
                              ref.read(masterDataViewModelProvider.notifier).addUnit(name);
                              setState(() => _selectedBillableUnit = name);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: BuildTextField(
                      label: 'Billable Quantity Per Item',
                      controller: _billableQuantityPerItemController,
                      hintText: 'e.g. 1.0',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              BuildTextField(
                label: 'Total Billable Quantity',
                controller: _totalBillableQuantityController,
                hintText: 'e.g. 100.0',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),

              SizedBox(height: 32.h),

              // SECTION 4: PRICING
              Text('SECTION 4: PRICING', style: context.fonts.purple12w700),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: BuildTextField(
                      label: 'Clinic Cost (\$)',
                      controller: _clinicCostController,
                      hintText: '0.00',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: Validators.empty,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: BuildTextField(
                      label: 'Retail Price Per Unit (\$)',
                      controller: _retailPricePerUnitController,
                      hintText: '0.00',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: Validators.empty,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 32.h),

              // SECTION 5: SUPPLIER & INVENTORY
              Text('SECTION 5: SUPPLIER & INVENTORY', style: context.fonts.purple12w700),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: BuildTextField(
                      label: 'Supplier',
                      controller: _supplierController,
                      hintText: 'Enter supplier name...',
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: BuildTextField(
                      label: 'Lot Number',
                      controller: _lotNumberController,
                      hintText: 'e.g. LOT123456',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _expirationDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          setState(() {
                            _expirationDate = date;
                            _expirationDateController.text = '${date.year}-${date.month}-${date.day}';
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: BuildTextField(
                          label: 'Expiration Date',
                          controller: _expirationDateController,
                          hintText: 'YYYY-MM-DD',
                          suffixIcon: const Icon(Icons.calendar_today_rounded, size: 18),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, _) {
                        final usageTypes = ref.watch(masterDataViewModelProvider).usageTypes;
                        return _buildSelectOrCreateDropdown(
                          label: 'Usage Type',
                          hint: 'Select Usage Type',
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
                ],
              ),

              SizedBox(height: 32.h),
              
              // SECTION 6: GLOBAL COMPLIANCE & STATUS
              Text('SECTION 6: GLOBAL COMPLIANCE & STATUS', style: context.fonts.purple12w700),
              SizedBox(height: 16.h),
              _buildSwitchRow(
                title: 'Enforce Lot & Expiration Tracking at Clinic Level',
                subtitle: 'Forces child clinics to log lot and expiration details upon receiving stock.',
                value: _enforceLotTracking,
                onChanged: (val) => setState(() => _enforceLotTracking = val),
              ),
              SizedBox(height: 16.h),
              _buildSwitchRow(
                title: 'Active Status',
                subtitle: 'Enable or disable this product in the global catalog.',
                value: _activeStatus,
                onChanged: (val) => setState(() => _activeStatus = val),
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
                  category: _selectedCategory,
                  subcategory: _selectedSubcategory,
                  quantity: 0,
                  status: _activeStatus ? 'Active' : 'Inactive',
                  brand: _selectedBrand,
                  manufacturer: _selectedManufacturer,
                  globalSku: _skuController.text,
                  productPurpose: _selectedPurpose,
                  unitType: _selectedUnit,
                  enforceLotTracking: _enforceLotTracking,
                  packageType: _selectedPackageType,
                  unitsPerPackage: int.tryParse(_unitsPerPackageController.text),
                  boxQuantity: int.tryParse(_boxQuantityController.text),
                  itemQuantityPerBox: int.tryParse(_itemQuantityPerBoxController.text),
                  billableUnit: _selectedBillableUnit,
                  billableQuantityPerItem: double.tryParse(_billableQuantityPerItemController.text),
                  totalBillableQuantity: double.tryParse(_totalBillableQuantityController.text),
                  clinicCost: double.tryParse(_clinicCostController.text),
                  retailPricePerUnit: double.tryParse(_retailPricePerUnitController.text),
                  supplier: _supplierController.text,
                  lotNumber: _lotNumberController.text,
                  expirationDate: _expirationDate,
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

  Widget _buildSwitchRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
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
                Text(title, style: context.fonts.black14w600),
                SizedBox(height: 4.h),
                Text(subtitle, style: context.fonts.grey12w400),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeColor: CustomColors.purple,
            onChanged: onChanged,
          ),
        ],
      ),
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
