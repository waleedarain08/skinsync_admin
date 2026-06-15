import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/repositories/product_repository.dart';
import '../models/product_model.dart';
import '../services/locator.dart';
import 'base_state_model.dart';
import 'base_view_model.dart';

final productViewModelProvider =
    NotifierProvider<ProductViewModel, ProductState>(
      ProductViewModel._,
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

  Future<ProductModel?> addProduct(ProductModel req) async {
    return await runSafely<ProductModel?>(
          showLoading: false,
          onLoadingChange: (loading) {
            state = state.copyWith(loading: loading);
          },
          () async {
            final produdct = await _productRepository.addProduct(req: req);
            final currentList = state.products ?? [];
            state = state.copyWith(products: [...currentList, produdct]);
            return produdct;
          },
        );
  }

  Future<bool> updateProduct(ProductModel req) async {
    final success =
        await runSafely<bool?>(
          showLoading: false,
          onLoadingChange: (loading) {
            state = state.copyWith(loading: loading);
          },
          () async {
            final produdct = await _productRepository.updateProduct(req: req);
            final currentList = state.products ?? [];
            final newList = currentList.map((e) => e.id == produdct.id ? produdct : e).toList();
            state = state.copyWith(products: newList);
            return true;
          },
        ) ??
        false;

    return success;
  }

  Future<bool> deleteProduct(int id) async {
    final success =
        await runSafely<bool?>(
          showLoading: true,
          // onLoadingChange: (loading) {
          //   state = state.copyWith(loading: loading);
          // },
          () async {
            final response = await _productRepository.deleteProduct(id: id);
            final currentList = state.products ?? [];
            currentList.removeWhere((element) => element.id == id);
            state = state.copyWith(products: currentList);
            EasyLoading.showSuccess(response.message);
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
