import 'package:skinsync_admin/models/requests/area_request.dart';
import 'package:skinsync_admin/models/responses/area_response.dart';
import 'package:skinsync_admin/models/responses/base_response_model.dart';

import '../models/requests/create_sub_area_request.dart';
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
    final response = AreaListResponse.fromJson(
      jsonResponse,
  
    );

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response.data ?? [];
  }

  @override
  Future<AreaModel> createArea(AreaRequest request) async {
    final jsonResponse = await _api.post(
      Endpoint.areas,
      body: request.toJson(),
    );
    final response = AreaResponse.fromJson(jsonResponse,
   
  );

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response.data!;
  }


  @override
  Future<BaseApiResponseModel> createSubArea(CreateSubAreaRequest request) async {
    final jsonResponse = await _api.post(
      Endpoint.subAreas,
      body: request.toJson(),
    );
    final response = BaseApiResponseModel.fromJson(
      jsonResponse,
        
    );

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }
}
