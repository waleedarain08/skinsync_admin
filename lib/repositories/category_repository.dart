import 'package:skinsync_admin/models/requests/create_category_request.dart';
import 'package:skinsync_admin/models/responses/base_response_model.dart';

import '../models/responses/category_list_response.dart';
import '../models/responses/category_detail_response.dart';

abstract class CategoryRepository {
  Future<List<CategoryModel>> getCategories();
  Future<CategoryDetailDto> getCategoryDetail(int categoryId);
  Future<BaseApiResponseModel> createCategory(CreateCategoryRequest request);
}
