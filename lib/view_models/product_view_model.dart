import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';
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

  ProductState({
    super.loading,
    super.currentPage = 1,
    super.totalPages = 1,
    this.products = const [],
    this.errorMessage,
    this.pageSize = 20,
    this.searchKeyword = '',
  });

  ProductState copyWith({
    bool? loading,
    List<ProductModel>? products,
    String? errorMessage,
    int? currentPage,
    int? pageSize,
    int? totalPages,
    String? searchKeyword,
  }) {
    return ProductState(
      loading: loading ?? this.loading,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
      pageSize: pageSize ?? this.pageSize,
      searchKeyword: searchKeyword ?? this.searchKeyword,
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

  @override
  void init() {
    super.init();
  }

  Future<void> initialize() async {
    await fetchProducts(page: 1, limit: 20);
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
          final response = await _productRepository.getProducts(search: search, page: page, limit: limit);
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

  Future<void> searchProducts(String keyword) async {
    await fetchProducts(search: keyword, page: 1, limit: state.pageSize);
  }

  Future<void> nextPage() async {
    if (state.currentPage < state.totalPages) {
      await fetchProducts(search: state.searchKeyword, page: state.currentPage + 1, limit: state.pageSize);
    }
  }

  Future<void> previousPage() async {
    if (state.currentPage > 1) {
      await fetchProducts(search: state.searchKeyword, page: state.currentPage - 1, limit: state.pageSize);
    }
  }

  Future<void> goToPage(int page) async {
    if (page >= 1 && page <= state.totalPages) {
      await fetchProducts(search: state.searchKeyword, page: page, limit: state.pageSize);
    }
  }

  Future<void> refreshProducts() async {
    await fetchProducts(search: state.searchKeyword, page: state.currentPage, limit: state.pageSize);
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

  List<DropdownMenuItem<int>> getProductDropdownItems() {
    return state.products
        .map((prod) => DropdownMenuItem(
              value: prod.id ?? 0,
              child: Text(prod.name),
            ))
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
      onLoadingChange: (loading) => state = state.copyWith(loading: loading),
      () async {
        await _productRepository.updateProduct(req: req);
        await refreshProducts();
        EasyLoading.showSuccess('Product updated successfully');
        return true;
      },
    ) ?? false;
  }

  Future<bool> deleteProduct(int id) async {
    return await runSafely<bool>(
      onLoadingChange: (loading) => state = state.copyWith(loading: loading),
      () async {
        await _productRepository.deleteProduct(id: id);
        await refreshProducts();
        EasyLoading.showSuccess('Product deleted successfully');
        return true;
      },
    ) ?? false;
  }
}
