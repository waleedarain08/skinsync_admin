import 'package:skinsync_admin/models/product_model.dart';
import 'package:skinsync_admin/models/requests/add_product_req_model.dart';

import '../models/clinic_model.dart';

abstract class ProductRepository {
  Future<ProductModel> addProduct({required AddProductReqModel req});
  Future<List<ProductModel>> getProducts();
}
