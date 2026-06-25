class DownTimeLevelRequest {
  final int? stepNumber;
  final String? downtimeLevel;
  final int? downtimeDays;

  DownTimeLevelRequest({
    this.stepNumber,
    this.downtimeLevel,
    this.downtimeDays,
  });

  Map<String, dynamic> toJson() => {
    "step_number": stepNumber,
    "downtime_level": downtimeLevel,
    "downtime_days": downtimeDays,
  };
}
