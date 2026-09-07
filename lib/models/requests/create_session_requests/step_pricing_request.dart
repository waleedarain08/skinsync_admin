import 'package:skinsync_admin/utils/enums.dart';

class StepPricingRequest {
  final int stepNumber;
  final int? basePrice;
  final List<UnitPriceOverride>? unitPriceOverrides;
  final bool? isFixedPrice;
  final int? fixedPrice;
  final List<String>? allowedRoles;

  StepPricingRequest({
    required this.stepNumber,
    this.basePrice,
    this.unitPriceOverrides,
    this.isFixedPrice,
    this.fixedPrice,
    this.allowedRoles,
  });

  Map<String, dynamic> toJson() => {
    'step_number': stepNumber,
    'keys': [CreateTreatmentSteps.pricing.name],
    'base_price': basePrice,
    'unit_price_overrides': unitPriceOverrides == null
        ? <dynamic>[]
        : List<dynamic>.from(unitPriceOverrides!.map((x) => x.toJson())),
    'is_fixed_price': isFixedPrice,
    'fixed_price': fixedPrice,
    'allowed_roles': allowedRoles == null
        ? <String>[]
        : List<dynamic>.from(allowedRoles!.map((x) => x)),
  };
}

class UnitPriceOverride {
  final int? productId;
  final bool? isDiffPrice;
  final int? pricePerUnit;
  final List<int>? pricePerUnitList;

  UnitPriceOverride({
    this.productId,
    this.isDiffPrice,
    this.pricePerUnit,
    this.pricePerUnitList,
  });

  Map<String, dynamic> toJson() => {
    'product_id': productId,
   // 'is_diff_price': isDiffPrice ?? false,
   // 'price_per_unit': pricePerUnit ?? 0,
   // 'price_per_unit_list': pricePerUnitList ?? <int>[],
  };
}
