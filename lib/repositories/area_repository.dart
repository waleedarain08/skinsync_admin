import '../models/requests/area_request.dart';
import '../models/responses/area_list_response.dart';

abstract class AreaRepository {
  Future<List<AreaModel>> getAreas();
  Future<AreaModel?> createArea(AreaRequest request);
}
