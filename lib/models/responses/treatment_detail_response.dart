import 'dart:convert';
import 'package:skinsync_admin/models/responses/base_response_model.dart';

class TreatmentDetailResponse extends BaseApiResponseModel<TreatmentDetailDto> {
  const TreatmentDetailResponse({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory TreatmentDetailResponse.fromJson(Map<String, dynamic> json) =>
      TreatmentDetailResponse(
        isSuccess: json['is_success'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] == null
            ? null
            : TreatmentDetailDto.fromJson(json['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'is_success': isSuccess,
        'message': message,
        'data': data?.toJson(),
      };
}

class TreatmentDetailDto {
  final int? id;
  final int? currentStep;
  final String? status;
  final List<int>? selectedCategoryIds;
  final List<TreatmentCategoryDetailDto>? selectedCategories;
  final String? globalSku;
  final String? patientDisplayName;
  final String? image;
  final String? icon;
  final String? shortDescription;
  final String? description;
  final List<int>? selectedAreaIds;
  final List<TreatmentAreaDetailDto>? selectedAreas;
  final bool? enableByDefault;
  final bool? useInAiSimulator;
  final List<TreatmentSessionDto>? sessions;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TreatmentDetailDto({
    this.id,
    this.currentStep,
    this.status,
    this.selectedCategoryIds,
    this.selectedCategories,
    this.globalSku,
    this.patientDisplayName,
    this.image,
    this.icon,
    this.shortDescription,
    this.description,
    this.selectedAreaIds,
    this.selectedAreas,
    this.enableByDefault,
    this.useInAiSimulator,
    this.sessions,
    this.createdAt,
    this.updatedAt,
  });

  factory TreatmentDetailDto.fromRawJson(String str) =>
      TreatmentDetailDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TreatmentDetailDto.fromJson(Map<String, dynamic> json) => TreatmentDetailDto(
        id: json['id'] as int?,
        currentStep: json['current_step'] as int?,
        status: json['status'] as String?,
        selectedCategoryIds: json['selected_category_ids'] != null
            ? List<int>.from(json['selected_category_ids'])
            : null,
        selectedCategories: json['selected_categories'] != null
            ? List<TreatmentCategoryDetailDto>.from(json['selected_categories']
                .map((x) => TreatmentCategoryDetailDto.fromJson(x)))
            : null,
        globalSku: json['global_sku'] as String?,
        patientDisplayName: json['patient_display_name'] as String?,
        image: json['image'] as String?,
        icon: json['icon'] as String?,
        shortDescription: json['short_description'] as String?,
        description: json['description'] as String?,
        selectedAreaIds: json['selected_area_ids'] != null
            ? List<int>.from(json['selected_area_ids'])
            : null,
        selectedAreas: json['selected_areas'] != null
            ? List<TreatmentAreaDetailDto>.from(json['selected_areas']
                .map((x) => TreatmentAreaDetailDto.fromJson(x)))
            : null,
        enableByDefault: json['enable_by_default'] as bool?,
        useInAiSimulator: json['use_in_ai_simulator'] as bool?,
        sessions: json['sessions'] != null
            ? List<TreatmentSessionDto>.from(json['sessions']
                .map((x) => TreatmentSessionDto.fromJson(x)))
            : null,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at']),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'current_step': currentStep,
        'status': status,
        'selected_category_ids': selectedCategoryIds,
        'selected_categories': selectedCategories == null
            ? null
            : List<dynamic>.from(selectedCategories!.map((x) => x.toJson())),
        'global_sku': globalSku,
        'patient_display_name': patientDisplayName,
        'image': image,
        'icon': icon,
        'short_description': shortDescription,
        'description': description,
        'selected_area_ids': selectedAreaIds,
        'selected_areas': selectedAreas == null
            ? null
            : List<dynamic>.from(selectedAreas!.map((x) => x.toJson())),
        'enable_by_default': enableByDefault,
        'use_in_ai_simulator': useInAiSimulator,
        'sessions': sessions == null
            ? null
            : List<dynamic>.from(sessions!.map((x) => x.toJson())),
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}

class TreatmentCategoryDetailDto {
  final int? id;
  final String? name;
  final String? icon;
  final String? image;
  final String? shortDescription;
  final String? status;

  TreatmentCategoryDetailDto({
    this.id,
    this.name,
    this.icon,
    this.image,
    this.shortDescription,
    this.status,
  });

  factory TreatmentCategoryDetailDto.fromJson(Map<String, dynamic> json) =>
      TreatmentCategoryDetailDto(
        id: json['id'] as int?,
        name: json['name'] as String?,
        icon: json['icon'] as String?,
        image: json['image'] as String?,
        shortDescription: json['short_description'] as String?,
        status: json['status'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon': icon,
        'image': image,
        'short_description': shortDescription,
        'status': status,
      };
}

class TreatmentAreaDetailDto {
  final int? id;
  final String? name;
  final String? globalSku;
  final String? icon;
  final String? image;
  final String? status;

  TreatmentAreaDetailDto({
    this.id,
    this.name,
    this.globalSku,
    this.icon,
    this.image,
    this.status,
  });

  factory TreatmentAreaDetailDto.fromJson(Map<String, dynamic> json) =>
      TreatmentAreaDetailDto(
        id: json['id'] as int?,
        name: json['name'] as String?,
        globalSku: json['global_sku'] as String?,
        icon: json['icon'] as String?,
        image: json['image'] as String?,
        status: json['status'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'global_sku': globalSku,
        'icon': icon,
        'image': image,
        'status': status,
      };
}

class TreatmentSessionDto {
  final int? id;
  final int? treatmentId;
  final int? areaId;
  final String? areaName;
  final String? title;
  final int? sessionNumber;
  final String? status;
  final int? currentStep;
  final bool? isCompleted;
  final DateTime? createdAt;

  TreatmentSessionDto({
    this.id,
    this.treatmentId,
    this.areaId,
    this.areaName,
    this.title,
    this.sessionNumber,
    this.status,
    this.currentStep,
    this.isCompleted,
    this.createdAt,
  });

  factory TreatmentSessionDto.fromJson(Map<String, dynamic> json) =>
      TreatmentSessionDto(
        id: json['id'] as int?,
        treatmentId: json['treatment_id'] as int?,
        areaId: json['area_id'] as int?,
        areaName: json['area_name'] as String?,
        title: json['title'] as String?,
        sessionNumber: json['session_number'] as int?,
        status: json['status'] as String?,
        currentStep: json['current_step'] as int?,
        isCompleted: json['is_completed'] as bool?,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'treatment_id': treatmentId,
        'area_id': areaId,
        'area_name': areaName,
        'title': title,
        'session_number': sessionNumber,
        'status': status,
        'current_step': currentStep,
        'is_completed': isCompleted,
        'created_at': createdAt?.toIso8601String(),
      };
}