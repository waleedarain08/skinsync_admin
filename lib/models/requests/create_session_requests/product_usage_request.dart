import 'package:skinsync_admin/utils/enums.dart';

class ProductUsagesRequest {
  final int stepNumber;
  final int? selectedUnitTypeId;
  final double? minimumUnits;
  final double? maximumUnits;
  final List<ProductUsage>? billableMaterials;
  final List<int>? otherMaterials;

  ProductUsagesRequest({
    required this.stepNumber,
    this.selectedUnitTypeId,
    this.minimumUnits,
    this.maximumUnits,
    this.billableMaterials,
    this.otherMaterials,
  });

  Map<String, dynamic> toJson() => {
    'step_number': stepNumber,
    'keys': [CreateTreatmentSteps.inventoryProducts.name],
    'selected_unit_type_id': selectedUnitTypeId,
    'minimum_units': minimumUnits,
    'maximum_units': maximumUnits,
    'billable_materials': billableMaterials == null
        ? []
        : List<dynamic>.from(billableMaterials!.map((x) => x.toJson())),
    'other_materials': otherMaterials == null
        ? []
        : List<dynamic>.from(otherMaterials!.map((x) => x)),
  };
}

class ProductUsage {
  final int? productId;
  final String? deductionTiming;
  final bool? allowSubstitution;
  final String? notes;

  ProductUsage({
    this.productId,
    this.deductionTiming,
    this.allowSubstitution,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'deduction_timing': deductionTiming,
    'allow_substitution': allowSubstitution,
    'notes': notes,
  };
}
