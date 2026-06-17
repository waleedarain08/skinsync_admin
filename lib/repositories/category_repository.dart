import '../models/responses/category_list_response.dart';

abstract class CategoryRepository {
  Future<List<CategoryModel>> getCategories();
}
