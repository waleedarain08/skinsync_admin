import 'package:skinsync_admin/models/product_model.dart';
import 'package:skinsync_admin/models/responses/base_response_model.dart';
import 'package:skinsync_admin/models/responses/product_list_response.dart';
import 'package:skinsync_admin/models/responses/product_detail_response.dart';
import 'package:skinsync_admin/models/responses/usage_type_list_response.dart';

import '../models/responses/brands_list_response.dart';
import '../models/responses/manufacturers_list_response.dart';
import '../models/responses/package_type_list_response.dart';
import '../models/responses/unit_types_list_response.dart';

abstract class ProductRepository {
  Future<ProductModel> addProduct({required ProductModel req});
  Future<ProductModel> updateProduct({required ProductModel req});
  Future<BaseApiResponseModel> deleteProduct({required int id});
  Future<ProductListResponse> getProducts({String search = '', int page = 1, int limit = 10});
  Future<ProductDetailResponse> getProductDetail({required int id});
  Future<BrandListResponse> fetchBrand();

  Future<ManufacturersListResponse> fetchManufacturer();


  Future<UnitTypesListResponse> fetchUnitTypes();

  Future<PackageTypeListResponse> fetchPackageTypes();

  Future<UsageTypeListResponse> fetchUsageTypes();



}
