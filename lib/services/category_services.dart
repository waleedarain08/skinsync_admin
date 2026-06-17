import '../models/responses/base_response_model.dart';
import '../models/responses/category_list_response.dart';
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
    final response = BaseApiResponseModel<List<CategoryModel>>.fromJson(
      jsonResponse,
      (json) {
        return (json as List)
            .map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
            .toList();
      },
    );

    if (!response.status) {
      throw BadRequestException(response.message);
    }
    return response.data ?? [];
  }
}
