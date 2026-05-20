class RoleModel {
  int? iD;
  String? name;
  String? description;
  Null permissions;
  Null users;

  RoleModel({
    this.iD,
    this.name,
    this.description,
    this.permissions,
    this.users,
  });

  RoleModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    description = json['Description'];
    permissions = json['Permissions'];
    users = json['Users'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['Name'] = name;
    data['Description'] = description;
    data['Permissions'] = permissions;
    data['Users'] = users;
    return data;
  }
}
