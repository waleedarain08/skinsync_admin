import 'package:skinsync_admin/models/requests/protocol_request.dart';
import 'package:skinsync_admin/models/responses/base_response_model.dart';

import '../models/requests/basic_info_request.dart';
import '../models/responses/basic_info_response.dart';
import '../repositories/treatment_repository.dart';
import '../utils/enums.dart';
import '../utils/exception.dart';
import 'api_base_helper.dart';

class TreatmentServices implements TreatmentRepository {
  // ignore: unused_field
  final ApiBaseHelper _api;

  TreatmentServices({required ApiBaseHelper api}) : _api = api;


  @override
  Future<BasicInfoResponse> createBasicInfo(BasicInfoRequest request) async {
    final jsonResponse = await _api.post(
      Endpoint.basicInfo,
      body: request.toJson(),
    );
    final response = BasicInfoResponse.fromJson(
      jsonResponse,

    );

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

   @override
  Future<BaseApiResponseModel> protocol({required ProtocolRequest request , required int draftID })async {
    final jsonResponse = await _api.patch(
      Endpoint.protocol,
      
      body: request,
      queryParams: {'treatment_id' : draftID.toString()}
    );
    final response = BaseApiResponseModel.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }

    return response;
  }

  // @override
  // Future<List<TreatmentModel>> getAdminTreatments() async {
  //   final jsonResponse = await _api.get(Endpoint.getAdminTreatments);
  //   final response = BaseApiResponseModel<List<TreatmentModel>>.fromJson(
  //     jsonResponse,
  //     (treatmentList) {
  //       treatmentList as List;
  //       return treatmentList
  //           .map(
  //             (json) => TreatmentModel.fromJson(json as Map<String, dynamic>),
  //           )
  //           .toList();
  //     },
  //   );

  //   if (!response.isSuccess) {
  //     throw BadRequestException(response.message);
  //   }
  //   return response.data ?? [];
  // }

  // @override
  // Future<TreatmentModel> addTreatment(AddTreatmentReqModel req) async {
  //   final jsonResponse = await _api.post(
  //     Endpoint.addClinicTreatment,
  //     body: req.toJson(),
  //   );
  //   final response = BaseApiResponseModel<TreatmentModel>.fromJson(
  //     jsonResponse,
  //     (treatment) => TreatmentModel.fromJson(treatment as Map<String, dynamic>),
  //   );

  //   if (!response.isSuccess) {
  //     throw BadRequestException(response.message);
  //   }
  //   return response.data!;
  // }

  // @override
  // Future<TreatmentModel> editTreatment(AddTreatmentReqModel req) async {
  //   final jsonResponse = await _api.patch(
  //     Endpoint.addClinicTreatment,
  //     body: req.toJson(),
  //   );
  //   final response = BaseApiResponseModel<TreatmentModel>.fromJson(
  //     jsonResponse,
  //     (treatment) => TreatmentModel.fromJson(treatment as Map<String, dynamic>),
  //   );

  //   if (!response.isSuccess) {
  //     throw BadRequestException(response.message);
  //   }
  //   return response.data!;
  // }

  // @override
  // Future<bool> deleteTreatment(int treatmentId) async {
  //   final jsonResponse = await _api.delete(
  //     Endpoint.deleteTreatment,
  //     pathParams: {"treatment_id": treatmentId.toString()},
  //   );
  //   final response = BaseApiResponseModel<TreatmentModel>.fromJson(
  //     jsonResponse,
  //     (treatment) => TreatmentModel.fromJson(treatment as Map<String, dynamic>),
  //   );

  //   if (!response.isSuccess) {
  //     throw BadRequestException(response.message);
  //   }
  //   return response.isSuccess;
  // }
}
