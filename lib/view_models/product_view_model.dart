import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/repositories/product_repository.dart';
import '../models/product_model.dart';
import '../services/locator.dart';
import 'base_state_model.dart';
import 'base_view_model.dart';

final productViewModelProvider =
    NotifierProvider<ProductViewModel, ProductState>(
      () => ProductViewModel._(),
    );

class ProductViewModel extends BaseViewModel<ProductState> {
  ProductViewModel._() : super(ProductState());

  final ProductRepository _productRepository = locator<ProductRepository>();

  Future<void> initialize() async {
    getProducts();
  }

  Future<bool> getProducts() async {
    return await runSafely<bool?>(
          showLoading: false,
          onLoadingChange: (loading) {
            state = state.copyWith(loading: loading);
          },
          () async {
            final products = await _productRepository.getProducts();
            state = state.copyWith(products: products);
            return true;
          },
        ) ??
        false;
  }

  Future<bool> addProduct(ProductModel req) async {
    final success =
        await runSafely<bool?>(
          showLoading: false,
          onLoadingChange: (loading) {
            state = state.copyWith(loading: loading);
          },
          () async {
            final produdct = await _productRepository.addProduct(req: req);
            final currentList = state.products ?? [];
            state = state.copyWith(products: [...currentList, produdct]);
            return true;
          },
        ) ??
        false;

    return success;
  }
}

class ProductState extends BaseStateModel {
  List<ProductModel>? products = [];
  ProductState({super.loading, this.products = const []});

  ProductState copyWith({bool? loading, List<ProductModel>? products}) {
    return ProductState(
      loading: loading ?? this.loading,
      products: products ?? this.products,
    );
  }
}
