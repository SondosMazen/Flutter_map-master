class User {
  String token = " ";
  int? id;
  String? name;
  List<String>? termsOfReference;
  List<String>? screenPermissions;

  User({required this.token, this.id, this.name, this.termsOfReference, this.screenPermissions});

  User.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    id = json['id'];
    name = json['name'];
    termsOfReference = json['termsOfReference'].cast<String>();
    screenPermissions = json['screen'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['id'] = this.id;
    data['name'] = this.name;
    data['termsOfReference'] = this.termsOfReference;
    data['screen'] = this.screenPermissions;
    return data;
  }
}



// class User {
//   String token = "";
//   int? id;
//   String? name;
//   List<String> termsOfReference = [];
//
//   User({required this.token, this.id, this.name, required this.termsOfReference});
//
//   User.fromJson(Map<String, dynamic> json) {
//     token = json['token'];
//     id = json['id'];
//     name = json['name'];
//     termsOfReference = json['termsOfReference'].cast<String>();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['token'] = this.token;
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['termsOfReference'] = this.termsOfReference;
//     return data;
//   }
// }
