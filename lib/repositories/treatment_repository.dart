import 'package:skinsync_admin/models/requests/protocol_request.dart';
import 'package:skinsync_admin/models/responses/base_response_model.dart';
import 'package:skinsync_admin/models/responses/basic_info_response.dart';

import '../models/requests/basic_info_request.dart';

abstract class TreatmentRepository {
  // Future<List<TreatmentModel>> getClinicTreatments();
  // Future<List<TreatmentModel>> getAdminTreatments();
  // Future<List<SideAreaModel>> getTreatmentsSideArea(int treatmentId);
  // Future<TreatmentModel> addTreatment(AddTreatmentReqModel req);
  // Future<TreatmentModel> editTreatment(AddTreatmentReqModel req);
  // Future<bool> deleteTreatment(int treatmentId);

  Future<BasicInfoResponse> createBasicInfo(BasicInfoRequest request);
    Future<BaseApiResponseModel> protocol({required ProtocolRequest request,required int draftID});


}
