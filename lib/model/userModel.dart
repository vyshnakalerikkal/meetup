class UserModel {
  UserModel({
    this.name,
    this.mobile,
    this.location,
    this.about,
    this.gender,
    this.image,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    location = json['location'];
    mobile = json['mobile'];
    about = json['about'];
    gender = json['gender'];
    image = json['image'];
  }

  String? name;
  String? location;
  String? mobile;
  String? about;
  String? gender;
  String? image;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['name'] = name;
    data['location'] = location;
    data['mobile'] = mobile;
    data['about'] = about;
    data['gender'] = gender;
    data['image'] = image;

    return data;
  }
}
