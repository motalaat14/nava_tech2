// To parse this JSON data, do
//
//     final orderDetailsModel = orderDetailsModelFromJson(jsonString);

import 'dart:convert';

OrderDetailsModel orderDetailsModelFromJson(String str) => OrderDetailsModel.fromJson(json.decode(str));

String orderDetailsModelToJson(OrderDetailsModel data) => json.encode(data.toJson());

class OrderDetailsModel {
  OrderDetailsModel({
    this.key,
    this.msg,
    this.data,
  });

  String key;
  String msg;
  Data data;

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) => OrderDetailsModel(
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
    this.orderNum,
    this.status,
    this.name,
    this.date,
    this.time,
    this.categoryTitle,
    this.categoryImage,
    this.lat,
    this.lng,
    this.region,
    this.residence,
    this.floor,
    this.street,
    this.addressNotes,
    this.notes,
    this.services,
    this.files,
    this.tax,
    this.total,
    this.payType,
  });

  int id;
  String orderNum;
  String status;
  String name;
  String date;
  String time;
  String categoryTitle;
  String categoryImage;
  double lat;
  double lng;
  String region;
  String residence;
  String floor;
  String street;
  String addressNotes;
  String notes;
  List<DataService> services;
  List<FileElement> files;
  double tax;
  String total;
  String payType;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    orderNum: json["order_num"],
    status: json["status"],
    name: json["name"],
    date: json["date"],
    time: json["time"],
    categoryTitle: json["category_title"],
    categoryImage: json["category_image"],
    lat: json["lat"].toDouble(),
    lng: json["lng"].toDouble(),
    region: json["region"],
    residence: json["residence"],
    floor: json["floor"],
    street: json["street"],
    addressNotes: json["address_notes"],
    notes: json["notes"],
    services: List<DataService>.from(json["services"].map((x) => DataService.fromJson(x))),
    files: List<FileElement>.from(json["files"].map((x) => FileElement.fromJson(x))),
    tax: json["tax"].toDouble(),
    total: json["total"],
    payType: json["pay_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_num": orderNum,
    "status": status,
    "name": name,
    "date": date,
    "time": time,
    "category_title": categoryTitle,
    "category_image": categoryImage,
    "lat": lat,
    "lng": lng,
    "region": region,
    "residence": residence,
    "floor": floor,
    "street": street,
    "address_notes": addressNotes,
    "notes": notes,
    "services": List<dynamic>.from(services.map((x) => x.toJson())),
    "files": List<dynamic>.from(files.map((x) => x.toJson())),
    "tax": tax,
    "total": total,
    "pay_type": payType,
  };
}

class FileElement {
  FileElement({
    this.id,
    this.image,
  });

  int id;
  String image;

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
    id: json["id"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
  };
}

class DataService {
  DataService({
    this.id,
    this.title,
    this.image,
    this.services,
    this.total,
  });

  int id;
  String title;
  String image;
  List<ServiceService> services;
  int total;

  factory DataService.fromJson(Map<String, dynamic> json) => DataService(
    id: json["id"],
    title: json["title"],
    image: json["image"],
    services: List<ServiceService>.from(json["services"].map((x) => ServiceService.fromJson(x))),
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image": image,
    "services": List<dynamic>.from(services.map((x) => x.toJson())),
    "total": total,
  };
}

class ServiceService {
  ServiceService({
    this.id,
    this.title,
    this.price,
    this.image,
  });

  int id;
  String title;
  int price;
  String image;

  factory ServiceService.fromJson(Map<String, dynamic> json) => ServiceService(
    id: json["id"],
    title: json["title"],
    price: json["price"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "price": price,
    "image": image,
  };
}
