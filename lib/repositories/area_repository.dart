import 'package:skinsync_admin/models/responses/base_response_model.dart';
import '../models/requests/area_request.dart';
import '../models/requests/create_sub_area_request.dart';
import '../models/responses/area_list_response.dart';

abstract class AreaRepository {
  Future<List<AreaModel>> getAreas();
  Future<AreaModel?> createArea(AreaRequest request);
  Future<BaseApiResponseModel> createSubArea(CreateSubAreaRequest request);

}
