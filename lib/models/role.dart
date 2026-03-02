class RoleModel {
  int? iD;
  String? name;
  String? description;
  Null? permissions;
  Null? users;

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Description'] = this.description;
    data['Permissions'] = this.permissions;
    data['Users'] = this.users;
    return data;
  }
}
