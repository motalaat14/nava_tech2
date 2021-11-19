// To parse this JSON data, do
//
//     final aboutModel = aboutModelFromJson(jsonString);

import 'dart:convert';

AboutModel aboutModelFromJson(String str) => AboutModel.fromJson(json.decode(str));

String aboutModelToJson(AboutModel data) => json.encode(data.toJson());

class AboutModel {
  AboutModel({
    this.key,
    this.msg,
    this.data,
  });

  String key;
  String msg;
  Data data;

  factory AboutModel.fromJson(Map<String, dynamic> json) => AboutModel(
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
    this.title,
    this.desc,
  });

  int id;
  String title;
  String desc;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    title: json["title"],
    desc: json["desc"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "desc": desc,
  };
}
