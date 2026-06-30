import 'dart:async';
import 'package:skinsync_admin/models/product_model.dart';
import 'package:skinsync_admin/models/responses/usage_type_list_response.dart';
import 'package:skinsync_admin/models/requests/create_product_request.dart';
import '../models/responses/base_response_model.dart';
import '../models/responses/brands_list_response.dart';
import '../models/responses/manufacturers_list_response.dart';
import '../models/responses/package_type_list_response.dart';
import '../models/responses/product_list_response.dart';
import '../models/responses/product_detail_response.dart';
import '../models/responses/unit_types_list_response.dart';
import '../models/responses/supplier_list_response.dart';
import '../repositories/product_repository.dart';
import '../utils/enums.dart';
import '../utils/exception.dart';
import 'api_base_helper.dart';

class ProductServices implements ProductRepository {
  final ApiBaseHelper _api;

  ProductServices({required ApiBaseHelper api}) : _api = api;

  @override
  Future<ProductModel> addProduct({required CreateProductRequest req}) async {
    final jsonResponse = await _api.post(Endpoint.products, body: req.toJson());
    final response = ProductResponse.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response.data!;
  }

  @override
  Future<ProductModel> updateProduct({
    required int id,
    required CreateProductRequest req,
  }) async {
    final jsonResponse = await _api.patch(
      Endpoint.updateProduct,
      body: req.toJson(),
      pathParams: {'id': id.toString()},
    );
    final response = ProductResponse.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response.data!;
  }

  @override
  Future<BaseApiResponseModel> deleteProduct({required int id}) async {
    final jsonResponse = await _api.delete(
      Endpoint.deleteProduct,
      pathParams: {'id': id.toString()},
    );
    final response = BaseApiResponseModel<Null>.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<ProductListResponse> getProducts({
    String search = '',
    String? selectedPurpose, ProductStatus? status,
    int page = 1,
    int limit = 10,
  }) async {
    final jsonResponse = await _api.get(
      Endpoint.products,
      queryParams: {
        'search': search,
        'status' : status == null || status == ProductStatus.all ? '' : status.name,
        'usage' : selectedPurpose ?? '',
        'page': page.toString(),
        'limit': limit.toString(),
      },
    );
    final response = ProductListResponse.fromJson(jsonResponse);
    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<ProductDetailResponse> getProductDetail({required int id}) async {
    final jsonResponse = await _api.get(
      Endpoint.updateProduct,
      pathParams: {'id': id.toString()},
    );
    final response = ProductDetailResponse.fromJson(jsonResponse);
    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<BrandListResponse> fetchBrand() async {
    final jsonResponse = await _api.get(Endpoint.getBrands);
    final response = BrandListResponse.fromJson(jsonResponse);
    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<ManufacturersListResponse> fetchManufacturer() async {
    final jsonResponse = await _api.get(Endpoint.manufacturersList);
    final response = ManufacturersListResponse.fromJson(jsonResponse);
    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<UnitTypesListResponse> fetchUnitTypes() async {
    final jsonResponse = await _api.get(Endpoint.unitTypesList);
    final response = UnitTypesListResponse.fromJson(jsonResponse);
    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<PackageTypeListResponse> fetchPackageTypes() async {
    final jsonResponse = await _api.get(Endpoint.packageTypeList);
    final response = PackageTypeListResponse.fromJson(jsonResponse);
    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<UsageTypeListResponse> fetchUsageTypes() async {
    final jsonResponse = await _api.get(Endpoint.usageType);
    final response = UsageTypeListResponse.fromJson(jsonResponse);
    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<SupplierListResponse> fetchSuppliers() async {
    final jsonResponse = await _api.get(Endpoint.suppliers);
    final response = SupplierListResponse.fromJson(jsonResponse);
    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<BaseApiResponseModel> updateProductStatus({
    required int productId,
    required String status,
  }) async {
    final jsonResponse = await _api.patch(
      Endpoint.productsStatus,
      body: {'status': status},
      queryParams: {'product_id': productId.toString()},
    );
    final response = BaseApiResponseModel<Null>.fromJson(jsonResponse);
    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }
}