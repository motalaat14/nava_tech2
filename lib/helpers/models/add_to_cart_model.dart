// To parse this JSON data, do
//
//     final addToCartModel = addToCartModelFromJson(jsonString);

import 'dart:convert';

AddToCartModel addToCartModelFromJson(String str) =>
    AddToCartModel.fromJson(json.decode(str));

String addToCartModelToJson(AddToCartModel data) => json.encode(data.toJson());

class AddToCartModel {
  AddToCartModel({
    this.key,
    this.msg,
    this.data,
  });

  String key;
  String msg;
  Data data;

  factory AddToCartModel.fromJson(Map<String, dynamic> json) => AddToCartModel(
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
    this.tax,
    this.price,
  });

  var tax;
  var price;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        tax: json["tax"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "tax": tax,
        "price": price,
      };
}
