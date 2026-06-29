import 'package:skinsync_admin/utils/enums.dart';

class BusinessLogicRequest {
  final bool enableByDefault;
  final bool useInAiSimulator;

  const BusinessLogicRequest({
    required this.enableByDefault,
    required this.useInAiSimulator,
  });

  Map<String, dynamic> toJson() => {
    'keys': [CreateTreatmentSteps.businessLogic.name],
    'enable_by_default': enableByDefault,
    'use_in_ai_simulator': useInAiSimulator,
  };
}
