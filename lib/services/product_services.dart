import 'dart:async';
import 'package:skinsync_admin/models/product_model.dart';
import 'package:skinsync_admin/models/requests/add_product_req_model.dart';
import '../models/responses/base_response_model.dart';
import '../repositories/product_repository.dart';
import '../utils/enums.dart';
import '../utils/exception.dart';
import 'api_base_helper.dart';

class ProductServices implements ProductRepository {
  final ApiBaseHelper _api;

  ProductServices({required ApiBaseHelper api}) : _api = api;

  @override
  Future<ProductModel> addProduct({required AddProductReqModel req}) async {
    final jsonResponse = await _api.post(
      Endpoint.registerClinic,
      body: req.toJson(),
    );
    final response = BaseApiResponseModel<ProductModel>.fromJson(
      jsonResponse,
      (json) => ProductModel.fromJson(json as Map<String, dynamic>),
    );

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response.data!;
  }

  @override
  Future<List<ProductModel>> getProducts() async {
    final jsonResponse = await _api.get(Endpoint.getClinics);
    final response = BaseApiResponseModel<List<ProductModel>>.fromJson(
      jsonResponse,
      (json) {
        return (json as List)
            .map((treatment) => ProductModel.fromJson(treatment))
            .toList();
      },
    );
    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response.data!;
  }
}
