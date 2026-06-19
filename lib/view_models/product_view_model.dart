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

  ProductState({
    super.loading,
    this.products = const [],
    this.errorMessage,
  });

  ProductState copyWith({
    bool? loading,
    List<ProductModel>? products,
    String? errorMessage,
  }) {
    return ProductState(
      loading: loading ?? this.loading,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
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

  @override
  void init() {
    super.init();
  }

  Future<void> initialize() async {
    await fetchProducts();
  }

  Future<void> fetchProducts() async {
    await runSafely(
      onLoadingChange: (loading) => state = state.copyWith(loading: loading),
      () async {
        try {
          final fetchedProducts = await _productRepository.getProducts();
          state = state.copyWith(
            products: fetchedProducts,
            errorMessage: null,
          );
        } catch (e) {
          state = state.copyWith(errorMessage: e.toString());
          rethrow;
        }
      },
    );
  }

  Future<void> refreshProducts() async {
    await fetchProducts();
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
        await fetchProducts();
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
        await fetchProducts();
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
        await fetchProducts();
        EasyLoading.showSuccess('Product deleted successfully');
        return true;
      },
    ) ?? false;
  }
}
