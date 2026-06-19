import '../models/responses/base_response_model.dart';
import '../models/responses/area_list_response.dart';
import '../repositories/area_repository.dart';
import '../utils/enums.dart';
import '../utils/exception.dart';
import 'api_base_helper.dart';

class AreaServices implements AreaRepository {
  final ApiBaseHelper _api;

  AreaServices({required ApiBaseHelper api}) : _api = api;

  @override
  Future<List<AreaModel>> getAreas() async {
    final jsonResponse = await _api.get(Endpoint.areas);
    final response = BaseApiResponseModel<List<AreaModel>>.fromJson(
      jsonResponse,
      (json) {
        return (json as List)
            .map((item) => AreaModel.fromJson(item as Map<String, dynamic>))
            .toList();
      },
    );

    if (!response.status) {
      throw BadRequestException(response.message);
    }
    return response.data ?? [];
  }
}
