// To parse this JSON data, do
//
//     final contactModel = contactModelFromJson(jsonString);

import 'dart:convert';

ContactModel contactModelFromJson(String str) => ContactModel.fromJson(json.decode(str));

String contactModelToJson(ContactModel data) => json.encode(data.toJson());

class ContactModel {
  ContactModel({
    this.key,
    this.msg,
    this.data,
  });

  String key;
  String msg;
  Data data;

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
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
    this.socialData,
    this.basicData,
    this.whatsapp,
    this.isProduction,
    this.mapZoom,
  });

  List<SocialDatum> socialData;
  BasicData basicData;
  String whatsapp;
  bool isProduction;
  int mapZoom;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    socialData: List<SocialDatum>.from(json["socialData"].map((x) => SocialDatum.fromJson(x))),
    basicData: BasicData.fromJson(json["basicData"]),
    whatsapp: json["whatsapp"],
    isProduction: json["isProduction"],
    mapZoom: json["mapZoom"],
  );

  Map<String, dynamic> toJson() => {
    "socialData": List<dynamic>.from(socialData.map((x) => x.toJson())),
    "basicData": basicData.toJson(),
    "whatsapp": whatsapp,
    "isProduction": isProduction,
    "mapZoom": mapZoom,
  };
}

class BasicData {
  BasicData({
    this.phone,
    this.phone2,
  });

  String phone;
  String phone2;

  factory BasicData.fromJson(Map<String, dynamic> json) => BasicData(
    phone: json["phone"],
    phone2: json["phone2"],
  );

  Map<String, dynamic> toJson() => {
    "phone": phone,
    "phone2": phone2,
  };
}

class SocialDatum {
  SocialDatum({
    this.key,
    this.value,
  });

  String key;
  String value;

  factory SocialDatum.fromJson(Map<String, dynamic> json) => SocialDatum(
    key: json["key"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "value": value,
  };
}
