import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skinsync_admin/models/responses/usage_type_list_response.dart';
import 'package:skinsync_admin/services/media_service.dart';
import 'package:skinsync_admin/utils/enums.dart';
import '../models/product_model.dart';
import '../models/requests/create_product_request.dart';
import '../models/responses/brands_list_response.dart';
import '../models/responses/manufacturers_list_response.dart';
import '../models/responses/package_type_list_response.dart';
import '../models/responses/product_detail_response.dart';
import '../models/responses/unit_types_list_response.dart';
import '../models/responses/supplier_list_response.dart';
import '../repositories/product_repository.dart';
import '../services/locator.dart';
import 'base_state_model.dart';
import 'base_view_model.dart';

final productViewModelProvider =
    NotifierProvider<ProductViewModel, ProductState>(ProductViewModel.new);

class ProductState extends BaseStateModel {
  final List<ProductModel> products;
  final String? errorMessage;
  final int pageSize;
  final String searchKeyword;
  final ProductDetailModel? selectedProduct;
  final String? imageUrl;

  final List<BrandModel>? brands;
  final List<ManufacturersModel>? manufacturers;
  final List<UnitTypeModel>? unitTypes;

  final List<PackageTypeModel>? packageTypes;
  final List<UsageTypeModel>? usageType;
  final List<SupplierModel>? suppliers;

  ProductState({
    super.loading,
    super.currentPage = 1,
    super.totalPages = 1,
    this.products = const [],
    this.errorMessage,
    this.pageSize = 20,
    this.searchKeyword = '',
    this.selectedProduct,
    this.brands,
    this.manufacturers,
    this.unitTypes,
    this.packageTypes,
    this.imageUrl,
    this.usageType,
    this.suppliers,
  });

  ProductState copyWith({
    bool? loading,
    List<ProductModel>? products,
    String? errorMessage,
    int? currentPage,
    int? pageSize,
    int? totalPages,
    String? searchKeyword,
    ProductDetailModel? selectedProduct,
    List<UnitTypeModel>? unitTypes,
    List<PackageTypeModel>? packageTypes,
    String? imageUrl,

    List<BrandModel>? brands,
    List<ManufacturersModel>? manufacturers,
    List<UsageTypeModel>? usageType,
    List<SupplierModel>? suppliers,
  }) {
    return ProductState(
      loading: loading ?? this.loading,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
      pageSize: pageSize ?? this.pageSize,
      searchKeyword: searchKeyword ?? this.searchKeyword,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      brands: brands ?? this.brands,
      manufacturers: manufacturers ?? this.manufacturers,
      imageUrl: imageUrl ?? this.imageUrl,
      unitTypes: unitTypes ?? this.unitTypes,
      packageTypes: packageTypes ?? this.packageTypes,
      usageType: usageType ?? this.usageType,
      suppliers: suppliers ?? this.suppliers,
    );
  }
}

class ProductViewModel extends BaseViewModel<ProductState> {
  ProductViewModel() : super(ProductState());

  final ProductRepository _productRepository = locator<ProductRepository>();

  // Maintain properties as getters from state for easy external consumption
  List<ProductModel> get products => state.products;
  bool get isLoading => state.loading;
  String? get errorMessage => state.errorMessage;
  int get currentPage => state.currentPage;
  int get pageSize => state.pageSize;
  int get totalPages => state.totalPages;
  String get searchKeyword => state.searchKeyword;
  ProductDetailModel? get selectedProduct => state.selectedProduct;

  @override
  void init() {
    super.init();
  }

  Future<void> initialize() async {
    await fetchProducts(page: 1, limit: 20);
  }

  void setImageNull() {
    state = state.copyWith(imageUrl: '');
  }

  void clearDropdowns() {
    state = state.copyWith(
      brands: [],
      manufacturers: [],
      unitTypes: [],
      packageTypes: [],
      usageType: [],
      suppliers: [],
    );
  }

  Future<void> fetchProducts({
    String search = '',
    int page = 1,
    int limit = 20,
    String? selectedPurpose = '', ProductStatus status = ProductStatus.all

  }) async {
    await runSafely(
      onLoadingChange: (loading) => state = state.copyWith(loading: loading),
      () async {
        try {
          final response = await _productRepository.getProducts(
            search: search,
            page: page,
            limit: limit,
            selectedPurpose: selectedPurpose,
            status: status
          );
          state = state.copyWith(
            products: (response.data ?? [])
                .map((e) => e.toProductModel())
                .toList(),
            currentPage: response.page,
            pageSize: response.limit,
            totalPages: response.totalPages,
            searchKeyword: search,
            errorMessage: null,
          );
        } catch (e) {
          state = state.copyWith(errorMessage: e.toString());
          rethrow;
        }
      },
    );
  }

