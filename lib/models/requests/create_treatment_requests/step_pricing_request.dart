import 'package:skinsync_admin/utils/enums.dart';

class StepPricingRequest {
  final int? stepNumber;
  final int? basePrice;
  final List<UnitPriceOverride>? unitPriceOverrides;

  StepPricingRequest({
    this.stepNumber,
    this.basePrice,
    this.unitPriceOverrides,
  });

  Map<String, dynamic> toJson() => {
    'keys': [CreateTreatmentSteps.pricing.name],
    'base_price': basePrice,
    'unit_price_overrides': unitPriceOverrides == null
        ? []
        : List<dynamic>.from(unitPriceOverrides!.map((x) => x.toJson())),
  };
}

class UnitPriceOverride {
  final int? productId;
  final int? pricePerUnit;

  UnitPriceOverride({this.productId, this.pricePerUnit});

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "price_per_unit": pricePerUnit,
  };
}
