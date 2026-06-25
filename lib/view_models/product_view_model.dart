import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skinsync_admin/models/responses/usage_type_list_response.dart';
import 'package:skinsync_admin/services/media_service.dart';
import '../models/product_model.dart';
import '../models/responses/brands_list_response.dart';
import '../models/responses/manufacturers_list_response.dart';
import '../models/responses/package_type_list_response.dart';
import '../models/responses/product_detail_response.dart';
import '../models/responses/unit_types_list_response.dart';
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
  final bool uploadingImage;

  final List<BrandModel>? brands;
  final List<ManufacturersModel>? manufacturers;
  final List<UnitTypeModel>? unitTypes;

  final List<PackageTypeModel>? packageTypes;
  final List<UsageTypeModel>? usageType;



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
    this.uploadingImage = false,
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
    bool? uploadingImage,
    List<BrandModel>? brands,
    List<ManufacturersModel>? manufacturers,
    List<UsageTypeModel>? usageType,
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
      uploadingImage: uploadingImage ?? this.uploadingImage,
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
    state = state.copyWith(imageUrl: null);
  }

  Future<void> fetchProducts({
    String search = '',
    int page = 1,
    int limit = 20,
  }) async {
    await runSafely(
      onLoadingChange: (loading) => state = state.copyWith(loading: loading),
      () async {
        try {
          final response = await _productRepository.getProducts(
            search: search,
            page: page,
            limit: limit,
          );
          state = state.copyWith(
            products: response.data ?? [],
            currentPage: response.page ?? page,
            pageSize: response.limit ?? limit,
            totalPages: response.totalPages ?? 1,
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

  List<ProductModel> getAllProducts() {
    return state.products;
  }

  ProductModel? findProductById(int id) {
    try {
      return state.products.firstWhere((prod) => prod.id == id);
    } catch (_) {
      return null;
    }
  }

  final MediaService _mediaService = MediaService();

  Future<void> pickAndUploadImage() async {
    try {
      state = state.copyWith(uploadingImage: true);

      final result = await FilePicker.pickFiles(
        type: FileType.image,
        withData: false,
      );

      if (result == null || result.files.first.path == null) {
        state = state.copyWith(uploadingImage: false);
        return;
      }

      final file = XFile(result.files.first.path!);

      final url = await _mediaService.uploadImage('products/image', file);

      state = state.copyWith(imageUrl: url, uploadingImage: false);
    } catch (e) {
      state = state.copyWith(uploadingImage: false, errorMessage: e.toString());

      EasyLoading.showError('Image upload failed');
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
  Future<ProductModel?> addProduct(ProductModel req) async {
    return await runSafely<ProductModel?>(
      onLoadingChange: (loading) => state = state.copyWith(loading: loading),
      () async {
        final productWithId = await _productRepository.addProduct(req: req);
        await refreshProducts();
        EasyLoading.showSuccess('Product created successfully');
        return productWithId;
      },
    );
  }

  Future<bool> updateProduct(ProductModel req) async {
    return await runSafely<bool>(
          onLoadingChange: (loading) =>
              state = state.copyWith(loading: loading),
          () async {
            await _productRepository.updateProduct(req: req);
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

  Future<void> fetchBrand() async {
    await runSafely(
      onLoadingChange: (loading) => state = state.copyWith(loading: loading),
          () async {
        try {
          final response = await _productRepository.fetchBrand(
          );
          state = state.copyWith(
            brands: response.data,
            errorMessage: null,
          );
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
          final response = await _productRepository.fetchManufacturer(
          );
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
          final response = await _productRepository.fetchUnitTypes(
          );
          state = state.copyWith(
            unitTypes: response.data,
            errorMessage: null,
          );
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
          final response = await _productRepository.fetchPackageTypes(
          );
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
          final response = await _productRepository.fetchUsageTypes(
          );
          state = state.copyWith(
            usageType: response.data,
            errorMessage: null,
          );
        } catch (e) {
          state = state.copyWith(errorMessage: e.toString());
          rethrow;
        }
      },
    );
  }

}
