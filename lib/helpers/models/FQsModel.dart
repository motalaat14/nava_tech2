// To parse this JSON data, do
//
//     final fQsModel = fQsModelFromJson(jsonString);

import 'dart:convert';

FQsModel fQsModelFromJson(String str) => FQsModel.fromJson(json.decode(str));

String fQsModelToJson(FQsModel data) => json.encode(data.toJson());

class FQsModel {
  FQsModel({
    this.key,
    this.msg,
    this.data,
  });

  String key;
  String msg;
  List<Datum> data;

  factory FQsModel.fromJson(Map<String, dynamic> json) => FQsModel(
    key: json["key"],
    msg: json["msg"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.id,
    this.question,
    this.answer,
    this.open=false,
  });

  int id;
  String question;
  String answer;
  bool open;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    question: json["question"],
    answer: json["answer"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question": question,
    "answer": answer,
  };
}
