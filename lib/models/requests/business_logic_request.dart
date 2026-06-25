class BusinessLogicRequest {
  final bool enableByDefault;
  final bool useInAiSimulator;

  const BusinessLogicRequest({
    required this.enableByDefault,
    required this.useInAiSimulator,
  });

  Map<String, dynamic> toJson() => {
    'step_number': 17,
    'enable_by_default': enableByDefault,
    'use_in_ai_simulator': useInAiSimulator,
  };
}
