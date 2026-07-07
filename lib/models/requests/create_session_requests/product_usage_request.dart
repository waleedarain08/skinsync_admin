import 'package:skinsync_admin/utils/enums.dart';

class ProductUsagesRequest {
  final List<ProductUsage>? productUsages;

  ProductUsagesRequest({this.productUsages});

  Map<String, dynamic> toJson() => {
    'step_number': 1,
    'keys': [CreateTreatmentSteps.inventoryProducts.name],
    'product_usages': productUsages == null
        ? []
        : List<dynamic>.from(productUsages!.map((x) => x.toJson())),
  };
}

class ProductUsage {
  final int? productId;
  final String? deductionTiming;
  final bool? allowSubstitution;
  final String? notes;
  final double? minQuantity;
  final double? maxQuantity;

  ProductUsage({
    this.productId,
    this.deductionTiming,
    this.allowSubstitution,
    this.notes,
    this.minQuantity,
    this.maxQuantity,
  });

  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'deduction_timing': deductionTiming,
    'allow_substitution': allowSubstitution,
    'notes': notes,
    'min_quantity': minQuantity,
    'max_quantity': maxQuantity,
  };
}