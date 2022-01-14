// To parse this JSON data, do
//
//     final subCategoryDetailsModel = subCategoryDetailsModelFromJson(jsonString);

import 'dart:convert';

SubCategoryDetailsModel subCategoryDetailsModelFromJson(String str) =>
    SubCategoryDetailsModel.fromJson(json.decode(str));

String subCategoryDetailsModelToJson(SubCategoryDetailsModel data) =>
    json.encode(data.toJson());

class SubCategoryDetailsModel {
  SubCategoryDetailsModel({
    this.key,
    this.msg,
    this.data,
  });

  String key;
  String msg;
  Data data;

  factory SubCategoryDetailsModel.fromJson(Map<String, dynamic> json) =>
      SubCategoryDetailsModel(
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
    this.services,
    this.guaranteeDays,
    this.tax,
    this.price,
  });

  List<Service> services;
  int guaranteeDays;
  var tax;
  var price;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        services: List<Service>.from(
            json["services"].map((x) => Service.fromJson(x))),
        guaranteeDays: json["guarantee_days"],
        tax: json["tax"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "services": List<dynamic>.from(services.map((x) => x.toJson())),
        "guarantee_days": guaranteeDays,
        "tax": tax,
        "price": price,
      };
}

class Service {
  Service({
    this.id,
    this.title,
    this.description,
    this.price,
    this.checked,
    this.count,
  });

  int id;
  String title;
  String description;
  int price;
  bool checked;
  int count;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        price: json["price"],
        checked: json["checked"],
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "price": price,
        "checked": checked,
        "count": count,
      };
}
