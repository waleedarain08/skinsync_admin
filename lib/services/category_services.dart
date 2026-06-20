import 'package:skinsync_admin/models/requests/create_category_request.dart';

import '../models/responses/base_response_model.dart';
import '../models/responses/category_list_response.dart';
import '../models/responses/category_detail_response.dart';
import '../repositories/category_repository.dart';
import '../utils/enums.dart';
import '../utils/exception.dart';
import 'api_base_helper.dart';

class CategoryServices implements CategoryRepository {
  final ApiBaseHelper _api;

  CategoryServices({required ApiBaseHelper api}) : _api = api;

  @override
  Future<List<CategoryModel>> getCategories() async {
    final jsonResponse = await _api.get(Endpoint.categories);
    final response = CategoryListResponse.fromJson(
      jsonResponse,
     
    );

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response.data ?? [];
  }

  @override
  Future<CategoryDetailDto> getCategoryDetail(int categoryId) async {
    final jsonResponse = await _api.get(
      Endpoint.categoryDetail,
      pathParams: {'id': categoryId.toString()},
    );
    final response =CategoryDetailResponse.fromJson(
      jsonResponse,
     
    );

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    if (response.data == null) {
      throw const BadRequestException('Category detail not found');
    }
    return response.data!;
  }

  @override
  Future<BaseApiResponseModel> createCategory(
    CreateCategoryResquest request,
  ) async {
    final jsonResponse = await _api.post(
      Endpoint.createCategory,
      body: request,
    );
    final response = BaseApiResponseModel.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }

    return response;
  }
}
