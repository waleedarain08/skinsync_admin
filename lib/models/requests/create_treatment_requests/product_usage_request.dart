import 'package:skinsync_admin/utils/enums.dart';

class ProductUsagesRequest {
  final List<ProductUsage>? productUsages;

  ProductUsagesRequest({this.productUsages});

  Map<String, dynamic> toJson() => {
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
  final List<SubAreaConsumptionModel>? subAreaConsumptions;

  ProductUsage({
    this.productId,
    this.deductionTiming,
    this.allowSubstitution,
    this.notes,
    this.subAreaConsumptions,
  });

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "deduction_timing": deductionTiming,
    "allow_substitution": allowSubstitution,
    "notes": notes,
    "sub_area_consumptions": subAreaConsumptions == null
        ? []
        : List<dynamic>.from(subAreaConsumptions!.map((x) => x.toJson())),
  };
}

class SubAreaConsumptionModel {
  final int? subAreaId;
  final String? subAreaName;
  final int? minQuantity;
  final int? maxQuantity;

  SubAreaConsumptionModel({
    this.subAreaId,
    this.subAreaName,
    this.minQuantity,
    this.maxQuantity,
  });

  Map<String, dynamic> toJson() => {
    "sub_area_id": subAreaId,
    "sub_area_name": subAreaName,
    "min_quantity": minQuantity,
    "max_quantity": maxQuantity,
  };
}
