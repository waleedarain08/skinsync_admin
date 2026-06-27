import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/product_model.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/utils/validators.dart';
import 'package:skinsync_admin/view_models/product_view_model.dart';
import 'package:skinsync_admin/view_models/category_view_model.dart';
import 'package:skinsync_admin/widgets/custom_primary_button.dart';
import 'package:skinsync_admin/widgets/custom_outlined_button.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';
import '../widgets/build_textfield.dart';
import '../widgets/app_network_image.dart';
import '../widgets/dailogbox/category_selection_dialog.dart';
import '../widgets/select_or_create_dropdown_widget.dart';

class CreateProductScreen extends ConsumerStatefulWidget {
  const CreateProductScreen({super.key, this.productToEdit});

  final ProductModel? productToEdit;

  static const String routeName = '/create-product';

  @override
  ConsumerState<CreateProductScreen> createState() =>
      _CreateProductScreenState();
}

class _CreateProductScreenState extends ConsumerState<CreateProductScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _skuController;
  late final TextEditingController _barcodeController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _unitsPerPackageController;

  late final TextEditingController _boxQuantityController;
  late final TextEditingController _itemQuantityPerBoxController;
  late final TextEditingController _billableQuantityPerItemController;
  late final TextEditingController _totalBillableQuantityController;
  late final TextEditingController _clinicCostController;
  late final TextEditingController _retailPricePerUnitController;
  late final TextEditingController _lotNumberController;
  late final TextEditingController _expirationDateController;

  String? _selectedBrand;
  String? _selectedSupplier;
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
  List<int> _selectedCategoryIds = [];

  void _updateTotalBillableQuantity() {
    final int boxQty = int.tryParse(_boxQuantityController.text) ?? 0;
    final int itemQty = int.tryParse(_itemQuantityPerBoxController.text) ?? 0;
    final double billableQty =
        double.tryParse(_billableQuantityPerItemController.text) ?? 0.0;
    final double total = boxQty * itemQty * billableQty;
    _totalBillableQuantityController.text = total.toStringAsFixed(1);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productViewModelProvider.notifier).setImageNull();
      ref.read(productViewModelProvider.notifier).clearDropdowns();
    });

    _nameController = TextEditingController(text: widget.productToEdit?.name);
    _skuController = TextEditingController(
      text: widget.productToEdit?.sku ?? widget.productToEdit?.globalSku,
    );
    _barcodeController = TextEditingController(
      text: widget.productToEdit?.barcode,
    );
    _descriptionController = TextEditingController(
      text: widget.productToEdit?.description,
    );
    _unitsPerPackageController = TextEditingController(
      text: widget.productToEdit?.unitsPerPackage?.toString() ?? '1',
    );

    _boxQuantityController = TextEditingController(
      text: widget.productToEdit?.boxQuantity?.toString() ?? '0',
    );
    _itemQuantityPerBoxController = TextEditingController(
      text: widget.productToEdit?.itemQuantityPerBox?.toString() ?? '0',
    );
    _billableQuantityPerItemController = TextEditingController(
      text: widget.productToEdit?.billableQuantityPerItem?.toString() ?? '0',
    );
    _totalBillableQuantityController = TextEditingController(
      text: widget.productToEdit?.totalBillableQuantity?.toString() ?? '0',
    );
    _clinicCostController = TextEditingController(
      text: widget.productToEdit?.clinicCost?.toString() ?? '0',
    );
    _retailPricePerUnitController = TextEditingController(
      text: widget.productToEdit?.retailPricePerUnit?.toString() ?? '0',
    );
    _lotNumberController = TextEditingController(
      text: widget.productToEdit?.lotNumber,
    );

    if (widget.productToEdit?.expirationDate != null) {
      _expirationDate = widget.productToEdit!.expirationDate;
      _expirationDateController = TextEditingController(
        text:
            '${_expirationDate!.year}-${_expirationDate!.month}-${_expirationDate!.day}',
      );
    } else {
      _expirationDateController = TextEditingController();
    }

    _selectedBrand = widget.productToEdit?.brand;
    _selectedSupplier = widget.productToEdit?.supplier;
    _selectedManufacturer = widget.productToEdit?.manufacturer;
    _selectedPurpose = widget.productToEdit?.productPurpose;
    _selectedUnit = widget.productToEdit?.unit;
    _selectedPackageType = widget.productToEdit?.packageType;
    _selectedCategory = widget.productToEdit?.category;
    _selectedSubcategory = widget.productToEdit?.subcategory;
    _selectedBillableUnit = widget.productToEdit?.billableUnit;
    _enforceLotTracking = widget.productToEdit?.enforceLotTracking ?? true;
    _activeStatus = widget.productToEdit?.status?.toLowerCase() != 'inactive';
    _selectedCategoryIds = widget.productToEdit?.selectedCategoryIds ?? [];
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
    _lotNumberController.dispose();
    _expirationDateController.dispose();
    super.dispose();
  }

  void _showCreateMasterItemDialog(
    BuildContext context,
    WidgetRef ref,
    String title,
    void Function(String name) onAdd,
  ) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create New $title', style: context.fonts.black18w600),
          content: BuildTextField(
            label: 'Name',
            controller: controller,
            hintText: 'Enter name...',
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: CustomPrimaryButton(
                onTap: () {
                  final name = controller.text.trim();
                  if (name.isNotEmpty) {
                    onAdd(name);
                    Navigator.pop(context);
                  }
                },
                label: 'Add',
                width: 100.w,
              ),
            ),
            SizedBox(height: 10.h),
            CustomOutlinedButton(
              onTap: () => Navigator.pop(context),
              label: 'Cancel',
            ),
          ],
        );
      },
    );
  }

  Widget _buildImagePicker() {
    final state = ref.watch(productViewModelProvider);

    final image = state.imageUrl ?? widget.productToEdit?.image;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Product Image', style: context.fonts.black14w600),

        SizedBox(height: 12.h),

        InkWell(
          onTap: () {
            ref.read(productViewModelProvider.notifier).pickAndUploadImage();
          },

          child: Container(
            width: 140.w,
            height: 140.w,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(),
            ),

            child: image != null && image.isNotEmpty && image != ''
                ? AppNetworkImage(
                    imageUrl: image,
                    width: 140.w,
                    height: 140.w,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.circular(12),
                    errorIcon: Icons.broken_image_outlined,
                    errorIconSize: 40,
                  )
                : const Center(child: Icon(Icons.add_a_photo)),
          ),
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
              icon: const Icon(
                Icons.add_circle_outline_rounded,
                color: CustomColors.purple,
                size: 20,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
          style: context.fonts.black14w400,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: CustomColors.lightGrey,
            size: context.sp(20),
          ),
          decoration: AppDecorations.input(context, hint: hint),
          dropdownColor: CustomColors.white,
          borderRadius: context.appBorderRadius(all: 12),
          validator: (val) => val == null || val.isEmpty ? 'Required' : null,
        ),
      ],
    );
  }

  Future<void> _showCategorySelectionDialog(BuildContext context) async {
    try {
      // Fetch categories with the default screen loader
      await ref.read(categoryViewModelProvider.notifier).fetchCategories();

      if (!context.mounted) return;

      await showDialog(
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
    } catch (e) {
      // Any errors will be handled or logged automatically by runSafely in the view model
    }
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
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: CustomColors.purple,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isEdit =
        widget.productToEdit != null && widget.productToEdit!.id != null;
    final bool isCategoryLocked =
        widget.productToEdit != null &&
        widget.productToEdit!.id == null &&
        widget.productToEdit!.category != null;
    final state = ref.watch(productViewModelProvider);

    return GradientScaffold(
      body: Padding(
        padding: context.appEdgeInsets(all: 32),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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
                      SizedBox(width: 8.w),
                      Text(
                        isEdit
                            ? 'Edit Catalog Product'
                            : 'Create New Catalog Product',
                        style: context.fonts.black32w700,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      CustomOutlinedButton(
                        onTap: () => context.pop(),
                        label: 'Cancel',
                      ),
                      SizedBox(width: 16.w),
                      CustomPrimaryButton(
                        onTap: () {
                          if (!_formKey.currentState!.validate() ||
                              state.loading)
                            return;
                          final product = ProductModel(
                            id: widget.productToEdit?.id,
                            name: _nameController.text,
                            image:
                                state.imageUrl ??
                                widget.productToEdit?.image ??
                                '',
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
                            unitsPerPackage: int.tryParse(
                              _unitsPerPackageController.text,
                            ),
                            boxQuantity: int.tryParse(
                              _boxQuantityController.text,
                            ),
                            itemQuantityPerBox: int.tryParse(
                              _itemQuantityPerBoxController.text,
                            ),
                            billableUnit: _selectedBillableUnit,
                            billableQuantityPerItem: double.tryParse(
                              _billableQuantityPerItemController.text,
                            ),
                            totalBillableQuantity: double.tryParse(
                              _totalBillableQuantityController.text,
                            ),
                            clinicCost: double.tryParse(
                              _clinicCostController.text,
                            ),
                            retailPricePerUnit: double.tryParse(
                              _retailPricePerUnitController.text,
                            ),
                            supplier: _selectedSupplier,
                            lotNumber: _lotNumberController.text,
                            expirationDate: _expirationDate?.toUtc(),
                            selectedCategoryIds: _selectedCategoryIds,
                            barcode: _barcodeController.text,
                          );

                          final notifier = ref.read(
                            productViewModelProvider.notifier,
                          );
                          if (isEdit) {
                            notifier.updateProduct(product).then((success) {
                              if (success && context.mounted) context.pop(true);
                            });
                          } else {
                            notifier.createProduct(product).then((success) {
                              if (success == true && context.mounted)
                                context.pop(true);
                            });
                          }
                        },
                        label: state.loading
                            ? 'Saving...'
                            : 'Save Catalog Product',
                        width: 180.w,
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Header Row
                      SizedBox(height: 32.h),

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
                            _buildImagePicker(),
                            SizedBox(height: 24.h),

                            // SECTION 1: BASIC INFORMATION
                            Text(
                              'SECTION 1: BASIC INFORMATION',
                              style: context.fonts.purple12w700,
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: BuildTextField(
                                    label: 'Product Name',
                                    controller: _nameController,
                                    hintText:
                                        'e.g. Botox Cosmetic 100 Unit Vial',
                                    validator: Validators.empty,
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                // Expanded(
                                //   child: Consumer(
                                //     builder: (context, ref, _) {
                                //       final brands = ref
                                //           .watch(productViewModelProvider)
                                //           .brands
                                //           ?.map((e) => e.name)
                                //           .toList() ??
                                //           [];
                                //       return _buildSelectOrCreateDropdown(
                                //         label: 'Brand',
                                //         hint: 'Select Brand',
                                //         value: _selectedBrand,
                                //         items: brands,
                                //         onChanged: (val) =>
                                //             setState(() => _selectedBrand = val),
                                //         onCreate: () => _showCreateMasterItemDialog(
                                //           context,
                                //           ref,
                                //           'Brand',
                                //           (name) {
                                //             ref.read(productViewModelProvider.notifier).fetchBrand();
                                //             // ref
                                //             //     .read(
                                //             //       masterDataViewModelProvider
                                //             //           .notifier,
                                //             //     )
                                //             //     .addBrand(name).then((_){
                                //             //
                                //             //     });
                                //             setState(() => _selectedBrand = name);
                                //           },
                                //         ),
                                //       );
                                //     },
                                //   ),
                                // ),
                                Expanded(
                                  child: Consumer(
                                    builder: (context, ref, _) {
                                      final brands =
                                          ref
                                              .watch(productViewModelProvider)
                                              .brands ??
                                          [];

                                      return SelectOrCreateDropdown<String>(
                                        label: 'Brand',
                                        hint: 'Select Brand',
                                        value: _selectedBrand,
                                        items: brands
                                            .map((e) => e.name)
                                            .toList(),
                                        // ← convert to List<String>
                                        itemLabel: (brand) => brand,
                                        // ← String displays itself
                                        onChanged: (val) => setState(
                                          () => _selectedBrand = val,
                                        ),
                                        onOpen: () => ref
                                            .read(
                                              productViewModelProvider.notifier,
                                            )
                                            .fetchBrand(),
                                        onCreate: () =>
                                            _showCreateMasterItemDialog(
                                              context,
                                              ref,
                                              'Brand',
                                              (name) => setState(
                                                () => _selectedBrand = name,
                                              ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Category',
                                            style: context.fonts.black14w600,
                                          ),
                                          if (!isCategoryLocked)
                                            IconButton(
                                              onPressed: () =>
                                                  _showCategorySelectionDialog(
                                                    context,
                                                  ),
                                              icon: const Icon(
                                                Icons
                                                    .add_circle_outline_rounded,
                                                color: CustomColors.purple,
                                                size: 20,
                                              ),
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(),
                                            ),
                                        ],
                                      ),
                                      SizedBox(height: 8.h),
                                      GestureDetector(
                                        onTap: () => isCategoryLocked
                                            ? null
                                            : _showCategorySelectionDialog(
                                                context,
                                              ),
                                        child: AbsorbPointer(
                                          child: TextFormField(
                                            controller: TextEditingController(
                                              text: _selectedCategory,
                                            ),
                                            style: context.fonts.black14w400,
                                            decoration:
                                                AppDecorations.input(
                                                  context,
                                                  hint:
                                                      'Select Category Hierarchy',
                                                ).copyWith(
                                                  suffixIcon: isCategoryLocked
                                                      ? null
                                                      : Icon(
                                                          Icons
                                                              .keyboard_arrow_right_rounded,
                                                          color: CustomColors
                                                              .lightGrey,
                                                          size: context.sp(20),
                                                        ),
                                                ),
                                            validator: (val) =>
                                                val == null || val.isEmpty
                                                ? 'Required'
                                                : null,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 16.w),

                                // Expanded(
                                //   child: Consumer(
                                //     builder: (context, ref, _) {
                                //       final manufacturers = ref
                                //           .watch(masterDataViewModelProvider)
                                //           .manufacturers;
                                //       return _buildSelectOrCreateDropdown(
                                //         label: 'Manufacturer',
                                //         hint: 'Select Manufacturer',
                                //         value: _selectedManufacturer,
                                //         items: manufacturers,
                                //         onChanged: (val) => setState(
                                //           () => _selectedManufacturer = val,
                                //         ),
                                //         onCreate: () => _showCreateMasterItemDialog(
                                //           context,
                                //           ref,
                                //           'Manufacturer',
                                //           (name) {
                                //             ref
                                //                 .read(
                                //                   masterDataViewModelProvider
                                //                       .notifier,
                                //                 )
                                //                 .addManufacturer(name);
                                //             setState(
                                //               () => _selectedManufacturer = name,
                                //             );
                                //           },
                                //         ),
                                //       );
                                //     },
                                //   ),
                                // ),
                                Expanded(
                                  child: Consumer(
                                    builder: (context, ref, _) {
                                      final manufacturers =
                                          ref
                                              .watch(productViewModelProvider)
                                              .manufacturers ??
                                          [];

                                      return SelectOrCreateDropdown<String>(
                                        label: 'Manufacturer',
                                        hint: 'Select Manufacturer',
                                        value: _selectedManufacturer,
                                        items: manufacturers
                                            .map((e) => e.name)
                                            .toList(),
                                        // ← convert to List<String>
                                        itemLabel: (manufacturer) =>
                                            manufacturer,
                                        // ← String displays itself
                                        onChanged: (val) => setState(
                                          () => _selectedManufacturer = val,
                                        ),
                                        onOpen: () => ref
                                            .read(
                                              productViewModelProvider.notifier,
                                            )
                                            .fetchManufacturer(),
                                        onCreate: () =>
                                            _showCreateMasterItemDialog(
                                              context,
                                              ref,
                                              'Manufacturer',
                                              (name) => setState(
                                                () => _selectedManufacturer =
                                                    name,
                                              ),
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
                            SizedBox(height: 16.h),
                            Row(
                              children: [
                                // Expanded(
                                //   child: Consumer(
                                //     builder: (context, ref, _) {
                                //       final usageTypes = ref
                                //           .watch(masterDataViewModelProvider)
                                //           .usageTypes;
                                //       return _buildSelectOrCreateDropdown(
                                //         label: 'Usage Type',
                                //         hint: 'Select Usage Type',
                                //         value: _selectedPurpose,
                                //         items: usageTypes,
                                //         onChanged: (val) {
                                //           setState(() {
                                //             _selectedPurpose = val;
                                //             if (val?.toLowerCase() == 'variable') {
                                //               _enforceLotTracking = true;
                                //             }
                                //           });
                                //         },
                                //         onCreate: () => _showCreateMasterItemDialog(
                                //           context,
                                //           ref,
                                //           'Usage Type',
                                //           (name) {
                                //             ref
                                //                 .read(
                                //                   masterDataViewModelProvider
                                //                       .notifier,
                                //                 )
                                //                 .addUsageType(name);
                                //             setState(() => _selectedPurpose = name);
                                //           },
                                //         ),
                                //       );
                                //     },
                                //   ),
                                // ),
                                Expanded(
                                  child: Consumer(
                                    builder: (context, ref, _) {
                                      final usageType =
                                          ref
                                              .watch(productViewModelProvider)
                                              .usageType ??
                                          [];

                                      return SelectOrCreateDropdown<String>(
                                        label: 'Usage Type',
                                        hint: 'Select Usage Type',
                                        value: _selectedPurpose,
                                        items: usageType
                                            .map((e) => e.name)
                                            .toList(),
                                        // ← convert to List<String>
                                        itemLabel: (usageType) => usageType,
                                        // ← String displays itself
                                        onChanged: (val) => setState(
                                          () => _selectedPurpose = val,
                                        ),
                                        onOpen: () => ref
                                            .read(
                                              productViewModelProvider.notifier,
                                            )
                                            .fetchUsageType(),
                                        onCreate: () =>
                                            _showCreateMasterItemDialog(
                                              context,
                                              ref,
                                              'UsageType',
                                              (name) => setState(
                                                () => _selectedPurpose = name,
                                              ),
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
                            Text(
                              'SECTION 2: PACKAGING',
                              style: context.fonts.purple12w700,
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Expanded(
                                //   child: Column(
                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                //     children: [
                                //       Consumer(
                                //         builder: (context, ref, _) {
                                //           final packageTypes = ref
                                //               .watch(masterDataViewModelProvider)
                                //               .packageTypes;
                                //           return _buildSelectOrCreateDropdown(
                                //             label: 'Package Type',
                                //             hint: 'Select Package Type',
                                //             value: _selectedPackageType,
                                //             items: packageTypes,
                                //             onChanged: (val) {
                                //               setState(() {
                                //                 _selectedPackageType = val;
                                //                 _updateTotalBillableQuantity();
                                //               });
                                //             },
                                //             onCreate: () =>
                                //                 _showCreateMasterItemDialog(
                                //                   context,
                                //                   ref,
                                //                   'Package Type',
                                //                   (name) {
                                //                     ref
                                //                         .read(
                                //                           masterDataViewModelProvider
                                //                               .notifier,
                                //                         )
                                //                         .addPackageType(name);
                                //                     setState(() {
                                //                       _selectedPackageType = name;
                                //                       _updateTotalBillableQuantity();
                                //                     });
                                //                   },
                                //                 ),
                                //           );
                                //         },
                                //       ),
                                //       SizedBox(height: 6.h),
                                //       Text(
                                //         'The bulk unit purchased from suppliers, e.g. Carton, Case.',
                                //         style: context.fonts.grey12w400,
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: .start,
                                    children: [
                                      Consumer(
                                        builder: (context, ref, _) {
                                          final packageTypes =
                                              ref
                                                  .watch(
                                                    productViewModelProvider,
                                                  )
                                                  .packageTypes ??
                                              [];

                                          return SelectOrCreateDropdown<String>(
                                            label: 'Package Type',
                                            hint: 'Select Package Type',
                                            value: _selectedPackageType,
                                            items: packageTypes
                                                .map((e) => e.name)
                                                .toList(),
                                            // ← convert to List<String>
                                            itemLabel: (brand) => brand,
                                            // ← String displays itself
                                            onChanged: (val) => setState(
                                              () => _selectedPackageType = val,
                                            ),
                                            onOpen: () => ref
                                                .read(
                                                  productViewModelProvider
                                                      .notifier,
                                                )
                                                .fetchPackageTypes(),
                                            onCreate: () =>
                                                _showCreateMasterItemDialog(
                                                  context,
                                                  ref,
                                                  'Package Type',
                                                  (name) => setState(
                                                    () => _selectedPackageType =
                                                        name,
                                                  ),
                                                ),
                                          );
                                        },
                                      ),
                                      SizedBox(height: 6.h),
                                      Text(
                                        'The bulk unit purchased from suppliers, e.g. Carton, Case.',
                                        style: context.fonts.grey12w400,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      Text(
                                        'Number of inner boxes inside one Package Type bulk unit.',
                                        style: context.fonts.grey12w400,
                                      ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      BuildTextField(
                                        label: 'Item Quantity Per Box',
                                        controller:
                                            _itemQuantityPerBoxController,
                                        hintText: 'e.g. 1',
                                        keyboardType: TextInputType.number,
                                        onChanged: (_) {
                                          setState(() {
                                            _updateTotalBillableQuantity();
                                          });
                                        },
                                      ),
                                      SizedBox(height: 6.h),
                                      Text(
                                        'Count of physical consumable items (like syringes) per inner box.',
                                        style: context.fonts.grey12w400,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: .start,
                                    children: [
                                      Consumer(
                                        builder: (context, ref, _) {
                                          final unitTypes =
                                              ref
                                                  .watch(
                                                    productViewModelProvider,
                                                  )
                                                  .unitTypes ??
                                              [];

                                          return SelectOrCreateDropdown<String>(
                                            label: 'Unit Type',
                                            hint: 'Select Unit Type',
                                            value: _selectedUnit,
                                            items: unitTypes
                                                .map((e) => e.name)
                                                .toList(),
                                            // ← convert to List<String>
                                            itemLabel: (unit) => unit,
                                            // ← String displays itself
                                            onChanged: (val) => setState(
                                              () => _selectedUnit = val,
                                            ),
                                            onOpen: () => ref
                                                .read(
                                                  productViewModelProvider
                                                      .notifier,
                                                )
                                                .fetchUnitTypes(),
                                            onCreate: () =>
                                                _showCreateMasterItemDialog(
                                                  context,
                                                  ref,
                                                  'Unit Type',
                                                  (name) => setState(
                                                    () => _selectedUnit = name,
                                                  ),
                                                ),
                                          );
                                        },
                                      ),
                                      SizedBox(height: 6.h),
                                      Text(
                                        'The base physical consumable item type, e.g. Syringe, Vial.',
                                        style: context.fonts.grey12w400,
                                      ),
                                    ],
                                  ),
                                ),
                                // Expanded(
                                //   child: Column(
                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                //     children: [
                                //       Consumer(
                                //         builder: (context, ref, _) {
                                //           final units = ref
                                //               .watch(masterDataViewModelProvider)
                                //               .units;
                                //           return _buildSelectOrCreateDropdown(
                                //             label: 'Unit Type',
                                //             hint: 'Select Unit Type',
                                //             value: _selectedUnit,
                                //             items: units,
                                //             onChanged: (val) {
                                //               setState(() {
                                //                 _selectedUnit = val;
                                //                 _updateTotalBillableQuantity();
                                //               });
                                //             },
                                //             onCreate: () =>
                                //                 _showCreateMasterItemDialog(
                                //                   context,
                                //                   ref,
                                //                   'Unit Type',
                                //                   (name) {
                                //                     ref
                                //                         .read(
                                //                           masterDataViewModelProvider
                                //                               .notifier,
                                //                         )
                                //                         .addUnit(name);
                                //                     setState(() {
                                //                       _selectedUnit = name;
                                //                       _updateTotalBillableQuantity();
                                //                     });
                                //                   },
                                //                 ),
                                //           );
                                //         },
                                //       ),
                                //       SizedBox(height: 6.h),
                                //       Text(
                                //         'The base physical consumable item type, e.g. Syringe, Vial.',
                                //         style: context.fonts.grey12w400,
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),

                            // DYNAMIC PACKAGING CALCULATION FOOTER
                            Builder(
                              builder: (context) {
                                final int boxQty =
                                    int.tryParse(_boxQuantityController.text) ??
                                    0;
                                final int itemQty =
                                    int.tryParse(
                                      _itemQuantityPerBoxController.text,
                                    ) ??
                                    0;
                                final int totalItems = boxQty * itemQty;
                                final String unitName =
                                    _selectedPackageType ?? 'Carton';
                                final String packName =
                                    _selectedUnit ?? 'Syringe';

                                return Container(
                                  margin: EdgeInsets.only(top: 16.h),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 12.h,
                                  ),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: CustomColors.purple.withValues(
                                      alpha: 0.05,
                                    ),
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(
                                      color: CustomColors.purple.withValues(
                                        alpha: 0.1,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.calculate_outlined,
                                        color: CustomColors.purple,
                                        size: 20,
                                      ),
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
                              },
                            ),

                            SizedBox(height: 32.h),

                            // SECTION 3: BILLING / CONSUMPTION
                            Text(
                              'SECTION 3: BILLING / CONSUMPTION',
                              style: context.fonts.purple12w700,
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Consumer(
                                        builder: (context, ref, _) {
                                          final unitTypes =
                                              ref
                                                  .watch(
                                                    productViewModelProvider,
                                                  )
                                                  .unitTypes ??
                                              [];
                                          return SelectOrCreateDropdown<String>(
                                            label: 'Billable Unit',
                                            hint: 'Select Billable Unit',
                                            value: _selectedBillableUnit,
                                            items: unitTypes
                                                .map((e) => e.name)
                                                .toList(),
                                            itemLabel: (unit) => unit,
                                            onChanged: (val) => setState(
                                              () => _selectedBillableUnit = val,
                                            ),
                                            onOpen: () => ref
                                                .read(
                                                  productViewModelProvider
                                                      .notifier,
                                                )
                                                .fetchUnitTypes(),
                                            onCreate: () =>
                                                _showCreateMasterItemDialog(
                                                  context,
                                                  ref,
                                                  'Billable Unit',
                                                  (name) => setState(
                                                    () =>
                                                        _selectedBillableUnit =
                                                            name,
                                                  ),
                                                ),
                                          );
                                        },
                                      ),
                                      SizedBox(height: 6.h),
                                      Text(
                                        'Unit of measurement for treatment and billing, e.g. ml, units.',
                                        style: context.fonts.grey12w400,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      BuildTextField(
                                        label: 'Billable Quantity Per Item',
                                        controller:
                                            _billableQuantityPerItemController,
                                        hintText: 'e.g. 1.0',
                                        keyboardType:
                                            const TextInputType.numberWithOptions(
                                              decimal: true,
                                            ),
                                        onChanged: (_) {
                                          setState(() {
                                            _updateTotalBillableQuantity();
                                          });
                                        },
                                      ),
                                      SizedBox(height: 6.h),
                                      Text(
                                        'Volume or potency contained in a single syringe/vial, e.g. 4.0 ml.',
                                        style: context.fonts.grey12w400,
                                      ),
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
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  'Calculated total volume/potency of the entire bulk unit (Unit Type) in billable units.',
                                  style: context.fonts.grey12w400,
                                ),
                              ],
                            ),

                            SizedBox(height: 32.h),

                            // SECTION 4: PRICING
                            Text(
                              'SECTION 4: PRICING',
                              style: context.fonts.purple12w700,
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      BuildTextField(
                                        label: 'Clinic Cost (\$)',
                                        controller: _clinicCostController,
                                        hintText: '0.00',
                                        keyboardType:
                                            const TextInputType.numberWithOptions(
                                              decimal: true,
                                            ),
                                        validator: Validators.empty,
                                      ),
                                      SizedBox(height: 6.h),
                                      Text(
                                        'The cost price paid by the clinic per bulk Unit Type, e.g. \$800.',
                                        style: context.fonts.grey12w400,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      BuildTextField(
                                        label: 'Retail Price Per Unit (\$)',
                                        controller:
                                            _retailPricePerUnitController,
                                        hintText: '0.00',
                                        keyboardType:
                                            const TextInputType.numberWithOptions(
                                              decimal: true,
                                            ),
                                        validator: Validators.empty,
                                      ),
                                      SizedBox(height: 6.h),
                                      Text(
                                        'The default retail price charged to patients per billable unit, e.g. \$15.',
                                        style: context.fonts.grey12w400,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 32.h),

                            // SECTION 5: SUPPLIER & INVENTORY
                            Text(
                              'SECTION 5: SUPPLIER & INVENTORY',
                              style: context.fonts.purple12w700,
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Consumer(
                                        builder: (context, ref, _) {
                                          final suppliers =
                                              ref
                                                  .watch(
                                                    productViewModelProvider,
                                                  )
                                                  .suppliers ??
                                              [];
                                          return SelectOrCreateDropdown<String>(
                                            label: 'Supplier',
                                            hint: 'Select Supplier',
                                            value: _selectedSupplier,
                                            items: suppliers
                                                .map((e) => e.name)
                                                .toList(),
                                            itemLabel: (supplier) => supplier,
                                            onChanged: (val) => setState(
                                              () => _selectedSupplier = val,
                                            ),
                                            onOpen: () => ref
                                                .read(
                                                  productViewModelProvider
                                                      .notifier,
                                                )
                                                .fetchSuppliers(),
                                            onCreate: () =>
                                                _showCreateMasterItemDialog(
                                                  context,
                                                  ref,
                                                  'Supplier',
                                                  (name) => setState(
                                                    () => _selectedSupplier =
                                                        name,
                                                  ),
                                                ),
                                          );
                                        },
                                      ),
                                      SizedBox(height: 6.h),
                                      Text(
                                        'The vendor or supplier of this product, e.g. McKesson.',
                                        style: context.fonts.grey12w400,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      BuildTextField(
                                        label: 'Lot Number',
                                        controller: _lotNumberController,
                                        hintText: 'e.g. LOT123456',
                                      ),
                                      SizedBox(height: 6.h),
                                      Text(
                                        'The manufacturing batch/lot code of the product, e.g. L98765.',
                                        style: context.fonts.grey12w400,
                                      ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          final date = await showDatePicker(
                                            context: context,
                                            initialDate:
                                                _expirationDate ??
                                                DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2100),
                                          );
                                          if (date != null) {
                                            setState(() {
                                              _expirationDate = date;
                                              _expirationDateController.text =
                                                  '${date.year}-${date.month}-${date.day}';
                                            });
                                          }
                                        },
                                        child: AbsorbPointer(
                                          child: BuildTextField(
                                            label: 'Expiration Date',
                                            controller:
                                                _expirationDateController,
                                            hintText: 'YYYY-MM-DD',
                                            suffixIcon: const Icon(
                                              Icons.calendar_today_rounded,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 6.h),
                                      Text(
                                        'The official expiration date of the batch, e.g. 2026-12-31.',
                                        style: context.fonts.grey12w400,
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),

                            SizedBox(height: 32.h),

                            // SECTION 6: GLOBAL COMPLIANCE & STATUS
                            Text(
                              'SECTION 6: GLOBAL COMPLIANCE & STATUS',
                              style: context.fonts.purple12w700,
                            ),
                            SizedBox(height: 16.h),
                            _buildSwitchRow(
                              title:
                                  'Enforce Lot & Expiration Tracking at Clinic Level',
                              subtitle:
                                  'Forces child clinics to log lot and expiration details upon receiving stock.',
                              value: _enforceLotTracking,
                              onChanged: (val) =>
                                  setState(() => _enforceLotTracking = val),
                            ),
                            SizedBox(height: 16.h),
                            _buildSwitchRow(
                              title: 'Active Status',
                              subtitle:
                                  'Enable or disable this product in the global catalog.',
                              value: _activeStatus,
                              onChanged: (val) =>
                                  setState(() => _activeStatus = val),
                            ),

                            SizedBox(height: 16.h),
                            BuildTextField(
                              maxLines: 3,
                              label: 'Description / Usage Instructions',
                              controller: _descriptionController,
                              hintText:
                                  'Global product details and reconstitution instructions...',
                            ),
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
}
