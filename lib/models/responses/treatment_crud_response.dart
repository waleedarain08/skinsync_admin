import 'package:skinsync_admin/models/responses/treatment_list_response.dart';
import 'base_response_model.dart';

class TreatmentCrudResponse extends BaseApiResponseModel<TreatmentListData> {
  const TreatmentCrudResponse({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory TreatmentCrudResponse.fromJson(Map<String, dynamic> json) =>
      TreatmentCrudResponse(
        isSuccess: (json['is_success'] as bool?)  ?? false,
        message: json['message'] ?? '',
        data: json['data'] == null
            ? null
            : TreatmentListData.fromJson(json['data'] as Map<String, dynamic>),
      );


}