  Future<void> fetchProductDetail(int productId) async {
    await runSafely(
      onLoadingChange: (loading) => state = state.copyWith(loading: loading),
      () async {
        try {
          final response = await _productRepository.getProductDetail(
            id: productId,
          );
          state = state.copyWith(
            selectedProduct: response.data,
            errorMessage: null,
          );
        } catch (e) {
          state = state.copyWith(errorMessage: e.toString());
          rethrow;
        }
      },
    );
  }

  Future<void> searchProducts(String keyword) async {
    await fetchProducts(search: keyword, page: 1, limit: state.pageSize);
  }

  Future<void> nextPage() async {
    if (state.currentPage < state.totalPages) {
      await fetchProducts(
        search: state.searchKeyword,
        page: state.currentPage + 1,
        limit: state.pageSize,
      );
    }
  }

  Future<void> previousPage() async {
    if (state.currentPage > 1) {
      await fetchProducts(
        search: state.searchKeyword,
        page: state.currentPage - 1,
        limit: state.pageSize,
      );
    }
  }

  Future<void> goToPage(int page) async {
    if (page >= 1 && page <= state.totalPages) {
      await fetchProducts(
        search: state.searchKeyword,
        page: page,
        limit: state.pageSize,
      );
    }
  }

  Future<void> refreshProducts() async {
    await fetchProducts(
      search: state.searchKeyword,
      page: state.currentPage,
      limit: state.pageSize,
    );
  }

  final MediaService _mediaService = MediaService();

