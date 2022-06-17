class StudentObj {
  String? sId;
  String? name;
  String? email;
  String? mobile;
  String? gender;

  StudentObj({this.sId, this.name, this.email, this.mobile, this.gender});

  StudentObj.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['Name'];
    email = json['Email'];
    mobile = json['Mobile'];
    gender = json['Gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['Name'] = this.name;
    data['Email'] = this.email;
    data['Mobile'] = this.mobile;
    data['Gender'] = this.gender;
    return data;
  }
}