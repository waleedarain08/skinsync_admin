import 'package:skinsync_admin/models/requests/area_request.dart';

import '../models/requests/create_sub_area_request.dart';
import '../models/responses/area_list_response.dart';
import '../models/responses/base_response_model.dart';
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

  @override
  Future<AreaModel> createArea(AreaRequest request) async {
    final jsonResponse = await _api.post(
      Endpoint.areas,
      body: request.toJson(),
    );
    final response = BaseApiResponseModel<AreaModel>.fromJson(jsonResponse, (
      json,
    ) {
      if (json == null) {
        return null;
      }
      return AreaModel.fromJson(json as Map<String, dynamic>);
    });

    if (!response.status) {
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
    final response = BaseApiResponseModel<Null>.fromJson(
      jsonResponse,
          (_) => null,
    );

    if (!response.status) {
      throw BadRequestException(response.message);
    }
    return response;
  }
}
