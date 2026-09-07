import '../utils/enums.dart';

class DurationOption {
  final String? id;
  final PlanInterval? interval;
  final double? amount;

  DurationOption({this.id, this.interval, this.amount});

  factory DurationOption.fromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? json['duration_id']?.toString() ?? '';
    final amount =
        (json['amount'] as num?)?.toDouble() ??
        (json['price'] as num?)?.toDouble() ??
        (json['base_price'] as num?)?.toDouble() ??
        0.0;

    return DurationOption(
      id: id,
      interval: json['interval'] != null
          ? PlanInterval.values.byName(json['interval'])
          : null,
      amount: amount,
    );
  }
}
