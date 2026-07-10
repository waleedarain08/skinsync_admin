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
  });

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['keys'] = [CreateTreatmentSteps.basicInfo.name];
    return json;
    //   return {
    //   'step_number': 2,

    //   'selected_category_ids': List<dynamic>.from(selectedCategoryIds.map((x) => x)),
    //   'global_sku': globalSku,
    //   'patient_display_name': patientDisplayName,
    //   'image': image,
    //   'icon': icon,
    //   'short_description': shortDescription,
    //   'description': description,
    // };
  }
}
