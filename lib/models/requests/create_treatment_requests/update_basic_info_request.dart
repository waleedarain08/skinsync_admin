import 'package:skinsync_admin/models/requests/create_treatment_requests/basic_info_request.dart';
import 'package:skinsync_admin/utils/enums.dart';

class UpdateBasicInfoRequest extends BasicInfoRequest {
  UpdateBasicInfoRequest({
    required super.selectedCategoryIds,
    required super.globalSku,
    required super.patientDisplayName,
    required super.image,
    required super.icon,
    required super.shortDescription,
    required super.description,
    required super.enableByDefault,
    required super.useInAiSimulator,
  });

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['keys'] = [CreateTreatmentSteps.basicInfo.name];
    return json;
  }
}
