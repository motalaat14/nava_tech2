// To parse this JSON data, do
//
//     final walletDetailsModel = walletDetailsModelFromJson(jsonString);

import 'dart:convert';

WalletDetailsModel walletDetailsModelFromJson(String str) => WalletDetailsModel.fromJson(json.decode(str));

String walletDetailsModelToJson(WalletDetailsModel data) => json.encode(data.toJson());

class WalletDetailsModel {
  WalletDetailsModel({
    this.key,
    this.msg,
    this.data,
  });

  String key;
  String msg;
  Data data;

  factory WalletDetailsModel.fromJson(Map<String, dynamic> json) => WalletDetailsModel(
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
    this.debtor,
    this.wallet,
    this.firstDate,
    this.currentDate,
    this.orders,
  });

  int debtor;
  int wallet;
  String firstDate;
  String currentDate;
  Orders orders;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    debtor: json["debtor"],
    wallet: json["wallet"],
    firstDate: json["firstDate"],
    currentDate: json["currentDate"],
    orders: Orders.fromJson(json["orders"]),
  );

  Map<String, dynamic> toJson() => {
    "debtor": debtor,
    "wallet": wallet,
    "firstDate": firstDate,
    "currentDate": currentDate,
    "orders": orders.toJson(),
  };
}

class Orders {
  Orders({
    this.data,
    this.pagination,
  });

  List<Datum> data;
  Pagination pagination;

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    pagination: Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "pagination": pagination.toJson(),
  };
}

class Datum {
  Datum({
    this.id,
    this.orderNum,
    this.category,
    this.added,
    this.deduction,
    this.balance,
  });

  int id;
  String orderNum;
  String category;
  int added;
  int deduction;
  int balance;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    orderNum: json["order_num"],
    category: json["category"],
    added: json["added"],
    deduction: json["deduction"],
    balance: json["balance"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_num": orderNum,
    "category": category,
    "added": added,
    "deduction": deduction,
    "balance": balance,
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
