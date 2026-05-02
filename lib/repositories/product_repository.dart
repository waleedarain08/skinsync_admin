import 'package:skinsync_admin/models/product_model.dart';
import 'package:skinsync_admin/models/responses/base_response_model.dart';

abstract class ProductRepository {
  Future<ProductModel> addProduct({required ProductModel req});
  Future<ProductModel> updateProduct({required ProductModel req});
  Future<BaseApiResponseModel> deleteProduct({required int id});
  Future<List<ProductModel>> getProducts();
}
