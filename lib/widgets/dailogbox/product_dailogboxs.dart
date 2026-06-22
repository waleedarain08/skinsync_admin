import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/product_model.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/utils/validators.dart';
import 'package:skinsync_admin/view_models/master_data_view_model.dart';
import 'package:skinsync_admin/view_models/product_view_model.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import '../custom_outlined_button.dart';
import '../../models/responses/category_list_response.dart';
import '../../view_models/category_view_model.dart';
import '../build_textfield.dart';
import 'standard_dialog.dart';

class ProductDialogBox extends ConsumerStatefulWidget {
  const ProductDialogBox({super.key, this.product});
  final ProductModel? product;

  @override
  ConsumerState<ProductDialogBox> createState() => _ProductDialogBoxState();
}

class _ProductDialogBoxState extends ConsumerState<ProductDialogBox> {
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
  List<int> _selectedCategoryIds = [];

  void _updateTotalBillableQuantity() {
    final int boxQty = int.tryParse(_boxQuantityController.text) ?? 0;
    final int itemQty = int.tryParse(_itemQuantityPerBoxController.text) ?? 0;
    final double billableQty = double.tryParse(_billableQuantityPerItemController.text) ?? 0.0;
    final double total = boxQty * itemQty * billableQty;
    _totalBillableQuantityController.text = total.toStringAsFixed(1);
  }

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
    _selectedCategoryIds = widget.product?.selectedCategoryIds ?? [];
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Category', style: context.fonts.black14w600),
                            IconButton(
                              onPressed: () => _showCategorySelectionDialog(context),
                              icon: const Icon(Icons.add_circle_outline_rounded, color: CustomColors.purple, size: 20),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        GestureDetector(
                          onTap: () => _showCategorySelectionDialog(context),
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: TextEditingController(text: _selectedCategory),
                              style: context.fonts.black14w400,
                              decoration: AppDecorations.input(
                                context,
                                hint: 'Select Category Hierarchy',
                              ).copyWith(
                                suffixIcon: Icon(
                                  Icons.keyboard_arrow_right_rounded,
                                  color: CustomColors.lightGrey,
                                  size: context.sp(20),
                                ),
                              ),
                              validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                            ),
                          ),
                        ),
                      ],
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
              SizedBox(height: 16.h),
              Row(
                children: [
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
                  // Expanded(
                  //   child: SelectOrCreateDropdown<UsageType>(
                  //     label: 'Usage Type',
                  //     hint: 'Select Usage Type',
                  //     value: _selectedPurpose,
                  //     items: UsageType.values,
                  //     itemLabel: (usageType) => usageType.name,
                  //     onChanged: (val) =>
                  //         setState(() => _selectedPurpose = val),
                  //     onOpen: () => ref
                  //         .read(productViewModelProvider.notifier)
                  //         .fetchBrand(),
                  //     onCreate: () {},
                  //     // onCreate: () => _showCreateMasterItemDialog(
                  //     //   context,
                  //     //   ref,
                  //     //   'Usage Type',
                  //     //       (name) =>
                  //     //       setState(() => _selectedPurpose = name),
                  //     // ),
                  //   ),
                  // ),
                ],
              ),
              
              SizedBox(height: 32.h),

              // SECTION 2: PACKAGING
              Text('SECTION 2: PACKAGING', style: context.fonts.purple12w700),
              SizedBox(height: 16.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Consumer(
                          builder: (context, ref, _) {
                            final packageTypes = ref.watch(masterDataViewModelProvider).packageTypes;
                            return _buildSelectOrCreateDropdown(
                              label: 'Unit Type',
                              hint: 'Select Unit Type',
                              value: _selectedUnit,
                              items: packageTypes,
                              onChanged: (val) {
                                setState(() {
                                  _selectedUnit = val;
                                  _updateTotalBillableQuantity();
                                });
                              },
                              onCreate: () => _showCreateMasterItemDialog(
                                context,
                                ref,
                                'Unit Type',
                                (name) {
                                  ref.read(masterDataViewModelProvider.notifier).addPackageType(name);
                                  setState(() {
                                    _selectedUnit = name;
                                    _updateTotalBillableQuantity();
                                  });
                                },
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 6.h),
                        Text('The bulk unit purchased from suppliers, e.g. Carton, Case.', style: context.fonts.grey12w400),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BuildTextField(
                          label: 'Box Quantity',
                          controller: _boxQuantityController,
                          hintText: 'e.g. 10',
                          keyboardType: TextInputType.number,
                          onChanged: (_) {
                            setState(() {
                              _updateTotalBillableQuantity();
                            });
                          },
                        ),
                        SizedBox(height: 6.h),
                        Text('Number of inner boxes inside one Unit Type bulk unit.', style: context.fonts.grey12w400),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BuildTextField(
                          label: 'Item Quantity Per Box',
                          controller: _itemQuantityPerBoxController,
                          hintText: 'e.g. 1',
                          keyboardType: TextInputType.number,
                          onChanged: (_) {
                            setState(() {
                              _updateTotalBillableQuantity();
                            });
                          },
                        ),
                        SizedBox(height: 6.h),
                        Text('Count of physical consumable items (like syringes) per inner box.', style: context.fonts.grey12w400),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Consumer(
                          builder: (context, ref, _) {
                            final units = ref.watch(masterDataViewModelProvider).units;
                            return _buildSelectOrCreateDropdown(
                              label: 'Package Type',
                              hint: 'Select Package Type',
                              value: _selectedPackageType,
                              items: units,
                              onChanged: (val) {
                                setState(() {
                                  _selectedPackageType = val;
                                  _updateTotalBillableQuantity();
                                });
                              },
                              onCreate: () => _showCreateMasterItemDialog(
                                context,
                                ref,
                                'Package Type',
                                (name) {
                                  ref.read(masterDataViewModelProvider.notifier).addUnit(name);
                                  setState(() {
                                    _selectedPackageType = name;
                                    _updateTotalBillableQuantity();
                                  });
                                },
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 6.h),
                        Text('The base physical consumable item type, e.g. Syringe, Vial.', style: context.fonts.grey12w400),
                      ],
                    ),
                  ),
                ],
              ),

              // DYNAMIC PACKAGING CALCULATION FOOTER
              Builder(
                builder: (context) {
                  final int boxQty = int.tryParse(_boxQuantityController.text) ?? 0;
                  final int itemQty = int.tryParse(_itemQuantityPerBoxController.text) ?? 0;
                  final int totalItems = boxQty * itemQty;
                  final String unitName = _selectedUnit ?? 'Carton';
                  final String packName = _selectedPackageType ?? 'Syringe';
                  
                  return Container(
                    margin: EdgeInsets.only(top: 16.h),
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: CustomColors.purple.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: CustomColors.purple.withValues(alpha: 0.1)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calculate_outlined, color: CustomColors.purple, size: 20),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            "Total ${packName}s in 1 $unitName = $boxQty boxes × $itemQty ${packName}s = $totalItems ${packName}s.",
                            style: context.fonts.purple14w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              ),

              SizedBox(height: 32.h),

              // SECTION 3: BILLING / CONSUMPTION
              Text('SECTION 3: BILLING / CONSUMPTION', style: context.fonts.purple12w700),
              SizedBox(height: 16.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Consumer(
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
                        SizedBox(height: 6.h),
                        Text('Unit of measurement for treatment and billing, e.g. ml, units.', style: context.fonts.grey12w400),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BuildTextField(
                          label: 'Billable Quantity Per Item',
                          controller: _billableQuantityPerItemController,
                          hintText: 'e.g. 1.0',
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (_) {
                            setState(() {
                              _updateTotalBillableQuantity();
                            });
                          },
                        ),
                        SizedBox(height: 6.h),
                        Text('Volume or potency contained in a single syringe/vial, e.g. 4.0 ml.', style: context.fonts.grey12w400),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BuildTextField(
                    label: 'Total Billable Quantity',
                    controller: _totalBillableQuantityController,
                    hintText: 'Calculated automatically...',
                    readOnly: true,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  SizedBox(height: 6.h),
                  Text('Calculated total volume/potency of the entire bulk unit (Unit Type) in billable units.', style: context.fonts.grey12w400),
                ],
              ),

              SizedBox(height: 32.h),

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
                  selectedCategoryIds: _selectedCategoryIds,
                  barcode: _barcodeController.text,
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

  void _showCategorySelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CategorySelectionDialog(
        initialCategoryIds: _selectedCategoryIds,
        onConfirmed: (result) {
          setState(() {
            _selectedCategory = result['path'] as String;
            _selectedCategoryIds = result['ids'] as List<int>;
          });
        },
      ),
    );
  }
}

class CategorySelectionDialog extends ConsumerStatefulWidget {
  final List<int> initialCategoryIds;
  final ValueChanged<Map<String, dynamic>> onConfirmed;

  const CategorySelectionDialog({
    super.key,
    required this.initialCategoryIds,
    required this.onConfirmed,
  });

  @override
  ConsumerState<CategorySelectionDialog> createState() => _CategorySelectionDialogState();
}

class _CategorySelectionDialogState extends ConsumerState<CategorySelectionDialog> {
  final List<int> _selectedIds = [];
  final List<String> _selectedNames = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoryViewModelProvider.notifier).fetchCategories();
    });

    _selectedIds.addAll(widget.initialCategoryIds);
    _rebuildNamesPath();
  }

  void _rebuildNamesPath() {
    _selectedNames.clear();
    final categories = ref.read(categoryViewModelProvider).categories;
    
    CategoryModel? findInList(List<CategoryModel> list, int id) {
      for (final cat in list) {
        if (cat.id == id) return cat;
        final child = findInList(cat.subCategories, id);
        if (child != null) return child;
      }
      return null;
    }

    for (final id in _selectedIds) {
      final node = findInList(categories, id);
      if (node != null) {
        _selectedNames.add(node.name);
      }
    }
  }

  CategoryModel? _findCategoryInTree(List<CategoryModel> items, int id) {
    for (final item in items) {
      if (item.id == id) return item;
      if (item.subCategories.isNotEmpty) {
        final found = _findCategoryInTree(item.subCategories, id);
        if (found != null) return found;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryViewModelProvider);
    final categories = categoryState.categories;

    final List<List<CategoryModel>> columns = [categories];
    for (int i = 0; i < _selectedIds.length; i++) {
      final selectedId = _selectedIds[i];
      final node = _findCategoryInTree(categories, selectedId);
      if (node != null && node.subCategories.isNotEmpty) {
        columns.add(node.subCategories);
      } else {
        break;
      }
    }

    final selectedPathText = _selectedNames.isNotEmpty
        ? _selectedNames.join(' → ')
        : 'None';

    return StandardDialog(
      title: 'Select Category',
      width: context.w(800),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selected Path:',
            style: context.fonts.black14w600,
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            width: double.infinity,
            decoration: BoxDecoration(
              color: CustomColors.whiteGrey,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: CustomColors.border),
            ),
            child: Text(
              selectedPathText,
              style: context.fonts.purple14w600,
            ),
          ),
          SizedBox(height: 24.h),
          SizedBox(
            height: context.h(300),
            child: columns.isEmpty || categories.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Scrollbar(
                    thumbVisibility: true,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: columns.length,
                      separatorBuilder: (context, index) => Container(
                        width: 1,
                        color: CustomColors.border,
                        margin: EdgeInsets.symmetric(horizontal: 12.w),
                      ),
                      itemBuilder: (context, columnIndex) {
                        final items = columns[columnIndex];
                        final activeId = _selectedIds.length > columnIndex
                            ? _selectedIds[columnIndex]
                            : null;

                        return SizedBox(
                          width: context.w(220),
                          child: ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, itemIndex) {
                              final item = items[itemIndex];
                              final isSelected = activeId == item.id;

                              return Container(
                                margin: EdgeInsets.only(bottom: 8.h),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? CustomColors.purple.withValues(alpha: 0.1)
                                      : Colors.white,
                                  borderRadius: context.appBorderRadius(all: 10),
                                  border: Border.all(
                                    color: isSelected
                                        ? CustomColors.purple
                                        : CustomColors.border,
                                    width: isSelected ? 1.5 : 1,
                                  ),
                                ),
                                child: ListTile(
                                  title: Text(
                                    item.name,
                                    style: isSelected
                                        ? context.fonts.purple14w600
                                        : context.fonts.black14w400,
                                  ),
                                  trailing: item.subCategories.isNotEmpty
                                      ? Icon(
                                          Icons.chevron_right_rounded,
                                          color: isSelected
                                              ? CustomColors.purple
                                              : CustomColors.lightGrey,
                                        )
                                      : null,
                                  onTap: () {
                                    setState(() {
                                      if (columnIndex < _selectedIds.length) {
                                        _selectedIds.removeRange(
                                            columnIndex, _selectedIds.length);
                                        _selectedNames.removeRange(
                                            columnIndex, _selectedNames.length);
                                      }
                                      _selectedIds.add(item.id);
                                      _selectedNames.add(item.name);
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      actions: [
        CustomOutlinedButton(
          onTap: () {
            widget.onConfirmed({
              'path': '',
              'ids': <int>[],
            });
            Navigator.pop(context);
          },
          label: 'Clear Category',
        ),
        const Spacer(),
        CustomOutlinedButton(
          onTap: () => Navigator.pop(context),
          label: 'Cancel',
        ),
        SizedBox(width: 12.w),
        CustomPrimaryButton(
          onTap: () {
            widget.onConfirmed({
              'path': _selectedNames.join(' > '),
              'ids': List<int>.from(_selectedIds),
            });
            Navigator.pop(context);
          },
          label: 'Select Category',
        ),
      ],
    );
  }
}
