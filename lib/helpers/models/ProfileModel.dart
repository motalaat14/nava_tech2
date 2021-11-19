// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  ProfileModel({
    this.key,
    this.msg,
    this.data,
  });

  String key;
  String msg;
  Data data;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    key: json["key"],
    msg: json["msg"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "msg": msg,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.name,
    this.avatar,
    this.email,
    this.phone,
    this.lang,
    this.online,
    this.active,
    this.userType,
  });

  int id;
  String name;
  String avatar;
  String email;
  String phone;
  String lang;
  int online;
  int active;
  String userType;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    avatar: json["avatar"],
    email: json["email"],
    phone: json["phone"],
    lang: json["lang"],
    online: json["online"],
    active: json["active"],
    userType: json["user_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "avatar": avatar,
    "email": email,
    "phone": phone,
    "lang": lang,
    "online": online,
    "active": active,
    "user_type": userType,
  };
}
