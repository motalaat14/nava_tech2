// To parse this JSON data, do
//
//     final newOrdersModel = newOrdersModelFromJson(jsonString);

import 'dart:convert';

NewOrdersModel newOrdersModelFromJson(String str) =>
    NewOrdersModel.fromJson(json.decode(str));

String newOrdersModelToJson(NewOrdersModel data) => json.encode(data.toJson());

class NewOrdersModel {
  NewOrdersModel({
    this.key,
    this.msg,
    this.data,
  });

  String key;
  String msg;
  Data data;

  factory NewOrdersModel.fromJson(Map<String, dynamic> json) => NewOrdersModel(
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
    this.data,
    this.pagination,
  });

  List<Datum> data;
  Pagination pagination;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        pagination: Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "pagination": pagination.toJson(),
      };
}

class Datum {
  Datum(
      {this.id,
      this.avatar,
      this.name,
      this.address,
      this.orderNum,
      this.createdDate,
      this.date,
      this.time,
      this.status,
      this.orderStatus});

  int id;
  String avatar;
  String name;
  String address;
  String orderNum;
  String createdDate;
  String date;
  String time;
  String status;
  String orderStatus;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        avatar: json["avatar"],
        name: json["name"],
        address: json["address"],
        orderNum: json["order_num"],
        createdDate: json["created_date"],
        date: json["date"],
        time: json["time"],
        status: json["status"],
        orderStatus: json["order_status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "avatar": avatar,
        "name": name,
        "address": address,
        "order_num": orderNum,
        "created_date": createdDate,
        "date": date,
        "time": time,
        "status": status,
        "order_status": orderStatus,
      };
}

class Pagination {
  Pagination({
    this.total,
    this.count,
    this.perPage,
    this.currentPage,
    this.totalPages,
  });

  int total;
  int count;
  int perPage;
  int currentPage;
  int totalPages;

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        total: json["total"],
        count: json["count"],
        perPage: json["per_page"],
        currentPage: json["current_page"],
        totalPages: json["total_pages"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "count": count,
        "per_page": perPage,
        "current_page": currentPage,
        "total_pages": totalPages,
      };
}
