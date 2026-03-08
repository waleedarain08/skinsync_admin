class ProductModel {
  int? id;
  String? name;
  int? units;

  ProductModel({this.id, this.name, this.units});

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    units = json['units'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['units'] = units;
    return data;
  }
}
