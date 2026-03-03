class TreatmentModel {
  int? id;
  int? price;
  String? name;
  String? description;
  bool? isArea;
  List<SideAreaModel>? sideAreas;

  TreatmentModel({
    this.id,
    this.name,
    this.description,
    this.isArea,
    this.sideAreas,
    this.price,
  });

  TreatmentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['treatment_price'];
    name = json['name'];
    description = json['description'];
    isArea = json['is_area'];
    sideAreas = json['side_areas'] != null
        ? (json['side_areas'] as List)
              .map((e) => SideAreaModel.fromJson(e))
              .toList()
        : null;
  }

  TreatmentModel copyWith({
    int? id,
    String? name,
    String? description,
    bool? isArea,
    List<SideAreaModel>? sideAreas,
    int? price,
  }) {
    return TreatmentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isArea: isArea ?? this.isArea,
      sideAreas: sideAreas ?? this.sideAreas,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toRequest() {
    return {
      'treatment_id': id,
      'treatments_sub_sec_id': sideAreas
          ?.map((sideArea) => sideArea.id)
          .toList(),
    };
  }
}

class SideAreaModel {
  int? id;
  String? name;
  double? perSyringePrice;
  int? maxSyringe;

  SideAreaModel({this.id, this.name, this.perSyringePrice, this.maxSyringe});

  SideAreaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    perSyringePrice = json['per_syringe_price'];
    maxSyringe = json['max_syringe'];
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "per_syringe_price": perSyringePrice,
      "max_syringe": maxSyringe,
    };
  }
}
