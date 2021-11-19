// To parse this JSON data, do
//
//     final notificationsModel = notificationsModelFromJson(jsonString);

import 'dart:convert';

NotificationsModel notificationsModelFromJson(String str) => NotificationsModel.fromJson(json.decode(str));

String notificationsModelToJson(NotificationsModel data) => json.encode(data.toJson());

class NotificationsModel {
  NotificationsModel({
    this.key,
    this.msg,
    this.data,
  });

  String key;
  String msg;
  Data data;

  factory NotificationsModel.fromJson(Map<String, dynamic> json) => NotificationsModel(
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
  Datum({
    this.id,
    this.toId,
    this.message,
    this.seen,
    this.type,
    this.orderId,
    this.createdAt,
  });

  int id;
  int toId;
  String message;
  bool seen;
  String type;
  int orderId;
  String createdAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    toId: json["to_id"],
    message: json["message"],
    seen: json["seen"],
    type: json["type"],
    orderId: json["order_id"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "to_id": toId,
    "message": message,
    "seen": seen,
    "type": type,
    "order_id": orderId,
    "created_at": createdAt,
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
