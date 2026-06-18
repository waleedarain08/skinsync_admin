import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';
import '../utils/dummy_data.dart';
import 'base_state_model.dart';
import 'base_view_model.dart';

final productViewModelProvider =
    NotifierProvider<ProductViewModel, ProductState>(
      ProductViewModel._,
    );

class ProductViewModel extends BaseViewModel<ProductState> {
  ProductViewModel._() : super(ProductState());

  // We maintain a local, mutable copy of dummyProducts in memory
  static final List<ProductModel> _localProducts = List.from(dummyProducts);

  Future<void> initialize() async {
    getProducts();
  }

  Future<bool> getProducts() async {
    state = state.copyWith(loading: true);
    // Simulate short network delay to keep the feel realistic but ultra-responsive
    await Future.delayed(const Duration(milliseconds: 100));
    state = state.copyWith(products: List.from(_localProducts), loading: false);
    return true;
  }

  Future<ProductModel?> addProduct(ProductModel req) async {
    state = state.copyWith(loading: true);
    await Future.delayed(const Duration(milliseconds: 100));
    final newId = _localProducts.isEmpty ? 1 : (_localProducts.map((p) => p.id ?? 0).reduce((a, b) => a > b ? a : b) + 1);
    final productWithId = ProductModel(
      id: newId,
      image: req.image.isEmpty ? 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop' : req.image,
      name: req.name,
      description: req.description,
      unit: req.unit,
      sku: req.sku,
      category: req.category,
      quantity: req.quantity ?? 0,
      status: req.status ?? 'Active',
      brand: req.brand,
      manufacturer: req.manufacturer,
      globalSku: req.globalSku,
      productPurpose: req.productPurpose,
      unitType: req.unitType,
      enforceLotTracking: req.enforceLotTracking,
      packageType: req.packageType,
      unitsPerPackage: req.unitsPerPackage,
      subcategory: req.subcategory,
      boxQuantity: req.boxQuantity,
      itemQuantityPerBox: req.itemQuantityPerBox,
      billableUnit: req.billableUnit,
      billableQuantityPerItem: req.billableQuantityPerItem,
      totalBillableQuantity: req.totalBillableQuantity,
      clinicCost: req.clinicCost,
      retailPricePerUnit: req.retailPricePerUnit,
      supplier: req.supplier,
      lotNumber: req.lotNumber,
      expirationDate: req.expirationDate,
      selectedCategoryIds: req.selectedCategoryIds,
    );
    _localProducts.add(productWithId);
    state = state.copyWith(products: List.from(_localProducts), loading: false);
    EasyLoading.showSuccess('Product created successfully');
    return productWithId;
  }

  Future<bool> updateProduct(ProductModel req) async {
    state = state.copyWith(loading: true);
    await Future.delayed(const Duration(milliseconds: 100));
    final idx = _localProducts.indexWhere((p) => p.id == req.id);
    if (idx != -1) {
      _localProducts[idx] = req;
    }
    state = state.copyWith(products: List.from(_localProducts), loading: false);
    EasyLoading.showSuccess('Product updated successfully');
    return true;
  }

  Future<bool> deleteProduct(int id) async {
    state = state.copyWith(loading: true);
    await Future.delayed(const Duration(milliseconds: 100));
    _localProducts.removeWhere((p) => p.id == id);
    state = state.copyWith(products: List.from(_localProducts), loading: false);
    EasyLoading.showSuccess('Product deleted successfully');
    return true;
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
