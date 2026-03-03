class AddTreatmentReqModel {
  final int treatmentId;
  final double treatmentPrice;
  // final List<SideAreaModel> sideareas;

  AddTreatmentReqModel({
    required this.treatmentId,
    // required this.sideareas,
    required this.treatmentPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'treatment_id': treatmentId,
      'treatment_price': treatmentPrice,
      //   'side_area': sideareas
      //       .map(
      //         (area) => {'side_area_id': area.id, 'price': area.perSyringePrice},
      //       )
      //       .toList(),
    };
  }
}
