import 'package:skinsync_admin/models/product_model.dart';
import 'package:skinsync_admin/models/responses/base_response_model.dart';
import 'package:skinsync_admin/models/responses/product_list_response.dart';
import 'package:skinsync_admin/models/responses/product_detail_response.dart';
import 'package:skinsync_admin/models/responses/usage_type_list_response.dart';
import 'package:skinsync_admin/models/requests/create_product_request.dart';
import 'package:skinsync_admin/utils/enums.dart';

import '../models/responses/brands_list_response.dart';
import '../models/responses/manufacturers_list_response.dart';
import '../models/responses/package_type_list_response.dart';
import '../models/responses/unit_types_list_response.dart';
import '../models/responses/supplier_list_response.dart';

abstract class ProductRepository {
  Future<ProductModel> addProduct({required CreateProductRequest req});
  Future<ProductModel> updateProduct({required int id, required CreateProductRequest req});
  Future<BaseApiResponseModel> deleteProduct({required int id});
  Future<ProductListResponse> getProducts({String search = '', int page = 1, int limit = 10,String? selectedPurpose, ProductStatus status});
  Future<ProductDetailResponse> getProductDetail({required int id});
  Future<BrandListResponse> fetchBrand();
  Future<ManufacturersListResponse> fetchManufacturer();
  Future<UnitTypesListResponse> fetchUnitTypes();
  Future<PackageTypeListResponse> fetchPackageTypes();
  Future<UsageTypeListResponse> fetchUsageTypes();
  Future<SupplierListResponse> fetchSuppliers();
  Future<BaseApiResponseModel> updateProductStatus({required int productId, required String status});
}