import 'package:skinsync_admin/utils/enums.dart';

class StepPricingRequest {
  final int stepNumber;
  final int? basePrice;
  final List<UnitPriceOverride>? unitPriceOverrides;
  final bool? isFixedPrice;
  final int? fixedPrice;

  StepPricingRequest({
    required this.stepNumber,
    this.basePrice,
    this.unitPriceOverrides,
    this.isFixedPrice,
    this.fixedPrice,
  });

  Map<String, dynamic> toJson() => {
    'step_number': stepNumber,
    'keys': [CreateTreatmentSteps.pricing.name],
    'base_price': basePrice,
    'unit_price_overrides': unitPriceOverrides == null
        ? []
        : List<dynamic>.from(unitPriceOverrides!.map((x) => x.toJson())),
    'is_fixed_price': isFixedPrice,
    'fixed_price': fixedPrice,
  };
}

class UnitPriceOverride {
  final int? productId;
  final int? pricePerUnit;

  UnitPriceOverride({this.productId, this.pricePerUnit});

  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'price_per_unit': pricePerUnit,
  };
}
