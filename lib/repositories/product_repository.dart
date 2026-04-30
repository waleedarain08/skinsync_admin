import 'package:skinsync_admin/models/product_model.dart';

abstract class ProductRepository {
  Future<ProductModel> addProduct({required ProductModel req});
  Future<List<ProductModel>> getProducts();
}
