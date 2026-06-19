import 'dart:async';
import 'package:skinsync_admin/models/product_model.dart';
import '../models/responses/base_response_model.dart';
import '../models/responses/product_list_response.dart';
import '../repositories/product_repository.dart';
import '../utils/enums.dart';
import '../utils/exception.dart';
import 'api_base_helper.dart';

class ProductServices implements ProductRepository {
  final ApiBaseHelper _api;

  ProductServices({required ApiBaseHelper api}) : _api = api;

  @override
  Future<ProductModel> addProduct({required ProductModel req}) async {
    final jsonResponse = await _api.post(Endpoint.products, body: req.toJson());
    final response = ProductResponse.fromJson(
      jsonResponse
    
    );

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response.data!;
  }

  @override
  Future<ProductModel> updateProduct({required ProductModel req}) async {
    final jsonResponse = await _api.patch(
      Endpoint.updateProduct,
      body: req.toJson(),
      pathParams: {'id': req.id.toString()},
    );
    final response = ProductResponse.fromJson(
      jsonResponse,
    
    );

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response.data!;
  }

  @override
  Future<BaseApiResponseModel> deleteProduct({required int id}) async {
    final jsonResponse = await _api.delete(
      Endpoint.updateProduct,
      pathParams: {'id': id.toString()},
    );
    final response = BaseApiResponseModel<Null>.fromJson(
      jsonResponse,
    
    );

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<List<ProductModel>> getProducts() async {
    final jsonResponse = await _api.get(Endpoint.products);
    final response = ProductListResponse.fromJson(jsonResponse);
    if (!(response.isSuccess)) {
      throw BadRequestException(response.message);
    }
    return response.data ?? [];
  }
}