  Future<void> pickAndUploadImage({
    bool showLoading = true,
    bool showError = true,
  }) async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      withData: false,
    );

    if (result == null || result.files.first.path == null) {
      return;
    }

    final file = XFile(result.files.first.path!);

    final url = await runSafely<String?>(
      () => _mediaService.uploadImage('products/image', file),
      showLoading: showLoading,
      showError: showError,
    );

    if (url != null) {
      log('Product image uploaded: $url');

      state = state.copyWith(imageUrl: url);
    }
  }

  List<DropdownMenuItem<int>> getProductDropdownItems() {
    return state.products
        .map(
          (prod) =>
              DropdownMenuItem(value: prod.id ?? 0, child: Text(prod.name)),
        )
        .toList();
  }

  // CRUD Actions backed by the actual API repository
  Future<bool?> createProduct(ProductModel req) async {
    return await runSafely<bool?>(
      onLoadingChange: (loading) => state = state.copyWith(loading: loading),
      () async {
        final createRequest = CreateProductRequest(
          image: req.image,
          name: req.name,
          brand: req.brand,
          manufacturer: req.manufacturer,
          globalSku: req.globalSku,
          barcode: req.barcode,
          usageType: req.productPurpose ?? req.usageType,
          category: req.category,
          selectedCategoryIds: req.selectedCategoryIds,
          status: req.status,
          description: req.description,
          unitType: req.unitType,
          boxQuantity: req.boxQuantity,
          itemQuantityPerBox: req.itemQuantityPerBox,
          packageType: req.packageType,
          billableUnit: req.billableUnit,
          billableQuantityPerItem: req.billableQuantityPerItem,
          totalBillableQuantity: req.totalBillableQuantity,
          enforceLotTracking: req.enforceLotTracking,
          clinicCost: req.clinicCost,
          retailPricePerUnit: req.retailPricePerUnit,
          supplier: req.supplier,
          lotNumber: req.lotNumber,
          expirationDate: req.expirationDate?.toIso8601String(),
        );
        await _productRepository.addProduct(req: createRequest);
        await refreshProducts();
        EasyLoading.showSuccess('Product created successfully');
        return true;
      },
    );
  }

  Future<bool> updateProduct(ProductModel req) async {
    return await runSafely<bool>(
          onLoadingChange: (loading) =>
              state = state.copyWith(loading: loading),
          () async {
            final updateRequest = CreateProductRequest(
              image: req.image,
              name: req.name,
              brand: req.brand,
              manufacturer: req.manufacturer,
              globalSku: req.globalSku,
              barcode: req.barcode,
              usageType: req.productPurpose ?? req.usageType,
              category: req.category,
              selectedCategoryIds: req.selectedCategoryIds,
              status: req.status,
              description: req.description,
              unitType: req.unitType,
              boxQuantity: req.boxQuantity,
              itemQuantityPerBox: req.itemQuantityPerBox,
              packageType: req.packageType,
              billableUnit: req.billableUnit,
              billableQuantityPerItem: req.billableQuantityPerItem,
              totalBillableQuantity: req.totalBillableQuantity,
              enforceLotTracking: req.enforceLotTracking,
              clinicCost: req.clinicCost,
              retailPricePerUnit: req.retailPricePerUnit,
              supplier: req.supplier,
              lotNumber: req.lotNumber,
              expirationDate: req.expirationDate?.toIso8601String(),
            );
            await _productRepository.updateProduct(
              id: req.id!,
              req: updateRequest,
            );
            await refreshProducts();
            EasyLoading.showSuccess('Product updated successfully');
            return true;
          },
        ) ??
        false;
  }

  Future<bool> deleteProduct(int id) async {
    return await runSafely<bool>(
          onLoadingChange: (loading) =>
              state = state.copyWith(loading: loading),
          () async {
            await _productRepository.deleteProduct(id: id);
            await refreshProducts();
            EasyLoading.showSuccess('Product deleted successfully');
            return true;
          },
        ) ??
        false;
  }

  Future<bool> updateProductStatus(int productId, String status) async {
    return await runSafely<bool>(
          onLoadingChange: (loading) =>
              state = state.copyWith(loading: loading),
          () async {
            await _productRepository.updateProductStatus(
              productId: productId,
              status: status,
            );
            await refreshProducts();
            if (state.selectedProduct?.id == productId) {
              await fetchProductDetail(productId);
            }
            EasyLoading.showSuccess('Product status updated successfully');
            return true;
          },
        ) ??
        false;
  }

  Future<void> fetchBrand() async {
    await runSafely(
      onLoadingChange: (loading) => state = state.copyWith(loading: loading),
      () async {
        try {
          final response = await _productRepository.fetchBrand();
          state = state.copyWith(brands: response.data, errorMessage: null);
        } catch (e) {
          state = state.copyWith(errorMessage: e.toString());
          rethrow;
        }
      },
    );
  }

  Future<void> fetchManufacturer() async {
    await runSafely(
      onLoadingChange: (loading) => state = state.copyWith(loading: loading),
      () async {
        try {
          final response = await _productRepository.fetchManufacturer();
          state = state.copyWith(
            manufacturers: response.data,
            errorMessage: null,
          );
        } catch (e) {
          state = state.copyWith(errorMessage: e.toString());
          rethrow;
        }
      },
    );
  }

  Future<void> fetchUnitTypes() async {
    await runSafely(
      onLoadingChange: (loading) => state = state.copyWith(loading: loading),
      () async {
        try {
          final response = await _productRepository.fetchUnitTypes();
          state = state.copyWith(unitTypes: response.data, errorMessage: null);
        } catch (e) {
          state = state.copyWith(errorMessage: e.toString());
          rethrow;
        }
      },
    );
  }

  Future<void> fetchPackageTypes() async {
    await runSafely(
      onLoadingChange: (loading) => state = state.copyWith(loading: loading),
      () async {
        try {
          final response = await _productRepository.fetchPackageTypes();
          state = state.copyWith(
            packageTypes: response.data,
            errorMessage: null,
          );
        } catch (e) {
          state = state.copyWith(errorMessage: e.toString());
          rethrow;
        }
      },
    );
  }

  Future<void> fetchUsageType() async {
    await runSafely(
      onLoadingChange: (loading) => state = state.copyWith(loading: loading),
      () async {
        try {
          final response = await _productRepository.fetchUsageTypes();
          state = state.copyWith(usageType: response.data, errorMessage: null);
        } catch (e) {
          state = state.copyWith(errorMessage: e.toString());
          rethrow;
        }
      },
    );
  }

  Future<void> fetchSuppliers() async {
    await runSafely(
      onLoadingChange: (loading) => state = state.copyWith(loading: loading),
      () async {
        try {
          final response = await _productRepository.fetchSuppliers();
          state = state.copyWith(suppliers: response.data, errorMessage: null);
        } catch (e) {
          state = state.copyWith(errorMessage: e.toString());
          rethrow;
        }
      },
    );
  }
}