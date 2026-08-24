import 'base_response_model.dart';

class PatientTreatmentRequestResponse
    extends BaseApiResponseModel<List<PatientTreatmentRequestData>> {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  PatientTreatmentRequestResponse({
    required super.isSuccess,
    required super.message,
    super.data,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory PatientTreatmentRequestResponse.fromJson(Map<String, dynamic> json) {
    return PatientTreatmentRequestResponse(
      isSuccess: json['is_success'] ?? false,
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (e) => PatientTreatmentRequestData.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
      totalPages: json['total_pages'] ?? 0,
    );
  }
}

class PatientTreatmentRequestData {
  final int id;
  final int userId;
  final int groupId;
  final String name;

  final String? frontImageBefore;
  final String? frontImageAfter;

  final String? rightImageBefore;
  final String? rightImageAfter;

  final String? leftImageBefore;
  final String? leftImageAfter;

  final List<PatientTreatmentData> treatments;

  final String? createdAt;
  final String? updatedAt;

  PatientTreatmentRequestData({
    required this.id,
    required this.userId,
    required this.groupId,
    required this.name,
    this.frontImageBefore,
    this.frontImageAfter,
    this.rightImageBefore,
    this.rightImageAfter,
    this.leftImageBefore,
    this.leftImageAfter,
    required this.treatments,
    this.createdAt,
    this.updatedAt,
  });

  factory PatientTreatmentRequestData.fromJson(Map<String, dynamic> json) {
    return PatientTreatmentRequestData(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      groupId: json['group_id'] ?? 0,
      name: json['name'] ?? '',
      frontImageBefore: json['front_image_before'],
      frontImageAfter: json['front_image_after'],
      rightImageBefore: json['right_image_before'],
      rightImageAfter: json['right_image_after'],
      leftImageBefore: json['left_image_before'],
      leftImageAfter: json['left_image_after'],
      treatments:
          (json['treatments'] as List<dynamic>?)
              ?.map(
                (e) => PatientTreatmentData.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class PatientTreatmentData {
  final int treatmentId;
  final String treatmentName;
  final String? description;
  final String? image;
  final String? icon;
  final List<PatientTreatmentAreaData> areas;

  PatientTreatmentData({
    required this.treatmentId,
    required this.treatmentName,
    this.description,
    this.image,
    this.icon,
    required this.areas,
  });

  factory PatientTreatmentData.fromJson(Map<String, dynamic> json) {
    return PatientTreatmentData(
      treatmentId: json['treatment_id'] ?? 0,
      description: json['treatment_desc'],
      image: json['treatment_image'],
      icon: json['treatment_icon'],
      treatmentName: json['treatment_name'] ?? '',
      areas:
          (json['areas'] as List<dynamic>?)
              ?.map(
                (e) => PatientTreatmentAreaData.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }
}

class PatientTreatmentAreaData {
  final int areaId;
  final String areaName;
  final String? image;
  final String? icon;
  final List<PatientTreatmentMaterialData> materials;

  PatientTreatmentAreaData({
    required this.areaId,
    required this.areaName,
    this.image,
    this.icon,
    required this.materials,
  });

  factory PatientTreatmentAreaData.fromJson(Map<String, dynamic> json) {
    return PatientTreatmentAreaData(
      areaId: json['area_id'] ?? 0,
      areaName: json['area_name'] ?? '',
      image: json['area_image'],
      icon: json['area_icon'],
      materials:
          (json['materials'] as List<dynamic>?)
              ?.map(
                (e) => PatientTreatmentMaterialData.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }
}

class PatientTreatmentMaterialData {
  final int id;
  final String name;
  final int selectedQuantity;

  PatientTreatmentMaterialData({
    required this.id,
    required this.name,
    required this.selectedQuantity,
  });

  factory PatientTreatmentMaterialData.fromJson(Map<String, dynamic> json) {
    return PatientTreatmentMaterialData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      selectedQuantity: json['selected_quantity'] ?? 0,
    );
  }
}
