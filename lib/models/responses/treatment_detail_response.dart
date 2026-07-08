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
  final List<TreatmentCategoryDetailDto>? selectedCategories;
  final String? globalSku;
  final String? patientDisplayName;
  final String? image;
  final String? icon;
  final String? shortDescription;
  final String? description;
  final bool? enableByDefault;
  final bool? useInAiSimulator;
  final List<TreatmentAreaDto>? areas;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TreatmentDetailDto({
    this.id,
    this.currentStep,
    this.status,
    this.selectedCategories,
    this.globalSku,
    this.patientDisplayName,
    this.image,
    this.icon,
    this.shortDescription,
    this.description,
    this.enableByDefault,
    this.useInAiSimulator,
    this.areas,
    this.createdAt,
    this.updatedAt,
  });

  // Flattened sessions computed property for backward compatibility with older components
  List<TreatmentSessionDto> get sessions {
    if (areas == null) return [];
    final List<TreatmentSessionDto> allSessions = [];
    for (final area in areas!) {
      if (area.sessions != null) {
        allSessions.addAll(area.sessions!);
      }
    }
    return allSessions;
  }

  factory TreatmentDetailDto.fromRawJson(String str) =>
      TreatmentDetailDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TreatmentDetailDto.fromJson(Map<String, dynamic> json) => TreatmentDetailDto(
        id: json['id'] as int?,
        currentStep: json['current_step'] as int?,
        status: json['status'] as String?,
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
        enableByDefault: json['enable_by_default'] as bool?,
        useInAiSimulator: json['use_in_ai_simulator'] as bool?,
        areas: json['areas'] != null
            ? List<TreatmentAreaDto>.from(json['areas']
                .map((x) => TreatmentAreaDto.fromJson(x as Map<String, dynamic>)))
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
        'selected_categories': selectedCategories == null
            ? null
            : List<dynamic>.from(selectedCategories!.map((x) => x.toJson())),
        'global_sku': globalSku,
        'patient_display_name': patientDisplayName,
        'image': image,
        'icon': icon,
        'short_description': shortDescription,
        'description': description,
        'enable_by_default': enableByDefault,
        'use_in_ai_simulator': useInAiSimulator,
        'areas': areas == null
            ? null
            : List<dynamic>.from(areas!.map((x) => x.toJson())),
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

class TreatmentAreaDto {
  final int? areaId;
  final String? areaName;
  final List<TreatmentSessionDto>? sessions;

  TreatmentAreaDto({
    this.areaId,
    this.areaName,
    this.sessions,
  });

  factory TreatmentAreaDto.fromJson(Map<String, dynamic> json) => TreatmentAreaDto(
        areaId: json['area_id'] as int?,
        areaName: json['area_name'] as String?,
        sessions: json['sessions'] != null
            ? List<TreatmentSessionDto>.from(json['sessions']
                .map((x) => TreatmentSessionDto.fromJson(x as Map<String, dynamic>)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        'area_id': areaId,
        'area_name': areaName,
        'sessions': sessions == null
            ? null
            : List<dynamic>.from(sessions!.map((x) => x.toJson())),
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
