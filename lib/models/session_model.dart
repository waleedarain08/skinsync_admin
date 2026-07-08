class SessionModel {
  final int id;
  final int treatmentId;
  final int areaId;
  final String areaName;
  final String title;
  final int sessionNumber;
  final String status;
  final int currentStep;
  final bool isCompleted;
  final String createdAt;

  SessionModel({
    required this.id,
    required this.treatmentId,
    required this.areaId,
    required this.areaName,
    required this.title,
    required this.sessionNumber,
    required this.status,
    required this.currentStep,
    required this.isCompleted,
    required this.createdAt,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      id: json['id'] as int,
      treatmentId: json['treatment_id'] as int,
      areaId: json['area_id'] as int,
      areaName: json['area_name'] ?? '',
      title: json['title'] ?? '',
      sessionNumber: json['session_number'] as int,
      status: json['status'] ?? '',
      currentStep: json['current_step'] as int,
      isCompleted: (json['is_completed'] as bool?) ?? false,
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'treatment_id': treatmentId,
      'area_id': areaId,
      'area_name': areaName,
      'title': title,
      'session_number': sessionNumber,
      'status': status,
      'current_step': currentStep,
      'is_completed': isCompleted,
      'created_at': createdAt,
    };
  }
}