// class RoleModel {
//   RoleModel({
//     this.iD,
//     this.name,
//     this.description,
//     this.permissions,
//     this.users,
//   });
//
//   factory RoleModel.fromJson(Map<String, dynamic> json) {
//     return RoleModel(
//       iD: json['ID'],
//       name: json['Name'],
//       description: json['Description'],
//       permissions: json['Permissions'],
//       users: json['Users'],
//     );
//   }
//   int? iD;
//   String? name;
//   String? description;
//   Null permissions;
//   Null users;
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['ID'] = iD;
//     data['Name'] = name;
//     data['Description'] = description;
//     data['Permissions'] = permissions;
//     data['Users'] = users;
//     return data;
//   }
// }
