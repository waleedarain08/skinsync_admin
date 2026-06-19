import 'dart:async';

import 'package:skinsync_admin/models/requests/register_clinic_request_model.dart';
import 'package:skinsync_admin/models/responses/clinic_list_response.dart';
import 'package:skinsync_admin/repositories/clinic_repository.dart';

import '../models/clinic_model.dart';
import '../models/responses/base_response_model.dart';
import '../utils/enums.dart';
import '../utils/exception.dart';
import 'api_base_helper.dart';

class ClinicService implements ClinicRepository {
  final ApiBaseHelper _api;

  ClinicService({required ApiBaseHelper api}) : _api = api;

  @override
  Future<ClinicModel> registerClinic({
    required RegisterClinicReqModel req,
  }) async {
    final jsonResponse = await _api.post(
      Endpoint.registerClinic,
      body: req.toJson(),
    );
    final response = BaseApiResponseModel<ClinicModel>.fromJson(
      jsonResponse,
     
    );

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response.data!;
  }

  @override
  Future<ClinicModel> updateClinic({
    required int id,
    required RegisterClinicReqModel req,
  }) async {
    final jsonResponse = await _api.put(
      Endpoint.updateClinic,
      pathParams: {'id': id.toString()},
      body: req.toJson(),
    );
    final response = ClinicResponse.fromJson(
      jsonResponse,
     
    );

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response.data!;
  }

 @override
Future<List<ClinicModel>> getClinics() async {
  final jsonResponse = await _api.get(Endpoint.getClinics);
  final response = ClinicListResponse.fromJson(jsonResponse);

  if (!response.isSuccess) {
    throw BadRequestException(response.message);
  }
  return response.data ?? [];
}
}
