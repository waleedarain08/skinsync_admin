import '../models/responses/category_list_response.dart';
import '../models/responses/category_detail_response.dart';

abstract class CategoryRepository {
  Future<List<CategoryModel>> getCategories();
  Future<CategoryDetailDto> getCategoryDetail(int categoryId);
}
